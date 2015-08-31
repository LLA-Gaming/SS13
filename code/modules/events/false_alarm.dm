/datum/round_event_control/falsealarm
	name 			= "False Alarm"
	typepath 		= /datum/round_event/falsealarm
	phases_required = 0
	max_occurrences = 5
	rating = list(
				"Gameplay"	= 75, // I'm telling you man, there is something about the crew trying to lynch fake aliens that adds to gameplay
				"Dangerous"	= 10
				)

/datum/round_event/falsealarm
	announceWhen	= 0
	endWhen			= 1

/datum/round_event/falsealarm/announce()
	var/datum/round_event_control/E = pick(events.control)

	var/datum/round_event/Event = new E.typepath()

	message_admins("False Alarm: [Event]")
	Event.kill() 		//do not process this event - no starts, no ticks, no ends
	Event.announce() 	//just announce it like it's happening