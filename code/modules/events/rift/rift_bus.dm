//Special event for bussing the bluespace rift event.

/datum/round_event_control/rift_bus
	name = "Bluespace Rift Events (Full)"
	typepath = /datum/round_event/rift_bus
	event_flags = EVENT_SPECIAL
	weight = 0

/datum/round_event/rift_bus
	Start()
		var/datum/round_event_control/task/missing_data/M = locate(/datum/round_event_control/task/missing_data) in events.all_events
		M.occurrences = M.max_occurrences
		events.spawn_orphan_event(/datum/round_event/task/missing_data)
