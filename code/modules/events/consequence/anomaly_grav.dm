/datum/round_event_control/anomaly/anomaly_grav
	name = "Gravitational Anomaly"
	typepath = /datum/round_event/anomaly/anomaly_grav
	event_flags = EVENT_CONSEQUENCE
	max_occurrences = 1
	weight = 5
	accuracy = 85

/datum/round_event/anomaly/anomaly_grav
	start_when = 30
	alert_when = 200
	end_when = 1200
	spawn_zone = ANOMALY_SPAWN_NEAR //asay: I'm gonna spawn 20 gravity anomalies and noone is going to stop me
	anomaly_type = /obj/effect/anomaly/grav

	Alert()
		send_alerts("Gravitational anomaly detected on long range scanners. Expected location: [impact_area.name].")

	OnFail()
		return
	OnPass()
		return