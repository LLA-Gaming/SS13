/datum/controller/process/npcs/setup()
	name = "npc"
	schedule_interval = 1 //NPCs process faster then lighting. zoom zoom vroom vroom

/datum/controller/process/npcs/doWork()
	var/i = 1
	while(i<=npc_list.len)
		var/mob/living/carbon/human/npc/M = npc_list[i]
		if(M && !M.gc_destroyed)
			setLastTask("process()", "[M.type]")
			M.process()
			scheck()
			i++
			continue
		npc_list.Cut(i,i+1)