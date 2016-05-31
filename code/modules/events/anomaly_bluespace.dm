/datum/round_event_control/anomaly/anomaly_bluespace
	name = "Bluespace Anomaly"
	typepath = /datum/round_event/anomaly/anomaly_bluespace
	event_flags = EVENT_STANDARD
	max_occurrences = 1
	weight = 5

/datum/round_event/anomaly/anomaly_bluespace
	start_when = 30
	alert_when = 100
	end_when = 1200
	spawn_zone = ANOMALY_SPAWN_RANDOM //*bzzt* Call the shuttle. Why?. No reason
	anomaly_type = /obj/effect/anomaly/bluespace

	Alert()
		send_alerts("Unstable bluespace anomaly detected on long range scanners. Expected location: [impact_area.name].")