/datum/round_event_control/spontaneous_appendicitis
	name = "Spontaneous Appendicitis"
	typepath = /datum/round_event/spontaneous_appendicitis
	phases_required = 0
	max_occurrences = 4
	rating = list(
				"Gameplay"	= 65,
				"Dangerous"	= 30
				)

/datum/round_event/spontaneous_appendicitis
	var/mob/living/carbon/sucker = null //the mob which is affected by disease.

/datum/round_event/spontaneous_appendicitis/start()
	for(var/mob/living/carbon/human/H in shuffle(living_mob_list))
		var/foundAlready = 0	//don't infect someone that already has the virus
		for(var/datum/disease/D in H.viruses)
			foundAlready = 1
		if(H.stat == 2 || foundAlready)
			continue

		var/datum/disease/D = new /datum/disease/appendicitis
		D.holder = H
		D.affected_mob = H
		sucker = H
		H.viruses += D
		break