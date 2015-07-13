//protect head
/datum/assignment/protecthead
	name = "Protect a Head of staff"
	detail = "Assign a guard to a department head, this task is completed when the head reaches CentComm"
	cost = 0
	possible_departments = list("Security")
	var/datum/mind/mind = null

	generate_options()
		options.Add("Cancel")
		for(var/datum/mind/M in ticker.minds)
			if(length(list(M.assigned_role) & command_positions))
				options.Add(M)

	validate()
		if(ticker)
			if(!mind)
				return "add a head of staff to protect"
			if(!assigned_to.len)
				return "assign at least one user"
			for(var/datum/assignment/protecthead/R in sortAtom(ticker.assignments))
				if(mind == R.mind)
					return "duplicate target found in existing assignment"
			ticker.assignments.Add(src)
			return null
		return "invalid"

	update_label()
		if(mind)
			name = "Protect [mind.name] ([mind.assigned_role])"

	check_complete()
		if(complete)
			return 1
		for(var/datum/mind/M in ticker.minds)
			var/mob_area = get_area(M.current)
			if(is_type_in_list(mob_area, centcom_areas))
				if(!M.current.stat)
					return 1
		return 0


	add_goal(var/datum/mind/M)
		mind = M
		update_label()

	display()
		. += "<u>[name]</u><br>"
		. += "1) Protect [mind ? mind.name : "\<Insert Goal\>"] during their shift on [station_name]<br>"
		. += "2) Ensure [mind ? mind.name : "\<Insert Goal\>"] returns to CentComm on the shuttle or in a pod<br>"
		. += "Assigned to: [assigned_to.len ? list2text(gather_users(),", ") : "\<Insert Users\>"]<br>"
		. += "Assigned by: [assigned_by.owner]"

//protect dept
/datum/assignment/protectdept
	name = "Protect Department Staff"
	detail = "Assign a guard to protect staff members of a certain department, this task is completed when the staff reaches CentComm"
	cost = 0
	possible_departments = list("Security")
	var/dept = null

	generate_options()
		options = list("Cancel","Security","Engineering","Medical","Science","Supply")

	validate()
		if(ticker)
			if(!dept)
				return "add a department"
			if(!assigned_to.len)
				return "assign at least one user"
			for(var/datum/assignment/protectdept/R in sortAtom(ticker.assignments))
				if(dept == R.dept)
					return "duplicate department found in existing assignment"
			ticker.assignments.Add(src)
			return null
		return "invalid"

	update_label()
		if(dept)
			name = "Protect the [dept] staff"

	check_complete()
		if(complete)
			return 1
		var/list/L = list()
		var/list/targets = list()
		if(dept == "Security")
			L = security_positions
		if(dept == "Engineering")
			L = engineering_positions
		if(dept == "Medical")
			L = medical_positions
		if(dept == "Science")
			L = science_positions
		if(dept == "Supply")
			L = supply_positions
		for(var/datum/mind/M in ticker.minds)
			if(M.assigned_role in L)
				targets.Add(M)
		var/living = 0
		if(targets.len)
			for(var/datum/mind/M in ticker.minds)
				var/mob_area = get_area(M.current)
				if(is_type_in_list(mob_area, centcom_areas))
					if(!M.current.stat)
						living += 1
		if(targets.len && (living >= targets.len))
			return 1
		return 0

	add_goal(var/D)
		dept = D
		update_label()

	display()
		. += "<u>[name]</u><br>"
		. += "1) Protect each member of [dept ? dept : "\<Insert Goal\>"] during their shift on [station_name]<br>"
		. += "2) Ensure they return to CentComm on the shuttle or in a pod<br>"
		. += "Assigned to: [assigned_to.len ? list2text(gather_users(),", ") : "\<Insert Users\>"]<br>"
		. += "Assigned by: [assigned_by.owner]"