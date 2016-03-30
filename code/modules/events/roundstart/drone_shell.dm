/datum/round_event_control/drone_shell
	name = "Drone Shell"
	typepath = /datum/round_event/drone_shell
	event_flags = EVENT_ROUNDSTART | EVENT_HIDDEN
	weight = 10

/datum/round_event/drone_shell
	var/area/impact_area = null

	Setup()
		impact_area = FindEventAreaAwayFromPeople()
		if(!impact_area)
			CancelSelf()

	Start()
		var/list/impact_turfs = FindImpactTurfs(impact_area)
		if(impact_turfs.len)
			var/turf/landing = pick(impact_turfs)
			new /obj/item/drone_shell{origin_tech = 0}(landing)




