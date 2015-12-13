/mob/living/carbon/human/npc/gangster
	npc_name = "Bruiser"
	faction = "mafia"

	New()
		..()
		equip_to_appropriate_slot(new /obj/item/clothing/under/suit_jacket)
		equip_to_appropriate_slot(new /obj/item/clothing/shoes/laceup)
		equip_to_appropriate_slot(new /obj/item/clothing/suit/lawyer/blackjacket)
		equip_to_appropriate_slot(new /obj/item/clothing/head/fedora)

		//id
		var/obj/item/weapon/card/id/W = new(src)
		W.assignment = "Space Mafia"
		W.registered_name = real_name
		W.update_label()
		equip_to_slot_or_del(W, slot_wear_id)

		npc_say += "ey wise guy"
		npc_say += "you talkin' to me?"

/mob/living/carbon/human/npc/gangster_ranged
	npc_name = "Gunman"
	faction = "mafia"
	primary_weapon = /obj/item/weapon/gun/projectile/automatic/tommygun

	New()
		..()
		equip_to_appropriate_slot(new /obj/item/clothing/under/suit_jacket)
		equip_to_appropriate_slot(new /obj/item/clothing/shoes/laceup)
		equip_to_appropriate_slot(new /obj/item/clothing/suit/lawyer/blackjacket)
		equip_to_appropriate_slot(new /obj/item/clothing/head/fedora)

		//id
		var/obj/item/weapon/card/id/W = new(src)
		W.assignment = "Space Mafia"
		W.registered_name = real_name
		W.update_label()
		equip_to_slot_or_del(W, slot_wear_id)

		npc_say += "ey wise guy"
		npc_say += "you talkin' to me?"