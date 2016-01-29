/obj/item/device/assembly/heartmonitor
	name = "heart monitor"
	icon_state = "heart_monitor"
	g_amt = 500
	m_amt = 500

	New()
		..()
		processing_objects.Add(src)

	process()
		if(!holder)
			return 0

		if(istype(holder.loc, /mob/living))
			var/mob/living/L = holder.loc
			if(L.stat || L.stunned || L.weakened)
				pulse()
