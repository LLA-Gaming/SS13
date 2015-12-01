/datum/controller/gameticker/proc/evaluate_station()
	var/dat = ""
	if(assignments)
		for(var/datum/assignment/A in assignments.passive)
			A.check_complete()
		for(var/datum/assignment/A in assignments.active)
			A.fail() //fail any incomplete assignments
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
	dat += "<tr><td valign='top' width='100%'>"
	dat += "<h3>Round Timeline</h3>"
	if(ticker)
		for(var/X in ticker.timeline)
			dat += "[X]<BR>"
	dat += "</td>"
	//Assignments
	/* WORK IN PROGRESS
	dat += "<td valign='top' width='70%'>"
	dat += "<h3>Assignments:</h3><br>"
	dat += "Stuff to go here later"
	dat += "</td></tr>"
	*/
	dat += "</table>"
	for(var/mob/player in player_list)
		var/datum/browser/popup = new(player, "endroundresults", "<div align='center'>Timeline</div>", 900, 600)
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

/proc/add2timeline(var/text,var/major)
	if(ticker)
		if(major)
			ticker.timeline.Add("<b>[time2text(world.time, "hh:mm:ss")] [text]</b>")
		else
			ticker.timeline.Add("[time2text(world.time, "hh:mm:ss")] [text]")