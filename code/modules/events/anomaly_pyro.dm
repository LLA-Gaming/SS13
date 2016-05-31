/datum/round_event_control/anomaly/anomaly_pyro
	name = "Pyroclastic Anomaly"
	typepath = /datum/round_event/anomaly/anomaly_pyro
	event_flags = EVENT_STANDARD
	max_occurrences = 2
	weight = 15

/datum/round_event/anomaly/anomaly_pyro
	start_when = 10
	alert_when = 200
	end_when = 1200
	spawn_zone = ANOMALY_SPAWN_NEAR //*bzzt* I think Pistol Pete manifested in my chem lab
	anomaly_type = /obj/effect/anomaly/pyro

	Alert()
		send_alerts("Atmospheric anomaly detected on long range scanners. Expected location: [impact_area.name].")