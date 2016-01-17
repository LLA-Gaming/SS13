/datum/controller/process/objs/setup()
	name = "objs"
	schedule_interval = 20

/datum/controller/process/objs/doWork()
	for(var/obj/O in processing_objects)
		if(istype(O) && !O.gc_destroyed)
			setLastTask("process()", "[O.type]")
			O.process()
			scheck()
		else
			processing_objects -= O