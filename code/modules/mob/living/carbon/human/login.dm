/mob/living/carbon/human/Login()
	..()

	if(vr_controller)
		if(src in vr_controller.copies)
			vr_controller.UpdateClients()

	update_hud()
	if(ticker.mode)
		ticker.mode.update_all_synd_icons()	//This proc only sounds CPU-expensive on paper. It is O(n^2), but the outer for-loop only iterates through syndicates, which are only prsenet in nuke rounds and even when they exist, there's usually 6 of them.
	return
