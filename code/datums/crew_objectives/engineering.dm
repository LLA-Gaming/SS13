//singularity engine
/datum/assignment/singularity
	name = "Singularity Setup and Upkeep"
	detail = "Assign engineers to setup and maintain the singularity engine"
	possible_departments = list("Engineering")

	validate()
		if(ticker)
			if(!assigned_to.len)
				return "assign at least one user"
			ticker.assignments.Add(src)
			return null
		return "invalid"

	check_complete()
		if(complete)
			return 1
		for(var/obj/machinery/singularity/loose in world)
			if(loose.z != 1) continue
			for(var/obj/machinery/field/generator/F in orange(7, loose))
				if(!F.connected_gens)
					return 0
				else
					return 1
		return 0

	display()
		. += "<u>[name]</u><br>"
		. += "1) Setup the Singularity Engine<br>"
		. += "2) Maintain the engine until the end of the shift<br>"
		. += "Assigned to: [assigned_to.len ? list2text(gather_users(),", ") : "\<Insert Users\>"]<br>"
		. += "Assigned by: [assigned_by.owner]"

//station intact
/datum/assignment/station_upkeep
	name = "Maintain the Station Integrity"
	detail = "Assign engineers keep the station at least 99% intact"
	possible_departments = list("Engineering")

	validate()
		if(ticker)
			if(!assigned_to.len)
				return "assign at least one user"
			ticker.assignments.Add(src)
			return null
		return "invalid"

	check_complete()
		if(!ticker.mode)
			return 0
		if(complete)
			return 1
		var/station_integrity = round( 100.0 *  start_state.score(end_state), 0.1)
		if(station_integrity >= 98 && !ticker.mode.station_was_nuked)
			return 1

	display()
		. += "<u>[name]</u><br>"
		. += "1) Maintain the station integrity above 95%<br>"
		. += "Assigned to: [assigned_to.len ? list2text(gather_users(),", ") : "\<Insert Users\>"]<br>"
		. += "Assigned by: [assigned_by.owner]"