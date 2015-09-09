/datum/round_event_control/carp_migration
	name = "Carp Migration"
	typepath = /datum/round_event/carp_migration
	phases_required = 1
	max_occurrences = 6
	rating = list(
				"Gameplay"	= 5,
				"Dangerous"	= 40
				)


/datum/round_event/carp_migration
	announceWhen	= 3
	startWhen = 50

/datum/round_event/carp_migration/setup()
	startWhen = rand(40, 60)

/datum/round_event/carp_migration/announce()
	priority_announce("Unknown biological entities have been detected near [station_name()], please stand-by.", "Lifesign Alert")


/datum/round_event/carp_migration/start()
	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "carpspawn")
			new /mob/living/simple_animal/hostile/carp(C.loc)

/datum/round_event/carp_migration/declare_completion()
	var/carp_count = 0
	for(var/mob/living/simple_animal/hostile/carp/C in world)
		if(C.stat != DEAD)
			carp_count++
	if(!carp_count)
		return "<b>Carp Migration:</b> <font color='green'>The crew wiped out all of the space carps.</font>"
	if(carp_count < 5)
		return "<b>Carp Migration:</b> <font color='green'>The crew wiped out most of the space carps</font>"
	if(carp_count >= 5)
		return "<b>Carp Migration:</b> <font color='red'>The crew did not manage to kill off the space carp</font>"