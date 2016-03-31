//The Space Dust of Round Start Events

/datum/round_event_control/rodent_infestation
	name = "Spawn a Rodent Infestation"
	typepath = /datum/round_event/rodent_infestation
	event_flags = EVENT_ROUNDSTART
	weight = 50

/datum/round_event/rodent_infestation
	var/rat_count = 1
	var/area/impact_area = null

	Setup()
		rat_count = rand(2,5)
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





