/*
Captain
*/
/datum/job/captain
	title = "Captain"
	flag = CAPTAIN
	department_head = list("Centcom")
	department_flag = ENGSEC
	departments = list("Command","Security","Engineering","Medical","Science","Supply","Civilian")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Nanotrasen officials and Space law"
	selection_color = "#ccccff"
	req_spacelaw_notify = 1
	minimal_player_age = 14

	default_id = /obj/item/weapon/card/id/gold
	default_tablet = /obj/item/device/tablet/captain
	default_headset = /obj/item/device/radio/headset/heads/captain
	default_backpack = /obj/item/weapon/storage/backpack/captain
	default_satchel = /obj/item/weapon/storage/backpack/satchel_cap

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()

/datum/job/captain/equip_items(var/mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/clothing/under/U = new /obj/item/clothing/under/rank/captain(H)
	U.attachTie(new /obj/item/clothing/tie/medal/gold/captain())
	H.equip_to_slot_or_del(U, slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/capcarapace(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/brown(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), slot_glasses)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/telescopic(H), slot_r_store) // Equips the telebaton

	//Equip ID box
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(H), slot_l_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(H.back), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/book/manual/spacelaw(H), slot_l_hand)
	if(visualsOnly)
		return
	//Implant him
	var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
	L.imp_in = H
	L.implanted = 1

	world << "<b>[H.real_name] is the captain!</b>"

/datum/job/captain/get_access()
	return get_all_accesses()

/*
Head of Personnel
*/
/datum/job/hop
	title = "Head of Personnel"
	flag = HOP
	department_head = list("Captain")
	department_flag = CIVILIAN
	departments = list("Command","Supply","Civilian")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ddddff"
	req_spacelaw_notify = 1
	minimal_player_age = 10

	default_id = /obj/item/weapon/card/id/silver
	default_tablet = /obj/item/device/tablet/hop
	default_headset = /obj/item/device/radio/headset/heads/hop

	access = list(access_security, access_sec_doors, access_brig, access_court, access_forensics_lockers,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_theatre, access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_therapist, access_mineral_storeroom)
	minimal_access = list(access_security, access_sec_doors, access_court,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_theatre, access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_therapist, access_mineral_storeroom)


/datum/job/hop/equip_items(var/mob/living/carbon/human/H, visualsOnly = FALSE)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/head_of_personnel(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/brown(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/hopcap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/telescopic(H), slot_r_store) // Equips the telebaton
	if(visualsOnly)
		return
	//Equip ID box
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(H), slot_l_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(H.back), slot_in_backpack)
