//parent of all task events.

/datum/round_event_control/task
	name = "Undefined Task"
	//typepath = /datum/round_event/task
	event_flags = EVENT_TASK
	weight = 10
	var/requires_delivery = 1 //for the most part this will be 1, requires something to be sent through cargo
	var/task_level = 1
	var/complete_time = 10200 //default: 17 minutes //minutes = deciseconds * 10 * 60

/datum/round_event/task/
	end_when = -1

	var/task_name = "Get Undefined Thing"
	var/task_desc = "Do Undefined directive"
	var/complete_time = 10200
	var/failed = 0
	var/requires_delivery = 1

	var/list/goals = list()

	proc/check_complete(var/atom/movable/MA)
		for(var/G in goals)
			if(istype(MA,G))
				goals.Remove(G)
		if(!goals.len)
			AbruptEnd()

	PreSetup(var/datum/round_event_control/task/C)
		..()
		if(C)
			complete_time = world.time + C.complete_time
			requires_delivery = C.requires_delivery
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
		if(world.time >= complete_time) //out of time
			failed = 1
			AbruptEnd()

	End()
		if(failed)
			OnFail()
		else
			OnPass()


//placebo effect
/datum/round_event_control/task/nothing
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
	end_when = 0