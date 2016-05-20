/datum/round_event_control/eye_horror
	name = "Eye Horror"
	typepath = /datum/round_event/eye_horror
	event_flags = EVENT_ENDGAME
	max_occurrences = 1
	weight = 10
	accuracy = 100

/datum/round_event/eye_horror
	start_when = 300
	end_when = 6000
	var/area/impact_area
	var/passed = 0
	var/mob/living/simple_animal/hostile/eyehorror/eye

	Setup()
		impact_area = FindEventAreaNearPeople()
		if(!impact_area)
			CancelSelf()
			return

	Alert()
		send_alerts("Paranormal frequencies and eldritch lifesigns detected in [impact_area.name]. Evacuate [impact_area.name]")

	Start()
		var/turf/landing = pick(FindImpactTurfs(impact_area))
		eye = new /mob/living/simple_animal/hostile/eyehorror(landing)
		for(var/mob/living/L in area_contents(impact_area))
			L.flash_eyes()
			events.AddAwards("eventmedal_eyehorror",list("[L.key]"))

	Tick()
		if(eye.stat == DEAD)
			eye = null
		if(!eye)
			passed = 1
			AbruptEnd()

	End()
		if(passed)
			OnPass()
		else
			OnFail()

	OnFail()
		if (branching_allowed)
			var/datum/event_cycler/E = new /datum/event_cycler/(rand(300,1800), "The Eyes That See")
			E.events_allowed = EVENT_CONSEQUENCE
			E.lifetime = 1

	OnPass()
		if (branching_allowed)
			var/datum/event_cycler/E = new /datum/event_cycler/(rand(300,1800), "The Eyes That See")
			E.events_allowed = EVENT_REWARD
			E.lifetime = 1