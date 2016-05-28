/datum/round_event_control/space_explorer
	name = "Space Explorers"
	typepath = /datum/round_event/space_explorer
	event_flags = EVENT_STANDARD
	max_occurrences = 1
	candidate_flag = BE_EXPLORER
	candidates_needed = 1

/datum/round_event/space_explorer
	var/spawncount = 1
	var/successSpawn = 0	//So we don't make a command report if nothing gets spawned.

	var/list/goodies = list(
						//top tier stock parts
						/obj/item/weapon/stock_parts/cell/hyper=5,
						/obj/item/weapon/stock_parts/scanning_module/phasic=5,
						/obj/item/weapon/stock_parts/micro_laser/ultra=5,
						/obj/item/weapon/stock_parts/matter_bin/super=5,
						/obj/item/weapon/stock_parts/manipulator/pico=5,
						/obj/item/weapon/stock_parts/cell/hyper=5,
						/obj/item/weapon/stock_parts/capacitor/super=5,
						//guns
						/obj/item/weapon/gun/projectile/automatic/mini_uzi=4,
						/obj/item/weapon/gun/projectile/automatic/deagle=3,
						/obj/item/weapon/gun/projectile/automatic/c20r=3,
						/obj/item/weapon/gun/energy/stunrevolver=4,
						/obj/item/weapon/gun/energy/laser/retro=2,
						//spells? (rare)
						/obj/item/weapon/spellbook/oneuse/knock=1,
						/obj/item/weapon/spellbook/oneuse/fireball=1,
						/obj/item/weapon/spellbook/oneuse/mindswap=1
						)

	Setup()
		spawncount = rand(1, 3)

	Alert()
		spawn(0)
			//Send the signal to everyone
			for(var/mob/M in player_list)
				if(!istype(M,/mob/new_player))
					M << sound('sound/machines/signal.ogg',0,null,null,25) // lower this sound because its a LOUD BEEP
			sleep(50)
			priority_announce("Distress signal recieved from nearby unknown spacecrafts", "Distress Signal")

	Start()
		while(spawncount > 0 && candidates.len)
			var/client/C = pick_n_take(candidates)
			var/X = rand(100,200)
			var/Y = rand(100,200)
			var/Z = 6
			var/obj/pod/large/pre_equipped/ship = new()
			ship.z = Z
			ship.x = X
			ship.y = Y
			var/mob/living/carbon/human/H = new()
			H.loc = ship
			H.key = C.key
			suit_up(H)
			ship.pilot = H
			ship.PrintSystemNotice("Systems initialized.")
			if(ship.power_source)
				ship.PrintSystemNotice("Power Charge: [ship.power_source.charge]/[ship.power_source.maxcharge] ([ship.power_source.percent()]%)")
			else
				ship.PrintSystemAlert("No power source installed.")
			ship.PrintSystemNotice("Integrity: [round((ship.health / ship.max_health) * 100)]%.")

			spawncount--
			successSpawn = 1
			if (!prevent_stories) EventStory("The station recieved a strange visitor... a space explorer.")

/datum/round_event/space_explorer/proc/suit_up(var/mob/living/carbon/human/H)
	var/datum/preferences/A = H.client.prefs
	A.copy_to(H)
	//ok that is all fine and dandy except the spawned individual looks exactly like the person's typical character
	//we don't want this for meta reasons so lets start making them randum
	//at most we just want to keep the prefered gender
	//lets start with underwear
	H.undershirt = "Nude"
	H.underwear = "Nude"
	H.socks = "Nude"
	//Ok they should have a face and skintone now
	H.skin_tone = random_skin_tone()
	H.hair_style = random_hair_style(H.gender)
	if(prob(25)) // not everyone has a damn mustache in this world
		H.facial_hair_style = random_facial_hair_style(H.gender)
	H.hair_color = random_short_color()
	H.facial_hair_color = H.hair_color
	//great.. but the name?
	if(H.gender == MALE)
		H.real_name = "[pick(first_names_male)] [pick(last_names)]"
	else
		H.real_name = "[pick(first_names_female)] [pick(last_names)]"
	H.mind.name = H.real_name
	H.name = H.real_name
	//ok prepare the person's DNA
	ready_dna(H)
	var/obj/item/weapon/storage/backpack/dufflebag/duffle = new()
	H.equip_to_slot_or_del(duffle, slot_back,1)
	for(var/i=0 ,i<=duffle.storage_slots,i++)
		var/obj/item/goodie = pick(goodies)
		if(goodie)
			H.equip_to_slot_or_del(new goodie(H.back), slot_in_backpack)
	//Clothing and stuff..
	var/outfit_type = pick("Space Dweller","Laborer","Merchant")
	switch(outfit_type)
		if("Space Dweller")
			H.equip_to_slot_or_del(new /obj/item/clothing/under/ntwork(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/ntwork(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/ntwork(H), slot_gloves)
		if("Laborer")
			H.equip_to_slot_or_del(new /obj/item/clothing/under/overalls(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/brown(H), slot_gloves)
		if("Merchant")
			/* need to make room for that EVA gear
			if(prob(50)) //ay carumba
				H.equip_to_slot_or_del(new /obj/item/clothing/head/sombrero(H), slot_head)
				H.equip_to_slot_or_del(new /obj/item/clothing/mask/fakemoustache(H), slot_wear_mask)
			*/
			H.equip_to_slot_or_del(new /obj/item/clothing/under/redoveralls(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/device/radio(H), slot_belt)
	var/obj/item/weapon/card/id/C = new /obj/item/weapon/card/id(H)
	H.equip_to_slot_or_del(C, slot_wear_id)
	C.registered_name = H.real_name
	C.assignment = "Space Explorer"
	C.update_label()
	//EVA gear
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), slot_wear_mask)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/tank/emergency_oxygen(H), slot_s_store)


	//antag?
	var/antag = 0
	var/datum/mind/Mind = H.mind
	if(prob(50))
		Mind.assigned_role = "MODE"
		Mind.special_role = "Space Renegade"
		ticker.mode.traitors |= Mind			//Adds them to current traitor list. Which is really the extra antagonist list.
		antag = 1
		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = Mind
		kill_objective.find_target()
		if(kill_objective.target)
			var/fluff_kill = rand(1,4)
			switch(fluff_kill)
				if(1)
					kill_objective.explanation_text = "Kill [kill_objective.target.name]. Your scanner reports that they might be the [kill_objective.target.assigned_role]"
				if(2)
					kill_objective.explanation_text = "Take out [kill_objective.target.name]. Your scanner reports they may be the only thing standing in your way"
				if(3)
					kill_objective.explanation_text = "Kick the living crap out of [kill_objective.target.name], make sure they do not come out alive. Your scanner recommended this, better do as it says."
				if(4)
					kill_objective.explanation_text = "The station has a [kill_objective.target.assigned_role], their name is [kill_objective.target.name].. Take them out"
			Mind.objectives += kill_objective
		else
			qdel(kill_objective)



		var/datum/objective/steal/steal_objective = new
		steal_objective.owner = Mind
		steal_objective.find_target()
		var/fluff_steal = rand(1,4)
		switch(fluff_steal)
			if(1)
				steal_objective.explanation_text = "It's time for a raid. The scanner reports [steal_objective.targetinfo.name] aboard the vessel"
			if(2)
				steal_objective.explanation_text = "You have wanted [steal_objective.targetinfo.name] for some time now, board the vessel and find one"
			if(3)
				steal_objective.explanation_text = "Find and steal [steal_objective.targetinfo.name]. These space stations oughta have some."
			if(4)
				steal_objective.explanation_text = "Your scanner asks you politely to steal a [steal_objective.targetinfo.name]. How can you possibly refuse that?"

		Mind.objectives += steal_objective


		var/datum/objective/survive/survive_objective = new
		survive_objective.owner = Mind
		Mind.objectives += survive_objective
	//finally fluff it up
	if(antag)
		Mind.current << "<B><font size=3 color=red>You are the Space Renegade.</font></B>"
		Mind.current << "You detect a nearby vessel, according to your scanners.. they detect you too."
		Mind.current << "Your pod computer beeps and boops, printing out various information about the vessel"
		Mind.current << "You recieve information of [station_name] and the crew aboard it and decide what to do next..."
		Mind.current << "You are equiped with a bag from your latest raid."
		var/obj_count = 1
		for(var/datum/objective/objective in Mind.objectives)
			Mind.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
			obj_count++
		return
	else
		Mind.current << "<B><font size=3 color=blue>You are the Space Explorer.</font></B>"
		Mind.current << "You are on the search for food, shelter and money"
		Mind.current << "You detect a nearby vessel, according to your scanners.. they detect you too."
		Mind.current << "You are equiped with a bag from your scavenging trip. Perhaps you can trade with the near-by vessel?"
		Mind.current << "You recieve information of [station_name] and the crew aboard it and set your coordinates for it. Is this what you have been looking for?"