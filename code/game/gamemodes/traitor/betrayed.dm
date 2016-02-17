/datum/game_mode/traitor/betrayed
	name = "betrayed"
	config_tag = "betrayed"
	restricted_jobs = list("Cyborg","AI","Perseus Security Enforcer","Perseus Security Commander") // Humans only / no percs
	antag_flag = BE_BETRAYED
	required_players = 4
	required_readies = 4 //there should be just as many readies as there is players or this wont be very fun
	traitor_name = "betrayed agent"

	uplink_uses = 3 // User gains TCs over time

	//betrayed vars
	var/checkwin_counter = 0
	var/finished = 0
	var/max_uplink_uses = 12
	var/reveal_time = 1950
	var/reveal_min = 1950 //3 minutes and 25 seconds
	var/reveal_max = 6000 //10 minutes
	var/revealed = 0
	var/locations_pinged = 0 //how many times the location was pinged
	//schedules
	var/pingagents_low = 3000 // 5 minutes
	var/pingagents_high = 6000 // 10 minutes
	var/tc_time = 1800 // 3 minutes
	var/tc_schedule = 0 //when to reward the agents with some TC
	var/ping_schedule = 0 //when to ping the location of the agents

/datum/game_mode/traitor/betrayed/process()
	if(!revealed) return
	if(tc_schedule <= world.time)
		tc_schedule = world.time + tc_time // 3 minutes
		give_tc()
	if(ping_schedule <= world.time)
		ping_schedule = world.time + rand(pingagents_low,pingagents_high) // 5 minute to 10 minutes
		ping_agents()
	checkwin_counter++
	if(checkwin_counter >= 5)
		if(!finished)
			ticker.mode.check_win()
		checkwin_counter = 0
	return 0

/datum/game_mode/traitor/betrayed/check_win()
	for(var/datum/mind/M in traitors)
		if(M.current && istype(M.current,/mob/living/carbon/human/) && M.current.stat != DEAD)
			//if there is a single traitor alive return 0
			return 0
	finished = 1
	return 1

/datum/game_mode/traitor/betrayed/check_finished()
	if(config.continuous_round_betrayed)
		return ..()
	if(finished != 0)
		return 1
	else
		return ..()

/datum/game_mode/traitor/betrayed/proc/ping_agents()
	var/location_data = ""
	for(var/datum/mind/M in traitors)
		if(M.special_role != "betrayed agent") continue
		if(M.current && istype(M.current,/mob/living/carbon/human/) && M.current.stat != DEAD)
			var/area/A = get_area(M.current)
			var/Atext = format_text(A)
			var/turf/t = get_turf(M.current)
			location_data += "<br> [M.name] ([t.x],[t.y],[t.z]) [Atext ? "(Atext)" : ""]"
	if(!location_data) return
	priority_announce("Location data for the undercover agents has been downloaded and printed out at all communications consoles.", "Undercover Agent Report");
	locations_pinged++
	for (var/obj/machinery/computer/communications/C in machines)
		if(! (C.stat & (BROKEN|NOPOWER) ) )
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( C.loc )
			P.name = "paper- 'Undercover Agent Report (#[locations_pinged])'"
			P.info = location_data
			C.messagetitle.Add("Undercover Agent Report (#[locations_pinged])")
			C.messagetext.Add(P.info)


/datum/game_mode/traitor/betrayed/proc/give_tc()
	for(var/datum/mind/M in traitors)
		if(M.special_role == "betrayed agent")
			if(M.current && istype(M.current,/mob/living/carbon/human/) && M.current.stat != DEAD)
				var/obj/item/device/uplink/hidden/H = M.find_syndicate_uplink()
				if(H)
					if(H.uses < max_uplink_uses)
						H.uses = Clamp(H.uses+2,0,max_uplink_uses)
						max_uplink_uses -= 2
						M.current << "<B>Your hidden uplink has been supplied additional points</B>"



/datum/game_mode/traitor/betrayed/announce()
	world << "<B>The current game mode is - Betrayed!</B>"
	world << "<B>A Syndicate informant has whistleblown to NanoTrasen, the agents boarded on station will be revealed shortly!</B>"

/datum/game_mode/traitor/betrayed/greet_traitor(var/datum/mind/traitor)
	traitor.current << "<B><font size=3 color=red>You are the [traitor_name].</font></B>"
	traitor.current << "<P><B>You are one of the Syndicate's best agents, but a double agent has betrayed you to Nanotrasen. It is only a matter of time until your presence is alerted to the station. Centcomm may attempt to periodically update the crew on your location while you are alive. Survive the shift so that you can find a better employer. The syndicate can only send some telecrystals at a time, but will try to make it up to you by sending more over time. You have until you are betrayed.</B></P>"
	traitor.current << "<U><B>Time until betrayal: [round(reveal_time / 600)] minutes</B></U>"
	var/obj_count = 1
	for(var/datum/objective/objective in traitor.objectives)
		traitor.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++
	return

/datum/game_mode/traitor/betrayed/pre_setup()
	//gather player count
	var/readies  = 0 // readies
	for(var/mob/new_player/player in player_list)
		if((player.ready))
			readies++
	while(readies > 0)
		readies -= 10
		if(readies >= 0)
			reveal_time += 1950 //add 3.25 minutes
	//set the time
	reveal_time = Clamp(reveal_time,reveal_min,reveal_max)
	if(..())
		return 1
	else
		return 0

/datum/game_mode/traitor/betrayed/post_setup()
	..()
	spawn(reveal_time)
		ping_schedule = world.time + rand(pingagents_low,pingagents_high) // 5 minute to 10 minutes
		tc_schedule = world.time + tc_time // 3 minutes
		revealed = 1
		var/revealtxt = "Nanotrasen has been informed of syndicate agents disguised as crew by a anonymous informant.\n"
		for(var/datum/mind/M in traitors)
			if(M.special_role != "betrayed agent") continue
			revealtxt += "\n [M.name], the [M.assigned_role]"
		priority_announce(revealtxt, "Revealed Undercover Agents");
	return 1

/datum/game_mode/traitor/betrayed/make_antag_chance(var/mob/living/carbon/human/character)
	//no latejoins
	return

/datum/game_mode/traitor/betrayed/forge_traitor_objectives(var/datum/mind/traitor)
	//kill
	var/datum/objective/assassinate/kill_objective = new
	kill_objective.owner = traitor
	kill_objective.find_target()
	traitor.objectives += kill_objective
	//steal
	var/datum/objective/steal/steal_objective = new
	steal_objective.owner = traitor
	steal_objective.find_target()
	traitor.objectives += steal_objective
	//survive
	var/datum/objective/survive/survive_objective = new
	survive_objective.owner = traitor
	traitor.objectives += survive_objective