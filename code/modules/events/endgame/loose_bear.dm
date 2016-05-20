/datum/round_event_control/loose_bear
	name = "Loose Space Bears"
	typepath = /datum/round_event/loose_bear
	event_flags = EVENT_ENDGAME
	max_occurrences = -1
	weight = 10
	accuracy = 80

/datum/round_event/loose_bear
	special_npc_name = "Space Bear Federation"
	alert_when	= 600
	end_when = 6000
	var/area/impact_area
	var/passed = 0
	var/bear_count = 1
	var/list/bears = list()

	Setup()
		impact_area = FindEventAreaAwayFromPeople()
		var/list/turf_test = FindImpactTurfs(impact_area)
		if(!impact_area || !turf_test.len)
			CancelSelf()
			return
		bear_count = rand(1,3)

	Alert()
		send_alerts("A picnic basket was reported missing in [impact_area.name]")

	Start()
		if (!prevent_stories) EventStory("A stray bear managed to board [station_name()] in search of picnic baskets.")
		for(var/i=1,i<=bear_count,i++)
			var/turf/landing = safepick(FindImpactTurfs(impact_area))
			var/mob/living/simple_animal/hostile/bear/B = new /mob/living/simple_animal/hostile/bear(landing)
			bears.Add(B)

	Tick()
		for(var/mob/living/simple_animal/hostile/bear/B in bears)
			if(B.stat == DEAD)
				bears.Remove(B)
		listclearnulls(bears)
		if(!bears.len)
			passed = 1
			AbruptEnd()

	End()
		if(passed)
			OnPass()
		else
			OnFail()

	OnFail()
		if (branching_allowed)
			var/datum/event_cycler/E = new /datum/event_cycler/(rand(300,1800), "Space Bear Federation")
			E.events_allowed = EVENT_CONSEQUENCE
			E.lifetime = 1

	OnPass()
		if (branching_allowed)
			var/datum/event_cycler/E = new /datum/event_cycler/(rand(300,1800), "Hudson")
			E.events_allowed = EVENT_REWARD
			E.lifetime = 1