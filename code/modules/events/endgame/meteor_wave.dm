/datum/round_event_control/meteor_wave
	name = "Meteor Wave"
	typepath = /datum/round_event/meteor_wave
	event_flags = EVENT_ENDGAME
	max_occurrences = 3
	weight = 10
	accuracy = 85

/datum/round_event/meteor_wave
	end_when = 60

	Alert()
		priority_announce("Meteors have been detected on collision course with the station.", "Meteor Alert", 'sound/AI/meteors.ogg')

	Tick()
		if(IsMultiple(active_for, 3))
			spawn_meteors(5, meteorsA) //meteor list types defined in gamemode/meteor/meteors.dm