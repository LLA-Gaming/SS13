/datum/round_event_control/hivebots
	name = "Hivebot Invasion"
	typepath = /datum/round_event/hivebots
	event_flags = EVENT_MAJOR
	weight = 10
	max_occurrences = 1

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
		EventStory("Hivebots warped in [impact_area.name] in a sudden flash!")

	Tick()
		var/obj/structure/hivebot_tele/tele = locate(/obj/structure/hivebot_tele) in world
		if(tele.z == 1)
			return //the tele hasnt activated yet
		var/hivebot_count = 0
		for(var/mob/living/simple_animal/hostile/hivebot/bot in living_mob_list)
			hivebot_count++
		if(!hivebot_count)
			AbruptEnd()
			passed = 1

	End()
		if(passed)
			OnPass()
		else
			OnFail()

	OnFail()
		var/datum/event_cycler/E = new /datum/event_cycler/(rand(300,1800), "???")
		E.events_allowed = EVENT_CONSEQUENCE
		E.lifetime = 1

	OnPass()
		EventStory("The hivebots that landed in [impact_area.name] were wiped out by the crew.")
		var/datum/event_cycler/E = new /datum/event_cycler/(rand(300,1800), "???")
		E.events_allowed = EVENT_REWARD
		E.lifetime = 1