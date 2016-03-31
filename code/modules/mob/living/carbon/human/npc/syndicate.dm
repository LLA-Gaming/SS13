/mob/living/carbon/human/npc/syndicate
	npc_name = "Syndicate"
	faction = "syndicate"

	New()
		..()
		equip_to_appropriate_slot(new /obj/item/clothing/under/syndicate)
		equip_to_appropriate_slot(new /obj/item/clothing/suit/armor/vest)
		equip_to_appropriate_slot(new /obj/item/clothing/shoes/swat)
		equip_to_appropriate_slot(new /obj/item/clothing/gloves/combat)
		equip_to_appropriate_slot(new /obj/item/device/radio/headset)
		equip_to_appropriate_slot(new /obj/item/clothing/mask/gas)
		equip_to_appropriate_slot(new /obj/item/clothing/head/helmet/swat)
		equip_to_appropriate_slot(new /obj/item/weapon/storage/backpack)

		//id
		var/obj/item/weapon/card/id/W = new(src)
		W.assignment = "Operative"
		W.registered_name = real_name
		W.update_label()
		equip_to_slot_or_del(W, slot_wear_id)

		npc_say += "Patrolling deep space almost makes you wish for a nuclear explosion"
		npc_say += "Death to Nanotrasen!"

/mob/living/carbon/human/npc/syndicate_melee
	npc_name = "Syndicate"
	faction = "syndicate"
	primary_weapon = /obj/item/weapon/melee/energy/sword/red
	secondary_weapon = /obj/item/weapon/shield/energy

	New()
		..()
		equip_to_appropriate_slot(new /obj/item/clothing/under/syndicate)
		equip_to_appropriate_slot(new /obj/item/clothing/suit/armor/vest)
		equip_to_appropriate_slot(new /obj/item/clothing/shoes/swat)
		equip_to_appropriate_slot(new /obj/item/clothing/gloves/combat)
		equip_to_appropriate_slot(new /obj/item/device/radio/headset)
		equip_to_appropriate_slot(new /obj/item/clothing/mask/gas)
		equip_to_appropriate_slot(new /obj/item/clothing/head/helmet/swat)
		equip_to_appropriate_slot(new /obj/item/weapon/storage/backpack)

		//id
		var/obj/item/weapon/card/id/W = new(src)
		W.assignment = "Operative"
		W.registered_name = real_name
		W.update_label()
		equip_to_slot_or_del(W, slot_wear_id)

		//activate weapons
		for(var/obj/item/weapon/melee/energy/sword/E in contents)
			E.attack_self(src)
		for(var/obj/item/weapon/shield/energy/E in contents)
			E.attack_self(src)

		npc_say += "Patrolling deep space almost makes you wish for a nuclear explosion"
		npc_say += "Death to Nanotrasen!"

/mob/living/carbon/human/npc/syndicate_knife
	npc_name = "Syndicate"
	faction = "syndicate"
	primary_weapon = /obj/item/weapon/kitchenknife

	New()
		..()
		equip_to_appropriate_slot(new /obj/item/clothing/under/syndicate)
		equip_to_appropriate_slot(new /obj/item/clothing/suit/armor/vest)
		equip_to_appropriate_slot(new /obj/item/clothing/shoes/swat)
		equip_to_appropriate_slot(new /obj/item/clothing/gloves/combat)
		equip_to_appropriate_slot(new /obj/item/device/radio/headset)
		equip_to_appropriate_slot(new /obj/item/clothing/mask/gas)
		equip_to_appropriate_slot(new /obj/item/clothing/head/helmet/swat)
		equip_to_appropriate_slot(new /obj/item/weapon/storage/backpack)

		//id
		var/obj/item/weapon/card/id/W = new(src)
		W.assignment = "Operative"
		W.registered_name = real_name
		W.update_label()
		equip_to_slot_or_del(W, slot_wear_id)

		npc_say += "Patrolling deep space almost makes you wish for a nuclear explosion"
		npc_say += "Death to Nanotrasen!"


/mob/living/carbon/human/npc/syndicate_ranged
	npc_name = "Syndicate"
	faction = "syndicate"
	primary_weapon = /obj/item/weapon/gun/projectile/automatic/c20r

	New()
		..()
		equip_to_appropriate_slot(new /obj/item/clothing/under/syndicate)
		equip_to_appropriate_slot(new /obj/item/clothing/suit/armor/vest)
		equip_to_appropriate_slot(new /obj/item/clothing/shoes/swat)
		equip_to_appropriate_slot(new /obj/item/clothing/gloves/combat)
		equip_to_appropriate_slot(new /obj/item/device/radio/headset)
		equip_to_appropriate_slot(new /obj/item/clothing/mask/gas)
		equip_to_appropriate_slot(new /obj/item/clothing/head/helmet/swat)
		equip_to_appropriate_slot(new /obj/item/weapon/storage/backpack)

		//id
		var/obj/item/weapon/card/id/W = new(src)
		W.assignment = "Operative"
		W.registered_name = real_name
		W.update_label()
		equip_to_slot_or_del(W, slot_wear_id)

		npc_say += "Patrolling deep space almost makes you wish for a nuclear explosion"
		npc_say += "Death to Nanotrasen!"

/mob/living/carbon/human/npc/syndicate_melee_s
	npc_name = "Syndicate"
	faction = "syndicate"
	primary_weapon = /obj/item/weapon/melee/energy/sword/red
	secondary_weapon = /obj/item/weapon/shield/energy

	New()
		..()
		equip_to_appropriate_slot(new /obj/item/clothing/under/syndicate)
		equip_to_appropriate_slot(new /obj/item/clothing/suit/space/rig/syndi)
		equip_to_appropriate_slot(new /obj/item/clothing/shoes/swat)
		equip_to_appropriate_slot(new /obj/item/clothing/gloves/combat)
		equip_to_appropriate_slot(new /obj/item/device/radio/headset)
		equip_to_appropriate_slot(new /obj/item/clothing/mask/gas/syndicate)
		equip_to_appropriate_slot(new /obj/item/clothing/head/helmet/space/rig/syndi)
		equip_to_appropriate_slot(new /obj/item/weapon/tank/jetpack/oxygen)

		//id
		var/obj/item/weapon/card/id/W = new(src)
		W.assignment = "Operative"
		W.registered_name = real_name
		W.update_label()
		equip_to_slot_or_del(W, slot_wear_id)

		//activate weapons
		for(var/obj/item/weapon/melee/energy/sword/E in contents)
			E.attack_self(src)
		for(var/obj/item/weapon/shield/energy/E in contents)
			E.attack_self(src)

		npc_say += "Patrolling deep space almost makes you wish for a nuclear explosion"
		npc_say += "Death to Nanotrasen!"

	Process_Spacemove(var/check_drift = 0)
		for(var/obj/item/weapon/tank/jetpack/O in contents)
			return 1
		..()

/mob/living/carbon/human/npc/syndicate_ranged_s
	npc_name = "Syndicate"
	faction = "syndicate"
	primary_weapon = /obj/item/weapon/gun/projectile/automatic/c20r

	New()
		..()
		equip_to_appropriate_slot(new /obj/item/clothing/under/syndicate)
		equip_to_appropriate_slot(new /obj/item/clothing/suit/space/rig/syndi)
		equip_to_appropriate_slot(new /obj/item/clothing/shoes/swat)
		equip_to_appropriate_slot(new /obj/item/clothing/gloves/combat)
		equip_to_appropriate_slot(new /obj/item/device/radio/headset)
		equip_to_appropriate_slot(new /obj/item/clothing/mask/gas/syndicate)
		equip_to_appropriate_slot(new /obj/item/clothing/head/helmet/space/rig/syndi)
		equip_to_appropriate_slot(new /obj/item/weapon/tank/jetpack/oxygen)

		//id
		var/obj/item/weapon/card/id/W = new(src)
		W.assignment = "Operative"
		W.registered_name = real_name
		W.update_label()
		equip_to_slot_or_del(W, slot_wear_id)

		npc_say += "Patrolling deep space almost makes you wish for a nuclear explosion"
		npc_say += "Death to Nanotrasen!"

	Process_Spacemove(var/check_drift = 0)
		for(var/obj/item/weapon/tank/jetpack/O in contents)
			return 1
		..()
