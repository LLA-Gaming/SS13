/datum/round_event_control/borer_nest
	name = "Spawn a Borer Nest"
	typepath = /datum/round_event/borer_nest
	event_flags = EVENT_ROUNDSTART
	weight = 10

/datum/round_event/borer_nest
	var/area/impact_area = null

	Setup()
		impact_area = FindEventAreaAwayFromPeople()
		if(!impact_area)
			CancelSelf()

	Start()
		var/list/impact_turfs = FindImpactTurfs(impact_area)
		if(impact_turfs.len)
			var/turf/landing = pick(impact_turfs)
			new /obj/structure/borer_nest(landing)
			new /obj/structure/borer_egg(landing)






