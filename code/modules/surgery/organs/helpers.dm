mob/proc/getorgan()
	return
mob/living/carbon/getorgan(typepath)
	return (locate(typepath) in internal_organs)

mob/proc/getlimb()
	return

mob/living/carbon/human/getlimb(typepath)
	return (locate(typepath) in organs)

mob/living/carbon/human/proc/isbleeding()
	if(bodytemperature <= 170)
		return 0
	var/bleeding_state = 0
	for(var/obj/item/organ/limb/L in organs)
		if(L.bleeding)
			bleeding_state += L.bleedstate
	return Clamp(bleeding_state,0,3)



