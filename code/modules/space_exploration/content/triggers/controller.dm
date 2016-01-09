var/global/list/triggers = list()

#define TT_NORMAL 			1
#define TT_ON_COMPLETION 	2

/obj/effect/trigger_controller
	icon = 'icons/effects/space_exploration.dmi'
	icon_state = "trigger_controller"
	invisibility = 100
	layer = 4.1

	var/_id
	var/_delete_on_completion = 0
	var/completed = 0
	var/list/slaves = list() // List of triggers with same ID

	initialize()
		for(var/obj/effect/trigger/trigger in triggers)
			if(trigger._id == _id)
				slaves += trigger

		processing_objects.Add(src)

	proc/CheckCompletion()
		for(var/obj/effect/trigger/trigger in slaves)
			if(trigger.trigger_type & TT_ON_COMPLETION)
				continue

			if(!trigger.Evaluate())
				return 0

		return 1

	proc/DeleteSelfAndSlaves()
		for(var/obj/effect/trigger/trigger in slaves)
			for(var/obj/effect/trigger_modules/module in trigger.location)
				qdel(module)
			qdel(trigger)
		qdel(src)

	process()
		if(completed)
			processing_objects.Remove(src)
			if(_delete_on_completion)
				DeleteSelfAndSlaves()

			return 0

		if(CheckCompletion())
			for(var/obj/effect/trigger/trigger in slaves)
				for(var/obj/effect/trigger_modules/completion/completed in get_turf(trigger))
					completed.OnCompleted()
			completed = 1

		return 1