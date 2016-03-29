/datum/round_event_control/cooldown
	name = "Cooldown"
	typepath = /datum/round_event/cooldown
	event_flags = EVENT_CONSEQUENCE
	max_occurrences = -1
	weight = 20
	accuracy = 100

/datum/round_event/cooldown
	var/area/impact_area

	Setup()
		impact_area = FindEventAreaNearPeople()
		if(!impact_area)
			CancelSelf()

	Start()
		for(var/turf/simulated/S in area_contents(impact_area))
			var/datum/gas_mixture/G = S.air
			if(G)
				G.temperature = 255 //not too cold where you die, but cold enough to cause slowdowns