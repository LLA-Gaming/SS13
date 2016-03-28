//badmin only event to test 510 funtime boom booms

//Only uncomment when testing 510 funtime boom booms.

/*
/datum/round_event_control/orbital_bombardment
	name = "Orbital Bombardment (DANGER)"
	typepath = /datum/round_event/orbital_bombardment
	event_flags = EVENT_SPECIAL
	weight = 0

/datum/round_event/orbital_bombardment
	start_when = 300
	end_when = -1
	var/bombs = 69

	Alert()
		priority_announce("Longe-range Orbital Bombardment detected near the station. Brace for impact", "Orbital Bombardment")

	Tick()
		if(!bombs)
			AbruptEnd()
			return
		var/area/impact_area = FindEventArea()
		var/turf/impact_turf = safepick(FindImpactTurfs(impact_area))
		if(impact_turf)
			explosion(impact_turf, 3, 4, 5, 4, 0, 0, 0)
			bombs--
		else
			bombs--
			return
*/