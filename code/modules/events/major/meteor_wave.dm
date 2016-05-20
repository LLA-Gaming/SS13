/datum/round_event_control/meteor_wave
	name = "Meteor Wave"
	typepath = /datum/round_event/meteor_wave
	event_flags = EVENT_MAJOR
	max_occurrences = -1
	weight = 3
	accuracy = 100

/datum/round_event/meteor_wave
	end_when = 60

	Start()
		if (!prevent_stories) EventStory("[station_name()] was struck by meteors.")

	Alert()
		priority_announce("Meteors have been detected on collision course with the station.", "Meteor Alert", 'sound/AI/meteors.ogg')

	Tick()
		if(IsMultiple(active_for, 3))
			spawn_meteors(5, meteorsA) //meteor list types defined in gamemode/meteor/meteors.dm