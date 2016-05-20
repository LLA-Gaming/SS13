/datum/round_event_control/disease_outbreak/spontaneous_appendicitis
	name = "Spontaneous Appendicitis"
	typepath = /datum/round_event/disease_outbreak/spontaneous_appendicitis
	event_flags = EVENT_CONSEQUENCE
	max_occurrences = 4
	weight = 15
	accuracy = 100

/datum/round_event/disease_outbreak/spontaneous_appendicitis
	possible_viruses = list(/datum/disease/appendicitis)

	Alert()
		return