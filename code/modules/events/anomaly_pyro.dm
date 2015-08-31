/datum/round_event_control/anomaly/anomaly_pyro
	name = "Pyroclastic Anomaly"
	typepath = /datum/round_event/anomaly/anomaly_pyro
	max_occurrences = 2
	rating = list(
				"Gameplay"	= 20,
				"Dangerous"	= 60
				)

/datum/round_event/anomaly/anomaly_pyro
	startWhen = 10
	announceWhen = 3
	endWhen = 70


/datum/round_event/anomaly/anomaly_pyro/announce()
	priority_announce("Atmospheric anomaly detected on long range scanners. Expected location: [impact_area.name].", "Anomaly Alert")

/datum/round_event/anomaly/anomaly_pyro/start()
	var/turf/T = pick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/pyro(T.loc)

/datum/round_event/anomaly/anomaly_pyro/tick()
	if(!newAnomaly)
		kill()
		return
	if(IsMultiple(activeFor, 5))
		newAnomaly.anomalyEffect()

/datum/round_event/anomaly/anomaly_pyro/declare_completion()
	if(failed)
		return "<b>Pyroclastic Anomaly:</b> <font color='red'>The anomaly was not deactivated, setting [impact_area.name] ablaze!</font>"
	else
		return "<b>Pyroclastic Anomaly:</b> <font color='green'>The anomaly was deactivated by the crew, preventing [impact_area.name] from being completely consumed by flame!</font>"