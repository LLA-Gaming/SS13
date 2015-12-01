/mob/living/carbon/human/npc/clown
	npc_name = "Clown"
	faction = "clown"
	var/list/csay = list()

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

		csay += "HONK!"
		csay += "Welcome to clown planet!"

		//clownface
		hair_style = "Bald"
		facial_hair_style = "Shaved"
		ready_dna(src)
		mutations.Add(CLUMSY)

	Life()
		..()
		if(prob(3) && !client && stat == CONSCIOUS)
			src.say(pick(csay))

	targeting() //Clowns dont attack unless provoked
		in_range = list()
		can_see = list()
		if(!client && stat == CONSCIOUS)
			//in_range
			for(var/mob/living/M in orange(src,10))
				if(istype(M,/mob/living/carbon/human/npc))
					continue
				in_range.Add(M)

			if(!in_range.len) //needs a living mob in range to process
				state = NPC_STATE_INACTIVE
				return
			if(state == NPC_STATE_INACTIVE)
				state = NPC_STATE_MOVING
			//can_see
			if(!(blinded > 0))
				for(var/mob/living/M in hearers(src))
					var/turf/t = get_turf(M) //is it dark?
					var/area/a = get_area(t)
					if ((!a.lighting_use_dynamic || t.lighting_lumcount >= 0.50) || (istype(src.glasses, /obj/item/clothing/glasses/night) || istype(src.glasses, /obj/item/clothing/glasses/thermal)))
						//despite support for thermal vision on NPCs, i would not reccomend giving them that in the first place unless you want the crew to have some.
						if (!minimal_vision)
							can_see.Add(M)
						else
							if (src.loc.x > M.loc.x && src.dir == WEST)
								can_see.Add(M)

							if (src.loc.x < M.loc.x && src.dir == EAST)
								can_see.Add(M)

							if (src.loc.y < M.loc.y && src.dir == NORTH)
								can_see.Add(M)

							if (src.loc.y > M.loc.y && src.dir == SOUTH)
								can_see.Add(M)

			if(target)
				//next to src
				var/distance = get_dist(src, target)
				if(distance <= 1 && !ranged)
					state = NPC_STATE_MELEE
					return
				//lost him
				if(!(locate(target) in hearers(src)))
					target = null
					return
				if(target.stat)
					target = null