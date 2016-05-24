/datum/round_event_control/meteor_wave/meaty
	name = "Meaty Ore Wave"
	typepath = /datum/round_event/meteor_wave/meaty
	max_occurrences = 1
	weight = 1

/datum/round_event/meteor_wave/meaty
	Alert()
		priority_announce("Meaty ores have been detected on collision course with the station.", "Oh Crap, Get The Mop.",'sound/AI/meteors.ogg')

	Tick()
		if(IsMultiple(active_for, 3))
			spawn_meteors(5, meteorsB) //meteor list types defined in gamemode/meteor/meteors.dm