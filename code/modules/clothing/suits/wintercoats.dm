/obj/item/clothing/suit/wintercoat
	name = "winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatwinter"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|ARMS|HEAD
	has_hood = 1
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS | HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	allowed = list(/obj/item/weapon/tank/emergency_oxygen,/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/weapon/dnainjector,/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/paper,/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/device/flashlight/seclite,/obj/item/weapon/lighter,/obj/item/weapon/lighter/zippo,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/clothing/mask/cigarette,/obj/item/weapon/reagent_containers/food/drinks/flask)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	var/obj/item/clothing/head/winterhood/hood = null // the hood
	var/hooded = 0 // if its on or not
	action_button_name = "Toggle Hood"

	New()
		MakeHood()
		..()

	Destroy()
		..()
		RemoveHood()

	proc/MakeHood()
		hood = new /obj/item/clothing/head/winterhood/(src)
		hood.icon_state = initial(icon_state)

	ui_action_click()
		..()
		ToggleHood()

	AltClick(var/mob/user)
		if(!Adjacent(user)) return // Adjacent check
		togglecoat()

	verb/togglecoat()
		set name = "Toggle Coat"
		set category = "Object"
		set src in usr
		ToggleHood()

	equipped(mob/user, slot)
		if(slot != slot_wear_suit)
			RemoveHood()
		..()

	proc/RemoveHood()
		hooded = 0
		if(ishuman(hood.loc))
			var/mob/living/carbon/H = hood.loc
			H.unEquip(hood, 1)
			src.icon_state = initial(icon_state)
			H.update_inv_wear_suit()
		hood.loc = src

	dropped()
		RemoveHood()

	proc/ToggleHood()
		var/mob/living/carbon/human/H = src.loc
		if(hood && !hooded)
			if(ishuman(src.loc))
				if(H.wear_suit != src)
					H << "You must be wearing [src] to flip on the hood."
					return
				if(H.head)
					H << "You're already wearing something on your head."
					return
				else
					H << "You button up [src]"
					H.equip_to_slot_if_possible(hood,slot_head,0,0,1)
					hooded = 1
					src.icon_state += "_open"
					H.update_inv_wear_suit()
		else
			H << "You unbutton up the [src]"
			RemoveHood()

//
// The hood
//

/obj/item/clothing/head/winterhood
	name = "winter hood"
	desc = "A hood attached to a heavy winter jacket."
	icon_state = "generic_hood"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	icon_state = "coatwinter"
	flags = NODROP | BLOCKHAIR
	flags_inv = HIDEEARS
	var/obj/item/clothing/suit/wintercoat/coat = null
	New()
		..()
		if(istype(loc, /obj/item/clothing/suit/wintercoat))
			coat = loc
		else
			qdel(src) // Spawned without a hoodie, delete it
	Destroy()
		..()
		if(coat)
			qdel(src.coat) // If there is a wintercoat attached when one gets deleted, delete the other


//
// Winter Coats
//

/obj/item/clothing/suit/wintercoat/captain
	name = "captain's winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatcaptain"

/obj/item/clothing/suit/wintercoat/cargo
	name = "cargo winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatcargo"

/obj/item/clothing/suit/wintercoat/engineer
	name = "engineering winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatengineer"

/obj/item/clothing/suit/wintercoat/atmos
	name = "atmos winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatatmos"

/obj/item/clothing/suit/wintercoat/hydro
	name = "hydroponics winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coathydro"

/obj/item/clothing/suit/wintercoat/medical
	name = "medical winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatmedical"

/obj/item/clothing/suit/wintercoat/medical/emt
	name = "first-responder winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatemt"

/obj/item/clothing/suit/wintercoat/miner
	name = "mining winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatminer"

/obj/item/clothing/suit/wintercoat/science
	name = "science winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatscience"

/obj/item/clothing/suit/wintercoat/security
	name = "security winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatsecurity"
