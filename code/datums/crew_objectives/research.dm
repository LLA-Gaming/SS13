//research tech
/datum/assignment/research
	name = "Research Tech"
	detail = "Assign a scientist to research a certain technology, this task is completed by delivering the blueprint to CentComm"
	possible_departments = list("Science")
	var/datum/design/tech = null

	generate_options()
		options.Add("Cancel")
		for(var/obj/machinery/r_n_d/server/RnDserver)
			if(RnDserver.files)
				for(var/datum/design/D in RnDserver.files.possible_designs)
					options.Add(D)
			break

	validate()
		if(ticker)
			if(!tech)
				return "add a research target"
			if(!assigned_to.len)
				return "assign at least one user"
			for(var/datum/assignment/research/R in sortAtom(ticker.assignments))
				if(tech == R.tech)
					return "duplicate target found in existing assignment"
			ticker.assignments.Add(src)
			return null
		return "invalid"

	update_label()
		if(tech)
			name = "Research Tech: [tech]"

	check_complete()
		if(complete)
			return 1
		var/found = 0
		for(var/obj/item/weapon/disk/design_disk/D in world)
			var/disk_area = get_area(D)
			if(is_type_in_list(disk_area, centcom_areas))
				if(D.blueprint && D.blueprint.build_path  == tech.build_path )
					found = 1
		if(found)
			return 1
		else
			return 0


	add_goal(var/datum/design/goal)
		tech = goal
		update_label()

	display()
		. += "<u>[name]</u><br>"
		. += "1) Research and create \"[tech ? tech : "\<Insert Goal\>"]\"<br>"
		. += "2) Hand deliver the blueprints on a component disk to central command<br>"
		. += "Assigned to: [assigned_to.len ? list2text(gather_users(),", ") : "\<Insert Users\>"]<br>"
		. += "Assigned by: [assigned_by.owner]"

//research slimes
/datum/assignment/xenoslimes
	name = "Research Xenobiology"
	detail = "Assign a scientist to research a certain slime extract, this task is completed by delivering the extract to CentComm"
	possible_departments = list("Science")
	var/slime = null

	generate_options()
		options.Add("Cancel")
		options.Add("Grey","Gold","Silver","Metal","Purple","Dark Purple","Orange","Yellow","Red","Blue","Dark Blue","Pink","Green","Light Pink","Black","Oil","Adamantine","Bluespace","Pyrite","Cerulean","Sepia")

	validate()
		if(ticker)
			if(!slime)
				return "add a slime goal"
			if(!assigned_to.len)
				return "assign at least one user"
			for(var/datum/assignment/xenoslimes/R in sortAtom(ticker.assignments))
				if(slime == R.slime)
					return "duplicate target found in existing assignment"
			ticker.assignments.Add(src)
			return null
		return "invalid"

	update_label()
		if(slime)
			name = "Research Xenobiology: [slime] slimes"

	check_complete()
		if(complete)
			return 1
		var/found = 0
		for(var/obj/item/slime_extract/D in world)
			var/disk_area = get_area(D)
			if(is_type_in_list(disk_area, centcom_areas))
				if(D.icon_state == "[slime] slime extract" && D.Uses)
					found = 1
		if(found)
			return 1
		else
			return 0


	add_goal(var/goal)
		slime = goal
		update_label()

	display()
		. += "<u>[name]</u><br>"
		. += "1) Research and create [slime ? slime : "\<Insert Goal\>"] slime extract<br>"
		. += "2) Hand deliver the extract to central command<br>"
		. += "Assigned to: [assigned_to.len ? list2text(gather_users(),", ") : "\<Insert Users\>"]<br>"
		. += "Assigned by: [assigned_by.owner]"

