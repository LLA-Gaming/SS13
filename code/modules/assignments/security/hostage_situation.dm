/datum/assignment/hostile_takeover
	name = "Hostile Takeover"
	details = "Eliminate the hostiles aboard the station!"
	dept = list("Security")
	heads = list("Head of Security")
	var/list/hotzones
	var/area/hotzone
	var/list/impact_turfs
	var/faction
	var/list/mobs = list()

	New()
		..()
		hotzones = assignments.get_hotzones("station")

	tick()
		..()
		if(IsMultiple(activeFor,10))
			check_complete()

	check_complete()
		for(var/mob/living/carbon/human/npc/NPC in mobs)
			if(NPC.stat != DEAD)
				return 0
		complete()
		return 1

	pre_setup()
		var/loop = 1
		for(loop, loop < 50, loop++)
			if(loop > 50)
				return 0
			if(!hotzones.len)
				return 0
			hotzone = locate(pick(hotzones))
			if(!hotzone)
				return
			impact_turfs = get_area_turfs(hotzone)
			//remove walls and other dense turfs
			var/mobs_detected = 0
			if(impact_turfs.len)
				for(var/turf/T in impact_turfs)
					for(var/mob/living/L in T.contents)
						mobs_detected = 1
						break
					if(T.density || T.opacity)
						impact_turfs.Remove(T)
						continue
					for(var/obj/O in T.contents)
						if(O.density)
							impact_turfs.Remove(T)
							break
			if(!mobs_detected)
				//decide faction
				faction = pick("Russians","Syndicates","Pirates","Space Mafia","Angry Clowns")
				//ok if there are spawn points
				if(hotzone && impact_turfs.len)
					var/randname = pick(list(
					"[faction] at [format_text(hotzone.name)]",
					"[format_text(hotzone.name)] Seized by [faction]",
					"Hostile Takeover: [format_text(hotzone.name)]",
					"[faction] Detected",
					))
					name = randname
					details = "Eliminate the [faction] located in [format_text(hotzone.name)]!"
					todo.Add("Evacuate any crew members from [format_text(hotzone.name)]")
					todo.Add("Eliminate the [faction]")
				//can this be done?
				if(hotzone && impact_turfs.len)
					spawn_takeover()
					return 1
				else
					continue
			else
				continue

	proc/spawn_takeover()
		switch(faction)
			if("Russians")
				var/mob/living/carbon/human/npc/russian1 = new /mob/living/carbon/human/npc/russian_ranged(pick(impact_turfs))
				var/mob/living/carbon/human/npc/russian2 = new /mob/living/carbon/human/npc/russian(pick(impact_turfs))
				mobs.Add(russian1)
				mobs.Add(russian2)
			if("Syndicates")
				var/mob/living/carbon/human/npc/syndicate1 = new /mob/living/carbon/human/npc/syndicate(pick(impact_turfs))
				var/mob/living/carbon/human/npc/syndicate2 = new /mob/living/carbon/human/npc/syndicate(pick(impact_turfs))
				var/mob/living/carbon/human/npc/syndicate3 = new /mob/living/carbon/human/npc/syndicate(pick(impact_turfs))
				mobs.Add(syndicate1)
				mobs.Add(syndicate2)
				mobs.Add(syndicate3)
			if("Pirates")
				var/mob/living/carbon/human/npc/pirate1 = new /mob/living/carbon/human/npc/pirate(pick(impact_turfs))
				var/mob/living/carbon/human/npc/pirate2 = new /mob/living/carbon/human/npc/pirate(pick(impact_turfs))
				var/mob/living/carbon/human/npc/pirate3 = new /mob/living/carbon/human/npc/pirate_ranged(pick(impact_turfs))
				mobs.Add(pirate1)
				mobs.Add(pirate2)
				mobs.Add(pirate3)
			if("Space Mafia")
				var/mob/living/carbon/human/npc/gangster1 = new /mob/living/carbon/human/npc/gangster(pick(impact_turfs))
				var/mob/living/carbon/human/npc/gangster2 = new /mob/living/carbon/human/npc/gangster_ranged(pick(impact_turfs))
				var/mob/living/carbon/human/npc/gangster3 = new /mob/living/carbon/human/npc/gangster_ranged(pick(impact_turfs))
				mobs.Add(gangster1)
				mobs.Add(gangster2)
				mobs.Add(gangster3)
			if("Angry Clowns")
				var/mob/living/carbon/human/npc/clown1 = new /mob/living/carbon/human/npc(pick(impact_turfs))
				var/mob/living/carbon/human/npc/clown2 = new /mob/living/carbon/human/npc(pick(impact_turfs))
				var/mob/living/carbon/human/npc/clown3 = new /mob/living/carbon/human/npc(pick(impact_turfs))
				mobs.Add(clown1)
				mobs.Add(clown2)
				mobs.Add(clown3)
				for(var/mob/living/carbon/human/npc/N in mobs)
					N.real_name = "Angry Clown"
					N.faction = "clown"
					var/obj/item/clothing/mask/gas/clown_hat/cmask = new /obj/item/clothing/mask/gas/clown_hat
					cmask.icon_state = pick("clown","sexyclown","joker","rainbow")
					N.equip_to_appropriate_slot(new /obj/item/clothing/under/rank/clown)
					N.equip_to_appropriate_slot(new /obj/item/clothing/shoes/clown_shoes)
					N.equip_to_appropriate_slot(new /obj/item/device/radio/headset)
					N.equip_to_appropriate_slot(cmask)
					N.equip_to_appropriate_slot(new /obj/item/weapon/bikehorn)
					N.equip_to_appropriate_slot(new /obj/item/weapon/storage/backpack/clown)
					//id
					var/obj/item/weapon/card/id/W = new(src)
					W.assignment = "Clown"
					W.registered_name = N.real_name
					W.update_label()
					N.equip_to_slot_or_del(W, slot_wear_id)