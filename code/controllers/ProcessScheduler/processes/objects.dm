/datum/controller/process/objs/setup()
	name = "objs"
	schedule_interval = 20

/datum/controller/process/objs/doWork()
	var/i = 1
	while(i<=processing_objects.len)
		var/obj/O = processing_objects[i]
		if(O && !O.gc_destroyed)
			setLastTask("process()", "[O.type]")
			O.process()
			scheck()
			i++
			continue
		processing_objects.Cut(i,i+1)