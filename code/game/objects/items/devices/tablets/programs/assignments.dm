/datum/program/assignments
	name = "Assignments"
	app_id = "assignments"
	drm = 1
	usesalerts = 1
	var/command = 0
	var/list/deptlist = list()
	var/mode = 2
	var/temp //For displaying text or error messages

	var/datum/assignment/new_task = null

	use_app()
		if(!ticker || !job_master || !assignments)
			dat = "Error: Contact a system administrator"
			return
		if(!tablet.network())
			dat = "Error: Connection not found"
			return
		verify_user()
		dat = ""
		if(new_task)
			dat += "<a href='byond://?src=\ref[src];choice=cleartemp'>Cancel</a><br>"
			dat += "<div class='statusDisplay'>"
			dat += "<u>Name:</u> [new_task.name]<br>"
			dat += "<u>Details:</u> [new_task.details]<br><br>"
			if(new_task.todo.len)
				dat += "<u>Tasks:</u><br>"
			var/i = 0
			for(var/X in new_task.todo)
				i++
				dat += "[i]) [X]<br>"
			if(new_task.assigned_to.len)
				dat += "<br>Assigned Users:</u> [list2text(new_task.assigned_to,"<br>")]"
			dat += "</div>"
			dat += "Commands:<br>"
			if(istype(new_task,/datum/assignment/passive/custom/))
				dat += "[command_button("<a href='byond://?src=\ref[new_task];choice=name;app=\ref[src]'>Rename</a>")]<br>"
				dat += "[command_button("<a href='byond://?src=\ref[new_task];choice=details;app=\ref[src]'>Set Details</a>")]<br>"
				dat += "[command_button("<a href='byond://?src=\ref[new_task];choice=step;app=\ref[src]''>Add Steps</a>")]<br>"
			dat += "[command_button("<a href='byond://?src=\ref[new_task];choice=users;app=\ref[src]'>Add Users</a>")]<br>"
			dat += "[command_button("<a href='byond://?src=\ref[src];choice=save'>Create</a>")]<br>"
			return
		if(temp)
			dat += "<div class='statusDisplay'>[temp]</div><hr>"
			dat += "<a href='byond://?src=\ref[src];choice=cleartemp'>OK</a>"
			return
		dat += "<center><h3>Assignments</h3>"
		dat += "<a href='byond://?src=\ref[src];mode=1'>Available</a>"
		dat += "<a href='byond://?src=\ref[src];mode=2'>Active</a>"
		dat += "<a href='byond://?src=\ref[src];mode=3'>Completed</a>"
		dat += "</center><hr>"

		if(mode == 1) //available
			dat += "<h3>Available Assignments</h3>"
			if(command)
				dat += "<div class='statusDisplay'>"
				dat += "New Assignment[command_button(" - <a href='byond://?src=\ref[src];choice=New'>Create</a>")]<br>"
				for(var/datum/assignment/A in assignments.available)
					if(!A.can_view(tablet))
						continue
					dat += "[A.name][command_button(" - <a href='byond://?src=\ref[src];choice=New;target=\ref[A]'>Assign</a>")]<br>"
				dat += "</div>"
			else
				dat += "<div class='statusDisplay'>"
				dat += "ACCESS DENIED<br>"
				dat += "List can be disclosed by department head"
				dat += "</div>"

		if(mode == 2) //active
			dat += "<h3>Active Assignments</h3>"
			dat += "<div class='statusDisplay'>"
			for(var/datum/assignment/A in assignments.all)
				if(!A.can_view(tablet))
					continue
				dat += "[A.name] - <a href='byond://?src=\ref[src];choice=details;target=\ref[A]'>Details</a><br>"
			dat += "</div>"

		if(mode == 3) //complete
			dat += "<h3>Completed Assignments</h3>"
			dat += "<div class='statusDisplay'>"
			for(var/datum/assignment/A in sortAtom(assignments.complete))
				if(!A.can_view(tablet))
					continue
				dat += "[A.name] - <a href='byond://?src=\ref[src];choice=details;target=\ref[A]'>Details</a><br>"
			dat += "</div>"

	Topic(href, href_list)
		if (!..()) return
		if (!ticker) return
		if(href_list["mode"])
			mode = text2num(href_list["mode"])
		switch(href_list["choice"])
			if("cleartemp")
				temp = null
				if(new_task)
					recycle_assignment(new_task)
			if("details")
				var/datum/assignment/A = locate(href_list["target"])
				if(A)
					temp += "<u>Name:</u> [A.name]<br>"
					if(A.centcomm)
						temp += "<u>Created by:</u> Centcomm<br>"
						if(A.assigned_by != "Centcomm")
							temp += "<u>Supervisor:</u> [A.assigned_by]<br>"
					else
						temp += "<u>Created by:</u> [A.assigned_by]<br>"
					temp += "<u>Details:</u> [A.details]<br><br>"
					if(A.todo.len)
						temp += "<u>Tasks:</u><br>"
					var/i = 0
					for(var/X in A.todo)
						i++
						temp += "[i]) [X]<br>"
					if(A.assigned_to.len)
						temp += "<br>Assigned Users:</u> [list2text(A.assigned_to,"<br>")]"
					if(!A.complete && A.assigned_by == "[tablet.owner] ([tablet.ownjob])")
						if(istype(A,/datum/assignment/passive/custom/))
							temp += "[command_button("<br><a href='byond://?src=\ref[A];choice=report_complete;app=\ref[src]'>Report Complete</a>")]"
						if(!A.success && !A.canceled && !A.failed)
							temp += "[command_button("<br><a href='byond://?src=\ref[A];choice=cancel;app=\ref[src]'>Cancel Assignment</a>")]"
				else
					temp += "Error: Assignment not found"
			if("New")
				var/datum/assignment/A = locate(href_list["target"])
				if(A)
					new_task = A
					assignments.available.Remove(A)
					assignments.update_assignments()
					if(A.repeat)
						spawn_assignment(A.type)
				else
					new_task = new /datum/assignment/passive/custom
				new_task.assigned_by = "[tablet.owner] ([tablet.ownjob])"
			if("cleartemp")
				var/datum/assignment = locate(href_list["target"])
				if(assignment)
					new_task = assignment
			if("save")
				if(assignments.all.len + assignments.complete.len >= 500)
					//this should probably never happen but better safe then sorry
					qdel(new_task)
					new_task = null
					temp = "Error: Too many assignments active"
				if(new_task)
					var/good = 0
					if(new_task.name && new_task.details && new_task.assigned_to.len)
						good = 1
					if(good)
						var/dupe = 0
						for(var/datum/assignment/A in assignments.all + assignments.complete)
							if(istype(A, /datum/assignment/passive/custom))
								continue //let em make as many of these as they want.
							if(!A.success && A.complete)
								continue //let em try again if they failed
							if(A.repeat == 2 && A.complete)
								continue //let em try again if its repeatable
							if(!A.repeat)
								continue //If for some reason they get ANOTHER repeated rng assignment, let em do it again instead of locking them out
							if(new_task.type == A.type)
								dupe++
						if(!dupe)
							if(new_task.setup())
								if(new_task.passive)
									assignments.passive.Add(new_task)
									assignments.update_assignments()
								else
									assignments.active.Add(new_task)
									assignments.update_assignments()
								//ALERT
								for(var/obj/item/device/tablet/T in tablets_list)
									var/auth = "[T.owner] ([T.ownjob])"
									if(auth in new_task.assigned_to)
										T.alert_self("New Assignment","[new_task.name]","assignments")
								new_task = null
								temp = "Assignment created!"
							else
								recycle_assignment(new_task)
								temp = "Assignment could not be created!"
						else
							recycle_assignment(new_task)
							temp = "Couldn't create duplicate assignment!"
					else
						recycle_assignment(new_task)
						temp = "assignment missing parameters!"



		use_app()
		tablet.attack_self(usr)

	proc/recycle_assignment(var/datum/assignment/A)
		if(istype(A,/datum/assignment/passive/custom))
			qdel(A)
			new_task = null
			return
		A.assigned_by = null
		A.assigned_to = list()
		if(!A.repeat)
			assignments.available.Add(A)
			assignments.update_assignments()
			new_task = null
		else
			qdel(A)
			new_task = null

	proc/command_button(var/button)
		if(command)
			return button
		return

	proc/verify_user()
		deptlist = job_master.GetDeptList(tablet.ownjob)
		if(!deptlist || !deptlist.len)
			deptlist = list("None")
		command = 0
		if(tablet.ownjob == "Quartermaster")
			//QM isnt a real head but still in charge of cargo
			command = 1
			return
		for(var/X in deptlist)
			if(X == "Command")
				command = 1

	proc/gather_assignees(var/datum/assignment/A)
		if(!A)
			return null
		var/list/results = list()
		for(var/obj/item/device/tablet/T in sortAtom(tablets_list))
			if(!(locate(/datum/program/assignments) in T.core.programs))
				continue
			var/list/depts = job_master.GetDeptList(T.ownjob)
			if(!depts)
				continue
			if(tablet == T && T.ownjob == "Captain")
				results.Add(T)
				continue
			if(length(A.dept & depts))
				results.Add(T)
				continue
		if(!results.len)
			return null
		else
			return results