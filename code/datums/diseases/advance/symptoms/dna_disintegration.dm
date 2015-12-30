/*
//////////////////////////////////////

DNA Disintegration

	Very noticable.
	Lowers resistance tremendously.
	Decreases stage speed tremendously.
	Decreases transmittablity tremendously.
	Fatal Level.

Bonus
	Deals genetic damage over time.

//////////////////////////////////////
*/

/datum/symptom/dna_disintegration

	name = "Deoxyribonucleic Acid Disintegration"
	stealth = -4
	resistance = -3
	stage_speed = -3
	transmittable = -4
	level = 6

/datum/symptom/dna_disintegration/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB * 2))
		var/mob/living/M = A.affected_mob
		switch(A.stage)
			if(4, 5)
				M.adjustCloneLoss(rand(2,4))
	return
