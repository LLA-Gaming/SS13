/*
//////////////////////////////////////

Acute Haemorrhaging

	Very Noticable.
	Decreases resistance.
	Reduces stage speed.
	Transmittable.
	Fatal Level.

BONUS
	Causes bleeding

//////////////////////////////////////
*/

/datum/symptom/acute_hyperhematidrosis

	name = "Acute Hyperhematidrosis"
	stealth = -3
	resistance = -2
	stage_speed = -2
	transmittable = 1
	level = 6

/datum/symptom/acute_hyperhematidrosis/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB / 2))
		var/mob/living/carbon/human/M = A.affected_mob
		switch(A.stage)
			if(1, 2)
				M << "<span class='notice'>[pick("Your body starts to itch.", "Your skin feels dry.")]</span>"
			if(3, 4)
				M << "<span class='notice'>[pick("A piece of your skin flakes off.", "Your skin is cracked.")]</span>"
			else
				var/obj/item/organ/limb/L = M.get_organ(pick("chest", "head", "l_leg", "r_leg", "l_arm", "r_arm"))
				if(L.status == ORGAN_ORGANIC) //We dont want robo limbs to bleed.
					M << "<span class='danger'>[pick("Your skin opens.", "You feel sticky.")]</span>"
					switch(L.bleedstate)
						if(0)
							L.bleeding = 1
							L.bleedstate = 1
						if(1)
							L.bleedstate = 2
						else
							L.bleedstate = 3
	return