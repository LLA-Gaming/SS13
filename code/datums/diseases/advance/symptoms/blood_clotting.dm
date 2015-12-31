/*
//////////////////////////////////////

Advanced Coagulation

	Not hidden.
	Medium resistance penalty.
	Medium stage speed penalty.
	High transmittablity penalty.
	High Level.

Bonus
	Heals bleeding.

//////////////////////////////////////
*/

/datum/symptom/blood_clotting

	name = "Advanced Coagulation"
	stealth = 0
	resistance = -2
	stage_speed = -2
	transmittable = -3
	level = 4

/datum/symptom/blood_clotting/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB * 3))
		var/mob/living/carbon/human/M = A.affected_mob
		switch(A.stage)
			if(4, 5)
				var/list/bleeding = M.get_damaged_organs(0,0,1)

				if(!bleeding.len)
					return

				for(var/obj/item/organ/limb/L in bleeding)
					switch(L.bleedstate)
						if(3)
							L.bleedstate = 2
						if(2)
							L.bleedstate = 1
						if(1)
							L.bleedstate = 0
							L.bleeding = 0
						else
							return
	return
