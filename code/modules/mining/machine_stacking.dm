/**********************Mineral stacking unit console**************************/

/obj/machinery/mineral/stacking_unit_console
	name = "stacking machine console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	density = 0
	anchored = 1
	var/obj/machinery/mineral/stacking_machine/machine = null
	var/machinedir = SOUTHEAST
	var/obj/item/weapon/card/id/inserted_id

/obj/machinery/mineral/stacking_unit_console/New()
	..()
	spawn(7)
		src.machine = locate(/obj/machinery/mineral/stacking_machine, get_step(src, machinedir))
		if (machine)
			machine.CONSOLE = src
		else
			qdel(src)

/obj/machinery/mineral/stacking_unit_console/attack_hand(user as mob)

	var/obj/item/stack/sheet/s
	var/dat

	dat += text("<b>Stacking unit console</b><br><br>")
	dat += text("Current unclaimed points: [machine.points]<br>")

	if(istype(inserted_id))
		dat += text("You have [inserted_id.mining_points] mining points collected. <A href='?src=\ref[src];choice=eject'>Eject ID.</A><br>")
		dat += text("<A href='?src=\ref[src];choice=claim'>Claim points.</A><br>")
	else
		dat += text("No ID inserted.  <A href='?src=\ref[src];choice=insert'>Insert ID.</A><br>")

	for(var/O in machine.stack_list)
		s = machine.stack_list[O]
		if(s.amount > 0)
			dat += text("[capitalize(s.name)]: [s.amount] <A href='?src=\ref[src];release=[s.type]'>Release</A><br>")

	dat += text("<br>Stacking: [machine.stack_amt]<br><br>")

	dat += text("<HR><b>Mineral Value List:</b><BR>[machine.get_ore_values()]")

	user << browse("[dat]", "window=console_stacking_machine")

	return

/obj/machinery/mineral/stacking_unit_console/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["choice"])
		if(istype(inserted_id))
			if(href_list["choice"] == "eject")
				inserted_id.loc = loc
				inserted_id.verb_pickup()
				inserted_id = null
			if(href_list["choice"] == "claim")
				if(access_mining_station in inserted_id.access)
					inserted_id.mining_points += machine.points
					if(ticker)
						ticker.mining_points += machine.points
					machine.points = 0
				else
					usr << "<span class='warning'>Required access not found.</span>"
		else if(href_list["choice"] == "insert")
			var/obj/item/weapon/card/id/I = usr.get_active_hand()
			if(istype(I))
				usr.drop_item()
				I.loc = src
				inserted_id = I
			else usr << "<span class='warning'>No valid ID.</span>"
	if(href_list["release"])
		if(!(text2path(href_list["release"]) in machine.stack_list)) return //someone tried to spawn materials by spoofing hrefs
		var/obj/item/stack/sheet/inp = machine.stack_list[text2path(href_list["release"])]
		var/obj/item/stack/sheet/out = new inp.type()
		out.amount = inp.amount
		inp.amount = 0
		machine.unload_mineral(out)

	src.updateUsrDialog()
	return

/obj/machinery/mineral/stacking_unit_console/attackby(var/obj/item/weapon/W, var/mob/user)
	if(istype(W,/obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/I = usr.get_active_hand()
		if(istype(I) && !istype(inserted_id))
			usr.drop_item()
			I.loc = src
			inserted_id = I
			interact(user)

/**********************Mineral stacking unit**************************/


/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	density = 1
	anchored = 1.0
	var/obj/machinery/mineral/stacking_unit_console/CONSOLE
	var/stk_types = list()
	var/stk_amt   = list()
	var/stack_list[0] //Key: Type.  Value: Instance of type.
	var/stack_amt = 50; //ammount to stack before releassing
	var/points = 0
	var/ore_values = list(("glass" = 1), ("metal" = 1), ("reinforced glass" = 4), ("gold" = 20), ("silver" = 20), ("uranium" = 30), ("bananium" = 30), ("solid plasma" = 40),("diamond" = 40), ("plasteel" = 41))
	input_dir = EAST
	output_dir = WEST

/obj/machinery/mineral/stacking_machine/proc/process_sheet(obj/item/stack/sheet/inp)
	if(!(inp.type in stack_list)) //It's the first of this sheet added
		var/obj/item/stack/sheet/s = new inp.type(src,0)
		s.amount = 0
		stack_list[inp.type] = s
	var/obj/item/stack/sheet/storage = stack_list[inp.type]
	storage.amount += inp.amount //Stack the sheets
	inp.loc = null //Let the old sheet garbage collect
	while(storage.amount > stack_amt) //Get rid of excessive stackage
		var/obj/item/stack/sheet/out = new inp.type()
		out.amount = stack_amt
		unload_mineral(out)
		storage.amount -= stack_amt
	if(istype(inp))
		var/n = inp.name
		var/a = inp.amount
		if(n in ore_values)
			points += ore_values[n] * a

/obj/machinery/mineral/stacking_machine/process()
	var/turf/T = get_step(src, input_dir)
	if(T)
		for(var/obj/item/stack/sheet/S in T)
			process_sheet(S)

/obj/machinery/mineral/stacking_machine/proc/get_ore_values()
	var/dat = "<table border='0' width='200'>"
	for(var/ore in ore_values)
		var/value = ore_values[ore]
		dat += "<tr><td>[capitalize(ore)]</td><td>[value]</td></tr>"
	dat += "</table>"
	return dat
