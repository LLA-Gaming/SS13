/datum/round_event_control/disease_outbreak/severe
	name = "Severe Disease Outbreak"
	typepath = /datum/round_event/disease_outbreak/severe
	event_flags = EVENT_ENDGAME
	max_occurrences = 1
	weight = 5
	accuracy = 80

/datum/round_event/disease_outbreak/severe
	possible_viruses = list(/datum/disease/transformation/robot, /datum/disease/transformation/xeno, /datum/disease/wizarditis, /datum/disease/gbs)
	//now we are really playing with fire here!!
