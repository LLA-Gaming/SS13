/datum/round_event_control/false_alarm
	name = "Cooldown"
	typepath = /datum/round_event/false_alarm
	event_flags = EVENT_STANDARD
	weight			= 9
	max_occurrences = 5
	earliest_start = 0

/datum/round_event/false_alarm

	Start()
		var/datum/round_event_control/E = pick(events.all_events)

		events.spawn_orphan_event(E.typepath, 1)