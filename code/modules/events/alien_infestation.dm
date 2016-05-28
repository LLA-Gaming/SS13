/datum/round_event_control/alien_infestation
	name = "Alien Infestation"
	typepath = /datum/round_event/alien_infestation
	event_flags = EVENT_STANDARD
	max_occurrences = 1
	needs_ghosts = 1
	weight = 5
	candidate_flag = BE_ALIEN
	candidate_afk_bracket = ALIEN_AFK_BRACKET
	candidates_needed = 1

/datum/round_event/alien_infestation
	alert_when	= 1200
	end_when = -1

	var/spawncount = 1
	var/successSpawn = 0
	var/alien_type = /mob/living/carbon/alien/larva

	var/crew_alive = 0
	var/target_kills = 0
	var/failed = 0

	SetTimers()
		alert_when = rand(alert_when, alert_when + 600)

	Setup()
		spawncount = rand(1, 2)
		if(!candidates.len)
			CancelSelf()
		if(holiday == "April Fool's Day")
			alien_type = /mob/living/carbon/alien/beepsky/larva

	Alert()
		priority_announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", 'sound/AI/aliens.ogg')

	Start()
		for(var/mob/living/carbon/human/L in living_mob_list)
			if(L.stat == 2) continue
			crew_alive++
		target_kills = crew_alive / 2
		if (!prevent_stories) EventStory("The rumors were true. [station_name()] was dealing with a real alien infestation.")
		var/list/vents = list()
		for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in world)
			if(temp_vent.loc.z == 1 && !temp_vent.welded && temp_vent.network)
				if(temp_vent.network.normal_members.len > 20)	//Stops Aliens getting stuck in small networks. See: Security, Virology
					vents += temp_vent

		while(spawncount > 0 && vents.len && candidates.len)
			var/obj/vent = pick_n_take(vents)
			var/client/C = pick_n_take(candidates)

			var/mob/living/carbon/alien/new_xeno = new alien_type(vent.loc)
			new_xeno.key = C.key

			spawncount--
			successSpawn = 1

	Tick()
		var/xeno_count = 0
		var/death_count = 0
		for(var/mob/living/carbon/human/L in player_list)
			if(L.stat == 2)
				death_count++
		if(death_count >= target_kills)
			failed = 1
			AbruptEnd()
		for(var/mob/living/carbon/alien/L in living_mob_list)
			if(L.stat == 2) continue
			xeno_count++
		if(!xeno_count)
			AbruptEnd()

	End()
		if(failed)
			OnFail()
		else
			OnPass()

	OnFail()
		if (!prevent_stories) EventStory("[station_name()] was eventually covered in alien weeds as the queen claimed her throne aboard the new Xeno Station.",1)

	OnPass()
		if (!prevent_stories) EventStory("[station_name()] was wiped of all xeno lifeforms by the brave crew.")
		for(var/mob/living/carbon/human/L in player_list)
			if(L.stat != DEAD)
				events.AddAwards("eventmedal_alieninfestation",list("[L.key]"))