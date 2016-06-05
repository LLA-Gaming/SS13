//parent of all task events.

/datum/round_event_control/task
	name = "Undefined Task"
	//typepath = /datum/round_event/task
	event_flags = EVENT_TASK | EVENT_HIDDEN
	weight = 10
	earliest_start = 0
	var/requires_delivery = 1 //for the most part this will be 1, requires something to be sent through cargo
	var/task_level = 1

/datum/round_event/task/
	end_when = -1

	var/task_name = "Get Undefined Thing"
	var/task_desc = "Do Undefined directive"
	var/task_level = 1
	var/requires_delivery = 1

	var/list/goals = list()
	var/list/completed_goals = list()

	proc/check_complete(var/atom/movable/MA)
		for(var/G in goals)
			if(istype(MA,G))
				if(G in completed_goals) continue
				completed_goals.Add(G)
		if(completed_goals.len == goals.len)
			cash_out()
			AbruptEnd()

	proc/cash_out()
		supply_shuttle.points += 50 * task_level
		return

	PreSetup(var/datum/round_event_control/task/C)
		..()
		if(C)
			requires_delivery = C.requires_delivery
			task_level = C.task_level
		return

	Setup()
		if(!supply_shuttle)
			CancelSelf()
		if(requires_delivery)
			supply_shuttle.tasks.Add(src)

	Alert()
		for(var/obj/item/device/tablet/T in tablets_list)
			if(locate(/datum/program/cargobay) in T.core.programs)
				T.alert_self("Cargo Bay Monitor", "New task from Central Command!", "cargocontrol")

	End()
		OnPass()

	OnPass()
		if(supply_shuttle.task_cycler)
			if(task_level >= supply_shuttle.task_cycler.task_level)
				supply_shuttle.task_cycler.task_level++
		supply_shuttle.tasks.Remove(src)
		for(var/obj/item/device/tablet/T in tablets_list)
			if(locate(/datum/program/cargobay) in T.core.programs)
				T.alert_self("Cargo Bay Monitor", "Task Complete: [task_name]!", "cargocontrol")