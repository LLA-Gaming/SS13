/mob/living/carbon/alien/beepsky/humanoid/Login()
	..()
	update_hud()
	if(!isturf(loc))
		client.eye = loc
		client.perspective = EYE_PERSPECTIVE
	return
