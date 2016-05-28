/datum/round_event_control/anomaly/anomaly_vortex
	name = "Vortex Anomaly"
	typepath = /datum/round_event/anomaly/anomaly_vortex
	event_flags = EVENT_STANDARD
	max_occurrences = 5
	weight = 2

/datum/round_event/anomaly/anomaly_vortex
	start_when = 10
	alert_when = 200
	end_when = 600
	spawn_zone = ANOMALY_SPAWN_AWAY //*bzzt* I left the mechbay for 2 minutes and now there is a black hole in it.. great.
	anomaly_type = /obj/effect/anomaly/bhole

	Start()
		..()
		if (!prevent_stories) EventStory("[impact_area.name] was consumed by a black hole vortex.")

	Alert()
		send_alerts("Localized high-intensity vortex anomaly detected on long range scanners. Expected location: [impact_area.name].")

	OnFail()
		return
	OnPass()
		return