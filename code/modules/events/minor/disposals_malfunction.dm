/datum/round_event_control/disposals_malfunction
	name = "Malfunctioning Disposals"
	typepath = /datum/round_event/disposals_malfunction
	event_flags = EVENT_MINOR
	max_occurrences = -1
	weight = 10
	accuracy = 80

/datum/round_event/disposals_malfunction
	end_when = 6000
	var/area/impact_area
	var/passed = 0
	var/obj/machinery/disposal/infected

	Setup()
		for(var/i=0, i<=50, i++)
			impact_area = FindEventAreaAwayFromPeople()
			if(!impact_area)
				CancelSelf()
				return
			infected = locate(/obj/machinery/disposal) in area_contents(impact_area)
			if(infected)
				break


	Alert()
		send_alerts("A disposals chute has malfunctioned.. We are not sure where. Please locate and manually reboot its pump mechanism")

	Tick()
		if(!infected.mode)
			infected = null
		else
			if(IsMultiple(active_for,2))
				var/obj/structure/disposalholder/H = new(infected)
				var/list/trash_list = list()
				for(var/T in typesof(/obj/item/trash))
					trash_list.Add(T)
				var/picked = pick(trash_list)
				new picked(H)
				infected.expel(H)
		if(!infected)
			passed = 1
			AbruptEnd()

	End()
		if(passed)
			OnPass()
		else
			OnFail()

	OnFail()
		if (branching_allowed)
			var/datum/event_cycler/E = new /datum/event_cycler/(rand(300,1800), "Garbage Expert", null)
			E.events_allowed = EVENT_CONSEQUENCE
			E.lifetime = 1

	OnPass()
		if (branching_allowed)
			var/datum/event_cycler/E = new /datum/event_cycler/(rand(300,1800), "Garbage Expert", null)
			E.events_allowed = EVENT_REWARD
			E.lifetime = 1