/mob/living/carbon/alien/beepsky/humanoid/queen
	name = "queen beepsky"
	caste = "q"
	maxHealth = 250
	health = 250
	icon_state = "alienq_s"
	status_flags = CANPARALYSE
	heal_rate = 5
	plasma_rate = 20
	ventcrawler = 0 //pull over that ass too fat


/mob/living/carbon/alien/beepsky/humanoid/queen/New()
	create_reagents(100)

	//there should only be one queen
	for(var/mob/living/carbon/alien/beepsky/humanoid/queen/Q in living_mob_list)
		if(Q == src)		continue
		if(Q.stat == DEAD)	continue
		if(Q.client)
			name = "beepsky princess ([rand(1, 999)])"	//if this is too cutesy feel free to change it/remove it.
			break

	real_name = src.name
	verbs.Add(/mob/living/carbon/alien/beepsky/humanoid/proc/corrosive_acid,/mob/living/carbon/alien/beepsky/humanoid/proc/neurotoxin,/mob/living/carbon/alien/beepsky/humanoid/proc/resin)
	..()

/mob/living/carbon/alien/beepsky/humanoid/queen/handle_regular_hud_updates()
	..() //-Yvarov

	if (src.healths)
		if (src.stat != 2)
			switch(health)
				if(250 to INFINITY)
					src.healths.icon_state = "health0"
				if(175 to 250)
					src.healths.icon_state = "health1"
				if(100 to 175)
					src.healths.icon_state = "health2"
				if(50 to 100)
					src.healths.icon_state = "health3"
				if(0 to 50)
					src.healths.icon_state = "health4"
				else
					src.healths.icon_state = "health5"
		else
			src.healths.icon_state = "health6"

/mob/living/carbon/alien/beepsky/humanoid/queen/movement_delay()
	. = ..()
	. += 5


//Queen verbs
/mob/living/carbon/alien/beepsky/humanoid/queen/verb/lay_egg()

	set name = "Lay Egg (75)"
	set desc = "Lay an egg to produce huggers to impregnate prey with."
	set category = "Xenosky"

	if(locate(/obj/structure/alien/egg) in get_turf(src))
		src << "There's already an egg here."
		return

	if(powerc(75,1))//Can't plant eggs on spess tiles. That's silly.
		adjustToxLoss(-75)
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\green <B>[src] has laid an egg!</B>"), 1)
		new /obj/structure/alien/egg/beepsky(loc)
	return

/* Leaving this in case we decide to add huge queen beepsky. Not needed for the regular event.
/mob/living/carbon/alien/beepsky/humanoid/queen/large
	icon = 'icons/mob/alienqueen.dmi'
	icon_state = "queen_s"
	pixel_x = -16

/mob/living/carbon/alien/beepsky/humanoid/queen/large/update_icons()
	update_hud()		//TODO: remove the need for this to be here
	overlays.Cut()
	if(stat == DEAD)
		icon_state = "queen_dead"
	else if(stat == UNCONSCIOUS || lying || resting)
		icon_state = "queen_sleep"
	else
		icon_state = "queen_s"
	for(var/image/I in overlays_standing)
		overlays += I
*/