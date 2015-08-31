/datum/round_event_control/meteor_wave/dust
	name = "Minor Space Dust"
	typepath = /datum/round_event/meteor_wave/dust
	phases_required = 0
	max_occurrences = 1000
	rating = list(
				"Gameplay"	= 50, //stuck in the middle of the grid, neither annoying nor gameplay..
				"Dangerous"	= 0
				)

/datum/round_event/meteor_wave/dust
	startWhen		= 1
	endWhen			= 2

/datum/round_event/meteor_wave/dust/announce()
	return

/datum/round_event/meteor_wave/dust/start()
	spawn_meteors(1, meteorsC)

/datum/round_event/meteor_wave/dust/tick()
	return