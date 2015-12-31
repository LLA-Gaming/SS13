/*
//////////////////////////////////////

Augemites

	Noticable.
	Little Resistance.
	Very high stage speed penalty.
	High transmittablity penalty.
	High Level.

BONUS
	Will slowly augment the infected.

//////////////////////////////////////
*/

/datum/symptom/augment

	name = "Augmites"
	stealth = -2
	resistance = 3
	stage_speed = -4
	transmittable = -3
	level = 6

/datum/symptom/augment/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB / 3) && A.stage == 5)
		var/mob/living/carbon/human/M = A.affected_mob
		var/obj/item/organ/limb/L = M.get_organ(pick("chest", "head", "l_leg", "r_leg", "l_arm", "r_arm"))
		if(L.status == ORGAN_ORGANIC)
			M << "<span class='notice'>Your [L.getDisplayName()] feels hard and heavy.</span>"
			M.organs -= L
			switch(L.name)
				if("r_leg")
					M.organs += new /obj/item/organ/limb/robot/r_leg(src)
				if("l_leg")
					M.organs += new /obj/item/organ/limb/robot/l_leg(src)
				if("r_arm")
					M.organs += new /obj/item/organ/limb/robot/r_arm(src)
				if("l_arm")
					M.organs += new /obj/item/organ/limb/robot/l_arm(src)
				if("head")
					M.organs += new /obj/item/organ/limb/robot/head(src)
				if("chest")
					M.organs += new /obj/item/organ/limb/robot/chest(src)
					for(var/obj/item/alien_embryo/E in M.contents)	//Remove alien embryo
						E.Destroy()
					for(var/datum/disease/appendicitis/D in M.viruses)	//If they already have Appendicitis, Remove it
						D.cure(1)
			M.update_augments()

	return