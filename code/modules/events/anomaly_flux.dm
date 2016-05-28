/datum/round_event_control/anomaly/anomaly_flux
	name = "Energetic Flux"
	typepath = /datum/round_event/anomaly/anomaly_flux
	event_flags = EVENT_STANDARD
	max_occurrences = 2
	weight = 15

/datum/round_event/anomaly/anomaly_flux
	start_when = 30
	alert_when = 200
	end_when = 1200
	spawn_zone = ANOMALY_SPAWN_NEAR //*bzzt* OH MY GOD... JC A BOMB
	anomaly_type = /obj/effect/anomaly/flux
	var/turf/blast_spot = null

	Alert()
		send_alerts("Localized hyper-energetic flux wave detected on long range scanners. Expected location: [impact_area.name].")

	End()
		if(newAnomaly)
			blast_spot = get_turf(newAnomaly)
		..()

	OnFail()
		if(blast_spot)
			explosion(blast_spot, -1, 3, 5, 5)