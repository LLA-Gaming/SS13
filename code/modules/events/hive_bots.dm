/datum/round_event_control/hivebots
	name = "Hivebot Invasion"
	typepath = /datum/round_event/hivebots
	event_flags = EVENT_STANDARD
	max_occurrences = 1
	weight = 5

/datum/round_event/hivebots
	alert_when	= 600
	end_when = 3000
	var/area/impact_area
	var/turf/impact_turf
	var/passed = 0

	Setup()
		impact_area = FindEventAreaNearPeople()
		if(!impact_area)
			CancelSelf()
			return
		impact_turf = safepick(FindImpactTurfs(impact_area))
		if(!impact_turf)
			CancelSelf()
			return

	Alert()
		send_alerts("Synthetic lifesigns detected in [impact_area.name]")

	Start()
		new /obj/structure/hivebot_tele(impact_turf)
		if (!prevent_stories) EventStory("Hivebots warped in [impact_area.name] in a sudden flash!")
		for(var/mob/living/carbon/human/L in area_contents(impact_area))
			events.AddAwards("eventmedal_hivebots",list("[L.key]"))

	Tick()
		var/obj/structure/hivebot_tele/tele = locate(/obj/structure/hivebot_tele) in world
		if(tele || tele.z == 1)
			return //the tele hasnt activated yet
		var/hivebot_count = 0
		for(var/mob/living/simple_animal/hostile/hivebot/bot in living_mob_list)
			hivebot_count++
		if(!hivebot_count)
			passed = 1
			AbruptEnd()

	End()
		if(passed)
			OnPass()
		else
			OnFail()

	OnPass()
		if (!prevent_stories) EventStory("The hivebots that landed in [impact_area.name] were wiped out by the crew.")