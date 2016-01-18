/datum/controller/process/powernet/setup()
	name = "powernet"
	schedule_interval = 20

/datum/controller/process/powernet/doWork()
	for(var/datum/powernet/P in powernets)
		if(istype(P) && !P.gc_destroyed)
			P.reset()
			scheck()
		else
			powernets -= P