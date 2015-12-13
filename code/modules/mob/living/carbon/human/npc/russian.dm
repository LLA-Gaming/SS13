/mob/living/carbon/human/npc/russian
	npc_name = "Russian"
	faction = "russian"
	primary_weapon = /obj/item/weapon/kitchenknife

	New()
		..()
		equip_to_appropriate_slot(new /obj/item/clothing/under/soviet)
		equip_to_appropriate_slot(new /obj/item/clothing/shoes/jackboots)
		equip_to_appropriate_slot(new /obj/item/clothing/head/bearpelt)

		npc_say += "Cyka blyat"
		npc_say += "I need another vodka"

/mob/living/carbon/human/npc/russian_ranged
	name = "Russian"
	npc_name = "Russian"
	faction = "russian"
	ranged = 1
	primary_weapon = /obj/item/weapon/gun/projectile/revolver/mateba

	New()
		..()
		equip_to_appropriate_slot(new /obj/item/clothing/under/soviet)
		equip_to_appropriate_slot(new /obj/item/clothing/shoes/jackboots)
		equip_to_appropriate_slot(new /obj/item/clothing/head/ushanka)

		npc_say += "Cyka blyat"
		npc_say += "I need another vodka"