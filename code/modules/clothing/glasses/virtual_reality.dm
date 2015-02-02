var/datum/virtual_reality_controller/vr_controller = new()

/*
* Areas
*/

/area/virtual_reality
	name = "virtual reality"
	icon_state = "red2"

	requires_power = 0
	lighting_use_dynamic = 0
	has_gravity = 1

	Exited(var/atom/movable/A, var/atom/new_loc)
		if(isliving(A))
			var/mob/living/L = A

			if(!istype(get_area(L), /area/virtual_reality))
				message_admins("\red VR: [key_name(L, 1)] left the virtual reality area. (Teleported back)")
				log_game("VR: [key_name(L)] left the virtual reality area. (Teleported back)")

				..(L, new_loc)

				spawn(0)	L.loc = safepick(get_area_turfs(vr_controller.crew_destination))

				return 0

		..(A, new_loc)

	start_crew/
		name = "virtual reality - crew start"
		icon_state = "blue2"

	start_perseus/
		name = "virtual reality - perseus start"
		icon_state = "blue-red2"

	creative_suite/
		name = "virtual reality - creative suite area"
		icon_state = "blueold"

	thunderdome/
		name = "virtual reality - thunderdome"
		icon_state = "dark128"

		var/list/thunderdome_items = list(/obj/item/weapon/melee/energy/sword, /obj/item/weapon/melee/baton, /obj/item/weapon/gun/energy/laser,	\
											/obj/item/clothing/suit/armor/tdome, /obj/item/clothing/head/helmet/thunderdome, /obj/item/clothing/head/helmet/swat, \
											/obj/item/clothing/suit/armor/vest)

		// Removes the thunder-dome items when leaving the area.
		Exited(var/atom/movable/A, var/atom/new_loc)
			..()

			if(isliving(A))
				var/mob/living/L = A

				if(!istype(get_area(new_loc), src))
					L << "\blue You left the thunderdome. Removing thunderdome items."
					for(var/obj/item/I in L)
						for(var/_type in thunderdome_items)
							if(istype(I, _type))
								L.unEquip(I, 1)
								qdel(I)

/*
* VR Controller
*/

/datum/virtual_reality_controller
	var/area/crew_destination
	var/area/perseus_destination

	var/list/contained_clients = list() // List of clients who are inside the VR
	var/list/copies = list()
	var/list/goggles = list()

	var/can_enter = 1

	New()
		..()

		if(vr_controller)
			vr_controller = src

		crew_destination = locate(/area/virtual_reality/start_crew)
		perseus_destination = locate(/area/virtual_reality/start_perseus)

	proc/CreateMob(var/mob/living/carbon/human/H, var/glasses_type)
		var/area/destination

		if(glasses_type == 0)
			destination = crew_destination
		else if(glasses_type == 1)
			destination = perseus_destination

		var/mob/living/carbon/human/new_mob = new(pick(get_area_turfs(destination)))
		copy_human(H, new_mob, 1)

		copies += new_mob

		return new_mob

	proc/GetGogglesFromClient(var/client/C)
		if(C in contained_clients)
			for(var/obj/item/clothing/glasses/virtual/V in goggles)
				if(V.using_client == C)
					return V

		return 0

	proc/process()

		if(!can_enter)
			if(copies.len)
				var/copies_amt = 0
				var/show_message = 1
				for(var/mob/living/L in copies)
					if(L.client.holder)
						show_message = 0
						continue
					var/obj/item/clothing/glasses/virtual/V = GetGogglesFromClient(L.client)
					if(V)
						L << "\red You were kicked from the VR. (Reason: Admin turned entering off)"
						V.LeaveVR()
					copies_amt++

				if(show_message)
					message_admins("\red VR: Kicked [copies_amt] people from VR (entering disabled).")
					log_game("\red VR: Kicked [copies_amt] people from VR (entering disabled).")

		for(var/mob/living/L in copies)
			if(!istype(get_area(L), /area/virtual_reality))
				message_admins("\red VR: [key_name(L, 1)] left the virtual reality area. (Teleported back)(Skipped Area Boundary)")
				log_game("VR: [key_name(L)] left the virtual reality area. (Teleported back)(Skipped Area Boundary)")

				L.loc = safepick(get_area_turfs(crew_destination))

	// Allow the controller to handle these (currently does nothing)

	proc/HandleVREnter(var/obj/item/clothing/glasses/virtual/V, var/mob/living/carbon/human/H)
		if(!can_enter)
			if(H.client && H.client.holder && H.client.holder.rank.rights & R_PRIMARYADMIN)
				if(alert(H, "Entering the VR is currently admin blocked. Do you want to enter anyway?", "Confirmation", "Yes", "No") == "Yes")	return 1
				else	return 0
			H << "\red Entering the VR is currently disabled."
			return 0

		// Unset any changeling stings they might have.
		if(H.mind && H.mind.changeling)
			if(H.mind.changeling.chosen_sting)
				H.mind.changeling.chosen_sting.unset_sting(H)

		return 1

	proc/HandleVRExit(var/obj/item/clothing/glasses/virtual/V, var/client/C)
		return 1

/*
* VR Goggles
*/

/obj/item/clothing/glasses/virtual
	name = "virtual reality goggles"
	icon_state = "vrgoggles"

	g_amt = 100
	m_amt = 300

	var/glasses_type = 0 // 0 = Crew | 1 = Perseus
	var/is_in_use = 0
	var/client/using_client
	var/mob/living/carbon/human/original_mob

	perseus/
		name = "perseus virtual reality goggles"
		glasses_type = 1

	examine()
		..()
		// just some fluff
		usr << "\blue These glasses have an access level of [glasses_type + 1]."

	New()
		..()
		vr_controller.goggles += src

	equipped(var/mob/living/L, var/slot)
		..()

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(!H.glasses)

				if(slot != slot_glasses)
					return 1

				if(!H.client)
					return 1

				if(H.stat != 0)
					return 1

				if(H.client in vr_controller.contained_clients)
					L << "\red Looks like you're already in the VR. Contact the admins/coders."
					return 1

				if(!is_in_use)
					EnterVR(H)

	dropped(var/mob/living/carbon/human/H)
		..()
		LeaveVR()

	Del()
		vr_controller.goggles -= src
		LeaveVR()
		..()

	proc/EnterVR(var/mob/living/carbon/human/H)
		if(!H)
			return 0

		if(!vr_controller.HandleVREnter(src, H))
			H.unEquip(src)
			H.put_in_active_hand(src)
			return 0

		is_in_use = 1
		vr_controller.contained_clients += H.client
		using_client = H.client

		original_mob = H

		var/mob/living/carbon/human/new_mob = vr_controller.CreateMob(H, glasses_type)

		H.mind.transfer_to(new_mob)

		new_mob.verbs += /mob/proc/LeaveVRVerb

		new_mob << "\blue <font size=4>Welcome to the Virtual Reality!</font>"
		new_mob << "\blue <b>To leave the Virtual Reality, press the 'Leave Virtual Reality' verb in the 'Virtual Reality' tab.</b>"

		return

	proc/LeaveVR()
		if(!vr_controller.HandleVRExit(src, using_client))
			return 0

		if(using_client && using_client.mob && using_client.mob.mind)
			var/mob/living/copy
			for(var/mob/living/L in vr_controller.copies)
				if(L.client == using_client)
					copy = L
					vr_controller.copies -= L
					break

			using_client.mob.mind.transfer_to(original_mob)

			if(copy)
				qdel(copy)

		is_in_use = 0
		vr_controller.contained_clients -= using_client
		original_mob = 0
		using_client = 0

		return

/*
* Leave VR verb
*/

/mob/proc/LeaveVRVerb()
	set name = "Leave Virtual Reality"
	set category = "Virtual Reality"

	var/obj/item/clothing/glasses/virtual/V = vr_controller.GetGogglesFromClient(client)
	if(V)
		V.LeaveVR()
	else
		message_admins("\red VR: [key_name(src, 1)] broke the 'Leave Virtual Reality' verb.")
		log_game("VR: [key_name(src)] broke the 'Leave Virtual Reality' verb.")

/*
* Unlocked guns
*/

/obj/item/weapon/gun/projectile/automatic/fiveseven/nolock
	locked = 0

/obj/item/weapon/gun/energy/ep90/nolock
	locked = 0

/*
* An object to keep a certain item stocked at its position.
*/

/obj/effect/itemstock
	name = "item stock"
	icon_state = "item_stock"
	icon = 'icons/effects/effects.dmi'

	invisibility = 100

	var/to_supply
	var/to_supply_amount = 5

	var/last_check = 0
	var/cooldown = 10 // seconds

	New()
		..()

		if(!to_supply)
			qdel(src)
			return 0
		else
			if(!ispath(to_supply))
				to_supply = text2path(to_supply)

		processing_objects.Add(src)

	process()
		if(world.time > last_check + (cooldown*10))

			var/count = 0
			for(var/obj/O in get_turf(src))
				if(istype(O, to_supply))
					count++

			for(count, count < to_supply_amount, count++)
				new to_supply(get_turf(src))

			last_check = world.time
