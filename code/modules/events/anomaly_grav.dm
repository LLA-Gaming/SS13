/datum/round_event_control/anomaly/anomaly_grav
	name = "Gravitational Anomaly"
	typepath = /datum/round_event/anomaly/anomaly_grav
	max_occurrences = 2
	rating = list(
				"Gameplay"	= 10,
				"Dangerous"	= 35
				)
/datum/round_event/anomaly/anomaly_grav
	startWhen = 3
	announceWhen = 20
	endWhen = 50


/datum/round_event/anomaly/anomaly_grav/announce()
	priority_announce("Gravitational anomaly detected on long range scanners. Expected location: [impact_area.name].", "Anomaly Alert")

/datum/round_event/anomaly/anomaly_grav/start()
	var/turf/T = pick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/grav(T.loc)

/datum/round_event/anomaly/anomaly_grav/declare_completion()
	if(failed)
		return "<b>Gravitational Anomaly:</b> <font color='red'>The anomaly was not deactivated, throwing the contents of [impact_area.name] around!</font>"
	else
		return "<b>Gravitational Anomaly:</b> <font color='green'>The anomaly was deactivated by the crew, keeping [impact_area.name]'s contents safe.</font>"