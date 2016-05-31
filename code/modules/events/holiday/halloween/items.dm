/*
* Buckets
*/

/obj/item/weapon/storage/hallooween
	name = "bucket"
	icon = 'icons/obj/halloween.dmi'
	icon_state = "jack_o_bucket"
	item_state = "jack_o_bucket"

	storage_slots = 21
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/halloween_candy, /obj/item/trash/halloween, 	\
				/obj/item/weapon/reagent_containers/food/drinks/soda_cans/sting,							\
				/obj/item/weapon/grenade/stink																		\
				)
	use_to_pickup = 1
	max_combined_w_class = 0
	max_w_class = 1
	display_contents_with_number = 1
	allow_quick_gather = 1
	allow_quick_empty = 1

	var/lit = 0
	var/brightness = 3

	New()
		..()
		update_icon()

		// What this does is set the amount of candy you can fit into the bucket to 15x each type of candy.
		// So if you had every type of candy, you could fit it in there 15 times. Lots of room.

		max_combined_w_class = (length(typesof(/obj/item/weapon/reagent_containers/food/snacks/halloween_candy)) - 1) * 15
		storage_slots = max_combined_w_class

	/*
	* Lighting
	*/

	update_icon()
		icon_state = "[initial(icon_state)]_[contents.len > 0]_[lit]"
		if(lit)
			set_light(brightness)
		else
			set_light(0)

	attack_self()
		lit = !lit
		update_icon()

/*
* Stink Bomb Reagent
*/

/datum/reagent/stench
	name = "stench"
	id = "stench"
	description = "Yuk."
	color = "#7CFC00"
	reagent_state = 2

	on_mob_life(var/mob/living/M as mob)
		M.visible_message("<B>[M]</B> vomits on the floor!")

		M.nutrition -= 20
		M.adjustToxLoss(-3)

		var/turf/pos = get_turf(M)
		pos.add_vomit_floor(M)
		playsound(pos, 'sound/effects/splat.ogg', 50, 1)
		M.reagents.remove_reagent("stench", M.reagents.total_volume, 0)

/*
* Stink Bomb
*/

/obj/item/weapon/grenade/stink
	name = "stink bomb"
	icon = 'icons/obj/halloween.dmi'
	icon_state = "stinkbomb"
	w_class = 1

	New()
		..()
		w_class = 1

	prime()
		var/datum/reagents/R = new/datum/reagents(50)
		R.my_atom = src
		R.add_reagent("stench", 50)

		var/datum/effect/effect/system/chem_smoke_spread/smoke = new
		smoke.set_up(R, rand(5, 7), 0, get_turf(src), 0, silent = 1)
		playsound(get_turf(src), 'sound/effects/smoke.ogg', 50, 1, -3)
		smoke.start()
		R.delete()

		qdel(src)

/*
* Hallowings
*/

/obj/item/clothing/suit/hallowings
	name = "hallowings"
	icon_state = "hallowings"
	item_state = "hallowings"

/*
* Demon Horns
*/

/obj/item/clothing/head/demonhorns
	name = "demon horns"
	icon_state = "demonhorns"
	item_state = "demonhorns"


/*
* Cauldron
*/

/obj/structure/candy_cauldron
	name = "cauldron"
	desc = "It seems to be filled with a lot of candy..."
	icon = 'icons/obj/halloween.dmi'
	icon_state = "cauldron"
	density = 1
	anchored = 1


	New()
		..()
		set_light(4)

	// List of type paths that are excluded when grabbing into the cauldron.
	var/list/excluding = list(/obj/item/weapon/reagent_containers/food/snacks/halloween_candy,			\
							/obj/item/weapon/reagent_containers/food/snacks/halloween_candy/dexdrops	\
							)


	// List of type paths that are included when grabbing into the cauldron.
	var/list/including = list(/obj/item/weapon/reagent_containers/food/drinks/soda_cans/sting,	\
								/obj/item/weapon/grenade/stink, /obj/item/weapon/reagent_containers/food/snacks/chocolatebar, \
								/obj/item/weapon/reagent_containers/food/snacks/cookie, /obj/item/weapon/reagent_containers/food/snacks/candiedapple, \
								/obj/item/weapon/reagent_containers/food/snacks/candy_corn
							)

	attack_hand(var/mob/living/L)
		L << "\blue You reach into the cauldron..."
		if(do_after(L, 25))
			var/picked = pick((typesof(/obj/item/weapon/reagent_containers/food/snacks/halloween_candy) - excluding) + including)
			var/obj/O = new picked(get_turf(L))
			L << "\blue You pull out a [O.name]!"
			if(!L.put_in_hands(O))
				L << "\blue You drop the [O.name] because your hands are full."
				return
		return


	update_icon()
		icon_state = "[initial(icon_state)]"
