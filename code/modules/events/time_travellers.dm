/datum/round_event_control/time_travellers
	name = "Time Travellers"
	typepath = /datum/round_event/time_travellers
	max_occurrences = 1
	candidate_flag = BE_TIMEAGENT
	candidates_needed = 2

/datum/round_event/time_travellers
	alert_when	= 50
	end_when = -1

	var/area/arrival_point_A
	var/area/arrival_point_B

	var/datum/mind/mother
	var/datum/mind/father
	var/datum/mind/time_traveller

	var/datum/objective/objective


	var/spawncount = 2		//1 antag, 1 protag
	var/successSpawn = 0
	var/mission_complete = 0

	Tick()
		if(IsMultiple(active_for, 4))
			if((mother.current) && (mother.current.stat == DEAD || issilicon(mother.current) || isbrain(mother.current) || mother.current.z > MAX_Z_LEVELS))
				mission_complete = 1
			if((father.current) && (father.current.stat == DEAD || issilicon(father.current) || isbrain(father.current) || father.current.z > MAX_Z_LEVELS))
				mission_complete = 1

			if(mission_complete)
				if(time_traveller.current)
					var/mob/living/L = time_traveller.current
					L.visible_message("<span class='danger'>[L] fizzles away!</span>")
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(4, 2, get_turf(L))
					s.start()
					objective.completed = 1
					qdel(L)
					AbruptEnd()
	End()
		if(mission_complete)
			OnFail()

	OnFail()
		if (!prevent_stories) EventStory("The Time Agent managed to complete their assasination mission. The timeline as we know it was altered.")

	Alert()
		priority_announce("An electrical storm has been detected in your area, please repair potential electronic overloads.", "Electrical Storm Alert")

	Setup()
		arrival_point_A = FindEventAreaNearPeople()
		arrival_point_B = FindEventAreaAwayFromPeople()

		var/list/possible_targets = list()
		for(var/datum/mind/possible_target in ticker.minds)
			if(!possible_target.is_crewmember())
				continue
			if(ishuman(possible_target.current) && (possible_target.current.stat != 2))
				possible_targets += possible_target
		if(possible_targets.len)
			mother = pick_n_take(possible_targets)
			father = pick_n_take(possible_targets)

		var/list/turf_testA = get_area_turfs(arrival_point_A)
		var/list/turf_testB = get_area_turfs(arrival_point_B)
		if(!turf_testA.len)
			arrival_point_A = null
		if(!turf_testB.len)
			arrival_point_B = null

		if(!arrival_point_A || !arrival_point_B || !mother || !father)
			CancelSelf()
			return


	Start()
		//Once we have 2 candidates then we start picking em
		var/client/hero = pick_n_take(candidates)
		var/client/villian = pick_n_take(candidates)

		//Prepare our hero
		var/turf/spawn_point_A = safepick(get_area_turfs(arrival_point_A))
		var/obj/structure/closet/time_machine/timemachineA = new(spawn_point_A)
		var/mob/living/carbon/human/hero_mob = new(timemachineA)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(4, 2, spawn_point_A)
		s.start()
		var/datum/effect/effect/system/harmless_smoke_spread/spread = new()
		spread.set_up(5, 0, spawn_point_A, 0)
		spread.start()
		hero_mob.key = hero.key
		suit_up(hero_mob)

		//Prepare our Villian
		var/turf/spawn_point_B = safepick(get_area_turfs(arrival_point_B))
		var/obj/structure/closet/time_machine/timemachineB = new(spawn_point_B)
		var/mob/living/carbon/human/villian_mob = new(timemachineB)
		var/datum/effect/effect/system/spark_spread/s2 = new /datum/effect/effect/system/spark_spread
		s2.set_up(4, 2, spawn_point_B)
		s2.start()
		var/datum/effect/effect/system/harmless_smoke_spread/spread2 = new()
		spread2.set_up(5, 0, spawn_point_B, 0)
		spread2.start()
		villian_mob.key = villian.key
		suit_up(villian_mob,1)

		//Blow the lights
		var/obj/machinery/power/apc/APC_A = arrival_point_A.get_apc()
		var/obj/machinery/power/apc/APC_B = arrival_point_B.get_apc()
		if(APC_A) APC_A.overload_lighting()
		if(APC_B) APC_B.overload_lighting()


		successSpawn = 1
		if (!prevent_stories) EventStory("In a flash of light, Time Agent [villian_mob.real_name] appeared with an assassination mission. To prevent the very birth of their long time enemy, [hero_mob.real_name].")

/datum/round_event/time_travellers/proc/suit_up(var/mob/living/carbon/human/H,var/antag=0)
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

	//Equip em
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/white(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/labcoat(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/glass/beaker/bluespace(H), slot_s_store)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/holding, slot_back,1)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(H), slot_glasses)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), slot_ears)

	//Objectives and description text
	var/datum/mind/Mind = H.mind
	if(antag)
		Mind.assigned_role = "MODE"
		Mind.special_role = "Time Agent"
		ticker.mode.traitors |= Mind			//Adds them to current traitor list. Which is really the extra antagonist list.
		antag = 1
		objective = new
		objective.owner = Mind
		objective.explanation_text = "Assassinate [mother.name] or [father.name] to prevent [time_traveller.name] from being born"
		Mind.objectives += objective


		var/datum/objective/survive/survive_objective = new
		survive_objective.owner = Mind
		Mind.objectives += survive_objective

		Mind.current << "<B><font size=3 color=red>You are the Time Agent.</font></B>"
		Mind.current << "You have arrived approximately at [worldtime2text()] on [time2text(world.realtime, "MMM DD")], [year_integer+540]."
		Mind.current << "You were tasked with preventing [time_traveller.name] from being born!"
		Mind.current << "Simply killing them will not do. They have connections in high places and DNA secured safely to clone another"
		Mind.current << "This was the only way... good luck"
		Mind.current << "Use your time machine (disguised as a green closet) to get around the station! ((Alt click to activate))"
		var/obj_count = 1
		for(var/datum/objective/objective in Mind.objectives)
			Mind.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
			obj_count++
	else
		time_traveller = Mind
		Mind.assigned_role = "SPECIAL"
		Mind.current << "<B><font size=3 color=blue>You are the Time Traveller.</font></B>"
		Mind.current << "You have arrived approximately at [worldtime2text()] on [time2text(world.realtime, "MMM DD")], [year_integer+540]."
		Mind.current << "The Syndicate is trying to prevent your birth. You must prevent this!"
		Mind.current << "You descended from [mother.name], the [mother.assigned_role] as well as [father.name], [father.assigned_role]"
		Mind.current << "If either die you will cease to exist."
		Mind.current << "Use your time machine (disguised as a green closet) to get around the station! ((Alt click to activate))"



////Time Traveller Gear

/obj/structure/closet/time_machine
	name = "strange green closet"
	desc = "never seen something like that before."
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"
	anchored = 0
	var/teleporting = 0

/obj/structure/closet/time_machine/AltClick(var/mob/user)
	if(user.loc != src)
		return
	if(user.stat || user.restrained())
		return
	var/A

	A = input(user, "Area to teleport to", "Teleporting", A) in teleportlocs
	var/area/thearea = teleportlocs[A]

	if (!user || user.stat || user.restrained())
		return
	if(user.loc != src)
		return

	if(teleporting)
		return
	user << "Teleporting in 30 seconds, please remain seated inside the machine..."
	teleporting = 1
	spawn(300)
		if(user.loc != src) //abort if they got out
			teleporting = 0
			return
		var/datum/effect/effect/system/harmless_smoke_spread/smoke = new /datum/effect/effect/system/harmless_smoke_spread()
		smoke.set_up(5, 0, src.loc)
		smoke.attach(src)
		smoke.start()
		var/list/L = list()
		for(var/turf/T in get_area_turfs(thearea.type))
			if(!T.density)
				var/clear = 1
				for(var/obj/O in T)
					if(O.density)
						clear = 0
						break
				if(clear)
					L+=T

		if(!L.len)
			user <<"The time machine was unable to locate a suitable teleport destination for an unknown reason. Sorry."
			return

		var/list/tempL = L
		var/attempt = null
		var/success = 0
		while(tempL.len)
			attempt = pick(tempL)
			success = src.Move(attempt)
			if(!success)
				tempL.Remove(attempt)
			else
				break

		if(!success)
			src.loc = pick(L)

		smoke.start()
		teleporting = 0
		playsound(get_turf(src), 'sound/effects/phasein.ogg', 100)
		visible_message("<span class='danger'>[src] warps in!</span>")