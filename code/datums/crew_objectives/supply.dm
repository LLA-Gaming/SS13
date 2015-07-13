//mining points
/datum/assignment/miningpoints
	name = "Collect Mining Points"
	detail = "Assign a miner to collect a certain number of mining points"
	possible_departments = list("Supply")
	var/goal = 0

	generate_options()
		options.Add("Cancel")
		options.Add("100")
		options.Add("250")
		options.Add("500")
		options.Add("1000")
		options.Add("1500")
		options.Add("2000")
		options.Add("2500")
		options.Add("3000")
		options.Add("5000")

	validate()
		if(ticker)
			if(!goal)
				return "add a goal number"
			if(!assigned_to.len)
				return "assign at least one user"
			ticker.assignments.Add(src)
			return null
		return "invalid"

	update_label()
		if(goal)
			name = "Collect [goal] Mining Points"

	check_complete()
		if(complete)
			return 1
		if(ticker.mining_points >= goal)
			return 1
		return 0


	add_goal(var/points)
		goal = text2num(points)
		update_label()

	display(var/end_round)
		. += "<u>[name]</u><br>"
		. += "1) Mine and collect [goal ? goal : "\<Insert Goal\>"] points<br>"
		. += "Assigned to: [assigned_to.len ? list2text(gather_users(),", ") : "\<Insert Users\>"]<br>"
		if(end_round)
			. += "Assigned by: [assigned_by_actual ? assigned_by_actual : assigned_by.owner]"
		else
			. += "Assigned by: [assigned_by.owner]"