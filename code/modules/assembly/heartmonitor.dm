/obj/item/device/assembly/heartmonitor
	name = "heart monitor"
	icon_state = "heart_monitor"
	g_amt = 500
	m_amt = 500

	New()
		..()
		processing_objects.Add(src)

/obj/item/device/assembly/heartmonitor
	name = "heart monitor"
	icon_state = "heart_monitor"
	g_amt = 500
	m_amt = 500
	var/mob/living/last_checked = 0
	var/last_checked_stat = -1

	New()
		..()
		processing_objects.Add(src)

	process()
		if(!holder)
			return 0

		var/atom/last = src
		var/mob/living/found
		for(var/i in 1 to 5)
			if(istype(last, /area))
				break
			if(istype(last.loc, /mob/living))
				found = last.loc
				break
			last = last.loc

		if(!found)
			return 0

		var/list/tocheck = list(found.r_hand, found.l_hand)
		if(istype(found, /mob/living/carbon/human))
			tocheck += list(found:l_store, found:r_store, found:s_store , found:belt)

			for(var/obj/item/I in found:internal_organs)
				tocheck += I

		if(!(last in tocheck))
			return 0

		var/has_status_effects = (found.stunned || found.weakened)

		if(found == last_checked && found.stat == last_checked_stat && !has_status_effects)
			return 0

		last_checked = found
		last_checked_stat = found.stat

		if(found.stat || has_status_effects)
			pulse()
