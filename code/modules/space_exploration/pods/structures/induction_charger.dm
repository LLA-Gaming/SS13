/obj/machinery/pod_induction_charger
	name = "induction charger"
	icon_state = "induction_charger"
	icon = 'icons/obj/induction_charger.dmi'
	bound_width = 64
	bound_height = 64
	anchored = 1

	var/last_charge = 0
	var/charge_cooldown = 50
	var/charge_amount = 300
	var/obj/pod/charging = 0

	update_icon(var/covers = 0)
		overlays.Cut()

		if((stat & (NOPOWER|BROKEN)) || !anchored)
			overlays += image(icon = "icons/obj/induction_charger.dmi", icon_state = "broken")
			return 0

		if(!charging)
			overlays += image(icon = "icons/obj/induction_charger.dmi", icon_state = "idle")
			return 1

		if(charging.power_source.charge >= charging.power_source.maxcharge)
			overlays += image(icon = "icons/obj/induction_charger.dmi", icon_state = "fully_charged")
			return 1

		if(charging.size[1] <= 1)
			overlays += image(icon = "icons/obj/induction_charger.dmi", icon_state = "charging")
		else if(charging.size[1] > 1)
			if(!covers)
				overlays += image(icon = "icons/obj/induction_charger.dmi", icon_state = "not_overlapping")
			else
				overlays += image(icon = "icons/obj/induction_charger.dmi", icon_state = "charging")

		return 1

	emp_act(var/severity)
		if(severity < 3)
			stat |= BROKEN

	ex_act(var/severity)
		if(severity < 3)
			qdel(src)

	process()
		if((stat & (NOPOWER|BROKEN)) || !anchored)
			update_icon()
			return 0

		var/obj/pod/pod
		for(var/turf/T in locs)
			pod = locate() in T
			if(pod)
				break
		var/pod_covers_charger = 0
		if(pod)
			var/size = pod.size[1]
			if(size <= 1)
				charging = pod
			else if(size > 1)
				pod_covers_charger = 1
				for(var/turf/T in pod.GetTurfsUnderPod())
					if(!(T in locs))
						pod_covers_charger = 0

				charging = pod
		else
			charging = 0

		update_icon(pod_covers_charger)

		if(!charging)
			return 0

		if(pod.size[1] > 1 && !pod_covers_charger)
			return 0

		if((world.time + charge_cooldown) < last_charge)
			return 0

		charging.AddPower(charge_amount)

		use_power(charge_amount)

		last_charge = world.time
