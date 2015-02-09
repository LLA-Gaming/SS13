/*
* Unlocked guns
*/

/obj/item/weapon/gun/projectile/automatic/fiveseven/nolock
	locked = 0

/obj/item/weapon/gun/energy/ep90/nolock
	locked = 0

/*
* An object to keep a certain item stocked at its position.
*/

/obj/effect/itemstock
	name = "item stock"
	icon_state = "item_stock"
	icon = 'icons/effects/effects.dmi'

	invisibility = 101

	var/to_supply
	var/to_supply_amount = 5

	var/last_check = 0
	var/cooldown = 10 // seconds

	New(loc, var/_to_supply = 0, var/_to_supply_amount = 5, var/_cooldown = 5)
		..(loc)

		if(_to_supply)
			if(!ispath(_to_supply))
				_to_supply = text2path(_to_supply)

			to_supply = _to_supply

		to_supply_amount = _to_supply_amount <= 0 ? _to_supply_amount : 1
		cooldown = _cooldown > 5 ? _cooldown : 5

		if(!to_supply)
			qdel(src)
			return 0
		else
			if(!ispath(to_supply))
				to_supply = text2path(to_supply)

		processing_objects.Add(src)

	process()
		if(world.time > last_check + (cooldown*10))

			var/count = 0
			for(var/obj/item/O in get_turf(src))
				if(istype(O, to_supply))
					count++

			for(count, count < to_supply_amount, count++)
				new to_supply(get_turf(src))

			last_check = world.time

/*
* This turns every item it is placed above into an itemstock.
*/

/obj/effect/itemstock_converter
	name = "convert to itemstock"
	icon_state = "item_stock_c"
	icon = 'icons/effects/effects.dmi'

	invisibility = 101

	var/custom_amt = 5
	var/cooldown = 10

	New()
		..()
		for(var/obj/item/O in get_turf(src))
			new /obj/effect/itemstock(get_turf(src), O.type, custom_amt, cooldown)

		qdel(src)
