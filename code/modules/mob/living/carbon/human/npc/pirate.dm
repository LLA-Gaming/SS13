/mob/living/carbon/human/npc/pirate
	npc_name = "Pirate"
	faction = "Pirate"
	primary_weapon = /obj/item/weapon/melee/energy/sword/pirate

	New()
		..()
		equip_to_appropriate_slot(new /obj/item/clothing/under/pirate)
		equip_to_appropriate_slot(new /obj/item/clothing/shoes/jackboots)
		equip_to_appropriate_slot(new /obj/item/clothing/glasses/eyepatch)
		equip_to_appropriate_slot(new /obj/item/clothing/head/bandana)

		//id
		var/obj/item/weapon/card/id/W = new(src)
		W.assignment = "Pirate"
		W.registered_name = real_name
		W.update_label()
		equip_to_slot_or_del(W, slot_wear_id)

		npc_say += "YAAAARRR"
		npc_say += "Lootin' and plunderin'"

		//activate weapons
		for(var/obj/item/weapon/melee/energy/sword/E in contents)
			E.attack_self(src)

/mob/living/carbon/human/npc/pirate_ranged
	npc_name = "Pirate Gunner"
	faction = "Pirate"
	primary_weapon = /obj/item/weapon/gun/energy/laser

	New()
		..()
		equip_to_appropriate_slot(new /obj/item/clothing/under/pirate)
		equip_to_appropriate_slot(new /obj/item/clothing/shoes/jackboots)
		equip_to_appropriate_slot(new /obj/item/clothing/glasses/eyepatch)
		equip_to_appropriate_slot(new /obj/item/clothing/suit/pirate)
		equip_to_appropriate_slot(new /obj/item/clothing/head/pirate)

		//id
		var/obj/item/weapon/card/id/W = new(src)
		W.assignment = "Pirate"
		W.registered_name = real_name
		W.update_label()
		equip_to_slot_or_del(W, slot_wear_id)

		npc_say += "YAAAARRR"
		npc_say += "Lootin' and plunderin'"