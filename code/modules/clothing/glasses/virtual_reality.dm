var/datum/virtual_reality_controller/vr_controller = new()

/*
* Areas
*/

/area/virtual_reality
	name = "virtual reality"
	icon_state = "red2"

	requires_power = 1
	lighting_use_dynamic = 0
	has_gravity = 1
	power_equip = 1

	// This is here so it is available at this scope.

	// Items not allowed to take out of the thunderdome.
	var/list/thunderdome_items = list(/obj/item/weapon/melee/energy/sword, /obj/item/weapon/melee/baton, /obj/item/weapon/gun/energy/laser,	\
									/obj/item/clothing/suit/armor/tdome, /obj/item/clothing/head/helmet/thunderdome, /obj/item/clothing/head/helmet/swat, \
									/obj/item/clothing/suit/armor/vest, /obj/item/weapon/twohanded/dualsaber)

	// Items not allowed to take out of the perseus start area.
	var/list/forbidden_perseus_items = list(/obj/item/weapon/plastique/breach)

	// Forbidden items to take out of the firing range.
	var/list/forbidden_range_items = list(/obj/item/weapon/gun/projectile/automatic/fiveseven, /obj/item/weapon/gun/energy/ep90)

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

	// All the Entered() overrides are to prevent people from throwing items to another area to bypass the Exit restriction.
	Entered(var/atom/movable/M, var/atom/old_loc)
		for(var/x in thunderdome_items)
			if(istype(M, x))
				qdel(M)

		if(istype(get_area(old_loc), /area/virtual_reality/firing_range))
			for(var/y in forbidden_range_items)
				if(istype(M, y))
					qdel(M)

		if(istype(get_area(old_loc), /area/virtual_reality/start_perseus))
			for(var/z in forbidden_perseus_items)
				if(istype(M, z))
					qdel(M)

		..(M, old_loc)

		return 1


	start_crew/
		name = "virtual reality - crew start"
		icon_state = "blue2"

	start_perseus/
		name = "virtual reality - perseus start"
		icon_state = "blue-red2"

		// Remove breaching charges from people unless they're perseus units.
		Exited(var/atom/movable/A, var/atom/new_loc)
			..()

			if(isliving(A))
				var/mob/living/L = A
				if(!istype(get_area(new_loc), src))
					if(!locate(/obj/item/weapon/implant/enforcer) in A)
						L << "\blue Removing certain perseus items..."
						for(var/obj/item/I in L.get_contents())
							for(var/_type in forbidden_perseus_items)
								if(istype(I, _type))
									L.unEquip(I, 1)
									qdel(I)


	creative_suite/
		name = "virtual reality - creative suite area"
		icon_state = "blueold"

	thunderdome/
		name = "virtual reality - thunderdome"
		icon_state = "dark128"

		// Removes the thunder-dome items when leaving the area.
		Exited(var/atom/movable/A, var/atom/new_loc)
			..()

			if(isliving(A))
				var/mob/living/L = A
				if(!istype(get_area(new_loc), src))
					L << "\blue Removing thunderdome items..."
					for(var/obj/item/I in L.get_contents())
						for(var/_type in thunderdome_items)
							if(istype(I, _type))
								L.unEquip(I, 1)
								qdel(I)

		Enter(var/atom/movable/O, var/atom/oldloc)
			// Get (stay) out of here.
			if(istype(O, /obj/structure/stool/bed/chair/janicart))
				return 0

			return 1

	firing_range/
		icon_state = "dark"
		name = "virtualy reality - firing range"


		Exited(var/atom/movable/A, var/atom/new_loc)
			..()

			if(isliving(A))
				var/mob/living/L = A
				if(!locate(/obj/item/weapon/implant/enforcer) in A)
					if(!istype(get_area(new_loc), src))
						L << "\blue Removing firing range items..."
						for(var/obj/item/I in L.get_contents())
							for(var/_type in forbidden_range_items)
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

	var/list/forbidden_types = list()

	New()
		..()

		// If for some reason it already exists, replace it with the new one.
		if(vr_controller)
			vr_controller = src

		crew_destination = locate(/area/virtual_reality/start_crew)
		perseus_destination = locate(/area/virtual_reality/start_perseus)

		LoadForbiddenTypes()

	Del()

		// Make sure we get rid of all the people in the VR.
		for(var/mob/living/L in copies)
			if(L.client)
				var/obj/item/clothing/glasses/virtual/V = GetGogglesFromClient(L.client)
				if(V)
					L << "\red <b>You were removed from the VR. (Reason: VR controller restarting.)</b>"
					V.LeaveVR()

		..()

	proc/UpdateClients()
		for(var/obj/item/clothing/glasses/virtual/V in goggles)
			if(!V.original_mob)
				continue
			for(var/mob/living/L in copies)
				if(V.original_mob.computer_id == L.computer_id)
					V.using_client = L.client

	proc/LoadForbiddenTypes(var/file = "config/forbidden_vr_types.txt")
		if(fexists(file))
			var/list/lines = file2list(file)
			for(var/line in lines)
				if(!line)	continue

				line = trim(line)
				if(!length(line))	continue
				else if(copytext(line, 1, 2) == "#")	continue

				if(!ispath(line))
					line = text2path(line)

				if(!line)
					continue

				forbidden_types += line

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

		// Remove all bullet casings for clean-up.
		for(var/obj/item/ammo_casing/A in get_area(locate(/area/virtual_reality)))
			qdel(A)

		// Make sure we're kicking people who are not supposed to be in the VR when entering is disabled.
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

		// Remove all humans from the VR which do not belong there.
		for(var/area in typesof(/area/virtual_reality))
			for(var/mob/living/carbon/human/H in get_area(locate(area)))
				if(!(H.client in contained_clients) && !(H in copies))
					H << "\red <b>You're not supposed to be in here.</b>"
					H.loc = get_turf(safepick(latejoin))
					message_admins("\red VR: [key_name(H, 1)] entered the VR area without being a clone. (Teleported Back)")
					log_game("VR: [key_name(H)] entered the VR area without being a clone. (Teleported Back)")

		for(var/mob/living/L in copies)
			var/obj/item/clothing/glasses/virtual/V = GetGogglesFromClient(L.client)

			// This shouldn't happen unless they got teleported or teleported themselves somehow (see vr area Exited function)
			// but will make sure they stay inside the VR at all times.
			if(!istype(get_area(L), /area/virtual_reality))
				message_admins("\red VR: [key_name(L, 1)] left the virtual reality area. (Teleported back)(Skipped Area Boundary)")
				log_game("VR: [key_name(L)] left the virtual reality area. (Teleported back)(Skipped Area Boundary)")

				L.loc = safepick(get_area_turfs(crew_destination))

			// Kick people out of the VR if they're either: dead, or their "real life" counterpart is dead.
			if(V)
				if(L.stat == 2)
					V.LeaveVR()
				if(V.original_mob)
					if(V.original_mob.stat != 0)
						V.LeaveVR()

			if(L.client)
				// Make sure the client is in the contained clients list
				if(!(L.client in contained_clients))
					contained_clients += L.client

		// Make sure we're up-to-date on the goggle list.
		if(!goggles.len)
			for(var/obj/item/clothing/glasses/virtual/V in world)
				goggles += V

	// Allow the controller to handle these (currently does nothing)

	proc/HandleVREnter(var/obj/item/clothing/glasses/virtual/V, var/mob/living/carbon/human/H)
		if(!can_enter)
			if(H.client && H.client.holder && H.client.holder.rank.rights & R_PRIMARYADMIN)
				if(alert(H, "Entering the VR is currently admin blocked. Do you want to enter anyway?", "Confirmation", "Yes", "No") == "Yes")	return 1
				else	return 0
			H << "\red <b>Entering the VR is currently disabled.</b>"
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
		if(!original_mob)
			return 0

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

	invisibility = 101

	var/to_supply
	var/to_supply_amount = 5

	var/last_check = 0
	var/cooldown = 10 // seconds

	New(loc, var/_to_supply = 0, var/_to_supply_amount = 5, var/_cooldown = 5)
		..(loc)

		if(_to_supply)
			if(!ispath(_to_supply))
				_to_supply = text2path(_to_supply)

			to_supply = _to_supply

		to_supply_amount = _to_supply_amount <= 0 ? _to_supply_amount : 1
		cooldown = _cooldown > 5 ? _cooldown : 5

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
			for(var/obj/item/O in get_turf(src))
				if(istype(O, to_supply))
					count++

			for(count, count < to_supply_amount, count++)
				new to_supply(get_turf(src))

			last_check = world.time

/*
* This turns every item it is placed above into an itemstock.
*/

/obj/effect/itemstock_converter
	name = "convert to itemstock"
	icon_state = "item_stock_c"
	icon = 'icons/effects/effects.dmi'

	invisibility = 101

	var/custom_amt = 5
	var/cooldown = 10

	New()
		..()
		for(var/obj/item/O in get_turf(src))
			new /obj/effect/itemstock(get_turf(src), O.type, custom_amt, cooldown)

		qdel(src)