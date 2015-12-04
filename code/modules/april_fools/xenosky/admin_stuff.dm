/proc/create_xenosky(ckey)
	if(!ckey)
		var/list/candidates = list()
		for(var/mob/M in player_list)
			if(M.stat != DEAD)		continue	//we are not dead!
			if(!M.client.prefs.be_special_event & BE_ALIEN)	continue	//we don't want to be an alium
			if(M.client.is_afk())	continue	//we are afk
			if(M.mind && M.mind.current && M.mind.current.stat != DEAD)	continue	//we have a live body we are tied to
			candidates += M.ckey
		if(candidates.len)
			ckey = input("Pick the player you want to respawn as a xenosky.", "Suitable Candidates") as null|anything in candidates
		else
			usr << "<font color='red'>Error: create_xenosky(): no suitable candidates.</font>"
	if(!istext(ckey))	return 0

	var/alien_caste = input(usr, "Please choose which caste to spawn.","Pick a caste",null) as null|anything in list("Queen","Hunter","Sentinel","Drone","Larva")
	var/obj/effect/landmark/spawn_here = xeno_spawn.len ? pick(xeno_spawn) : pick(latejoin)
	var/mob/living/carbon/alien/new_xeno
	switch(alien_caste)
		if("Queen")		new_xeno = new /mob/living/carbon/alien/beepsky/humanoid/queen(spawn_here)
		if("Hunter")	new_xeno = new /mob/living/carbon/alien/beepsky/humanoid/hunter(spawn_here)
		if("Sentinel")	new_xeno = new /mob/living/carbon/alien/beepsky/humanoid/sentinel(spawn_here)
		if("Drone")		new_xeno = new /mob/living/carbon/alien/beepsky/humanoid/drone(spawn_here)
		if("Larva")		new_xeno = new /mob/living/carbon/alien/beepsky/larva(spawn_here)
		else			return 0

	new_xeno.ckey = ckey
	message_admins("\blue [key_name_admin(usr)] has spawned [ckey] as a filthy xenosky [alien_caste].", 1)
	return 1