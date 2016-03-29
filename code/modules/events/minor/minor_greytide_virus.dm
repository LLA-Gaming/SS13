/datum/round_event_control/minor_greytide_virus
	name = "Minor Greytide Virus"
	typepath = /datum/round_event/minor_greytide_virus
	event_flags = EVENT_MINOR
	max_occurrences = -1
	weight = 5
	accuracy = 80

/datum/round_event/minor_greytide_virus
	special_npc_name = "Gr3y.T1d3"
	var/area/impact_area
	var/list/airlocks = list()

	Setup()
		impact_area = FindEventAreaAwayFromPeople()
		if(!impact_area)
			CancelSelf()

	Alert()
		send_alerts("[impact_area] is now open for all. Thank you for choosing Gr3y.T1d3 for all your hacking needs.")

	Start()
		for(var/obj/machinery/door/airlock/O in area_contents(impact_area))
			O.emergency = 1
			O.locked = 0
			O.update_icon(0)