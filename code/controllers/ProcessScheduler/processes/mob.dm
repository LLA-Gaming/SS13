/datum/controller/process/mobs/setup()
	name = "mobs"
	schedule_interval = 20

/datum/controller/process/mobs/doWork()
	for(var/mob/M in mob_list)
		if(istype(M) && !M.gc_destroyed)
			setLastTask("Life()", "[M.type]")
			M.Life()
			scheck()
		else
			mob_list -= M