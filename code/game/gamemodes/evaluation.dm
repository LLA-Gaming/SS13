/datum/controller/gameticker/proc/evaluate_station()
	var/dat = ""

	//Round statistics report
	end_state = new /datum/station_state()
	end_state.count()
	var/station_integrity = round( 100.0 *  start_state.score(end_state), 0.1)
	var/disk_rescued = 1
	for(var/obj/item/weapon/disk/nuclear/D in world)
		var/disk_area = get_area(D)
		if(!is_type_in_list(disk_area, centcom_areas))
			disk_rescued = 0
			break

	//Event timeline
	dat += "<table>"
	dat += "<tr><td valign='top' width='60%'>"
	dat += "<h3>Round Timeline</h3>"
	if(ticker && ticker.intel)
		for(var/X in ticker.timeline)
			dat += "[X]<BR>"
	dat += "</td>"
	//Assignments
	dat += "<td valign='top' width='40%'>"
	dat += "<h3>Crew Assignments:</h3><br>"
	for(var/datum/assignment/A in assignments)
		if(A.subtask) continue
		dat += "<div class='statusDisplay'>"
		dat += "<u>[A.name]</u> - [A.check_complete() ? "<font color='green'>Success!</font>" : "<font color='red'>Failed.</font>"]<br>"
		dat += "Assigned to: [A.assigned_to.len ? list2text(A.gather_users(),", ") : "None"]<br>"
		dat += "Assigned by: [A.assigned_by_actual ? A.assigned_by_actual : A.assigned_by.owner]"
		dat += "</div>"
	dat += "</td></tr></table>"
	for(var/mob/player in player_list)
		var/datum/browser/popup = new(player, "endroundresults", "<div align='center'>Crew Assignments</div>", 900, 600)
		popup.set_content(dat)
		popup.open(0)

	//Station stats
	var/station_evacuated
	if(emergency_shuttle.location > 0)
		station_evacuated = 1
	var/num_survivors = 0
	var/num_escapees = 0

	world << "<BR><BR><BR><FONT size=3><B>The round has ended.</B></FONT>"

	//Player status report
	for(var/mob/Player in mob_list)
		if(Player.mind)
			if(Player.stat != DEAD && !isbrain(Player))
				num_survivors++
				if(station_evacuated) //If the shuttle has already left the station
					var/turf/playerTurf = get_turf(Player)
					if(playerTurf.z != 2)
						Player << "<font color='blue'><b>You managed to survive, but were marooned on [station_name()]...</b></FONT>"
					else
						num_escapees++
						Player << "<font color='green'><b>You managed to survive the events on [station_name()] as [Player.real_name].</b></FONT>"
				else
					Player << "<font color='green'><b>You managed to survive the events on [station_name()] as [Player.real_name].</b></FONT>"
			else
				Player << "<font color='red'><b>You did not survive the events on [station_name()]...</b></FONT>"

	world << "<BR>[TAB]Shift Duration: <B>[round(world.time / 36000)]:[add_zero(world.time / 600 % 60, 2)]:[world.time / 100 % 6][world.time / 100 % 10]</B>"
	if(emergency_shuttle && emergency_shuttle.location == 2)
		world << "<BR>[TAB]Nuclear Authentication Disk: <B>[disk_rescued ? "<font color='green'>Secured!</font>" : "<font color='red'>Lost!</font>"]</B>"
	world << "<BR>[TAB]Station Integrity: <B>[mode.station_was_nuked ? "<font color='red'>Destroyed</font>" : "[station_integrity]%"]</B>"
	world << "<BR>[TAB]Total Population: <B>[joined_player_list.len]</B>"
	if(joined_player_list.len)
		world << "<BR>[TAB]Survival Rate: <B>[num_survivors] ([round((num_survivors/joined_player_list.len)*100, 0.1)]%)</B>"
		if(station_evacuated)
			world << "<BR>[TAB]Evacuation Rate: <B>[num_escapees] ([round((num_escapees/joined_player_list.len)*100, 0.1)]%)</B>"
	world << "<BR>"
	if(events)
		world << "<b><u>Event Results</u></b>"
		for(var/datum/round_event/E in events.queue)
			qdel(E) //kill off any unqueued events. they don't deserve any light of day.
		for(var/datum/round_event/E in events.finished)
			E.end() // end it first
			var/win = E.declare_completion()
			if(!win) continue
			world << "[TAB][win]"


//Round intel

/proc/add2timeline(var/text,var/major)
	if(ticker)
		if(major)
			ticker.timeline.Add("<b>[time2text(world.time, "hh:mm:ss")] [text]</b>")
		else
			ticker.timeline.Add("[time2text(world.time, "hh:mm:ss")] [text]")

/datum/roundintel
	//rateStation() compares the data and adds "moods" to this list, the contents
	//of the moods list then is run through "add_danger" would increase the danger rating. for example.
	var/list/moods = list()
	//people
	var/active_crew = 0 //Active crew
	var/active_heads = 0 //Active heads of staff
	var/active_antags = 0 //Active antags (can also be crew)
	var/active_perseus = 0 //Perseus
	//things
	var/mining_points = 0
	var/research = 0
	var/singularity = 0

	proc/gather_stats()
		//people
		for(var/datum/mind/M in ticker.minds)
			if(!(M.assigned_role in list("Perseus Security Enforcer", "Perseus Security Commander", "SPECIAL")) && (M.special_role != "MODE")) // crew member?
				if(M.current) //currently a mob?
					if(istype(M.current,/mob/living/carbon/human)) // Human?
						if(M.current.stat != DEAD) //alive?
							active_crew++
							if(M.assigned_role in command_positions)
								active_heads++
			if(M.special_role && M.assigned_role != "SPECIAL") //antag of any kind?
				if(M.current) //currently a mob?
					if(M.current.stat != DEAD) //alive?
						active_antags++
			if(M.assigned_role in list("Perseus Security Enforcer", "Perseus Security Commander"))
				if(M.current) //currently a mob?
					if(M.current.stat != DEAD) //alive?
						active_perseus++
		//mining
		mining_points = ticker.mining_points
		//research
		var/obj/machinery/r_n_d/server/core/C
		for(var/obj/machinery/r_n_d/server/core/found in world)
			if(found.z == 1)
				C = found
		if(C)
			var/max_designs = C.files.possible_designs.len
			var/has_designs = C.files.known_designs.len
			research = round((has_designs / max_designs)*100)
		//singularity
		for(var/obj/machinery/singularity/loose in world)
			if(loose.z != 1) continue
			for(var/obj/machinery/field/generator/F in orange(7, loose))
				if(!F.connected_gens)
					singularity = 0
				else
					singularity = 1



	proc/rateStation()
		if(!ticker || !ticker.intel) return
		if(ticker.current_state != 3) return
		if(!events)
			return
		if(!events.autoratings)
			return
		var/list/commands = list() // sets up a list of commands to fire when adjusting the event ratings.
		//out with the old, in with the new
		var/datum/roundintel/O = ticker.intel
		var/datum/roundintel/N = new()
		ticker.intel = N
		N.gather_stats()
		//compare
		/* blueberries go home
		if(N.active_perseus)
			commands.Add("perseus_available")
		*/
		if(N.active_antags < O.active_antags)
			commands.Add("antags_defeated")
		else
			commands.Add("antags_progress")

		if((N.active_crew - O.active_antags) < (O.active_crew - O.active_antags))
			commands.Add("lost_crew")
		else
			commands.Add("crew_stable")

		if(N.mining_points > O.mining_points)
			commands.Add("research_up")

		if(N.research > O.research)
			commands.Add("research_up")

		if(N.singularity)
			commands.Add("sing_stable")
		else
			commands.Add("SINGLOOSE")

		//Adjust
		for(var/X in commands)
			switch(X)
				/* blueberries go home
				if("perseus_available")
					//boost gameplay up by a bit
					//but not much. don't kill me
					if(prob(50))
						events.rating["Gameplay"] += rand(2,10)
				*/
				if("antags_defeated")
					//Reward gameplay for defeated antags
					events.rating["Gameplay"] += rand(0,15)
				if("antags_progress")
					//Add a bit to annoying if the antags are doing fine
					events.rating["Gameplay"] -= rand(0,15)
				if("lost_crew")
					events.rating["Gameplay"] -= rand(0,15)
				if("crew_stable")
					events.rating["Gameplay"] += rand(0,15)
				if("research_up")
					events.rating["Gameplay"] += rand(0,15)
				if("sing_stable")
					//if the sing is stable, we progress down the dangerous line
					events.rating["Dangerous"] += rand(5,15)
				if("SINGLOOSE")
					//this means either the engine was never setup or is loose, we want to severely dampen what events can fire until this is rectified
					//Annoying/Gameplay cannot exceed 20 points
					//Dangerous cannot exceed 50 points
					events.rating["Dangerous"] += rand(5,15)
					//If we exceed 30/70, time to reset to the middle
					if(events.rating["Gameplay"] > 70 || events.rating["Gameplay"] < 30)
						events.rating["Gameplay"] = 50
					//If we exceed 500, time to scramble
					if(events.rating["Dangerous"] > 50)
						events.rating["Dangerous"] = rand(0,50)


		//If we are in the negatives, make it 0
		events.rating["Gameplay"] = max(events.rating["Gameplay"],0)
		events.rating["Dangerous"] = max(events.rating["Dangerous"],0)
		var/scramble = 0
		//If we exceed 100, time to reset to the middle
		if(events.rating["Gameplay"] > 100)
			events.rating["Gameplay"] = 50
			scramble = 1
		//If we exceed 100, time to reset to the begining of progression with a little bonus maybe.
		if(events.rating["Dangerous"] > 100)
			events.rating["Dangerous"] = rand(0,30)
			scramble = 1

		if(prob(25) && scramble)
			events.rating["Dangerous"] = rand(0,100)
			events.rating["Gameplay"] = rand(0,100)