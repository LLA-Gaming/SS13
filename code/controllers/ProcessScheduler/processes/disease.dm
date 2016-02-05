/datum/controller/process/diseases/setup()
	name = "diseases"
	schedule_interval = 20

/datum/controller/process/diseases/doWork()
	for(var/datum/disease/D in active_diseases)
		if(istype(D) && !D.gc_destroyed)
			setLastTask("process()", "[D.type]")
			D.process()
			scheck()
		else
			active_diseases -= D