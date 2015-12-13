/mob/living/carbon/human/npc/clown
	npc_name = "Clown"
	faction = "clown"
	retaliate = 1

	New()
		..()
		equip_to_appropriate_slot(new /obj/item/clothing/under/rank/clown)
		equip_to_appropriate_slot(new /obj/item/clothing/shoes/clown_shoes)
		equip_to_appropriate_slot(new /obj/item/device/radio/headset)
		equip_to_appropriate_slot(new /obj/item/clothing/mask/gas/clown_hat)
		equip_to_appropriate_slot(new /obj/item/weapon/bikehorn)
		equip_to_appropriate_slot(new /obj/item/weapon/storage/backpack/clown)

		//id
		var/obj/item/weapon/card/id/W = new(src)
		W.assignment = "Clown"
		W.registered_name = real_name
		W.update_label()
		equip_to_slot_or_del(W, slot_wear_id)

		npc_say += "HONK!"
		npc_say += "Welcome to clown planet!"

		//clownface
		hair_style = "Bald"
		facial_hair_style = "Shaved"
		ready_dna(src)
		mutations.Add(CLUMSY)