#define FIREDOME_IDLE 		0
#define FIREDOME_SETUP 		1
#define FIREDOME_RUNNING 	2

var/datum/controller/firedome/firedome = new()

/datum/controller/firedome
	var/list/modes = list()
	var/datum/firedome_mode/active_mode = null
	var/list/candidates = list()
	var/status = FIREDOME_IDLE
	var/list/mind_storage = list()
	var/mob/living/carbon/human/firemaster = null

//Initial controller setup.
/datum/controller/firedome/New()
	//There can be only one firedome manager. Out with the old and in with the new.
	if(firedome != src)
		if(istype(firedome))
			del(firedome)
		firedome = src

	if(!modes.len)
		init_subtypes(/datum/firedome_mode, modes)

/datum/controller/firedome/proc/process()
	if(status == FIREDOME_IDLE)
		return
	if(status == FIREDOME_SETUP)
		return
	if(status == FIREDOME_RUNNING)
		if(!active_mode)
			reset()
			message_ghosts("Firedome has been reset due to a error")
			return
		active_mode.process()

/datum/controller/firedome/proc/pre_setup(var/datum/firedome_mode/mode)
	status = FIREDOME_SETUP
	active_mode = mode
	reset_arena()
	active_mode.setup()
	firemaster = new()
	firemaster.loc = pick(fdomemaster)
	firemaster.real_name = "McStarter"
	firemaster.name = firemaster.real_name
	firemaster.hair_style = "Short Hair"
	firemaster.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(firemaster), slot_shoes)
	firemaster.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(firemaster), slot_wear_suit)
	firemaster.equip_to_slot_or_del(new /obj/item/clothing/under/rank/bartender(firemaster), slot_w_uniform)
	firemaster.faction = "ignoreme"

/datum/controller/firedome/proc/message_ghosts(var/msg)
	msg = "<span class='game deadsay'><span class='prefix'>FIREDOME: </span>[msg]</span>"
	for (var/mob/dead/observer/M in player_list)
		M.show_message(msg, 2)

/datum/controller/firedome/proc/fmaster_speak(var/msg)
	if(!active_mode) return
	if(!firemaster) return
	var/radio_msg = "<B><span class='radio'>[firemaster.name] \[#FIRE\]</B> </span><span class='radio'>says \"[msg]\"</span>"
	for (var/client/C in candidates)
		C.mob.show_message(radio_msg, 2)


/datum/controller/firedome/proc/reset()
	status = FIREDOME_IDLE
	restore_players()
	mind_storage = list()
	candidates = list()
	if(active_mode)
		active_mode.reset()
	active_mode = null
	qdel(firemaster)
	reset_arena()

/datum/controller/firedome/proc/reset_arena()
	var/area/fdome = locate(/area/fdome/arena)
	for(var/mob/living/mob in fdome)
		qdel(mob) //Clear mobs
	for(var/obj/obj in fdome)
		if(istype(obj,/obj/machinery/camera))
			continue
		if(istype(obj,/obj/effect/landmark/))
			continue
		qdel(obj) //Clear objects

	var/area/template = locate(/area/fdome/source)
	template.copy_contents_to(fdome)

/datum/controller/firedome/proc/restore_players()
	for(var/client/C in candidates)
		for(var/X in mind_storage)
			if(X == C.ckey)
				C.mob.mind = mind_storage[C.ckey]
				C.mob.ghostize(1)
				return
		if(C.mob.mind.assigned_role == "FIREDOME")
			C.mob.mind.assigned_role = null


//Modes
/datum/firedome_mode/
	var/name = "Invalid"
	var/team = 0
	var/pve = 0
	var/rules = ""
	var/min_players = 0
	var/max_players = 10
	var/list/weapons = list()
	var/list/equipment = list(/obj/item/clothing/under/color/grey,/obj/item/clothing/shoes/sneakers/black)
	var/list/team1equipment = list(/obj/item/clothing/under/color/green,/obj/item/clothing/shoes/sneakers/black)
	var/list/team2equipment = list(/obj/item/clothing/under/color/red,/obj/item/clothing/shoes/sneakers/black)
	var/list/enemies = list()

	var/list/team1 = list()
	var/list/team2 = list()
	var/list/players = list()

	proc/process()
		if(pve)
			var/player_count = 0
			var/enemy_count = 0
			for(var/mob/M in team2)
				if(!M.stat)
					enemy_count++
			for(var/client/C in team1)
				if(!C.mob.stat)
					player_count++
			if(!enemy_count)
				firedome.reset()
				firedome.message_ghosts("\"[name]\" ended with Human Victory")
			if(!player_count)
				firedome.reset()
				firedome.message_ghosts("\"[name]\" ended with Human Defeat")
			return
		if(team)
			var/team1_count = 0
			var/team2_count = 0
			for(var/client/C in team2)
				if(!C.mob.stat)
					team2_count++
			for(var/client/C in team1)
				if(!C.mob.stat)
					team1_count++
			if(!team2_count)
				var/list/winners = list()
				for(var/client/C in team1)
					var/mob/living/carbon/human/H = C.mob
					winners.Add(H.mind.name)
				firedome.reset()
				firedome.message_ghosts("\"[name]\" ended with Team 1 Victory ([jointext(winners,", ")])")
			if(!team1_count)
				var/list/winners = list()
				for(var/client/C in team2)
					var/mob/living/carbon/human/H = C.mob
					winners.Add(H.mind.name)
				firedome.reset()
				firedome.message_ghosts("\"[name]\" ended with Team 2 Victory ([jointext(winners,", ")])")
			return
		if(!team)
			var/player_count = 0
			for(var/client/C in players)
				if(!C.mob.stat)
					player_count++
			if(player_count <= 1)
				var/winner = "No one"
				for(var/client/C in players)
					if(!C.mob.stat)
						var/mob/living/carbon/human/H = C.mob
						winner = H.mind.name
				firedome.reset()
				firedome.message_ghosts("\"[name]\" ended with [winner] as the winner!")
			return

	proc/setup()
		firedome.message_ghosts("\"[name]\" will start in 1 minute, sign up in the OOC tab")
		spawn(600) // 1 minute later
			if(firedome.candidates.len < min_players)
				firedome.message_ghosts("Not enough players to start \"[name]\" reseting firedome")
				firedome.reset()
				return
			gather_combatants()
			decide_teams()
			spawn_enemies()
			spawn_items()
			start()
			firedome.message_ghosts("\"[name]\" is starting now in the firedome")


	proc/gather_combatants()
		for(var/client/C in firedome.candidates)
			if(istype(C.mob,/mob/dead/observer/))
				var/mob/dead/observer/ghost = C.mob
				var/saved_name = ghost.name
				var/mob/living/carbon/human/H = new(pick(fdome))
				H.skin_tone = "albino"
				players.Add(C)
				if(ghost.mind && ghost.can_reenter_corpse)
					firedome.mind_storage[C.ckey] = ghost.mind
				C.mob = H
				H.ckey = C.ckey
				H.real_name = "Mr. " + pick(last_names)
				H.name = H.real_name
				if(H.mind)
					H.mind.assigned_role = "FIREDOME"
					H.mind.name = saved_name
			else
				firedome.candidates.Remove(C)

	proc/spawn_equipment(var/point,var/team=0)
		switch(team)
			if(1)
				for(var/X in team1equipment)
					var/obj/O = new X
					O.loc = point
			if(2)
				for(var/X in team2equipment)
					var/obj/O = new X
					O.loc = point
			if(0)
				for(var/X in equipment)
					var/obj/O = new X
					O.loc = point

	proc/decide_teams()
		if(pve)
			for(var/client/C in firedome.candidates)
				if(istype(C.mob,/mob/living/carbon/human/))
					var/mob/living/carbon/human/H = C.mob
					team1.Add(C)
					H.loc = pick(fdome1)
					spawn_equipment(H.loc)
					for(var/obj/item/I in H.loc)
						H.equip_to_appropriate_slot(I)
			return
		if(team)
			//Gather Teams
			var/teamsplit = round(firedome.candidates.len / 2)
			for(var/client/C in firedome.candidates)
				if(team1.len >= teamsplit)
					break
				players.Remove(C)
				team1.Add(C)
			team2 = players
			//relocate the players
			for(var/client/C in team1)
				if(istype(C.mob,/mob/living/carbon/human/))
					C.mob.loc = pick(fdome1)
					var/mob/living/carbon/human/H = C.mob
					spawn_equipment(H.loc,1)
					for(var/obj/item/I in H.loc)
						H.equip_to_appropriate_slot(I)
			for(var/client/C in team2)
				if(istype(C.mob,/mob/living/carbon/human/))
					C.mob.loc = pick(fdome2)
					var/mob/living/carbon/human/H = C.mob
					spawn_equipment(H.loc,2)
					for(var/obj/item/I in H.loc)
						H.equip_to_appropriate_slot(I)
			return
		if(!pve && !team)
			for(var/client/C in firedome.candidates)
				if(istype(C.mob,/mob/living/carbon/human/))
					var/mob/living/carbon/human/H = C.mob
					H.loc = pick(fdome)
					spawn_equipment(H.loc)
					for(var/obj/item/I in H.loc)
						H.equip_to_appropriate_slot(I)
			return

	proc/spawn_enemies()
		if(!enemies.len)
			return
		var/player_count = team1.len + team2.len + players.len
		for(var/i=0, i<player_count, i++)
			var/picked = pick(enemies)
			var/mob/M = new picked
			if(team)
				M.loc = pick(fdome)
			if(!team)
				M.loc = pick(fdome)
			if(pve)
				M.loc = pick(fdome)
				team2.Add(M)

	proc/spawn_items()
		if(!weapons.len)
			return
		if(pve)
			for(var/i=0, i<team1.len, i++)
				var/picked = pick(weapons)
				var/obj/O = new picked
				O.loc = pick(fdome)
		else
			for(var/i=0, i<team1.len*2, i++)
				var/picked = pick(weapons)
				var/obj/O = new picked
				O.loc = pick(fdome1items)
			for(var/i=0, i<team2.len*2, i++)
				var/picked = pick(weapons)
				var/obj/O = new picked
				O.loc = pick(fdome2items)
			for(var/i=0, i<players.len*2, i++)
				var/picked = pick(weapons)
				var/obj/O = new picked
				O.loc = pick(fdome)

	proc/start()
		firedome.fmaster_speak("[name] will begin in 30 seconds, please hold your fire")
		for(var/client/C in firedome.candidates)
			if(istype(C.mob,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = C.mob
				H.Stun(30)
		spawn(50)
			firedome.fmaster_speak("The rules for [name] are as follows: [rules]")
		spawn(250)
			for(var/client/C in firedome.candidates)
				if(istype(C.mob,/mob/living/carbon/human))
					var/mob/living/carbon/human/H = C.mob
					H.revive()
			firedome.fmaster_speak("BEGIN!")
			firedome.status = FIREDOME_RUNNING
			if(team || pve)
				var/area/fdome = locate(/area/fdome/arena)
				for(var/obj/machinery/door/poddoor/M in fdome)
					if(M.id == "firedome")
						if(M.density)
							spawn(0)	M.open()
						else
							spawn(0)	M.close()
		return

	proc/reset()
		team1 = list()
		team2 = list()
		players = list()


/datum/firedome_mode/classic
	name = "Free For All"
	min_players = 2
	rules = "There can be only one!"
	equipment = list(/obj/item/clothing/suit/armor/vest,/obj/item/clothing/head/helmet,/obj/item/clothing/under/color/grey,/obj/item/clothing/shoes/sneakers/black)
	weapons = list(/obj/item/weapon/crowbar,/obj/item/weapon/extinguisher,/obj/item/weapon/bikehorn)

/datum/firedome_mode/boxing
	name = "Boxing"
	min_players = 2
	max_players = 10
	rules = "The only rule is no ear biting"
	equipment = list(/obj/item/clothing/under/shorts/black,/obj/item/clothing/shoes/sneakers/black,/obj/item/clothing/gloves/boxing)

/datum/firedome_mode/toolbox
	name = "Robust Challenge"
	min_players = 2
	rules = "Toolbox eachother until there is only 1 man standing"
	weapons = list(/obj/item/weapon/storage/toolbox)

/datum/firedome_mode/screwdriver
	name = "Screwdriver"
	min_players = 2
	rules = "Stab eachother in the eyes until they cant even see you stabbing them in the eyes"
	weapons = list(/obj/item/weapon/screwdriver)

/datum/firedome_mode/tdm
	name = "Team Deathmatch"
	min_players = 2
	team = 1
	rules = "Eliminate the other team using laser guns"
	team1equipment = list(/obj/item/clothing/suit/armor/vest,/obj/item/clothing/head/helmet,/obj/item/clothing/under/color/green,/obj/item/clothing/shoes/sneakers/black,/obj/item/weapon/gun/energy/laser/captain)
	team2equipment = list(/obj/item/clothing/suit/armor/vest,/obj/item/clothing/head/helmet,/obj/item/clothing/under/color/red,/obj/item/clothing/shoes/sneakers/black,/obj/item/weapon/gun/energy/laser/captain)

/datum/firedome_mode/dodgeball
	name = "Dodgeball"
	min_players = 2
	team = 1
	rules = "Hit eachother with dodgeballs, instant kill on contact. Use throw to catch the dodgeballs"
	weapons = list(/obj/item/weapon/beach_ball/holoball/dodgeball/deathball)

/datum/firedome_mode/carps
	name = "Spess Carp Madness"
	min_players = 1
	pve = 1
	max_players = 5
	rules = "Bork Bork, Kill all carps using your kitchen knife."
	equipment = list(/obj/item/clothing/under/rank/chef,/obj/item/clothing/suit/chef,/obj/item/clothing/shoes/sneakers/black,/obj/item/clothing/head/chefhat,/obj/item/weapon/kitchenknife)
	enemies = list(/mob/living/simple_animal/hostile/carp)

/mob/dead/observer/verb/join_firedome()
	set name = "Enter Firedome"
	set category = "OOC"
	if(!client)
		return
	if(!firedome || !ticker)
		return
	if(ticker.current_state != 3)
		src << "Cannot start the firedome at this time."
		return
	if(firedome.status == FIREDOME_IDLE)
		var/list/D = list()
		D["Cancel"] = "Cancel"
		for(var/datum/firedome_mode/M in firedome.modes)
			D["[M.name] (max players [M.max_players])"] = M
		var/t = input(usr, "Firedome Mode Select") as null|anything in D
		if(!t)
			return
		if(t == "Cancel")
			return
		if(firedome.status != FIREDOME_IDLE)
			return
		var/datum/firedome_mode/mode = D[t]
		firedome.pre_setup(mode)
	if(firedome.status == FIREDOME_SETUP)
		if(firedome.candidates.len >= firedome.active_mode.max_players)
			src << "The Firedome has reached full capacity (mode: [firedome.active_mode])"
			return
		for(var/client/C in firedome.candidates)
			if(C.ckey == ckey)
				return
		firedome.message_ghosts("[name] has signed up for the next firedome round")
		firedome.candidates.Add(src.client)
	if(firedome.status == FIREDOME_RUNNING)
		src << "The Firedome is currently in progress"
		return


#undef FIREDOME_IDLE
#undef FIREDOME_SETUP
#undef FIREDOME_RUNNING
