var/global/pipe_processing_killed = 0

/datum/controller/process/pipenet/setup()
	name = "pipenet"
	schedule_interval = 20

/datum/controller/process/pipenet/doWork()
	if(pipe_processing_killed) return
	var/i = 1
	while(i<=pipe_networks.len)
		var/datum/pipe_network/P = pipe_networks[i]
		if(P && !P.gc_destroyed)
			P.process()
			scheck()
			i++
			continue
		pipe_networks.Cut(i,i+1)