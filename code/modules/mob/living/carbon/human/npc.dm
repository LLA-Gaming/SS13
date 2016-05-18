/*
	NPCs
like humans only automated. expands upon the concept of simple_animal hostiles like russians. can be stunned, shoot guns. that sorta thing
*/

/mob/living/carbon/human/npc
	faction = "npc"
	a_intent = "harm"
	m_intent = "run"
	universal_speak = 1
	var/npc_name
	var/frustration = 0
	var/state = 0
	var/minimal_vision = 0 //non-zero to remove the eyes in the back of the head
	var/ranged = 0
	var/move_delay = 0
	var/mob/living/target = null
	var/mob/living/frustrated_at = null
	var/idlemove_chance = 45
	var/always_melee = 0 //for zombies
	var/can_slip = 1
	//lists
	var/list/path = list()
	//NPCs are left handed, keep this in mind when equiping them. they can still attack with their right hand but only if the left is empty
	//left being primary weapon and right being secondary
	var/primary_weapon = null //put the path to the weapon you want the npc to have here
	var/secondary_weapon = null //put the path to the secondary weapon you want the npc to have here.. this should be a riot shield or something.
	var/list/friendly_factions = list("npc")
	var/list/in_range = list()
	var/list/can_see = list()
	var/list/npc_say = list()
	var/retaliate = 0
	//custom stuff
	var/mutant_race
	var/custom_skintone
	var/custom_hair
	var/custom_facial_hair
	var/custom_haircolor
	//constants
	var/const/NPC_STATE_INACTIVE = 0
	var/const/NPC_STATE_IDLE = 1
	var/const/NPC_STATE_MOVING = 2
	var/const/NPC_STATE_MELEE = 4

/mob/living/carbon/human/npc/New()
	..()

	var/datum/preferences/A = new()//Randomize appearance for the npc
	A.copy_to(src)
	ready_dna(src)

	if(!npc_name)
		if(src.gender == MALE)
			src.real_name = text("[] []", pick(first_names_male), pick(last_names))
		else
			src.real_name = text("[] []", pick(first_names_female), pick(last_names))
	else
		src.real_name = npc_name

	dir = pick(NORTH,SOUTH,EAST,WEST)
	var/obj/item/I1
	var/obj/item/I2
	if(primary_weapon)
		I1 = new primary_weapon
	if(secondary_weapon)
		I2 = new secondary_weapon
	if(I1)
		equip_to_slot_or_del(I1, slot_l_hand)
	if(I2)
		equip_to_slot_or_del(I2, slot_r_hand)
	npc_list.Add(src)

/mob/living/carbon/human/npc/Destroy()
	npc_list.Remove(src)
	..()

/mob/living/carbon/human/npc/initialize()
	..()
	//name
	if(npc_name)
		real_name = npc_name
		name = npc_name
	//power suit?
	for(var/obj/item/clothing/suit/space/powersuit/P in get_turf(src))
		P.enter_suit(src)
		if(P.helmet)
			P.toggle_helmet()
		if(P.cell)
			P.power()
		break
	//under clothing second
	for(var/obj/item/clothing/under/U in get_turf(src))
		equip_to_appropriate_slot(U)
	//anything else
	for(var/obj/item/I in get_turf(src))
		equip_to_appropriate_slot(I)
	//underwear and mutant race
	if(mutant_race && dna)
		dna.mutantrace = mutant_race
	undershirt = "Nude"
	underwear = "Nude"
	socks = "Nude"
	//hairs and stuff
	if(custom_skintone)
		skin_tone = custom_skintone
	if(custom_hair)
		hair_style = custom_hair
	if(custom_facial_hair)
		facial_hair_style = custom_facial_hair
	if(custom_haircolor)
		hair_color = custom_haircolor
		facial_hair_color = custom_haircolor

/mob/living/carbon/human/npc/Life()
	..()
	if(!client && stat == CONSCIOUS)
		in_range = list()
		can_see = list()
		if(!client && stat == CONSCIOUS)
			//in_range
			for(var/mob/living/M in oviewers(src,18))
				if(M.stat != CONSCIOUS)
					continue
				if(!M.client)
					continue
				if(istype(M,/mob/living/carbon/human/npc))
					continue
				in_range.Add(M)
		nutrition = initial(nutrition)
		if(!in_range.len)
			return
		if(prob(3))
			if(npc_say.len)
				src.say(pick(npc_say))
		//idle_movement
		if(!target)
			if(prob(idlemove_chance) && canmove && isturf(loc) && !pulledby && !grabbed_by.len)
				if(prob(50))
					step(src, pick(cardinal))
				else
					dir = turn(dir,pick(90,-90))

/mob/living/carbon/human/npc/proc/targeting()
	can_see = list()
	if(!client && stat == CONSCIOUS)
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
				if ((!a.dynamic_lighting || t.get_lumcount() * 10 >= 0.50) || (istype(src.glasses, /obj/item/clothing/glasses/night) || istype(src.glasses, /obj/item/clothing/glasses/thermal)))
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

		for(var/mob/living/M in shuffle(can_see))
			if(target || retaliate)
				break
			if(M.faction == faction)
				continue
			if(M.stat)
				continue
			if(frustrated_at == M && M.lying) //only ignore the frustrated_at mob if its laying down
				continue
			target = M
			state = NPC_STATE_MOVING

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

/mob/living/carbon/human/npc/proc/process()
	targeting()
	if(state == NPC_STATE_MOVING)
		move_to()
	if(state == NPC_STATE_MELEE)
		attack_at()

/mob/living/carbon/human/npc/proc/move_to()
	if(!(locate(target) in hearers(src)))
		target = null
		return
	if(frustration >= 10)
		frustration = 0
		if(target)
			frustrated_at = target
		target = null
	if(target && target.stat)
		target = null
	if(!target)
		state = NPC_STATE_IDLE
		return
	if(lying || restrained())
		return 0
	var/distance = get_dist(src, target)
	if(distance <= 1 && !ranged)
		state = NPC_STATE_MELEE
		return 0
	else
		if(world.time > move_delay)
			/*
			for(var/turf/T in path)
				T.color = initial(T.color)
			*/
			path = AStar(get_turf(src), get_turf(target), /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 15, null, null)
			if(!path)
				path = list()
				target = null
				state = NPC_STATE_IDLE
				return
			/*
			for(var/turf/T in path)
				T.color = initial(T.color)
				T.color = "#FF0000"
			*/
			if(ranged)
				if(path && path.len >= 7)
					if(!step_towards(src, path[2]))
						frustration++
				else
					var/rand_dir = pick(NORTH,SOUTH,EAST,WEST)
					step(src,rand_dir)
			else
				if(path && path.len >= 2)
					if(!step_towards(src, path[2]))
						frustration++

			set_move_delay()
		//shoot guns
		if(next_move <= world.time && ranged)
			if(!target)
				return
			var/tturf = get_turf(target)
			if(prob(80))
				if(!buckled)
					//face the direction it is shooting
					if (src.loc.x > target.loc.x)
						dir = WEST

					if (src.loc.x < target.loc.x)
						dir = EAST

					if (src.loc.y < target.loc.y)
						dir = NORTH

					if (src.loc.y > target.loc.y)
						dir = SOUTH
				shoot_gun(tturf, src.loc, src)
				if(target.lying)
					frustration += 6
			changeNext_move(8)
	return 1

/mob/living/carbon/human/npc/proc/attack_at()
	if(!target || lying || restrained() || target.stat)
		target = null
		state = NPC_STATE_MOVING
		return
	var/distance = get_dist(src, target)
	if(distance > 1)
		state = NPC_STATE_MOVING
		return
	if(next_move <= world.time)
		//face the direction it is attacking
		if (src.loc.x > target.loc.x)
			dir = WEST

		if (src.loc.x < target.loc.x)
			dir = EAST

		if (src.loc.y < target.loc.y)
			dir = NORTH

		if (src.loc.y > target.loc.y)
			dir = SOUTH
		changeNext_move(8)
		if(src.l_hand)
			if(get_active_hand() != l_hand)
				src.hand = !( src.hand )
			if(istype(src.l_hand, /obj/item/weapon))
				var/obj/item/weapon/A = src.l_hand
				if(istype(A,/obj/item/weapon/gun) && !always_melee)
					var/obj/item/weapon/gun/G = A
					ranged = 1
					G.shoot_live_shot(src, 1, target)
					return
				if(!A.force)
					throw_item(src.target)
					return
				A.attack(src.target, src)
				return
		else if(src.r_hand)
			if(get_active_hand() != r_hand)
				src.hand = !( src.hand )
			if(istype(src.r_hand, /obj/item/weapon))
				var/obj/item/weapon/A = src.r_hand
				if(istype(A,/obj/item/weapon/gun) && !always_melee)
					var/obj/item/weapon/gun/G = A
					ranged = 1
					G.shoot_live_shot(src, 1, target)
					return
				if(!A.force)
					throw_item(src.target)
					return
				A.attack(src.target, src)
				return
		else
			UnarmedAttack(target, 1)
			return
	state = NPC_STATE_MOVING

/mob/living/carbon/human/npc/proc/shoot_gun(var/targ, var/start, var/user, var/bullet = 0)
	var/obj/item/weapon/gun/A
	if(src.l_hand)
		if(istype(src.l_hand, /obj/item/weapon/gun))
			A = src.l_hand
	else if(src.r_hand)
		if(istype(src.r_hand, /obj/item/weapon/gun))
			A = src.r_hand
	if(A)
		A.shoot_live_shot(src, 0, targ)
		if(istype(A,/obj/item/weapon/gun/energy))
			var/obj/item/weapon/gun/energy/E = A
			if(E.ammo_type && E.ammo_type.len)
				var/obj/item/projectile/BB
				var/obj/item/ammo_casing/shot = E.ammo_type[E.select]
				var/prj_type = shot.projectile_type
				var/turf/targloc = get_turf(targ)
				var/turf/curloc = get_turf(src)
				BB = new prj_type(src.loc)
				if(BB && targloc)
					BB.original = targ
					BB.firer = user
					BB.def_zone = ran_zone()
					if(targloc == curloc)
						target.bullet_act(BB)
						qdel(BB)
						return 1
					BB.loc = get_turf(user)
					BB.starting = get_turf(user)
					BB.current = curloc
					BB.yo = targloc.y - curloc.y
					BB.xo = targloc.x - curloc.x
					BB.process()
		else
			var/obj/item/weapon/gun/projectile/P = A
			if(P && P.chambered && P.chambered.BB)
				var/obj/item/projectile/BB
				var/turf/targloc = get_turf(targ)
				var/turf/curloc = get_turf(src)
				BB = new P.chambered.BB.type(src.loc)
				if(BB && targloc)
					BB.original = targ
					BB.firer = user
					BB.def_zone = ran_zone()
					if(targloc == curloc)
						target.bullet_act(BB)
						qdel(BB)
						return 1
					BB.loc = get_turf(user)
					BB.starting = get_turf(user)
					BB.current = curloc
					BB.yo = targloc.y - curloc.y
					BB.xo = targloc.x - curloc.x
					BB.process()


	else
		ranged = 0


/mob/living/carbon/human/npc/proc/set_move_delay(var/extra=0)
	move_delay = world.time//set move delay
	switch(m_intent)
		if("run")
			if(drowsyness > 0)
				move_delay += 6
			move_delay += config.run_speed
		if("walk")
			move_delay += 1
	move_delay += movement_delay()
	move_delay += extra

	if(config.Tickcomp)
		move_delay -= 1.3
		var/tickcomp = (1 / (world.tick_lag)) * 1.3
		move_delay = move_delay + tickcomp

/mob/living/carbon/human/npc/proc/breath_check()
	for(var/obj/item/weapon/tank/O in contents)
		if(O.air_contents && O.air_contents.gasses[OXYGEN])
			return 1
	return 0

/mob/living/carbon/human/npc/attackby(var/obj/item/O as obj, var/mob/user as mob)
	..()
	if(user)
		if(src.faction != user.faction)
			target = user

/mob/living/carbon/human/npc/attack_hand(mob/living/carbon/human/M as mob)
	..()
	if(M)
		if(M.a_intent == "help")
			return
		if(src.faction != M.faction)
			target = M

/mob/living/carbon/human/npc/bullet_act(var/obj/item/projectile/Proj)
	if(Proj && Proj.firer)
		if(src.faction == Proj.firer.faction)
			return
		else
			target = Proj.firer
	..()

/mob/living/carbon/human/npc/throw_item(atom/target)
	if(usr.stat || !target)
		return

	var/atom/movable/item = src.get_active_hand()

	if(!item || (item.flags & NODROP)) return

	if(istype(item, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = item
		item = G.toss() //throw the person instead of the grab
		qdel(G)			//We delete the grab, as it needs to stay around until it's returned.
		if(ismob(item))
			var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
			var/turf/end_T = get_turf(target)
			if(start_T && end_T)
				var/mob/M = item
				var/start_T_descriptor = "<font color='#6b5d00'>tile at [start_T.x], [start_T.y], [start_T.z] in area [get_area(start_T)]</font>"
				var/end_T_descriptor = "<font color='#6b4400'>tile at [end_T.x], [end_T.y], [end_T.z] in area [get_area(end_T)]</font>"

				add_logs(usr, M, "thrown", admin=0, addition="from [start_T_descriptor] with the target [end_T_descriptor]")

	if(!item) return //Grab processing has a chance of returning null

	if(!ismob(item)) //Honk mobs don't have a dropped() proc honk
		unEquip(item)
	//actually throw it!
	if(item)
		item.layer = initial(item.layer)
		src.visible_message("\red [src] has thrown [item].")

		if(!src.lastarea)
			src.lastarea = get_area(src.loc)
		if(!has_gravity(src))
			src.inertia_dir = get_dir(target, src)
			step(src, inertia_dir)


/*
		if(istype(src.loc, /turf/space) || (src.flags & NOGRAV)) //they're in space, move em one space in the opposite direction
			src.inertia_dir = get_dir(target, src)
			step(src, inertia_dir)
*/



		item.throw_at(target, item.throw_range, item.throw_speed)