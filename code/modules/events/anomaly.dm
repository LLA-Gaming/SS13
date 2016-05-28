/datum/round_event_control/anomaly
	name = "Energetic Flux"
	//typepath = /datum/round_event/anomaly
	//see anomaly_flux.dm for this event. /this/ event is just a base for anomaly events.
	event_flags = EVENT_STANDARD
	max_occurrences = 0 //This one probably shouldn't occur! It'd work, but it wouldn't be very fun.
	weight = 15

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
		if(spawn_zone == ANOMALY_SPAWN_NEAR)
			for(var/mob/living/carbon/human/L in area_contents(impact_area))
				events.AddAwards("eventmedal_anomaly",list("[L.key]"))
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