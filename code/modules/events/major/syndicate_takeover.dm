/datum/round_event_control/syndicate_takeover
	name = "Syndicate Takeover"
	typepath = /datum/round_event/syndicate_takeover
	event_flags = EVENT_MAJOR
	max_occurrences = 1
	weight = 5
	accuracy = 100

/datum/round_event/syndicate_takeover
	end_when = 6000
	var/area/impact_area
	var/passed = 0
	var/syndie_count = 1
	var/list/syndies = list()
	var/party_starts = 0
	var/sec_notified = 0

	Setup()
		impact_area = FindEventAreaNearPeople()
		if(!impact_area)
			CancelSelf()
			return
		syndie_count = rand(1,3)
		party_starts = world.time + 300 //30 seconds
		sec_notified = world.time + 600 //60 seconds

	Start()
		if (!prevent_stories) EventStory("Syndicates warped into [impact_area] in a flash.. The Crew was caught off guard.")

	Tick()
		if(world.time >= party_starts && party_starts >= 0)
			var/obj/machinery/disposal/bin = locate(/obj/machinery/disposal) in area_contents(impact_area)
			var/obj/structure/disposalholder/H
			if(bin) H = new(bin)
			for(var/i=1,i<=syndie_count,i++)
				var/turf/landing = pick(FindImpactTurfs(impact_area))
				var/mob/living/carbon/human/npc/syndicate/S = new /mob/living/carbon/human/npc/syndicate_knife(landing)
				syndies.Add(S)
				if(!bin)
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(4, 2, get_turf(S))
					s.start()
				else
					S.loc = H
			if(bin)
				for(var/mob/living/carbon/human/npc/syndicate/S in syndies)
					S.real_name = "Byndicate"
					S.name = "Byndicate"
					S.voice_name = "Byndicate"
				bin.expel(H)
			playsound(get_turf(syndies[1]), 'sound/effects/EMPulse.ogg', 25, 1)
			party_starts = -1
			for(var/mob/living/carbon/human/L in area_contents(impact_area))
				if(bin) events.AddAwards("eventmedal_byndicates",list("[L.key]"))
			return
		else if(world.time >= sec_notified && sec_notified >= 0)
			priority_announce("Hostile forces detected in [impact_area.name]. This is not a drill.", "Security Alert")
			sec_notified = -1
			return
		else if (party_starts == -1)
			for(var/mob/living/carbon/human/npc/syndicate/S in syndies)
				if(S.stat == DEAD)
					syndies.Remove(S)
			listclearnulls(syndies)
			if(!syndies.len)
				passed = 1
				AbruptEnd()
		else
			var/turf/landing = pick(FindImpactTurfs(impact_area))
			playsound(landing, 'sound/items/timer.ogg', 100, 1)

	End()
		if(passed)
			OnPass()
		else
			OnFail()

	OnFail()
		if (!prevent_stories) EventStory("The Syndicates managed to setup a base of operations in [impact_area], gathered all the intelligence they needed, and send it back to their base.. all while the crew as being lazy.")
		if (branching_allowed)
			var/datum/event_cycler/E = new /datum/event_cycler/(rand(300,1800), "Space Bear Federation")
			E.events_allowed = EVENT_CONSEQUENCE
			E.lifetime = 1

	OnPass()
		if (!prevent_stories) EventStory("Despite the surprise Syndicate attack, the crew was able to neutralize the targets.")
		if (branching_allowed)
			var/datum/event_cycler/E = new /datum/event_cycler/(rand(300,1800), "Hudson")
			E.events_allowed = EVENT_REWARD
			E.lifetime = 1