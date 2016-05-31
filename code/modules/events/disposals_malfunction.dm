/datum/round_event_control/disposals_malfunction
	name = "Malfunctioning Disposals"
	typepath = /datum/round_event/disposals_malfunction
	event_flags = EVENT_STANDARD

/datum/round_event/disposals_malfunction
	end_when = 1200
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

	Start()
		if (!prevent_stories) EventStory("The disposal bin in [impact_area] started spewing into the room.")

	Alert()
		send_alerts("A disposals bin has malfunctioned in [impact_area]. Please locate and manually reboot its pump mechanism quickly!")

	Tick()
		if(!infected.mode)
			infected = null
		else
			if(IsMultiple(active_for,10))
				var/obj/structure/disposalholder/H = new(infected)
				var/list/trash_list = list(/obj/item/trash/can,/obj/item/trash/candle,/obj/item/trash/popcorn,/obj/item/trash/syndi_cakes,/obj/item/trash/semki,/obj/item/trash/deadmouse,/obj/item/trash/cheesie,/obj/item/trash/pistachios)
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
		if (!prevent_stories) EventStory("The crew failed to press one button to stop the malfunctioning disposal bin.")
	OnPass()
		if (!prevent_stories) EventStory("The crew rebooted the malfunctioning disposal bin.")