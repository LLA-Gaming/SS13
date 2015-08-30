/*
* Auto-Wrapper
*/

/obj/machinery/auto_wrapper
	name = "automatic wrapper and tagger"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "unloader"
	density = 1
	var/_tag = 0
	var/paper_amt = 25
	var/max_paper_amt = 50
	var/input_dir = WEST
	var/output_dir = EAST
	var/on = 1
	var/list/restricted = list(/obj/item/smallDelivery, /obj/structure/bigDelivery, /obj/item/weapon/evidencebag, /obj/item/weapon/storage)

	New()
		..()

		component_parts = list()
		component_parts += new /obj/item/weapon/circuitboard/auto_wrapper(null)
		component_parts += new /obj/item/stack/sheet/metal(null, 1)
		component_parts += new /obj/item/stack/cable_coil(null, 1)

	examine()
		..()
		usr << "<span class='notice'>Current tag is: [_tag ? "*[TAGGERLOCATIONS[_tag]]*" : "*NONE*"]"
		usr << "<span class='notice'>Paper Amount: [paper_amt]</span>"

	attack_hand(var/mob/living/user)
		on = !on
		user << "<span class='notice'>You turn \the [src] [on ? "on" : "off"].</span>"

	attackby(var/obj/item/I, var/mob/living/user)
		if(istype(I, /obj/item/device/destTagger))
			var/obj/item/device/destTagger/tagger = I
			if(tagger.currTag)
				_tag = tagger.currTag
				usr << "<span class='notice'>You set \the [src]'s tag to *[uppertext(TAGGERLOCATIONS[_tag])]*.</span>"
			return 0

		if(istype(I, /obj/item/weapon/packageWrap))
			var/obj/item/weapon/packageWrap/wrap = I
			var/amt_to_remove = Clamp(wrap.amount, 0, (max_paper_amt - paper_amt))
			wrap -= amt_to_remove
			if(wrap.amount <= 0)
				user.unEquip(wrap)
				qdel(wrap)
			paper_amt += amt_to_remove
			user << "<span class='notice'>You insert [amt_to_remove] package wraps into \the [src]."

	process()
		if(!on)
			return 0

		if(!_tag)
			return 0

		if(!paper_amt)
			return 0

		var/turf/input_turf = get_step(get_turf(src), input_dir)
		var/turf/output_turf = get_step(get_turf(src), output_dir)

		for(var/obj/O in input_turf)
			var/restricted_object = 0
			for(var/path in restricted)
				if(istype(O, path))
					restricted_object = 1
					break

			if(O.anchored)
				continue

			if(restricted_object)
				continue

			var/amount_to_use = 1
			if(istype(O, /obj/structure/closet))
				amount_to_use = 3

			if((paper_amt - amount_to_use) <= 0)
				continue

			paper_amt -= amount_to_use

			if(istype(O, /obj/item))
				var/obj/item/smallDelivery/delivery = new(get_turf(src))
				delivery.wrapped = O
				delivery.sortTag = _tag
				O.loc = delivery

				var/obj/item/I = O
				var/i = round(I.w_class)
				if(i in list(1, 2, 3, 4, 5))
					delivery.icon_state = "deliverycrate[i]"
					delivery.w_class = i

				delivery.Move(output_turf)

			else if(istype(O, /obj/structure/closet/crate))
				var/obj/structure/closet/crate/crate = O
				if(crate.opened)
					continue

				var/obj/structure/bigDelivery/delivery = new(get_turf(src))
				delivery.icon_state = "deliverycrate"
				delivery.sortTag = _tag
				delivery.wrapped = crate
				crate.loc = delivery
				delivery.Move(output_turf)

			else if(istype (O, /obj/structure/closet))
				var/obj/structure/closet/crate/crate = O
				if(crate.opened)
					continue

				var/obj/structure/bigDelivery/delivery = new(get_turf(src))
				delivery.wrapped = crate
				delivery.sortTag = _tag
				crate.loc = delivery
				crate.welded = 1
				delivery.Move(output_turf)

/*
* Auto Body-Bag
*/

/obj/machinery/auto_bodybag_wrapper
	name = "auto body-bag wrapper"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "unloader"
	density = 1
	var/on = 1
	var/body_bag_amt = 7
	var/max_body_bag_amt = 7
	var/input_dir = WEST
	var/output_dir = EAST

	New()
		..()

		component_parts = list()
		component_parts += new /obj/item/weapon/circuitboard/sorting_conveyor(null)
		component_parts += new /obj/item/stack/sheet/metal(null, 1)
		component_parts += new /obj/item/stack/cable_coil(null, 1)

	attack_hand(var/mob/living/user)
		on = !on
		user << "<span class='notice'>You turn \the [src] [on ? "on" : "off"].</span>"

	attackby(var/obj/item/I, var/mob/living/user)
		if(istype(I, /obj/item/bodybag))
			if((body_bag_amt + 1) <= max_body_bag_amt)
				user << "<span class='notice'>You add \the [I] to \the [src].</span>"
				body_bag_amt++
				user.unEquip(I)
				qdel(I)

	process()
		if(!on)
			return 0

		if(!body_bag_amt)
			return 0

		var/turf/input_turf = get_step(get_turf(src), input_dir)
		var/turf/output_turf = get_step(get_turf(src), output_dir)

		for(var/mob/living/M in input_turf)
			if(body_bag_amt <= 0)
				break

			if(M.stat == 2)
				var/obj/structure/closet/body_bag/bag = new(get_turf(src))
				bag.close()
				M.loc = bag
				bag.Move(output_turf)

/*
* Crate Unloading Machine
*/

/obj/machinery/mineral/unloading_machine/crate
	var/crate_dir = NORTH

	process()
		var/turf/T = get_step(get_turf(src), input_dir)
		if(T)
			var/obj/structure/closet/crate/crate = locate() in T
			if(crate)
				if(!crate.locked && !crate.opened)
					crate.open()
					sleep(3)
					step(crate, crate_dir)
				else if(crate.opened || crate.locked)
					step(crate, crate_dir)
			else
				return 0

			for(var/obj/item/I in T)
				I.loc = get_step(get_turf(src), output_dir)
				sleep(2)

