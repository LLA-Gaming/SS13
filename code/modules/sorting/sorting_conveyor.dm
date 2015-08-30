/obj/machinery/sorting_conveyor
	name = "sorting conveyor"
	icon_state = "sorting_conveyor"
	anchored = 1

	var/obj/item/sorting_cartridge/cartridge

	New()
		..()

		component_parts = list()
		component_parts += new /obj/item/weapon/circuitboard/sorting_conveyor(null)
		component_parts += new /obj/item/stack/cable_coil(null, 1)

		spawn(3)
			cartridge = locate() in get_turf(src)
			if(cartridge)
				cartridge.loc = src

			var/obj/item/weapon/stock_parts/scanning_module/scanning_module = locate() in get_turf(src)
			if(scanning_module)
				cartridge.scanning_module = 0
				cartridge.scanning_module = scanning_module
				scanning_module.loc = cartridge

	examine()
		..()
		if(cartridge)
			cartridge.examine()

	process()
		if(!cartridge)
			return 0

		if(stat & (BROKEN | NOPOWER))
			return 0

		use_power(100)

		var/list/atoms = list()
		for(var/atom/movable/A in get_turf(src))
			if(!A.anchored)
				atoms += A

		var/list/processed = cartridge.ProcessAtoms(atoms)

		for(var/atom/movable/A in processed)
			var/direction = processed[A]
			spawn(1)
				step(A, direction)

	attackby(var/obj/item/I, var/mob/user)
		if(istype(I, /obj/item/sorting_cartridge))
			if(!cartridge)
				user.unEquip(I)
				I.loc = src
				cartridge = I
				user << "<span class='info'>You insert \the [I] into \the [src].</span>"
			else
				user << "<span class='alert'>There is already a cartridge installed.</span>"

		if(istype(I, /obj/item/weapon/screwdriver))
			default_deconstruction_screwdriver(user, icon_state, icon_state, I)
			return 0

		if(istype(I, /obj/item/weapon/crowbar))
			if(cartridge)
				cartridge.loc = get_turf(src)
				cartridge = 0
			default_deconstruction_crowbar(I)
			return 0

	attack_hand(var/mob/living/user)
		user.set_machine(src)
		if(cartridge)
			cartridge.OpenMenu(user)
