var/global/pipe_processing_killed = 0

/datum/controller/process/pipenet/setup()
	name = "pipenet"
	schedule_interval = 20

/datum/controller/process/pipenet/doWork()
	if(pipe_processing_killed) return
	for(var/datum/pipe_network/P in pipe_networks)
		if(istype(P) && !P.gc_destroyed)
			P.process()
		else
			pipe_networks -= P