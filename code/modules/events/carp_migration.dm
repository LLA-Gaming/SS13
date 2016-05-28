/datum/round_event_control/carp_migration
	name = "Carp Migration"
	typepath = /datum/round_event/carp_migration
	event_flags = EVENT_STANDARD
	earliest_start = 6000
	max_occurrences = 6
	weight = 15



/datum/round_event/carp_migration

	Alert()
		send_alerts("Unknown biological entities have been detected near [station_name()], please stand-by.")


	Start()
		for(var/obj/effect/landmark/C in landmarks_list)
			if(C.name == "carpspawn")
				new /mob/living/simple_animal/hostile/carp(C.loc)