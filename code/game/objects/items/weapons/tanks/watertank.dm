//Hydroponics tank and base code
/obj/item/weapon/watertank
	name = "backpack water tank"
	desc = "A S.U.N.S.H.I.N.E. brand watertank backpack with nozzle to water plants."
	icon = 'icons/obj/hydroponics.dmi'
	icon_state = "waterbackpack"
	item_state = "waterbackpack"
	w_class = 4.0
	slot_flags = SLOT_BACK
	slowdown = 1
	action_button_name = "Toggle Mister"

	var/obj/item/weapon/noz
	var/on = 0
	var/volume = 500

	New()
		..()
		create_reagents(volume)
		noz = make_noz()
		return

	examine()
		set src in usr
		..()
		for(var/datum/reagent/R in reagents.reagent_list)
			usr.send_text_to_tab("[round(R.volume)] units of [R.name] left.", "ic")
			usr << "[round(R.volume)] units of [R.name] left."
		return

	ui_action_click()
		if (usr.get_item_by_slot(slot_back) == src)
			toggle_mister()
		else
			usr << "<span class='notice'>The watertank needs to be on your back to use!</span>"
		return

	verb/toggle_mister()
		set name = "Toggle Mister"
		set category = "Object"
		on = !on

		var/mob/living/carbon/human/user = usr
		if(on)
			//Detach the nozzle into the user's hands
		//	var/list/L = list("left hand" = slot_l_hand,"right hand" = slot_r_hand)
			if(!user.put_in_any_hand_if_possible(noz))
				on = 0
				user << "<span class='notice'>You need a free hand to hold the mister!</span>"
				return
			noz.loc = user
		else
			//Remove from their hands and put back "into" the tank
			remove_noz(user)
		return

	proc/make_noz()
		return new /obj/item/weapon/reagent_containers/spray/mister(src)

	equipped(mob/user, slot)
		if (slot != slot_back)
			remove_noz(user)

	proc/remove_noz(mob/user)
		var/mob/living/carbon/human/M = user
		if(noz in get_both_hands(M))
			M.unEquip(noz)
		return

	Destroy()
		if (on)
			var/M = get(noz, /mob)
			remove_noz(M)
		..()
		return

// This mister item is intended as an extension of the watertank and always attached to it.
// Therefore, it's designed to be "locked" to the player's hands or extended back onto
// the watertank backpack. Allowing it to be placed elsewhere or created without a parent
// watertank object will likely lead to weird behaviour or runtimes.
/obj/item/weapon/reagent_containers/spray/mister
	name = "water mister"
	desc = "A mister nozzle attached to a water tank."
	icon = 'icons/obj/hydroponics.dmi'
	icon_state = "mister"
	item_state = "mister"
	w_class = 4.0
	amount_per_transfer_from_this = 50
	possible_transfer_amounts = list(25,50,100)
	volume = 500

	var/obj/item/weapon/watertank/tank

	New(parent_tank)
		..()
		if(check_tank_exists(parent_tank, src))
			tank = parent_tank
			reagents = tank.reagents	//This mister is really just a proxy for the tank's reagents
			loc = tank
		return

	dropped(mob/user as mob)
		user << "<span class='notice'>The mister snaps back onto the watertank!</span>"
		tank.on = 0
		loc = tank

	attack_self()
		return

	Move(dest, dir)
		// Only will move to valid locations
		if((dest == tank) || (dest == tank.loc /*person with tank on back*/))
			..()
		return

/proc/check_tank_exists(parent_tank, var/mob/living/carbon/human/M, var/obj/O)
	if (!parent_tank || !istype(parent_tank, /obj/item/weapon/watertank))	//To avoid weird issues from admin spawns
		M.unEquip(O)
		qdel(0)
		return 0
	else
		return 1

//Janitor tank
/obj/item/weapon/watertank/janitor
	name = "backpack water tank"
	desc = "A janitorial watertank backpack with nozzle to clean dirt and graffiti."
	icon_state = "waterbackpackjani"
	item_state = "waterbackpackjani"

	New()
		..()
		reagents.add_reagent("cleaner", 500)

	make_noz()
		return new /obj/item/weapon/reagent_containers/spray/mister/janitor(src)

/obj/item/weapon/reagent_containers/spray/mister/janitor
	name = "janitor spray nozzle"
	desc = "A janitorial spray nozzle attached to a watertank, designed to clean up large messes."
	icon = 'icons/obj/hydroponics.dmi'
	icon_state = "misterjani"
	item_state = "misterjani"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = null

	attack_self(var/mob/user)
		amount_per_transfer_from_this = (amount_per_transfer_from_this == 10 ? 5 : 10)
		user << "<span class='notice'>You [amount_per_transfer_from_this == 10 ? "remove" : "fix"] the nozzle. You'll now use [amount_per_transfer_from_this] units per spray.</span>"

//Atmos tank
/obj/item/weapon/watertank/atmos
	name = "backpack water tank"
	desc = "A backpack watertank with fire extinguisher nozzle, intended to fight fires. Shouldn't toxins have one of these?"
	icon_state = "waterbackpackatmos"
	item_state = "waterbackpackatmos"
	volume = 200

	make_noz()
		return new /obj/item/weapon/extinguisher/mini/nozzle(src)

/obj/item/weapon/extinguisher/mini/nozzle
	name = "fire extinguisher nozzle"
	desc = "A fire extinguisher nozzle attached to a water tank."
	icon = 'icons/obj/hydroponics.dmi'
	icon_state = "atmos_nozzle"
	item_state = "nozzleatmos"
	w_class = 4.0
	safety = 0
	var/obj/item/weapon/watertank/tank

	New(parent_tank)
		if(check_tank_exists(parent_tank, src))
			tank = parent_tank
			reagents = tank.reagents
			max_water = tank.volume
			loc = tank
		return

	dropped(mob/user as mob)
		user << "<span class='notice'>The nozzle snaps back onto the watertank!</span>"
		tank.on = 0
		loc = tank

	attack_self()
		return

	Move(dest, dir)
		// Only will move to valid locations
		if((dest == tank) || (dest == tank.loc /*person with tank on back*/))
			..()
		return