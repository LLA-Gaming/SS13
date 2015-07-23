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

	//Assignments
	dat += "<td valign='top' width='75%'>"
	dat += "<h3>Crew Assignments:</h3><br>"
	var/count
	for(var/datum/assignment/A in assignments)
		if(A.subtask) continue
		dat += "<div class='statusDisplay'>"
		dat += "<u>[A.name]</u> - [A.check_complete() ? "<font color='green'>Success!</font>" : "<font color='red'>Failed.</font>"]<br>"
		dat += "Assigned to: [A.assigned_to.len ? list2text(A.gather_users(),", ") : "None"]<br>"
		dat += "Assigned by: [A.assigned_by_actual ? A.assigned_by_actual : A.assigned_by.owner]"
		dat += "</div>"
		count++
	if(count)
		for(var/mob/player in player_list)
			var/datum/browser/popup = new(player, "endroundresults", "<div align='center'>Crew Assignments</div>", 500, 700)
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
	world << "<BR>[TAB]Survival Rate: <B>[num_survivors] ([round((num_survivors/joined_player_list.len)*100, 0.1)]%)</B>"
	if(station_evacuated)
		world << "<BR>[TAB]Evacuation Rate: <B>[num_escapees] ([round((num_escapees/joined_player_list.len)*100, 0.1)]%)</B>"
	world << "<BR>"