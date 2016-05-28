/datum/round_event_control/honking_angel
	name = "Honking Angel"
	typepath = /datum/round_event/honking_angel
	event_flags = EVENT_STANDARD
	max_occurrences = 1
	needs_ghosts = 1
	weight = 5
	candidate_flag = BE_ANGEL
	candidates_needed = 1

/datum/round_event/honking_angel

	var/spawncount = 1
	var/successSpawn = 0

	var/crew_alive = 0
	var/target_kills = 0
	var/failed = 0

	Setup()
		spawncount = rand(5, 8)

	Alert()
		priority_announce("Space-time anomalies detected on the station. There is no additional data.", "Anomaly Alert", 'sound/AI/spanomalies.ogg')

	Start()
		for(var/mob/living/L in player_list)
			if(L.stat == 2) continue
			crew_alive++
		target_kills = crew_alive / 2
		if (!prevent_stories) EventStory("Strange clown statues started appearing inside [station_name()]. Otherwise known as the Honking Angels.")
		var/list/possible_floors = list()
		spawncount = pick(1,1,1,2,2,3)
		for(var/turf/simulated/floor/temp_floor in world)
			if(temp_floor.z == 1 && !temp_floor.lighting_lumcount >= 0.50)
				possible_floors += temp_floor

	//
		var/list/candidates = get_candidates_event(BE_ANGEL)

		while(spawncount > 0 && possible_floors.len && candidates.len)
			var/turf/simulated/floor/F = pick_n_take(possible_floors)
			var/client/C = pick_n_take(candidates)
			//////
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(4, 2, F)
			s.start()
			var/mob/living/simple_animal/hostile/weeping_honk/M = new(F)
			//world << {"\red <b>[F]</b>"}
			//var/M = new /mob/living/simple_animal/hostile/weeping_honk(vent.loc)
			if (C)
				M.key = C.key

			spawncount--
			successSpawn = 1