/*
* Trash
*/

/obj/item/trash/halloween
	name = "trash"
	desc = "trash"
	icon = 'icons/obj/halloween.dmi'

	New(loc, var/_name, var/_desc, var/_icon_state)
		..()
		name = _name
		desc = _desc
		icon_state = _icon_state

/*
* Candy Base
*/


// When creating new candies, the proc order goes as follows.
// attack(M) -> can_eat(M) ? -> eaten(M) : return
// attack_self() -> unwrap()

/obj/item/weapon/reagent_containers/food/snacks/halloween_candy
	name =  "candy"
	desc = "Yum."
	icon = 'icons/obj/halloween.dmi'
	icon_state = ""

	w_class = 1
	bitesize = 1
	bitecount = 0
	wrapped = 1

	var/has_trash = 1

	New()
		..()
		eatverb = pick("nibble", "swallow", "eat", "lick")
		update_icon()
		reagents.add_reagent("sugar", 1)
		bitesize = reagents.total_volume
		pixel_x += rand(3, 6)
		pixel_y += rand(2, 4)

	proc/can_eat(var/mob/living/L)
		if(!L)	return
		if(wrapped)	return 0
		return 1

	proc/eaten(var/mob/living/L)
		if(!L)	return
		if(wrapped)	return

	proc/unwrap(var/mob/living/L)
		if(!L)	return
		if(!wrapped)	return
		L << "\blue You unwrap the [src]."
		wrapped = 0
		if(has_trash)
			new /obj/item/trash/halloween(get_turf(L), "'[name]' wrapper", "Used to contain '[name]'", "[initial(icon_state)]_wrapper")
		update_icon()

	attack_self(var/mob/living/L)
		if(!L)	return
		if(wrapped)
			unwrap(L)

	update_icon()
		..()
		icon_state = "[initial(icon_state)]_[wrapped]"

	attack(mob/M, mob/user, def_zone)
		if(!can_eat(M))
			if(wrapped)
				M << "\red You can't eat wrapped food."
				return
			M << "\red You can't eat this."
			return
		if(..(M, user, def_zone))
			eaten(M)

/*
* Candies
*/

/obj/item/weapon/reagent_containers/food/snacks/halloween_candy

	/*
	*	When adding new reagents to a candy, make sure to
	*	set the bitesize equal to the reagents.total_volume,
	*	that is, if you want it to be eaten in one bite....
	*/

	/*
	* Bluespace Candy
	*/

	bluespace/
		name = "bluespace candy"
		desc = "Warning: Eating this delicious hard candy may cause teleportation"
		icon_state = "bscandy"

		eaten(var/mob/living/L)
			..()
			do_teleport(L, get_turf(L), 5, asoundin = 'sound/effects/phasein.ogg')

	/*
	* Chocolate Griff
 	*/

	chocgriff/
		name = "chocolate griff"
		desc = "A delicious wrapped chocolate that’s bound to make you scream."
		icon_state = "chocgriff"

		eaten(var/mob/living/L)
			..()
			spawn(15)
				L.emote("scream")

	/*
	* Sour Shocker
	*/

	sourshock/
		name = "sour shocker"
		desc = "A shockingly sour candy that is bound to make you pucker up."
		icon_state = "sourshocker"

		eaten(var/mob/living/L)
			..()
			var/datum/effect/effect/system/spark_spread/S = new/datum/effect/effect/system/spark_spread(get_turf(L))
			S.set_up(3, 0, get_turf(L))
			S.start()
			L.Weaken(rand(2, 3))

	/*
	* Dexalin Drops + Package
	*/

	dexdrops/
		name = "dexalin drop"
		icon_state = "dexdrops_0"
		wrapped = 0

		New()
			..()
			reagents.add_reagent("dexalin", 1)
			bitesize = reagents.total_volume

		update_icon()
			return

	dexdrops_package/
		name = "dexalin drops"
		desc = "These fruit chews are like a breath of fresh air."
		icon_state = "dexdrops"
		var/amount = 0

		New()
			..()
			amount = rand(2, 4)

		unwrap(var/mob/living/L)
			if(!wrapped)	return
			L << "\blue You empty the [src] onto the floor."
			for(var/i = 0, i < amount, i++)
				new /obj/item/weapon/reagent_containers/food/snacks/halloween_candy/dexdrops(get_turf(src))
			wrapped = 0
			update_icon()

		update_icon()
			if(wrapped)
				icon_state = "dexdrops_1"
			else
				icon_state = "dexdrops_wrapper"

		can_eat()
			return 0

	/*
	* Changeling Chews
	*/

	changechews/
		name = "changeling chews"
		desc = "The label on the side reads: After eating these you’ll never be the same."
		icon_state = "changechews"

		eaten(var/mob/living/L)
			..()
			if(istype(L, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = L
				H.hair_style = pick(H.gender == "male" ? hair_styles_male_list : hair_styles_female_list)
				H.facial_hair_style = pick(facial_hair_styles_list)
				H.update_hair()

	/*
	* Jawbreaker
	*/

	jawbreaker/
		name = "jawbreaker"
		desc = "You should really avoid trying to bite these."
		icon_state = "jawbreaker"
		wrapped = 0


		New()
			..()
			reagents.add_reagent("sugar", 9)
			bitesize = 2
			eatverb = "bite"

		eaten(var/mob/living/L)
			..()
			L.adjustBruteLoss(rand(1, 2))

		update_icon()
			return

	/*
	* Fire Candy
	*/

	firecandy/
		name = "fire candy"
		desc = "Said to be the hottest candy in the galaxy."
		icon_state = "firecandy"

		New()
			..()
			reagents.add_reagent("capsaicin", 14)
			bitesize = 15

	/*
	* Kelotwists
	*/

	kelotwists/
		name = "kelotwists"
		desc = "These fruit chews are like a breath of fresh air."
		icon_state = "kelotwists"

		New()
			..()
			reagents.add_reagent("kelotane", 5)
			bitesize = 6

	/*
	* Peppermint Pattie
	*/

	/*pepperment_pattie/
		name = "Zork Peppermint Pattie"
		icon_state = "placeholder"*/

	/*
	* Lollipops
	*/

	lollipop/
		name = "lollipop"
		icon_state = "lollipop"

		var/list/possible_colors = list("yellow", "blue", "cyan", "green", "orange", "magenta", "purple", "red")
		var/lollipop_color = "yellow"
		has_trash = 0

		update_icon()
			if(wrapped)
				icon_state = "lollipop_1"
			else
				icon_state = "lollipop_[lollipop_color]"

		New()
			..()
			lollipop_color = pick(possible_colors)
			name = "[lollipop_color] lollipop"
			desc = ""
	/*
	* Gummy
	*/

	gummy/
		name = "gummy"
		icon_state = "gummy"

		var/list/possible_colors = list("corgi", "xeno", "bear", "syndie", "cat", "perseus", "bruisepack", "clown")
		var/gummy_color = "corgi"
		has_trash = 0

		New()
			..()
			gummy_color = pick(possible_colors)
			name = "[gummy_color] gummy"
			desc = "A large gummy that resembles a [gummy_color]. How could you eat something like this?"

		update_icon()
			if(wrapped)
				icon_state = "gummy_1"
			else
				icon_state = "gummy_[gummy_color]"

	/*
	* Candy Corn
	*/

	candycorn/
		name = "candy corn"
		desc = "A glowing piece of candy corn. Nothing odd about this."
		icon_state = "candycorn"

		eaten(var/mob/living/L)
			if(istype(L, /mob/living/carbon))
				var/mob/living/carbon/C = L
				if(C.dna)
					hardset_dna(C, null, null, null, "skeleton")

/*
* Drinks
*/

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/sting
	name = "sting energy drink"
	desc = "A popular energy drink guaranteed to give you the boost you need."
	icon = 'icons/obj/halloween.dmi'
	icon_state = "stingenergy"

	New()
		..()
		reagents.add_reagent("sugar", 25)
		reagents.add_reagent("hyperzine", 25)
