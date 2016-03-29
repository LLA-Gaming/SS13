//parent of all task events.

/datum/round_event_control/task
	name = "Undefined Task"
	//typepath = /datum/round_event/task
	event_flags = EVENT_TASK | EVENT_HIDDEN
	weight = 10
	var/requires_delivery = 1 //for the most part this will be 1, requires something to be sent through cargo
	var/task_level = 1
	var/complete_time = 10200 //default: 17 minutes //minutes = deciseconds * 10 * 60

/datum/round_event/task/
	end_when = -1

	var/task_name = "Get Undefined Thing"
	var/task_desc = "Do Undefined directive"
	var/complete_time = 10200
	var/task_level = 1
	var/failed = 0
	var/requires_delivery = 1

	var/list/goals = list()

	proc/check_complete(var/atom/movable/MA)
		for(var/G in goals)
			if(istype(MA,G))
				goals.Remove(G)
		if(!goals.len)
			AbruptEnd()
			cash_out()

	proc/cash_out()
		supply_shuttle.points += 50 * task_level
		return

	PreSetup(var/datum/round_event_control/task/C)
		..()
		if(C)
			if(C.complete_time >= 0)
				complete_time = world.time + C.complete_time
			else
				complete_time = -1
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

	Tick()
		if(complete_time >= 0)
			if(world.time >= complete_time) //out of time
				failed = 1
				AbruptEnd()
		else
			return

	End()
		if(!failed)
			OnFail()
		else
			OnPass()

	OnPass()
		if(supply_shuttle.task_cycler)
			if(task_level >= supply_shuttle.task_cycler.task_level)
				supply_shuttle.task_cycler.task_level++
		for(var/obj/item/device/tablet/T in tablets_list)
			if(locate(/datum/program/cargobay) in T.core.programs)
				T.alert_self("Cargo Bay Monitor", "Task Complete: [task_name]!", "cargocontrol")

//placebo effect
/datum/round_event_control/task/nothing
	name = "Nothing"
	typepath = /datum/round_event/task/nothing
	accuracy = 0 //this will never fire correctly.. as it should be
	weight = 300
	requires_delivery = 0
	complete_time = 0
	event_flags = EVENT_TASK | EVENT_HIDDEN
	deferred_creation = 1

	New()
		..()
		//determining the weight based on other tasks weights
		var/weights = 0
		for(var/datum/round_event_control/task/E in events.all_events)
			weights += E.weight
		weight = weights / 2

/datum/round_event/task/nothing
	task_name = "Nothing"
	task_desc = "Nothing"
	start_when = -1
	end_when = -1
	alert_when = -1

	Setup()
		CancelSelf()
		return