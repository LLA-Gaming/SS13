/datum/round_event_control/lost_tool
	name = "Lost Tools"
	typepath = /datum/round_event/lost_tool
	event_flags = EVENT_REWARD
	weight = 0
	max_occurrences = 2
	deferred_creation = 1

	New()
		..()
		//determining the weight based on other tasks weights
		var/weights = 0
		for(var/datum/round_event_control/E in events.all_events)
			if(E.event_flags & EVENT_REWARD)
				weights += E.weight
		weight = weights / 2

/datum/round_event/lost_tool
	var/tool_count = 3
	var/area/impact_area = null
	var/list/tools = list(
		/obj/item/weapon/crowbar,
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/weldingtool,
		/obj/item/weapon/wirecutters,
		/obj/item/weapon/wrench,
		/obj/item/device/multitool,
		/obj/item/device/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/device/t_scanner,
		/obj/item/device/analyzer)

	Setup()
		impact_area = FindEventAreaAwayFromPeople()
		if(!impact_area)
			CancelSelf()

	Start()
		var/list/impact_turfs = FindImpactTurfs(impact_area)
		for(var/i=0 to tool_count)
			if(!impact_turfs.len)
				break
			var/turf/landing = pick_n_take(impact_turfs)
			var/picked = pick_n_take(tools)
			new picked(landing)