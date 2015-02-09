var/datum/virtual_reality_controller/vr_controller = new()


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

		// Clean out the nulls.
		listclearnulls(contained_clients)
		listclearnulls(copies)

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

