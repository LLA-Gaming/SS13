/datum/round_event_control/meteor_wave/dust
	name = "Minor Space Dust"
	typepath = /datum/round_event/meteor_wave/dust
	event_flags = EVENT_ENDGAME
	weight = 300
	max_occurrences = 2
	deferred_creation = 1

	New()
		..()
		//determining the weight based on other tasks weights
		var/weights = 0
		for(var/datum/round_event_control/task/E in events.all_events)
			if(E.event_flags & EVENT_ENDGAME)
				weights += E.weight
		weight = weights / 2

/datum/round_event/meteor_wave/dust
	start_when = 0
	alert_when = 0
	end_when = 0

	Alert()
		return

	Start()
		spawn_meteors(1, meteorsC)

	Tick()
		return