/datum/controller/process/powernet/setup()
	name = "powernet"
	schedule_interval = 20

/datum/controller/process/powernet/doWork()
	var/i = 1
	while(i<=powernets.len)
		var/datum/powernet/P = powernets[i]
		if(P && !P.gc_destroyed)
			P.reset()
			scheck()
			i++
			continue
		powernets.Cut(i,i+1)