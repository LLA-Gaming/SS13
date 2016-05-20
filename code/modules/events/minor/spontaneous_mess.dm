/datum/round_event_control/spontaneous_mess
	name = "Spontaneous Mess"
	typepath = /datum/round_event/spontaneous_mess
	event_flags = EVENT_MINOR
	max_occurrences = -1
	weight = 10
	accuracy = 100

/datum/round_event/spontaneous_mess
	alert_when	= 50
	end_when = 6000
	var/area/impact_area
	var/passed = 0
	var/list/gibs = list()

	Setup()
		impact_area = FindEventAreaAwayFromPeople()
		if(!impact_area)
			CancelSelf()
			return

	Alert()
		send_alerts("An unintentional error in our Bluespace Research Division has teleported some... human components into [impact_area.name]. Remove them as soon as possible to prevent contagion.")

	Start()
		if (!prevent_stories) EventStory("Central Command warned the crew about spontaneous gib mess in [impact_area] and possible contagions.")
		for(var/turf/T in FindImpactTurfs(impact_area))
			gibs.Add(new /obj/effect/decal/cleanable/blood/gibs(T))

	Tick()
		listclearnulls(gibs)
		if(!gibs.len)
			passed = 1
			AbruptEnd()

	End()
		if(passed)
			OnPass()
		else
			OnFail()

	OnFail()
		if (!prevent_stories) EventStory("Despite the contagion warnings.. the crew was unphased and did not attempt to clean it.")
		if (branching_allowed)
			var/datum/event_cycler/E = new /datum/event_cycler/(rand(300,1800), "Bluespace Research Division", null)
			E.events_allowed = EVENT_CONSEQUENCE
			E.lifetime = 1

	OnPass()
		if (!prevent_stories) EventStory("All of the gibs in [impact_area] were clean.")
		if (branching_allowed)
			var/datum/event_cycler/E = new /datum/event_cycler/(rand(300,1800), "Bluespace Research Division", null)
			E.events_allowed = EVENT_REWARD
			E.lifetime = 1