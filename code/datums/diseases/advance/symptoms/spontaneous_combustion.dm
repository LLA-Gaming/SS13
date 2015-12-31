/*
//////////////////////////////////////

Spontaneous Combustion

	Decreases resistance.
	Reduces stage speed.
	Decreases transmittablity.
	Fatal level.

BONUS
	Causes spontaneous combustion

//////////////////////////////////////
*/

/datum/symptom/spontaneous_combustion

	name = "Spontaneous Combustion"
	stealth = 0
	resistance = -3
	stage_speed = -2
	transmittable = -3
	level = 6

/datum/symptom/spontaneous_combustion/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB / 2))
		var/mob/living/M = A.affected_mob
		switch(A.stage)
			if(1, 2)
				M << "<span class='notice'>Your body feels warm.</span>"
			if(3, 4)
				M << "<span class='danger'>[pick("Your body feels hot.", "Your skin feels like its burning.")]</span>"
			else
				M << "<br><span class='danger'>[pick("You burst into flames!", "You catch fire!")]</span></br>"
				M.adjust_fire_stacks(1)
				M.IgniteMob()

	return