//Special event for bussing the bluespace rift event.

/datum/round_event_control/rift_bus
	name = "Bluespace Rift Events (Full)"
	typepath = /datum/round_event/rift_bus
	event_flags = EVENT_SPECIAL
	weight = 0
	var/rift_events_exist = 0

/datum/round_event/rift_bus
	Start()
		if(control:rift_events_exist)
			return
		else
			var/datum/event_cycler/task_cycler/T
			for(var/datum/event_cycler/task_cycler/cycler in events.event_cyclers)
				T = cycler
			if(!T)
				supply_shuttle.task_cycler = new /datum/event_cycler/task_cycler //spawn a task cycler if one doesn't exist already.
			var/datum/round_event_control/task/missing_data/M = locate(/datum/round_event_control/task/missing_data) in events.all_events
			M.occurrences = M.max_occurrences
			events.spawn_orphan_event(/datum/round_event/task/missing_data)
			control:rift_events_exist = 1