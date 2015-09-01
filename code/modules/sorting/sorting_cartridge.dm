/obj/item/sorting_cartridge
	name = "sorting cartridge"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "harddisk"
	w_class = 2
	m_amt = 100
	g_amt = 100
	var/list/directions = list()
	var/list/behaviors = list()
	var/condition = AND
	var/panel_open = 0
	var/obj/item/weapon/stock_parts/scanning_module/scanning_module

	New()
		..()
		if(!length(directions))
			directions = GetDirections()
		scanning_module = new(src)

		if(length(behaviors))
			for(var/line in behaviors)
				behaviors -= line
				var/condition_pos = findtext(line, "-")
				var/_condition = 1
				if(condition_pos)
					_condition = text2num(copytext(line, condition_pos + 1))
					line = copytext(line, 1, condition_pos)
				line = text2path(line)
				var/datum/sorting_behavior/behavior = new line()
				behavior.condition = _condition
				behaviors += behavior

	examine()
		..()
		usr << "Moves objects and mobs [dir2text(directions["true"])] on true evaluation, which is when: "
		for(var/datum/sorting_behavior/behavior in behaviors)
			usr << "'[behavior.name]' evaluates to [behavior.condition ? "true" : "false"][(length(behaviors) > behaviors.Find(behavior)) ? ", [ConditionToDisplay(condition)]" : ""]"
		usr << "Moves objects and mobs [dir2text(directions["false"])] on false evaluation."

	proc/UpdateRating()
		behaviors.len = scanning_module.rating

	proc/ProcessAtoms(var/list/atoms = list())
		if(!scanning_module)
			return 0

		var/list/processed = list()
		for(var/atom/A in atoms)
			processed[A] = directions[(EvaluateBehaviors(A) ? "true" : "false")]

		return processed

	proc/EvaluateBehaviors(var/atom/A)
		var/list/results = list()

		for(var/datum/sorting_behavior/behavior in behaviors)
			var/result = behavior.case.Evaluate(A)
			if(!behavior.condition)
				result = !result
			results += result

		var/true = 0
		if(length(results) > 1)
			for(var/i = 2; i <= length(results); i++)
				var/previous_result = results[(i - 1)]
				var/result = results[i]

				if(condition == AND)
					if(previous_result && result)
						true = 1
					else
						true = 0
						break
				else if(condition == OR)
					if(previous_result || result)
						true = 1
						break
					else
						true = 0

		else
			true = results[1]

		return true

	proc/ConditionToDisplay(var/bf)
		switch(bf)
			if(AND)
				return "and"
			if(OR)
				return "or"

	proc/GetBehaviors()
		return (typesof(/datum/sorting_behavior) - /datum/sorting_behavior)

	proc/GetMenu()
		if(!scanning_module)
			return 0

		var/dat = "True Evaluation Direction: [button("action=changedir;eval=true", dir2text(directions["true"]))]<br>"
		dat += "False Evaluation Direction: [button("action=changedir;eval=false", dir2text(directions["false"]))]<br><hr>"

		dat += "Evaluation is true when: <br>"
		for(var/i = 1 to scanning_module.rating)
			var/datum/sorting_behavior/behavior = 0
			if((length(behaviors) >= i) && (behaviors[i] != null))
				behavior = behaviors[i]
				dat += "<b>[button("action=add_behavior;index=[i]", behavior.name)]</b> evaluates to "
				dat += "<b>[button("action=change_behavior_condition;index=[i]", uppertext((behavior.condition ? "true" : "false")))]</b>"
				if(scanning_module.rating > i)
					dat += "[button("action=change_condition", uppertext(ConditionToDisplay(condition)))]<br>"
				else
					dat += "<br>"
			else
				dat += "\[[button("action=add_behavior;index=[i]", "ADD")]\]<br>"

		return dat

	proc/OpenMenu(var/mob/living/user)
		if(!scanning_module)
			return 0

		var/datum/browser/popup = new(user, "logiccartridge", name, 350, 300)
		popup.set_content(GetMenu())
		popup.open()

	proc/button(var/action, var/name)
		return "<a href='?src=\ref[src];[action]'>[name]</a>"

	proc/ChangeDirInput(var/mob/living/user, var/list/dirs = cardinal.Copy())
		var/available_directions = dirs
		for(var/state in directions)
			var/direction = directions[state]
			available_directions -= direction

		for(var/available_direction in available_directions)
			available_directions -= available_direction
			available_directions[dir2text(available_direction)] = available_direction

		var/newdir = input("Please enter a new direction", "Input") in available_directions
		if(!newdir)
			return 0

		return available_directions[newdir]

	proc/GetDirections()
		var/list/dirs = list()
		dirs["true"] = NORTH
		dirs["false"] = SOUTH
		return dirs

	attackby(var/obj/item/I, var/mob/living/user)
		if(istype(I, /obj/item/device/multitool))
			OpenMenu(user)
			return 0

		if(istype(I, /obj/item/weapon/screwdriver))
			panel_open = !panel_open
			user << "<span class='notice'>You [panel_open ? "open" : "close"] the maintenance panel.</span>"
			return 0

		if(istype(I, /obj/item/weapon/stock_parts/scanning_module))
			if(scanning_module)
				user << "<span class='notice'>There already is a scanning module inserted.</span>"
				return 0
			else
				user << "<span class='notice'>You insert \the [I] into \the [src].</span>"
				user.unEquip(I)
				I.loc = src
				scanning_module = I
				UpdateRating()

	attack_hand(var/mob/living/user)
		if(panel_open && scanning_module)
			user << "<span class='notice'>You take \the [scanning_module] out.</span>"
			scanning_module.loc = get_turf(src)
			user.put_in_active_hand(scanning_module)
			scanning_module = 0
			behaviors = list()
			return 0
		..()

	Topic(href, href_list)
		if(..())
			return 0

		if(istype(loc, /obj/machinery/sorting_conveyor))
			if(!usr.canUseTopic(loc))
				return 0
		else if(!usr.canUseTopic(src))
			return 0

		if(href_list["action"] == "changedir")
			var/newdir = ChangeDirInput(usr)
			if(!newdir)
				return 0

			directions[href_list["eval"]] = newdir

		else if(href_list["action"] == "add_behavior")
			var/index = text2num(href_list["index"])

			if(!scanning_module)
				return 0

			if(index > scanning_module.rating)
				return 0

			var/list/new_behaviors = list()
			for(var/path in GetBehaviors())
				var/datum/sorting_behavior/behavior = new path()
				new_behaviors[behavior.name] = path
				qdel(behavior)

			var/new_behavior = input("Choose a new behavior", "Input") in new_behaviors + "Cancel" + "Remove"
			if(!new_behavior || new_behavior == "Cancel")
				return 0

			if(new_behavior == "Remove")
				behaviors[index] = null
				return 0

			var/path = new_behaviors[new_behavior]
			var/datum/sorting_behavior/behavior = new path()
			if(length(behaviors) >= index)
				behaviors[index] = behavior
			else
				behaviors += behavior

		else if(href_list["action"] == "change_condition")
			if(!scanning_module)
				return 0

			if(condition == AND)
				condition = OR
			else if(condition == OR)
				condition = AND

		else if(href_list["action"] == "change_behavior_condition")
			var/index = text2num(href_list["index"])

			if(index > length(behaviors))
				return 0

			if(index > scanning_module.rating)
				return 0

			var/datum/sorting_behavior/behavior = behaviors[index]
			if(!behavior)
				return 0

			behavior.condition = !behavior.condition

		OpenMenu(usr)
