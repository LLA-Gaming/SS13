/datum/round_event_control/anomaly
	name = "Energetic Flux"
	//typepath = /datum/round_event/anomaly
	//see anomaly_flux.dm for this event. /this/ event is just a base for anomaly events.
	event_flags = EVENT_CONSEQUENCE

/datum/round_event/anomaly
	var/area/impact_area
	var/turf/impact_spot
	var/obj/effect/anomaly/newAnomaly
	var/anomaly_type = /obj/effect/anomaly/flux
	var/spawn_zone = 0
	var/passed = 0
	var/const/ANOMALY_SPAWN_RANDOM = 0
	var/const/ANOMALY_SPAWN_NEAR = 1
	var/const/ANOMALY_SPAWN_AWAY = 2


	Setup()
		switch(spawn_zone)
			if(ANOMALY_SPAWN_RANDOM)
				impact_area = FindEventArea()
			if(ANOMALY_SPAWN_NEAR)
				impact_area = FindEventAreaNearPeople()
			if(ANOMALY_SPAWN_AWAY)
				impact_area = FindEventAreaAwayFromPeople()
		if(!impact_area)
			CancelSelf()
			return
		impact_spot = safepick(FindImpactTurfs(impact_area))
		if(!impact_spot)
			CancelSelf()
			return

	Alert()
		send_alerts("Localized hyper-energetic flux wave detected on long range scanners. Expected location of impact: [impact_area.name].")

	Start()
		var/turf/T = impact_spot
		if(T)
			newAnomaly = new anomaly_type(T.loc)

	Tick()
		if(!newAnomaly)
			passed = 1
			AbruptEnd()
			return
		newAnomaly.anomalyEffect()

	End()
		if(newAnomaly)//Kill the anomaly if it still exists at the end.
			qdel(newAnomaly)
		if(passed)
			OnPass()
		else
			OnFail()

	OnFail()
		if (branching_allowed)
			var/datum/event_cycler/E = new /datum/event_cycler/(300, "CentComm Anomaly Advisor")
			E.events_allowed = EVENT_CONSEQUENCE
			E.lifetime = 1

	OnPass()
		if (branching_allowed)
			var/datum/event_cycler/E = new /datum/event_cycler/(300, "CentComm Anomaly Advisor")
			E.events_allowed = EVENT_REWARD
			E.lifetime = 1