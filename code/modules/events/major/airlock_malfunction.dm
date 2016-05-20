/datum/round_event_control/airlock_malfunction
	name = "Malfunctioning Airlocks"
	typepath = /datum/round_event/airlock_malfunction
	event_flags = EVENT_MAJOR
	max_occurrences = -1
	weight = 5
	accuracy = 80

/datum/round_event/airlock_malfunction/
	start_when = 0
	alert_when = 300
	end_when = 6300 //Fail at 10 minutes and 30 seconds
	var/area/impact_area
	var/list/airlocks = list()

	Setup()
		impact_area = FindEventAreaNearPeople()
		var/list/area_contents = get_area_all_atoms(impact_area)
		for(var/obj/machinery/door/airlock/A in shuffle(area_contents))
			if(istype(A,/obj/machinery/door/airlock/external)) continue
			airlocks.Add(A)
		if(!airlocks.len)
			CancelSelf() //no candidates, end self.
	Start()
		..()
		if (!prevent_stories) EventStory("The APC in [impact_area] encountered a stack overflow and messed with the various airlocks's controls.")

	Alert()
		send_alerts("Abnormal airlock activity detected in [impact_area]. Recommend station engineer involvement. ")

	Tick()
		if(!airlocks.len)
			AbruptEnd()
		else
			var/obj/machinery/door/airlock/A = safepick(airlocks)
			spawn(0)
				if(!A.arePowerSystemsOn())
					A.safe = 1
					airlocks.Remove(A)
					return
				if(A.locked) A.locked = 0
				if(A.safe) A.safe = 0
				A.open()
				sleep(10)
				A.close()

	End()
		if(airlocks.len)
			OnFail() //Oh no you didn't kill all the airlocks before the time ran out
		else
			OnPass() //Hooray

	OnFail()
		if (!prevent_stories) EventStory("The airlocks that have been malfunctioning in [impact_area.name] stopped immediately at the same time.")
		if (branching_allowed)
			var/datum/event_cycler/E = new /datum/event_cycler/(300, "CentComm Technical Advisor")
			E.events_allowed = EVENT_CONSEQUENCE
			E.lifetime = 1

	OnPass()
		if (!prevent_stories) EventStory("The crew managed to fix the malfunctioning airlocks in [impact_area.name].")
		if (branching_allowed)
			var/datum/event_cycler/E = new /datum/event_cycler/(300, "CentComm Technical Advisor")
			E.events_allowed = EVENT_REWARD
			E.lifetime = 1