/datum/controller/process/mobs/setup()
	name = "mobs"
	schedule_interval = 20

/datum/controller/process/mobs/doWork()
	var/i = 1
	while(i<=mob_list.len)
		var/mob/M = mob_list[i]
		if(M && !M.gc_destroyed)
			setLastTask("Life()", "[M.type]")
			M.Life()
			scheck()
			i++
			continue
		mob_list.Cut(i,i+1)
