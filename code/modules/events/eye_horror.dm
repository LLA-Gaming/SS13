/datum/round_event_control/eye_horror
	name = "Eye Horror"
	typepath = /datum/round_event/eye_horror
	event_flags = EVENT_STANDARD
	max_occurrences = 3
	weight = 15

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