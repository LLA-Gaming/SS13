/datum/round_event_control/stray_cat
	name = "Stray Cat"
	typepath = /datum/round_event/stray_cat
	event_flags = EVENT_STANDARD
	max_occurrences = 1
	weight = 5
	earliest_start = 0

/datum/round_event/stray_cat/
	var/area/impact_area
	var/list/airlocks = list()

	Setup()
		impact_area = FindEventAreaAwayFromPeople()
		if(!impact_area)
			CancelSelf()
	Start()
		var/turf/landing = pick(FindImpactTurfs(impact_area))
		new /mob/living/simple_animal/cat/Proc(landing)
		if (!prevent_stories) EventStory("A stray cat managed to make its way onto the station.")
		//yep thats it.