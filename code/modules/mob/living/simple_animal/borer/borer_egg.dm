/obj/structure/borer_egg
	anchored = 1
	density = 0
	desc = "A strange egg. It glows sometimes."
	name = "egg"
	icon = 'icons/mob/animal.dmi'
	icon_state = "borer_egg"
	var/health = 100
	layer = TURF_LAYER

/obj/structure/borer_egg/New()
	..()
	spawn(rand(1800, 3000))
		processing_objects.Add(src)

/obj/structure/borer_egg/process()

	var/mob/dead/observer/ghost
	for(var/mob/dead/observer/O in src.loc)
		if(!O.client)	continue
		if(O.mind && O.mind.current && O.mind.current.stat != DEAD)	continue
		ghost = O
		break

	var/turf/location = get_turf(src)
	var/datum/gas_mixture/environment = location.return_air()
	if(environment.toxins >= MOLES_PLASMA_VISIBLE && ghost)
		var/response = alert(ghost, "This egg is ready to hatch. Do you want to be a cortical borer?",, "Yes", "No")
		if(response == "Yes")
			var/mob/living/simple_animal/borer/B = new /mob/living/simple_animal/borer
			B.loc = src.loc
			B.key = ghost.key
			qdel(src)
	else if(environment.toxins >= MOLES_PLASMA_VISIBLE || ghost)
		if(icon_state != "borer_egg_pulsing")
			icon_state = "borer_egg_pulsing"

	else
		if(icon_state != "borer_egg_grown")
			icon_state = "borer_egg_grown"


