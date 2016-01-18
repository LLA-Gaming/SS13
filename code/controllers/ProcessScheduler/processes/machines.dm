/datum/controller/process/machines/setup()
	name = "machines"
	schedule_interval = 20

/datum/controller/process/machines/doWork()
	for(var/obj/machinery/M in machines)
		if(istype(M) && !M.gc_destroyed)
			setLastTask("process()", "[M.type]")
			if(M.process() != PROCESS_KILL)
				if(M.use_power)
					M.auto_use_power()
			scheck()
		else
			machines -= M