/datum/round_event_control/dead_stowaway
	name = "Dead Stowaway"
	typepath = /datum/round_event/dead_stowaway
	event_flags = EVENT_REWARD
	max_occurrences = -1
	weight = 5
	accuracy = 100

/datum/round_event/dead_stowaway
	alert_when = 1200
	var/area/impact_area = null
	var/turf/landing
	var/list/possible_loots = list(
									/obj/item/weapon/gun/energy/gun,
									/obj/item/weapon/melee/baton/loaded,
									/obj/item/weapon/handcuffs,
									/obj/item/weapon/shard,
									/obj/item/weapon/spacecash/c1000,
									/obj/item/weapon/soap,
									/obj/item/weapon/gun/projectile/automatic/pistol,
									/obj/item/weapon/grenade/stink,
									/obj/item/weapon/crowbar/red,
									/obj/item/weapon/bikehorn,
									/obj/item/device/taperecorder,
									/obj/item/device/gps,
									/obj/item/device/paicard,
									/obj/item/weapon/ore/diamond,
									/obj/item/weapon/screwdriver,
									/obj/item/weapon/tank/emergency_oxygen/engi,
									/obj/item/weapon/wrench,
									/obj/item/weapon/wirecutters
									)

	Setup()
		impact_area = FindEventAreaAwayFromPeople()
		if(!impact_area)
			CancelSelf()
			return
		var/list/impact_turfs = FindImpactTurfs(impact_area)
		if(!impact_turfs.len)
			CancelSelf()
			return
		landing = pick(impact_turfs)

	Alert()
		send_alerts("Foreign lifesigns detected in [impact_area]")

	Start()
		var/mob/living/carbon/human/npc/dead = new(landing)
		suit_up(dead)
		dead.take_organ_damage(200, 200) //well what happened to them?
		new /obj/effect/decal/cleanable/blood(get_turf(dead))
		dead.death()


	proc/suit_up(var/mob/living/carbon/human/H)
		var/datum/preferences/A = new()//Randomize appearance for the zombie.
		A.copy_to(H)
		ready_dna(H)

		H.gender = pick(MALE, FEMALE)


		if(H.gender == MALE)
			H.real_name = text("[] []", pick(first_names_male), pick(last_names))
		else
			H.real_name = text("[] []", pick(first_names_female), pick(last_names))
		ready_dna(H)
		//
		H.equip_to_slot_or_del(new /obj/item/clothing/under/ntwork(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/ntwork(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/ntwork(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), slot_glasses)

		var/obj/item/weapon/storage/belt/B = new /obj/item/weapon/storage/belt
		B.name = "multi-belt"
		for(var/i=1, i<=7, i++)
			var/picked = pick_n_take(possible_loots)
			var/obj/item/loot = new picked
			if(loot.w_class <= 2)
				loot.loc = B
			else
				loot.loc = get_turf(H)
		H.equip_to_slot_or_del(B, slot_belt)