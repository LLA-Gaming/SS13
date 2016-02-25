/*
* Forcefield
*/

/obj/effect/hangar_forcefield
	name = "forcefield"
	icon = 'icons/effects/effects.dmi'
	icon_state = "bay_forcefield"
	unacidable = 1
	luminosity = 3
	anchored = 1
	density = 1
	layer = 3.3

	New()
		var/turf/simulated/S = get_turf(src)
		if(S)
			S.blocks_air = 1
		air_update_turf(1)
		..()

	Destroy()
		var/turf/simulated/S = get_turf(src)
		if(S)
			S.blocks_air = 0
		air_update_turf(1)
		..()

	var/obj/machinery/hangar_forcefield_generator/generator

	CanPass(var/atom/movable/M, var/turf/T, var/height = 0, var/air_group = 0)
		if(!generator)
			return 1
		return generator.CanPass(M, T, height, air_group)

	Move(newloc, dir)
		if(!generator)
			qdel(src)
			return 0
		generator.DestroyShields()

/*
* Forcefield generator
*/

/obj/machinery/hangar_forcefield_generator
	name = "forcefield generator"
	icon_state = "bay_forcefield_gen"
	anchored = 1
	unacidable = 1
	density = 0
	opacity = 0
	layer = 3.4
	req_access = list(access_heads)

	var/list/shields = list()
	var/list/permeable = list(/obj/pod)
	var/obj/machinery/hangar_forcefield_generator/linked
	var/list/req_passing_access = list() // Required access to pass through the shield.
	var/floor_type = /turf/simulated/floor
	var/generate_shields = 1

	New(loc, var/generate = 1)
		..()

		if(generate && generate_shields)
			spawn(4)
				GenerateShields()
		else
			generate_shields = 0

		active_power_usage =  (500 * (length(shields))) / 2

	Destroy()
		if(generate_shields)
			DestroyShields()
			qdel(linked)
		..()

	process()
		if(stat & (NOPOWER|BROKEN))
			DestroyShields()

		listclearnulls(shields)

		if(!length(shields) && !stat && generate_shields)
			GenerateShields(0)

	CanPass(var/atom/movable/M, var/turf/T, var/height = 0, var/air_group = 0)
		if(air_group || (height==0)) return 1

		if(emagged)
			return 1

		var/in_permeable = 0
		for(var/type in permeable)
			if(istype(M, type))
				in_permeable = 1
				break

		if(!in_permeable)
			return 0

		if(istype(M, /obj/pod))
			var/obj/pod/pod = M
			if(pod.pilot)
				for(var/obj/item/weapon/card/id/id in list(pod.pilot.get_active_hand(), pod.pilot.get_inactive_hand(), pod.pilot.wear_id, pod.pilot.belt))
					if(check_access(id, 1))
						return 1

				if(istype(pod.pilot.wear_id, /obj/item/device/tablet))
					var/obj/item/device/tablet/tablet = pod.pilot.wear_id
					if(tablet.id)
						var/obj/item/weapon/card/id/id = tablet.id
						if(check_access(id, 1))
							return 1

				pod.pilot << "<span class='warning'>You bounce back on the forcefield.</span>"
				return 0

		return 1

	proc/GenerateShields(var/generator = 1)
		var/turf/T = get_turf(src)
		var/obj/machinery/hangar_forcefield_generator/dummy/dummy
		while(istype(T, floor_type) && !dummy)
			var/obj/effect/hangar_forcefield/forcefield = new(T)
			for(var/obj/machinery/hangar_forcefield_generator/dummy/d in T)
				dummy = d
				break
			T = get_step(T, dir)
			shields += forcefield
			if(length(shields) == 1)
				forcefield.icon_state = "bay_forcefield_end"
			forcefield.generator = src
			forcefield.dir = dir

		if(!length(shields))
			return 0

		var/rotated = turn(dir, 180)

		var/obj/effect/hangar_forcefield/forcefield = shields[length(shields)]
		forcefield.icon_state = "bay_forcefield_end"
		forcefield.dir = rotated

		if(dummy)
			generator = 0
			linked = dummy
			UpdateLinked()

		else if(generator)
			var/obj/machinery/hangar_forcefield_generator/D = new(get_step(T, rotated), 0)
			D.dir = rotated
			D.linked = src

			linked = D

			UpdateLinked()

	proc/DestroyShields()
		for(var/obj/effect/E in shields)
			qdel(E)

	proc/Type2Name(var/type)
		switch(type)
			if(/obj/pod)
				return "Pods"
			if(/mob)
				return "Mobs"
			if(/obj/item)
				return "Items"

	proc/Name2Type(var/name)
		switch(name)
			if("Pods")
				return /obj/pod
			if("Mobs")
				return /mob
			if("Items")
				return /obj/item

	proc/UpdateLinked()
		if(!linked)
			return 0

		linked.permeable = permeable
		linked.emagged = emagged
		linked.req_access = req_access
		linked.req_passing_access = req_passing_access

	proc/OpenMenu(var/mob/living/user)
		var/dat

		dat = "Permeable: <a href='?src=\ref[src];action=add_permeable'>Add</a><br>"
		for(var/type in permeable)
			dat += "- [ispath(type) ? Type2Name(type) : type] <a href='?src=\ref[src];action=remove_permeable;toremove=[type]'>Remove</a><br>"

		var/datum/browser/popup = new(user, "hangar_forcefield", "Forcefield Control", 400, 280)
		popup.set_content(dat)
		popup.open()

	Topic(href, href_list)
		if(!usr.canUseTopic(src))
			return 0

		switch(href_list["action"])
			if("remove_permeable")
				var/type = href_list["toremove"]
				if(type in list("Atmospherics"))
					if(!(type in permeable))
						return 0
					permeable -= type
					return 1

				type = text2path(type)
				if(!(type in permeable))
					return 0

				permeable -= type

			if("add_permeable")
				var/list/choices = list()
				var/list/selectable = list(/obj/pod, /mob, /obj/item)
				if(emagged)
					selectable.Add("Atmospherics")

				for(var/type in selectable)
					if(!(type in permeable))
						choices += (ispath(type) ? Type2Name(type) : type)

				var/chosen = input(usr, "Pick", "Input") in choices
				if(!chosen)
					return 0

				if(chosen in list("Atmospherics"))
					permeable += chosen
				else
					permeable += Name2Type(chosen)

		OpenMenu(usr)
		UpdateLinked()

	check_access(obj/item/weapon/card/id/I, var/passing = 0)
		if(istype(I, /obj/item/device/tablet))
			var/obj/item/device/tablet/pda = I
			I = pda.id
		if(!istype(I) || !I.access) //not ID or no access
			return 0

		var/list/to_use = (passing ? req_passing_access : req_access)

		if(length(to_use) <= 0)
			return 1

		for(var/req in to_use)
			if(!(req in I.access)) //doesn't have this access
				return 0
		return 1

	attack_hand(var/mob/living/user)
		if(..())
			return 0

		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user

			for(var/obj/item/weapon/card/id/id in list(H.get_active_hand(), H.get_inactive_hand(), H.wear_id, H.belt))
				if(check_access(id) || emagged)
					OpenMenu(user)
					return 1

			user << "<span class='warning'>Access denied.</span>"

		else
			user << "<span class='warning'>You don't have the dexterity to use this.</span>"

	attackby(var/obj/item/I, var/mob/living/user)
		if(istype(I, /obj/item/weapon/card/emag))
			emagged = 1
			var/datum/effect/effect/system/spark_spread/sparks = new()
			sparks.set_up(5, 0, src)
			sparks.attach(src)
			sparks.start()
			user << "<span class='info'>You emag the [src].</span>"

		if(istype(I, /obj/item/weapon/card/id))
			return attack_hand(user)

	dummy/
		generate_shields = 0