/*
//////////////////////////////////////

Electromagnetic Discharge

	Noticable.
	Resistant.
	Reduces stage speed.
	Decreases transmittablity.
	High Level.

BONUS
	Uses stamina to generate electromagnetic pulses.

//////////////////////////////////////
*/

/datum/symptom/emp

	name = "Electromagnetic Discharge"
	stealth = -2
	resistance = 3
	stage_speed = -1
	transmittable = -1
	level = 5

/datum/symptom/emp/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob
		M << "<span class='notice'>You discharge.</span>"
		switch(A.stage)
			if(1,2)
				empulse(get_turf(M), 1, 2)
				M.adjustStaminaLoss(10)
			if(3,4)
				empulse(get_turf(M), 2, 4)
				M.adjustStaminaLoss(20)
			else
				empulse(get_turf(M), 3, 6)
				M.adjustStaminaLoss(30)
	return