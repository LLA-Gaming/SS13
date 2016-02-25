/datum/controller/process/machines/setup()
	name = "machines"
	schedule_interval = 20

/datum/controller/process/machines/doWork()
	var/i=1
	while(i<=machines.len)
		var/obj/machinery/M = machines[i]
		if(M && !M.gc_destroyed)
			setLastTask("process()", "[M.type]")
			if(M.process() != PROCESS_KILL)
				if(M.use_power)
					M.auto_use_power()
			scheck()
			i++
			continue
		machines.Cut(i,i+1)