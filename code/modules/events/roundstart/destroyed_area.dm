/datum/round_event_control/destroyed_area
	name = "Destroyed Area"
	typepath = /datum/round_event/destroyed_area
	event_flags = EVENT_ROUNDSTART | EVENT_HIDDEN
	weight = 10

/datum/round_event/destroyed_area
	var/area/impact_area = null

	Setup()
		impact_area = FindEventAreaAwayFromPeople()
		if(!impact_area)
			CancelSelf()

	Start()
		var/list/impact_turfs = FindImpactTurfs(impact_area)
		var/i=5
		for(var/turf/simulated/floor/F in shuffle(impact_turfs))
			if(i<=0) break
			F.break_tile_to_plating()
			i--
		var/obj/machinery/power/apc/APC = impact_area.get_apc()
		if(APC)
			APC.overload_lighting()
			APC.opened = 1
			APC.locked = 0
			APC.update_icon()
		for(var/obj/structure/table/T in area_contents(impact_area))
			if(prob(33))
				new T.parts( T.loc )
				qdel(T)