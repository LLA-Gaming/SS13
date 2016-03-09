/mob/living/carbon/alien/beepsky/spawn_gibs()
	robogibs(loc, viruses)

/mob/living/carbon/alien/beepsky/gib_animation(var/animate)
	..(animate, "gibbed-r")

/mob/living/carbon/alien/beepsky/spawn_dust()
	new /obj/effect/decal/remains/robot(loc)

/mob/living/carbon/alien/beepsky/spawn_dust()
	new /obj/effect/decal/remains/robot(loc)

/mob/living/carbon/alien/beepsky/dust_animation(var/animate)
	..(animate, "dust-r")


/mob/living/carbon/alien/beepsky/humanoid/death(gibbed)
	if(stat == DEAD)	return
	if(healths)			healths.icon_state = "health6"
	stat = DEAD

	if(!gibbed)
		playsound(loc, 'sound/voice/bsecureday.ogg', 80, 1, 1) //plays it super fast so it sounds like an electronic failure. Bug that we decided to keep as a feature.
		for(var/mob/O in viewers(src, null))
			O.show_message("<B>[src]</B> lets out a terrible screech, as if a thousand griefers cried out in joy, and then falls silent.", 1)
		update_canmove()
		update_icons()
		gibbed = 1 //no beepsky brain 4 u

	tod = worldtime2text() //weasellos time of death patch
	if(mind) 	mind.store_memory("Time of death: [tod]", 0)

	return ..(gibbed)