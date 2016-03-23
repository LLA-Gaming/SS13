/datum/round_event_control/nothing
	name = "Nothing"
	typepath = /datum/round_event/nothing
	event_flags = EVENT_CONSEQUENCE
	weight = 0
	max_occurrences = 2
	deferred_creation = 1

	New()
		..()
		//determining the weight based on other tasks weights
		var/weights = 0
		for(var/datum/round_event_control/task/E in events.all_events)
			if(E.event_flags & EVENT_CONSEQUENCE)
				weights += E.weight
		weight = weights / 2

/datum/round_event/nothing
	//nothing