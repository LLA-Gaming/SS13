/datum/round_event_control/carp_migration
	name = "Carp Migration"
	typepath = /datum/round_event/carp_migration
	event_flags = EVENT_CONSEQUENCE
	max_occurrences = 3
	weight = 10


/datum/round_event/carp_migration

	Alert()
		send_alerts("Unknown biological entities have been detected near [station_name()], please stand-by.")


	Start()
		for(var/obj/effect/landmark/C in landmarks_list)
			if(C.name == "carpspawn")
				new /mob/living/simple_animal/hostile/carp(C.loc)