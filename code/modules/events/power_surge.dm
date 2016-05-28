/datum/round_event_control/power_surge
	name = "Power Surge"
	typepath = /datum/round_event/power_surge
	event_flags = EVENT_STANDARD
	earliest_start = 0

/datum/round_event/power_surge
	start_when = 0
	alert_when = 300
	end_when = 2100 //Fail at 3 minutes and 30 seconds
	var/area/impact_area
	var/obj/machinery/power/apc/APC

	Setup()
		impact_area = FindEventAreaNearPeople()
		if(impact_area)
			APC = impact_area.get_apc()
		if(!APC)
			CancelSelf()

	Start()
		if (!prevent_stories) EventStory("[impact_area]'s power systems went haywire, causing power to flicker and spark electricity onto nearby crew members.")

	Alert()
		var/heard = 0
		for(var/mob/living/L in player_list)
			if(L in oview(7,get_turf(APC)))
				heard = 1
				break
		if(!heard)
			send_alerts("Abnormal power flow in [impact_area]'s powernet. Recommend station engineer involvement.")

	Tick()
		if(!APC)
			AbruptEnd()
		else
			if(!APC.operating || APC.shorted)
				APC.lighting = 3
				APC.equipment = 3
				APC.environ = 3
				APC = 0
				return
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(4, 2, get_turf(APC))
			s.start()
			//zap nerds
			for(var/mob/living/L in get_turf(APC))
				if(L.lying) continue
				L.Weaken(2)
			//
			var/random_n = rand(1,3)
			if(random_n == 1)
				APC.lighting = 0
				APC.equipment = 3
				APC.environ = 3
			if(random_n == 2)
				APC.lighting = 3
				APC.equipment = 0
				APC.environ = 3
			if(random_n == 3)
				APC.lighting = 3
				APC.equipment = 3
				APC.environ = 0
			APC.update()


	End()
		if(APC)
			APC.lighting = 3
			APC.equipment = 3
			APC.environ = 3
			OnFail()
		else
			OnPass()

	OnFail()
		if (!prevent_stories) EventStory("Crew members were far too lazy to deal with [impact_area]'s power.")

	OnPass()
		if (!prevent_stories) EventStory("The crew members were able to repair the APC in [impact_area].")