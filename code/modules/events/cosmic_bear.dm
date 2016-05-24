/datum/round_event_control/cosmic_bear
	name = "Cosmic Bear of Death"
	typepath = /datum/round_event/cosmic_bear
	earliest_start = 27000 // 45 minutes
	max_occurrences = 1
	weight = 5
	event_flags = EVENT_STANDARD
	candidate_flag = BE_CBEAR
	candidates_needed = 1

/datum/round_event/cosmic_bear
	alert_when		= 100
	end_when 		= -1
	special_npc_name = "Space Park Ranger"
	var/area/impact_area
	var/turf/impact_turf
	var/mob/living/simple_animal/hostile/cosmic_bear/new_bear
	var/crew_alive = 0
	var/target_kills = 0
	var/failed = 0

	Setup()
		special_npc_name = special_npc_name + " [pick(last_names)]"
		impact_area = FindEventAreaAwayFromPeople()
		if(!impact_area)
			CancelSelf()
			return
		impact_turf = safepick(FindImpactTurfs(impact_area))
		if(!impact_turf)
			CancelSelf()
			return

	Alert()
		send_alerts("Highly dangerous lifeform detected in [impact_area.name]. All crew are expected to avoid [impact_area.name]")

	Start()
		if (!prevent_stories) EventStory("In a quick flash, Cosmicam Ursus Mortis appeared in [impact_area.name] destroying anything in its way.")
		for(var/mob/living/carbon/human/L in living_mob_list)
			if(L.stat == 2) continue
			crew_alive++
		target_kills = crew_alive / 2
		var/client/C = pick(candidates)
		var/offset_turf = get_step(impact_turf,NORTHEAST)
		new_bear = new(impact_turf)
		new_bear.key = C.key

		//destroy all things in spawn zone
		for(var/atom/movable/AM in range(1,offset_turf))
			if(AM == new_bear) continue
			if(!AM.density) continue
			AM.ex_act(1)
		//spark effects
		for(var/turf/F in range(1,offset_turf))
			if(istype(F,/turf/simulated/wall))
				var/turf/simulated/wall/W = F
				W.dismantle_wall(1) //crush walls
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(4, 2, F)
			s.start()

	Tick()
		if(!new_bear)
			AbruptEnd()
		var/death_count = 0
		for(var/mob/living/carbon/human/L in living_mob_list)
			if(L.stat == 2)
				death_count++
		if(death_count >= target_kills)
			failed = 1
			AbruptEnd()

	End()
		if(failed)
			OnFail()
		else
			OnPass()

	OnFail()
		if (!prevent_stories) EventStory("Cosmicam Ursus Mortis devoured what was left of [station_name()].",1)

	OnPass()
		if (!prevent_stories) EventStory("The crew managed to slay Cosmicam Ursus Mortis. The beast let out one final roar before exploding into a pile of bear meat.")
		for(var/mob/living/carbon/human/L in player_list)
			if(L.stat != DEAD)
				events.AddAwards("eventmedal_cosmicbear",list("[L.key]"))