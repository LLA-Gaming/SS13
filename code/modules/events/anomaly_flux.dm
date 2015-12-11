/datum/round_event_control/anomaly/anomaly_flux
	name = "Energetic Flux"
	typepath = /datum/round_event/anomaly/anomaly_flux
	max_occurrences = 2
	weight = 15


/datum/round_event/anomaly/anomaly_flux
	startWhen = 3
	announceWhen = 20
	endWhen = 60


/datum/round_event/anomaly/anomaly_flux/announce()
	priority_announce("Localized hyper-energetic flux wave detected on long range scanners. Expected location: [impact_area.name].", "Anomaly Alert")


/datum/round_event/anomaly/anomaly_flux/start()
	var/turf/T = pick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/flux(T.loc)


/datum/round_event/anomaly/anomaly_flux/end()
	if(newAnomaly && !newAnomaly.loc) //if it doesn't exist in the game world its probably in the GC
		failed = 0
		qdel(newAnomaly)
		return
	if(newAnomaly)//If it hasn't been neutralized, it's time to blow up.
		failed = 1
		explosion(newAnomaly, -1, 3, 5, 5)
		qdel(newAnomaly)
	else
		failed = 0