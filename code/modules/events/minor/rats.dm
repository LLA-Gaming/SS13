/datum/round_event_control/rats
	name = "Rat Immigration"
	typepath = /datum/round_event/rats
	event_flags = EVENT_MINOR
	weight = 0
	max_occurrences = 2
	deferred_creation = 1

	New()
		..()
		//determining the weight based on other tasks weights
		var/weights = 0
		for(var/datum/round_event_control/E in events.all_events)
			if(E.event_flags & EVENT_MINOR)
				weights += E.weight
		weight = weights / 2

/datum/round_event/rats
	var/rat_count = 1
	var/area/impact_area = null

	Setup()
		impact_area = FindEventAreaAwayFromPeople()
		if(!impact_area)
			CancelSelf()

	Start()
		var/list/impact_turfs = FindImpactTurfs(impact_area)
		for(var/i=0 to rat_count)
			if(!impact_turfs.len)
				break
			var/turf/landing = pick_n_take(impact_turfs)
			new /mob/living/simple_animal/mouse{name = "rat"}(landing)