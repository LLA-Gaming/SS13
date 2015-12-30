/*
//////////////////////////////////////

Cirrhosis

	Very noticable.
	Medium resistance penalty.
	very high stage speed penalty.
	Decreases transmittablity.
	Fatal Level.

BONUS
	Deals random toxin damage over time.

//////////////////////////////////////
*/

/datum/symptom/cirrhosis

	name = "Cirrhosis"
	stealth = -3
	resistance = -2
	stage_speed = -4
	transmittable = -1
	level = 6

/datum/symptom/cirrhosis/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB * 2))
		var/mob/living/M = A.affected_mob
		switch(A.stage)
			if(3,4)
				M.adjustToxLoss(rand(1,2))
			if(5)
				M.adjustToxLoss(rand(2,4))
	return