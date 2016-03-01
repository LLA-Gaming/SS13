//Zombies
/mob/living/carbon/human/npc/zombie
	m_intent = "run"
	idlemove_chance = 0 //zombies have there own idle movecode
	faction = "zombie"
	always_melee = 1

	New()
		..()
		npc_say += "braaaaains"
		npc_say += "Mrrrhrrrrrrmmmm"
		npc_say += "BRAIIIIIIIIINSSSSS"
		npc_say += "uuuuuuuuuuuhhhh"
		npc_say += "grrrr-grrrii-gggrii-fffee-rrr"
		npc_say += "UHhuHUhuhhhh"
		npc_say += "thriii-thirriiill--errrr"
		npc_say += "GRRRRRRRRR"
		npc_say += "ahhhaaaarraaghh"
		npc_say += "eeemmmmmmaaarrrrrrraggh"
		npc_say += "AAARRAAAGGGGHHHHHH"
		npc_say += "FFFFEEEEERRAAAAG"
		npc_say += "bbbb-bbbr-ainnnnnns"

		src.contract_disease(new/datum/disease/z_virus)

	process()
		if(!client && stat == CONSCIOUS)
			if(!target)
				if(world.time > move_delay && !lying)
					m_intent = "walk"
					var/direction = pick(NORTH,SOUTH,EAST,WEST)
					step(src,direction)
					set_move_delay(2)
			else
				m_intent = "run"
		..()

	attack_at()
		//just as a note, zombies arent smart enough to smash ripleys/pods/closets to find humans. intended. those things are "safe passage" through zombie fields.
		if(!target || lying || restrained() || target.stat)
			state = NPC_STATE_MOVING
			return
		var/distance = get_dist(src, target)
		if(distance > 1)
			state = NPC_STATE_MOVING
			return
		if(next_move <= world.time)
			changeNext_move(8)
			if(!istype(src.wear_mask, /obj/item/clothing/mask) && !lying)
				if(prob(25))
					for(var/mob/O in viewers(world.view,src))
						O.show_message("\red <B>[src] has attempted to bite [src.target]!</B>", 1, "\red You hear struggling.", 2)
				else
					for(var/mob/O in viewers(world.view,src))
						O.show_message("\red <B>[src.target] has been bitten by [src]!</B>", 1, "\red You hear struggling.", 2)
					var/mob/living/carbon/human/T = target
					//hostile response if biting another NPC
					if(istype(target,/mob/living/carbon/human/npc))
						var/mob/living/carbon/human/npc/NPC = target
						if(NPC.faction != src.faction)
							NPC.target = src
					//
					var/obj/item/organ/limb/affecting = 0
					if(istype(T))
						for(var/obj/item/organ/limb/organ in T.organs)
							if(istype(organ, /obj/item/organ/limb/head))
								affecting = organ
								break
						if(affecting)
							affecting.take_damage(rand(1,7), 0)
					else
						T.apply_damage(rand(1,7))
					playsound(src.loc, 'sound/items/eatfood.ogg', 50, 1)
					if(prob(25))
						target.contract_disease(new/datum/disease/z_virus)
					src.add_blood(src.target)
					if (prob(33))
						var/turf/location = src.target.loc
						if (istype(location, /turf/simulated))
							location.add_blood(src.target)
					if (src.wear_mask)
						src.wear_mask.add_blood(src.target)
					if (src.head)
						src.head.add_blood(src.target)
					if (src.glasses && prob(33))
						src.glasses.add_blood(src.target)
					if (src.gloves)
						src.gloves.add_blood(src.target)
					if (prob(15))
						if (src.wear_suit)
							src.wear_suit.add_blood(src.target)
						else if (src.w_uniform)
							src.w_uniform.add_blood(src.target)
			else if(target && !lying && !restrained())
				if(prob(25))
					if(src.l_hand)
						if(istype(src.l_hand, /obj/item/weapon))
							var/obj/item/weapon/A = src.l_hand
							A.attack(src.target, src)
					else
						if(istype(src.r_hand, /obj/item/weapon))
							var/obj/item/weapon/A = src.r_hand
							A.attack(src.target, src)
				else if(prob(25))
					for(var/mob/O in viewers(world.view,src))
						O.show_message("\red <B>[src] has attempted to claw [src.target]!</B>", 1, "\red You hear struggling.", 2)
				else
					for(var/mob/O in viewers(world.view,src))
						O.show_message("\red <B>[src.target] has been clawed by [src]!</B>", 1, "\red You hear struggling.", 2)
					var/mob/living/carbon/human/T = target
					if(istype(target,/mob/living/carbon/human/npc))
						var/mob/living/carbon/human/npc/NPC = target
						if(NPC.faction != src.faction)
							NPC.target = src
					//
					var/obj/item/organ/limb/affecting = 0
					if(istype(T))
						for(var/obj/item/organ/limb/organ in T.organs)
							if(istype(organ, /obj/item/organ/limb/head))
								affecting = organ
								break
						if(affecting)
							affecting.take_damage(rand(1,7), 0)
					else
						T.apply_damage(rand(1,7))
					if(prob(12.5))
						target.contract_disease(new/datum/disease/z_virus)
					src.add_blood(src.target)
					if (prob(33))
						var/turf/location = src.target.loc
						if (istype(location, /turf/simulated))
							location.add_blood(src.target)
					if (src.wear_mask)
						src.wear_mask.add_blood(src.target)
					if (src.head)
						src.head.add_blood(src.target)
					if (src.glasses && prob(33))
						src.glasses.add_blood(src.target)
					if (src.gloves)
						src.gloves.add_blood(src.target)
					if (prob(15))
						if (src.wear_suit)
							src.wear_suit.add_blood(src.target)
						else if (src.w_uniform)
							src.w_uniform.add_blood(src.target)
			else
				state = NPC_STATE_IDLE
				return

//Zombies!

/datum/disease/z_virus
	name = "T-Virus"
	max_stages = 5
	spread = "Contact"
	cure = "???"
	spread_type = SPECIAL
	cure_id = "zed"
	affected_species = list("Human", "Human/Zombie")

/datum/disease/z_virus/stage_act()
	..()

	if(istype(affected_mob, /mob/living/carbon/human/npc/zombie)) //Possible fix to prevent processing of stage effects (specifically stage 5) after mob has zombified.
		if(!src.carrier)
			src.carrier = 1
		return
	/*if(istype(affected_mob, /mob/living/carbon/human/npc/zombie) && !src.carrier)
		src.carrier = 1
		return
	*/
/*	switch(stage)
		if(1)
			if (prob(8))
				affected_mob << pick("\red Something about you doesnt feel right.","\red Your head starts to itch.")
		if(2)
			if (prob(8))
				affected_mob << "\red Your limbs feel numb."
				affected_mob.bruteloss += 1
				affected_mob.updatehealth()
			if (prob(9))
				affected_mob << "\red You feel ill..."
			if (prob(9))
				affected_mob << "\red You feel a pain in your stomache..."
		if(3)
			if (prob(8))
				affected_mob << text("\red []", pick("owww...","I want...","Please..."))
				affected_mob.bruteloss += 1
				affected_mob.updatehealth()
			if (prob(10))
				affected_mob << "\red You feel very ill."
				affected_mob.bruteloss += 5
				affected_mob.updatehealth()
			if (prob(4))
				affected_mob << "\red You feel a stabbing pain in your head."
				affected_mob.paralysis += 2
			if (prob(4))
				affected_mob << "\red Whats going to happen to me?"
		if(4)
			if (prob(10))
				affected_mob << pick("\red You feel violently sick.")
				affected_mob.bruteloss += 8
				affected_mob.updatehealth()
			if (prob(20))
				affected_mob.say(pick("Mmmmm.", "Hey... You look...", "Hsssshhhhh!"))
			if (prob(8))
				affected_mob << "\red You cant... feel..."
		if(5)
			affected_mob.toxloss += 10
			affected_mob.updatehealth()
			affected_mob << "You feel the life slowly slip away from you as you join the army of the undead.."
			affected_mob:Zombify()
*/
	switch(stage)
		if(1)
			if(prob(1))
				affected_mob << pick("\red Something about you doesnt feel right.","\red Your head starts to itch.")
		if(2)
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				affected_mob << "\red Your muscles ache."
			if(prob(20))
				affected_mob.take_organ_damage(1)
			if(prob(1))
				affected_mob << "\red Your limbs feel numb."
				affected_mob.bruteloss += 1
				affected_mob.updatehealth()
			if(prob(1))
				affected_mob << "\red You feel ill..."
			if(prob(1))
				affected_mob << "\red You feel a pain in your stomache..."
		if(3)
			if(prob(2))
				affected_mob.emote("sneeze")
			if(prob(2))
				affected_mob.emote("cough")
			if(prob(1))
				affected_mob << "\red Your muscles ache."
			if(prob(20))
				affected_mob.take_organ_damage(1)
			if(prob(1))
				affected_mob << text("\red []", pick("owww...","I want...","Please..."))
				affected_mob.bruteloss += 1
				affected_mob.updatehealth()
			if(prob(1))
				affected_mob << "\red You feel very ill."
				affected_mob.bruteloss += 5
				affected_mob.updatehealth()
			if (prob(1))
				affected_mob << "\red You feel a stabbing pain in your head."
				affected_mob.paralysis += 2
			if (prob(1))
				affected_mob << "\red Whats going to happen to me?"
		if(4)
			if(prob(3))
				affected_mob.emote("sneeze")
			if(prob(3))
				affected_mob.emote("cough")
			if(prob(1))
				affected_mob << "\red Your muscles ache."
			if(prob(20))
				affected_mob.take_organ_damage(1)
			if(prob(3))
				affected_mob << pick("\red You feel violently sick.")
				affected_mob.bruteloss += 8
				affected_mob.updatehealth()
			if (prob(3))
				affected_mob.say(pick("Mmmmm.", "Hey... You look...", "Hsssshhhhh!"))
			if (prob(3))
				affected_mob << "\red You cant... feel..."
		if(5)
			affected_mob.toxloss += 10
			affected_mob.updatehealth()
			affected_mob:Zombify()


/mob/living/carbon/human/proc/Zombify()
	src.update_icons()
	var/mob/living/carbon/human/npc/zombie/Z = new/mob/living/carbon/human/npc/zombie(src.loc)
	//Yay, Zombie!
	Z.name = name
	Z.hair_color = hair_color
	Z.hair_style = hair_style
	Z.facial_hair_color = facial_hair_color
	Z.facial_hair_style = facial_hair_style
	Z.eye_color = eye_color
	Z.skin_tone = skin_tone
	Z.dna.mutantrace = dna.mutantrace
	Z.age = age

	Z.real_name = real_name

	Z.wear_mask = wear_mask
	Z.l_hand = l_hand
	Z.r_hand = r_hand
	Z.wear_suit = wear_suit
	Z.w_uniform = w_uniform
//	Z.w_radio = null
	Z.shoes = shoes
	Z.belt = belt
	Z.gloves = gloves
	Z.glasses = glasses
	Z.head = head
	Z.ears = ears
	Z.wear_id = wear_id
	Z.r_store = r_store
	Z.l_store = l_store
	Z.back = back

	Z.update_icons()
	Z.update_body()
	Z.update_hair()
	Z.loc = src.loc

	for(var/mob/living/simple_animal/borer/B in contents)
		B.detach()
		B.host = Z
		B.attach()
		B << "<span class='warning'>You notice that your host's brain activity has almost completely stopped, but an unnatural hunger keeps the body moving.</span>"

	src << "You feel the life slowly slip away from you as you join the army of the undead.."

	for(var/obj/O in contents)
		Z.contents += O
		O.loc = Z

	Z.base_icon_state = base_icon_state
//	Z.lying_icon = lying_icon

//	Z.last_b_state = last_b_state

//	Z.face_standing = face_standing
//	Z.face_lying = face_lying

//	Z.hair_icon_state = hair_icon_state
//	Z.face_icon_state = face_icon_state

//	Z.damageicon_standing = damageicon_standing
//	Z.damageicon_lying = damageicon_lying

	src.ghostize()
	qdel(src)
	return

/obj/item/weapon/reagent_containers/glass/bottle/t_virus
	name = "Z-Virus culture bottle"
	desc = "A small bottle. Contains Z-Virus virion in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	amount_per_transfer_from_this = 5

	New()
		var/datum/reagents/R = new/datum/reagents(20)
		reagents = R
		R.my_atom = src
		var/datum/disease/F = new /datum/disease/z_virus(0)
		var/list/data = list("viruses"= list(F))
		R.add_reagent("blood", 20, data)

///////////////////////////CURE//////////////////////////////////////////

datum/reagent/zed
	name = "Zombie Elixer"
	id = "zed"
	description = "For treating the Z-Virus."
//	reagent_state = LIQUID

	on_mob_life(var/mob/M)//no more mr. panacea
		holder.remove_reagent(src.id, 0.2)
		return



/obj/item/weapon/zedpen
	desc = "Small non-refillable auto-injector for curing the Z-Virus in early stages."
	name = "Z.E.D. Pen."
	icon = 'icons/obj/items.dmi'
	icon_state = "zed_1"
//	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = 1.0
	throw_speed = 7
	throw_range = 15
	m_amt = 60

/obj/item/weapon/zedpen/attack_paw(mob/user as mob)
	return src.attack_hand(user)
	return

/obj/item/weapon/zedpen/New()
	var/datum/reagents/R = new/datum/reagents(10)
	reagents = R
	R.my_atom = src
	R.add_reagent("zed", 10)
	..()
	return

/obj/item/weapon/zedpen/attack(mob/M as mob, mob/user as mob)
	if (!( istype(M, /mob) ))
		return
	if(istype(M, /mob/living/carbon/human/npc/zombie))
		return
	if (reagents.total_volume)
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\blue [] has been stabbed with [] by [].", M, src, user), 1)
//		user << "\red You stab [M] with the pen."
//		M << "\red You feel a tiny prick!"
		if(M.reagents) reagents.trans_to(M, 10)
		icon_state = "zed_0"
	return




/obj/item/weapon/storage/firstaid/zed
	name = "Zed-Kit"
	icon_state = "antitoxfirstaid"
	item_state = "firstaid-toxin"

/obj/item/weapon/storage/firstaid/zed/New()

	..()
	new /obj/item/weapon/zedpen( src )
	new /obj/item/weapon/zedpen( src )
	new /obj/item/weapon/zedpen( src )
	new /obj/item/weapon/zedpen( src )
	new /obj/item/weapon/zedpen( src )
	new /obj/item/weapon/zedpen( src )
	new /obj/item/device/healthanalyzer( src )
	return


////////////////////////////////////////////event code/////////////////////////////////////////

/obj/effect/landmark/holiday
	name = "landmark"

/client/proc/zombie_verb()
	set category = "Fun" //Changed to Fun because why do we need an entire category for one verb? ~Drache
	set name = "Spawn Zombies"
	zombie_event(1)

/client/proc/zombie_event(playercalled)

	var/SpawnNum
	var/SpawnChoice = "Full Event"

	if(playercalled == 1) // Set when an admin uses the spawn verb, triggers the input form.
		SpawnChoice = input("Spawn Zombies:", "Zombie Spawning", "Zombie Spawn") in list("At Current Location","At Spawn Point","Full Event")
		SpawnNum = 1

	if(SpawnChoice == "Full Event")
		SpawnNum = rand(5,30)
		if(playercalled)
			if(alert("Warning: This will cause zombies to spawn all over the station. Continue?","Continue?","Yes","No") == "No")
				return 0
			var/choice = input("Input number of zombies. 0 is random.") as num
			if(choice)
				SpawnNum = choice
			message_admins("[key_name_admin(usr)] has trigged a zombie event and spawned [SpawnNum] zombies", 1)

	var/list/spawns = list()

	if(SpawnChoice == "At Spawn Point" || SpawnChoice == "Full Event")
		for(var/obj/effect/landmark/holiday/O in world)
			spawns += O
		if(!spawns.len)
			message_admins("Error: No spawns points exist. Aborting zombie spawn.",1)
			return

	for(var/i=0,i<SpawnNum,i++) // Loops to determine zombie numver

		var/mob/living/carbon/human/npc/zombie/Z
		var/obj/effect/landmark/s
		if(SpawnChoice == "At Current Location")
			s = mob
		else
			s = pick(spawns)

		Z = new/mob/living/carbon/human/npc/zombie(s.loc)

		var/datum/preferences/A = new()//Randomize appearance for the zombie.
		A.copy_to(Z)
		ready_dna(Z)

		Z.gender = pick(MALE, FEMALE)


		if(Z.gender == MALE)
			Z.real_name = text("[] []", pick(first_names_male), pick(last_names))
		else
			Z.real_name = text("[] []", pick(first_names_female), pick(last_names))
		ready_dna(Z)
		var/a = pick("Janitor", "Medical Doctor", "Assistant", "Atmospheric Technician", "Security Officer", "Botanist", "Cargo Technician")
		job_master.EquipRank(Z, a, 0)