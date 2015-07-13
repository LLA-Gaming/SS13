var/global/list/crew_objectives = list()

//Assignemnts contain 1 or several tasks
/datum/assignment
	var/name = "Nothing"
	var/detail = "Do Nothing"
	var/list/possible_departments = list("Command","Security","Engineering","Medical","Science","Supply","Civilian")
	var/obj/item/device/tablet/assigned_by = null // Who assigned it
	var/assigned_by_actual = null // Who actually assigned it (frauds, impersonation) used in end round
	var/list/assigned_to = list() // Users assigned to this task
	var/complete = 0
	var/value = 0 // Set to non-zero if the assignment looks for a value
	var/list/options = list()
	var/notes = null
	var/max_goals = 1
	var/cost = 1
	var/custom = 0

	var/subtask = 0 //Things like gathering chemicals, herbs, and drinks should be sub tasks. things that dont appear in the end round

	proc/generate_options() // Runs when created in a tablet
		return 0

	proc/check_complete()
		if(complete)
			return 1

	proc/update_label()
		return 0

	proc/validate() // If it returns 0 it will start the assignment and save it to the ticker. if not it will return a string for the error message
		return "invalid"

	proc/add_goal()
		return

	proc/display()
		. += "[name]<br>"
		. += "Details: [detail]<br>"
		. += "Assigned to: [assigned_to.len ? list2text(assigned_to,", ") : "\<Insert Users\>"]"

	proc/gather_users()
		var/list/users = list()
		for(var/obj/item/device/tablet/T in assigned_to)
			users.Add("[T.owner]")
		return users

//Optional sub-assignments that do not show up in the end round.
/datum/assignment/custom/
	name = "Create Task"
	detail = "Create a task of your choice that the assigned crew can complete"
	subtask = 1
	cost = 0
	custom = 1

	display()
		. += "[name] - [detail]<br>"
		. += "Assigned to: [assigned_to.len ? list2text(assigned_to,", ") : "\<Insert Users\>"]<br>"
		. += "Assigned by: [assigned_by.owner]"

	validate()
		if(ticker)
			if(name == initial(name))
				return "Insert the name of the task"
			if(detail == initial(detail))
				return "Insert the detail of the task"
			if(!assigned_to.len)
				return "assign at least one user"
			ticker.assignments.Add(src)
			return null
		return "invalid"