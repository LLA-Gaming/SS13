/datum/round_event_control/cosmic_bear
	name = "Cosmic Bear of Death"
	typepath = /datum/round_event/cosmic_bear
	earliest_start = 27000 // 45 minutes
	max_occurrences = 1
	weight = 5

/datum/round_event/cosmic_bear
	announceWhen	= 5
	var/area/impact_area
	var/turf/impact_turf

/datum/round_event/cosmic_bear/tick_queue()
	var/list/candidates = get_candidates_event(BE_CBEAR)
	if(candidates.len)
		unqueue()

/datum/round_event/cosmic_bear/setup(loop=0)
	var/safety_loop = loop + 1
	if(safety_loop > 50)
		kill()
		end()
		return
	impact_area = findEventArea()
	if(!impact_area)
		setup(safety_loop)
	impact_turf = pick(get_area_turfs(impact_area))
	for(var/mob/living/M in range(5,impact_turf))
		impact_turf = null
	for(var/turf/space/S in range(5,impact_turf))
		impact_turf = null

	if(!impact_turf || !impact_area)
		setup(safety_loop)

/datum/round_event/cosmic_bear/kill()
	if(!impact_area)
		control.occurrences--
	return ..()

/datum/round_event/cosmic_bear/announce()
	if(impact_area && impact_turf)
		priority_announce("Highly dangerous lifeform detected in [impact_area.name]. All crew are expected to avoid [impact_area.name]", "Highly Dangerous Lifeform", 'sound/AI/attention.ogg')


/datum/round_event/cosmic_bear/start()
	if(impact_turf)
		var/list/candidates = get_candidates_event(BE_CBEAR)
		if(!candidates.len && events.queue_ghost_events && !loopsafety)
			queue()
			return
		var/client/C = pick_n_take(candidates)
		var/offset_turf = get_step(impact_turf,NORTHEAST)
		var/mob/living/simple_animal/hostile/cosmic_bear/new_bear = new(impact_turf)
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