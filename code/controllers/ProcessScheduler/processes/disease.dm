/datum/controller/process/diseases/setup()
	name = "diseases"
	schedule_interval = 20

/datum/controller/process/diseases/doWork()
	var/i = 1
	while(i<=active_diseases.len)
		var/datum/disease/D = active_diseases[i]
		if(D && !D.gc_destroyed)
			setLastTask("process()", "[D.type]")
			D.process()
			scheck()
			i++
			continue
		active_diseases.Cut(i,i+1)