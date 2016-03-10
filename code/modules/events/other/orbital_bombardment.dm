//badmin only event to test 510 funtime boom booms

/datum/round_event_control/orbital_bombarment
	name = "Orbital Bombarment"
	typepath = /datum/round_event/orbital_bombarment
	event_flags = EVENT_SPECIAL
	weight = 0

/datum/round_event/orbital_bombarment
	end_when = -1
	var/bombs = 50

	Tick()
		if(!bombs)
			AbruptEnd()
			return
		var/area/impact_area = FindEventArea()
		var/turf/impact_turf = safepick(FindImpactTurfs(impact_area))
		if(impact_turf)
			explosion(impact_turf, 2, 5, 10, 7, 0, 0, 0)
			bombs--
		else
			bombs--
			return