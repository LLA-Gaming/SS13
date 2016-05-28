//The legacy lives on forever.

/datum/round_event_control/meteor_wave/dust
	name = "Minor Space Dust"
	typepath = /datum/round_event/meteor_wave/dust
	event_flags = EVENT_STANDARD | EVENT_HIDDEN
	weight = 300
	earliest_start = 0

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