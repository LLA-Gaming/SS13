/obj/structure/borer_egg
	anchored = 1
	density = 0
	desc = "A strange egg. It glows sometimes."
	name = "egg"
	icon = 'icons/mob/animal.dmi'
	icon_state = "borer_egg"
	var/health = 100
	var/hitnoise = 'sound/items/Welder.ogg'
	var/special_conditions = 0
	var/timeleft

/obj/structure/borer_egg/New()
	..()
	timeleft = world.time + rand(1800, 3000)
	processing_objects.Add(src)

/obj/structure/borer_egg/process()

	if(timeleft > world.time)
		return

	var/turf/location = get_turf(src)
	var/datum/gas_mixture/environment = location.return_air()
	if(((PLASMA in environment.gasses) && environment.gasses[PLASMA] >= MOLES_PLASMA_VISIBLE) || locate(/obj/structure/borer_nest) in location)
		special_conditions = 1
	else
		special_conditions = 0

	var/mob/dead/observer/ghost
	for(var/mob/dead/observer/O in src.loc)
		if(!O.client)	continue
		if(O.can_reenter_corpse && O.mind && O.mind.current && O.mind.current.stat != DEAD)	continue
		ghost = O
		break

	if(ghost && special_conditions)
		if(!src || src.gc_destroyed)
			return
		var/mob/living/simple_animal/borer/B = new /mob/living/simple_animal/borer
		B.loc = src.loc
		B.key = ghost.key
		if(B.evil)
			B.make_special()
		qdel(src)

	else if(ghost || special_conditions)
		if(icon_state != "borer_egg_pulsing")
			icon_state = "borer_egg_pulsing"

	else
		if(icon_state != "borer_egg_grown")
			icon_state = "borer_egg_grown"

/obj/structure/borer_egg/proc/healthcheck()
	if(src.health <= 0)
		qdel(src)

/obj/structure/borer_egg/attackby(obj/item/I, mob/user)
	if(I.attack_verb.len)
		visible_message("<span class='danger'>[src] has been [pick(I.attack_verb)] with [I] by [user].</span>")
	else
		visible_message("<span class='danger'>[src] has been attacked with [I] by [user]!</span>")

	var/damage = I.force / 4
	if(istype(I, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = I

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(loc, hitnoise, 100, 1)

	src.health -= damage
	src.healthcheck()

/obj/structure/borer_egg/bullet_act(obj/item/projectile/Proj)
	src.health -= Proj.damage
	..()
	src.healthcheck()

/obj/structure/borer_egg/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 500)
		src.health -= 5
		src.healthcheck()

/obj/structure/borer_egg/attack_hand(mob/user)
	user << "<span class='notice'>It feels slimy.</span>"

/obj/structure/borer_nest
	anchored = 1
	density = 0
	name = "nest"
	desc = "A nest that helps eggs grow."
	icon = 'icons/mob/animal.dmi'
	icon_state = "borer_nest"
	layer = TURF_LAYER
	var/hitnoise = 'sound/items/Welder.ogg'
	var/health = 15

/obj/structure/borer_nest/ex_act(severity)
	qdel(src)

/obj/structure/borer_nest/attackby(obj/item/I, mob/user)
	if(I.attack_verb.len)
		visible_message("<span class='danger'>[src] has been [pick(I.attack_verb)] with [I] by [user].</span>")
	else
		visible_message("<span class='danger'>[src] has been attacked with [I] by [user]!</span>")

	var/damage = I.force / 4.0
	if(istype(I, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = I
		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(loc, hitnoise, 100, 1)

	health -= damage
	healthcheck()

/obj/structure/borer_nest/proc/healthcheck()
	if(health <= 0)
		qdel(src)

/obj/structure/borer_nest/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 500)
		src.health -= 5
		src.healthcheck()
