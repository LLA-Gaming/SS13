/mob/living/carbon/human/gib_animation(var/animate)
	..(animate, "gibbed-h")

/mob/living/carbon/human/dust_animation(var/animate)
	..(animate, "dust-h")

/mob/living/carbon/human/dust(var/animation = 1)
	..()

/mob/living/carbon/human/spawn_gibs()
	hgibs(loc, viruses, dna)

/mob/living/carbon/human/spawn_dust()
	new /obj/effect/decal/remains/human(loc)

/mob/living/carbon/human/death(gibbed)
	if(stat == DEAD)	return
	if(healths)		healths.icon_state = "health5"
	stat = DEAD
	attack_log += text("\[[time_stamp()]\] <font color ='red'>[key_name(src)] has died</font>")
	log_attack("<font color ='red'>[key_name(src)] has died</font>")
	dizziness = 0
	jitteriness = 0

	if(vr_controller)
		if(client in vr_controller.contained_clients)
			var/obj/item/clothing/glasses/virtual/V = vr_controller.GetGogglesFromClient(client)
			if(V)	V.LeaveVR()

	if(istype(loc, /obj/mecha))
		var/obj/mecha/M = loc
		if(M.occupant == src)
			M.go_out()

	if(!gibbed)
		emote("deathgasp") //let the world KNOW WE ARE DEAD

		update_canmove()
		if(client) blind.layer = 0

	tod = worldtime2text()		//weasellos time of death patch
	if(mind)	mind.store_memory("Time of death: [tod]", 0)
	if(ticker && ticker.mode)
//		world.log << "k"
		sql_report_death(src)
		ticker.mode.check_win()		//Calls the rounds wincheck, mainly for wizard, malf, and changeling now
	return ..(gibbed)

/mob/living/carbon/human/proc/makeSkeleton()
	if(!check_dna_integrity(src) || (dna.mutantrace == "skeleton"))	return
	dna.mutantrace = "skeleton"
	status_flags |= DISFIGURED
	update_hair()
	update_body()
	return 1

/mob/living/carbon/proc/ChangeToHusk()
	if(HUSK in mutations)	return
	mutations.Add(HUSK)
	status_flags |= DISFIGURED	//makes them unknown without fucking up other stuff like admintools
	return 1

/mob/living/carbon/human/ChangeToHusk()
	. = ..()
	if(.)
		update_hair()
		update_body()

/mob/living/carbon/proc/Drain()
	ChangeToHusk()
	mutations |= NOCLONE
	return 1