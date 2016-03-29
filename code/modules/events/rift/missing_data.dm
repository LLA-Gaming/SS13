/datum/round_event_control/task/missing_data
	name = "Locate Missing Data"
	//typepath = /datum/round_event/task/missing_data //RETURN TO THIS AFTER THE BETA TEST
	event_flags = EVENT_TASK | EVENT_HIDDEN
	weight = 10
	complete_time = -1
	task_level = 3

/datum/round_event/task/missing_data
	var/turf/landing
	Setup()
		var/area/A
		for(var/i=0, i<=50, i++)
			A = locate(safepick(typesof(/area/derelict)))
			var/obj/machinery/power/apc/apc = A.get_apc()
			if(apc && apc.z == 4) //generally this place should be a room and not a shuttle. sometimes locate() returns areas that do not exist.. somehow
				break
			A = null
		if(A)
			var/list/turfs = FindImpactTurfs(A)
			landing = safepick(turfs)
			if(!landing)
				CancelSelf()
				return
		else
			CancelSelf()
			return
		var/goal = /obj/item/weapon/disk/rift_data
		task_name = "Missing Data Recovery"
		task_desc = pick("Some data was lost for a xenoarcheological artifact. Recover this data and we will green light on station research for it. Estimated location of the data points to Sector 4")
		goals.Add(goal)
		new /obj/item/weapon/disk/rift_data(landing)
		..()

	OnPass()
		..()
		events.spawn_orphan_event(/datum/round_event/task/xeno_artifact_research)