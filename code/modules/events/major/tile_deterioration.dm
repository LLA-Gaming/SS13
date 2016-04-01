/datum/round_event_control/tile_deterioration
	name = "Tile Deterioration"
	typepath = /datum/round_event/tile_deterioration
	event_flags = EVENT_MAJOR
	weight = 0
	max_occurrences = 2
	deferred_creation = 1

	New()
		..()
		//determining the weight based on other tasks weights
		var/weights = 0
		for(var/datum/round_event_control/E in events.all_events)
			if(E.event_flags & EVENT_MAJOR)
				weights += E.weight
		weight = weights / 2

/datum/round_event/tile_deterioration
	var/tile_count = 3
	var/area/impact_area = null

	Setup()
		impact_area = FindEventAreaAwayFromPeople()
		if(!impact_area)
			CancelSelf()

	Start()
		var/list/impact_turfs = FindImpactTurfs(impact_area)
		for(var/i=0 to tile_count)
			if(!impact_turfs.len)
				break
			var/turf/simulated/floor/landing = pick_n_take(impact_turfs)
			if(istype(landing))
				landing.break_tile_to_plating()