/* Alien shit!
 * Contains:
 *		structure/alien
 *		Resin
 *		Weeds
 *		Egg
 *		effect/acid
 */


/obj/structure/alien
	icon = 'icons/mob/alien.dmi'

/*
 * Resin
 */
/obj/structure/alien/resin/beepsky
	name = "resin"
	desc = "Looks like some kind of metallic growth."
	icon = 'icons/mob/alien_b.dmi'
	icon_state = "resin"
	density = 1
	opacity = 1
	anchored = 1

/obj/structure/alien/resin/wall/beepsky
	name = "resin wall"
	desc = "Grey metallic slime and wires solidified into a wall."
	icon_state = "resinwall"	//same as resin, but consistency ho!
	icon = 'icons/mob/alien_b.dmi'

/obj/structure/alien/resin/membrane/beepsky
	name = "resin membrane"
	desc = "Grey metallic slime and wires just thin enough to let light pass through."
	icon_state = "resinmembrane"
	icon = 'icons/mob/alien_b.dmi'
	opacity = 0
	health = 120

/*
 * Weeds
 */

#define NODERANGE 3

/obj/structure/alien/weeds/beepsky
	gender = PLURAL
	name = "weeds"
	desc = "Weird electronic weeds."
	icon_state = "weeds"
	icon = 'icons/mob/alien_b.dmi'
	anchored = 1
	density = 0
	health = 15

/obj/structure/alien/weeds/beepsky/Life()
	set background = BACKGROUND_ENABLED
	var/turf/U = get_turf(src)

	if(istype(U, /turf/space))
		qdel(src)
		return

	direction_loop:
		for(var/dirn in cardinal)
			var/turf/T = get_step(src, dirn)

			if (!istype(T) || T.density || locate(/obj/structure/alien/weeds/beepsky) in T || istype(T, /turf/space))
				continue

			if(!linked_node || get_dist(linked_node, src) > linked_node.node_range)
				return

			for(var/obj/O in T)
				if(O.density)
					continue direction_loop

			new /obj/structure/alien/weeds/beepsky(T, linked_node)


//Weed nodes
/obj/structure/alien/weeds/beepsky/node
	name = "strange machine"
	desc = "Weird metallic structure."
	icon_state = "weednode"
	luminosity = NODERANGE
	var/node_range = NODERANGE


/obj/structure/alien/weeds/beepsky/node/New()
	..(loc, src)

#undef NODERANGE


/*
 * Egg
 */

//for the status var
#define MIN_GROWTH_TIME 1800	//time it takes to grow a hugger
#define MAX_GROWTH_TIME 3000

/obj/structure/alien/egg/beepsky
	name = "egg"
	desc = "A hard metallic egg."
	icon_state = "egg_growing"
	icon = 'icons/mob/alien_b.dmi'
	density = 0
	anchored = 1


/obj/structure/alien/egg/beepsky/New()
	new /obj/item/clothing/mask/facehugger/beepsky(src)
	..()
	spawn(rand(MIN_GROWTH_TIME, MAX_GROWTH_TIME))
		Grow()

#undef MIN_GROWTH_TIME
#undef MAX_GROWTH_TIME

//The door

/obj/structure/mineral_door/resin/beepsky
	mineralType = "metal"
	hardness = 1
	close_delay = 100
	openSound = 'sound/effects/attackblob.ogg'
	closeSound = 'sound/effects/attackblob.ogg'
