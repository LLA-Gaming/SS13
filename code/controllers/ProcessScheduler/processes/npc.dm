/datum/controller/process/npcs/setup()
	name = "npc"
	schedule_interval = 1 //NPCs process faster then lighting. zoom zoom vroom vroom

/datum/controller/process/npcs/doWork()
	for(var/mob/living/carbon/human/npc/M in npc_list)
		if(istype(M) && !M.gc_destroyed)
			setLastTask("process()", "[M.type]")
			M.process()
			scheck()
		else
			npc_list -= M