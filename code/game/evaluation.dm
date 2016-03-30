/datum/controller/gameticker/proc/evaluate_station()
	//Round statistics report
	var/station_integrity = 100
	if(start_state)
		end_state = new /datum/station_state()
		end_state.count()
		station_integrity = round( 100.0 *  start_state.score(end_state), 0.1)
	var/disk_rescued = 1
	for(var/obj/item/weapon/disk/nuclear/D in world)
		var/disk_area = get_area(D)
		if(!is_type_in_list(disk_area, centcom_areas))
			disk_rescued = 0
			break

	//Wrap up events
	if(events && events.active_events)
		for(var/datum/round_event/E in events.active_events)
			E.OnFail()
			qdel(E)

	//Station stats
	var/station_evacuated
	if(emergency_shuttle.location > 0)
		station_evacuated = 1
	var/num_crew = 0
	var/num_survivors = 0
	var/num_escapees = 0

	world << "<BR><BR><BR><FONT size=3><B>The round has ended.</B></FONT>"

	//Player status report
	for(var/mob/Player in mob_list)
		if(Player.mind)
			if(Player.mind.is_crewmember())
				num_crew++
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
	world << "<BR>[TAB]Crew Members: <B>[num_crew]</B>"
	if(num_crew)
		world << "<BR>[TAB]Survival Rate: <B>[num_survivors] ([round((num_survivors/num_crew)*100, 0.1)]%)</B>"
		if(station_evacuated)
			world << "<BR>[TAB]Evacuation Rate: <B>[num_escapees] ([round((num_escapees/num_crew)*100, 0.1)]%)</B>"
	world << "<BR>"

	//One final entry
	var/survivors_text
	var/marooned_text
	if(station_evacuated)
		if(num_escapees)
			if(num_escapees == 1)
				survivors_text = "The Sole Survivor emerged from the emergency shuttle to live another day"
			else
				survivors_text = "[num_escapees] survivors emerged from the emergency shuttle to live another day."
		if(num_survivors)
			var/marooned = num_survivors - num_escapees
			if(marooned == 1)
				marooned_text = "1 survivor remain marooned on the abandoned station"
			else
				marooned_text = "[marooned] survivors remain marooned on the abandoned station"

	EventStory("And so, the shift aboard [station_name()] came to a end. [survivors_text] [marooned_text]",2)

	if(events)
		world << "<b>The Story of [station_name()]</b>"
		for(var/X in events.story)
			world << "[TAB][X]"

	//Medals
	var/list/alert_clients = list()
	var/list/awards = events.awards
	for(var/id in awards)
		var/list/keys = awards[id]
		for(var/mob/M in player_list)
			if(M.client && M.key in keys)
				M.client.AwardMedal(id)
				alert_clients |= M.client

	for(var/client/C in alert_clients)
		C << "<br><br><font color='blue'><b>Your Medal List has been updated!</b></FONT>"

