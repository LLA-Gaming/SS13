/mob/living/carbon/alien/beepsky/humanoid/drone
	name = "beepsky drone"
	caste = "d"
	maxHealth = 100
	health = 100
	icon_state = "aliend_s"
	plasma_rate = 15


/mob/living/carbon/alien/beepsky/humanoid/drone/New()
	create_reagents(100)
	if(src.name == "beepsky drone")
		src.name = text("beepsky drone ([rand(1, 1000)])")
	src.real_name = src.name
	verbs.Add(/mob/living/carbon/alien/beepsky/humanoid/proc/resin,/mob/living/carbon/alien/beepsky/humanoid/proc/corrosive_acid)
	..()
//Drones use the same base as generic humanoids.

/mob/living/carbon/alien/beepsky/humanoid/drone/movement_delay()
	. = ..()
	. += 1


//Drone verbs
/mob/living/carbon/alien/beepsky/humanoid/drone/verb/evolve()
	set name = "Evolve (500)"
	set desc = "Produce an interal egg sac capable of spawning children. Only one queen can exist at a time."
	set category = "Xenosky"

	if(powerc(500))
		// Queen check
		var/no_queen = 1
		for(var/mob/living/carbon/alien/beepsky/humanoid/queen/Q in living_mob_list)
			if(!Q.key || !Q.getorgan(/obj/item/organ/brain))
				continue
			no_queen = 0

		if(no_queen)
			adjustToxLoss(-500)
			src << "\green You begin to evolve!"
			for(var/mob/O in viewers(src, null))
				O.show_message(text("\green <B>[src] begins to twist and contort!</B>"), 1)
			var/mob/living/carbon/alien/beepsky/humanoid/queen/new_xeno = new (loc)
			mind.transfer_to(new_xeno)
			qdel(src)
		else
			src << "<span class='notice'>We already have a living queen.</span>"
	return