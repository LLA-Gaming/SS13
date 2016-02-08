/obj/pod

	verb/LeavePod()
		set name = "Exit Pod"
		set category = "Pod"
		set src = usr.loc

		if(istype(usr, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = usr
			if(usr.canUseTopic(src))
				HandleExit(usr)
			else if(H.handcuffed)
				var/turf/location = get_turf(src)
				H << "<span class='notice'>You attempt to remove your restraints. (This will take around [pod_config.handcuffed_exit_delay/600] minutes and the pod has to stand still)</span>"
				spawn(pod_config.handcuffed_exit_delay)
					if(get_turf(src) == location)
						if(!H.handcuffed)
							return 0

						var/obj/item/weapon/handcuffs/cuffs = H.handcuffed
						cuffs.loc = src
						var/obj/item/weapon/pod_attachment/cargo/cargo = GetAttachmentOnHardpoint(P_HARDPOINT_CARGO_HOLD)
						if(cargo)
							cargo.PlaceInto(cuffs, 1)

						H << "<span class='notice'>You break free of your restraints.</span>"
						H.handcuffed = 0
						H.update_inv_handcuffed(0)

	verb/EnterPod()
		set name = "Enter Pod"
		set category = "Pod"
		set src in view(1)

		if(istype(usr, /mob/living/carbon/human))
			// canUseTopic doesn't play nice with 64x64
			if(usr.restrained() || usr.lying || usr.stat || usr.stunned || usr.weakened)
				return 0
			if(!(usr in bounds(1)))
				return 0
			if(!isturf(src.loc) && get(src.loc, usr.type) != usr)
				return 0
			HandleEnter(usr)

	verb/OpenHUDVerb()
		set name = "Open HUD"
		set category = "Pod"
		set src = usr.loc

		OpenHUD(usr)