/datum/round_event_control/consequence
	name = "Consequence"
	typepath = /datum/round_event/consequence
	event_flags = EVENT_ENDGAME
	weight = 0
	max_occurrences = -1
	deferred_creation = 1

	New()
		..()
		//determining the weight based on other tasks weights
		var/weights = 0
		for(var/datum/round_event_control/E in events.all_events)
			if(E.event_flags & EVENT_ENDGAME)
				weights += E.weight
		weight = weights / 3

/datum/round_event/consequence
	start_when = 0
	alert_when = 0
	end_when = 0

	Start()
		var/datum/event_cycler/E = new /datum/event_cycler/(0, special_npc_name, null)
		E.events_allowed = EVENT_CONSEQUENCE
		E.lifetime = 1
		E.prevent_stories = prevent_stories
		E.alerts = sends_alerts
		E.branching = branching_allowed