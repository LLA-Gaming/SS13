/datum/program/assignments
	name = "Assignments"
	app_id = "assignments"
	drm = 1
	usesalerts = 1
	var/command = 0
	var/list/deptlist = list()
	var/temp //For displaying text or error messages

	var/datum/assignment/new_task = null

	use_app()
		if(!ticker || !job_master)
			dat = "Error: Contact a system administrator"
			return
		var/obj/machinery/nanonet_server/MS = tablet.network()
		if(!istype(MS,/obj/machinery/nanonet_server/))
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
				dat += "<br>Assigned Users:</u> [jointext(new_task.assigned_to,"<br>")]"
			dat += "</div>"
			dat += "Commands:<br>"
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
		dat += "<h3>Active Assignments[command_button(" - <a href='byond://?src=\ref[src];choice=New'>Create</a><br>")]</h3>"
		dat += "<div class='statusDisplay'>"
		var/active_count = 0
		for(var/datum/assignment/A in MS.assignments)
			if(!A.can_view(tablet) || A.complete)
				continue
			dat += "[A.name] - <a href='byond://?src=\ref[src];choice=details;target=\ref[A]'>Details</a><br>"
			active_count++
		if(!active_count)
			dat += "None!"
		dat += "</div>"
		dat += "<BR>"
		dat += "<h3>Completed Assignments</h3>"
		dat += "<div class='statusDisplay'>"
		var/complete_count = 0
		for(var/datum/assignment/A in MS.assignments)
			if(!A.can_view(tablet) || !A.complete)
				continue
			dat += "[A.name] - <a href='byond://?src=\ref[src];choice=details;target=\ref[A]'>Details</a><br>"
			complete_count++
		if(!complete_count)
			dat += "None!"
		dat += "</div>"

	Topic(href, href_list)
		if (!..()) return
		if (!ticker) return
		var/obj/machinery/nanonet_server/MS = tablet.network()
		if(!istype(MS,/obj/machinery/nanonet_server/))
			return
		switch(href_list["choice"])
			if("cleartemp")
				temp = null
				if(new_task)
					recycle_assignment(new_task)
			if("details")
				var/datum/assignment/A = locate(href_list["target"])
				if(A)
					temp += "<u>Name:</u> [A.name]<br>"
					temp += "<u>Created by:</u> [A.assigned_by]<br>"
					temp += "<u>Details:</u> [A.details]<br><br>"
					if(A.todo.len)
						temp += "<u>Tasks:</u><br>"
					var/i = 0
					for(var/X in A.todo)
						i++
						temp += "[i]) [X]<br>"
					if(A.assigned_to.len)
						temp += "<br>Assigned Users:</u> [jointext(A.assigned_to,"<br>")]"
					if(!A.complete && A.assigned_by == "[tablet.owner] ([tablet.ownjob])")
						temp += "[command_button("<br><a href='byond://?src=\ref[A];choice=report_complete;app=\ref[src]'>Report Complete</a>")]"
						if(!A.complete)
							temp += "[command_button("<br><a href='byond://?src=\ref[A];choice=cancel;app=\ref[src]'>Cancel Assignment</a>")]"
				else
					temp += "Error: Assignment not found"
			if("New")
				new_task = new /datum/assignment/
				new_task.assigned_by = "[tablet.owner] ([tablet.ownjob])"
			if("cleartemp")
				var/datum/assignment = locate(href_list["target"])
				if(assignment)
					new_task = assignment
			if("save")
				if(new_task)
					var/good = 0
					if(new_task.name && new_task.details && new_task.assigned_to.len)
						good = 1
					if(good)
						MS.assignments.Add(new_task)
						//ALERT
						for(var/obj/item/device/tablet/T in tablets_list)
							var/auth = "[T.owner] ([T.ownjob])"
							if(auth in new_task.assigned_to)
								T.alert_self("New Assignment","[new_task.name]","assignments")
						new_task = null
						temp = "Assignment created!"
					else
						recycle_assignment(new_task)
						temp = "assignment missing parameters!"



		use_app()
		tablet.attack_self(usr)

	proc/recycle_assignment(var/datum/assignment/A)
		qdel(A)
		new_task = null
		return

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

	proc/gather_assignees()
		var/list/results = list()
		for(var/obj/item/device/tablet/T in sortAtom(tablets_list))
			if(!(locate(/datum/program/assignments) in T.core.programs))
				continue
			if(T.ownjob == "Captain") //Captain can only add himself
				continue
			var/list/my_depts = job_master.GetDeptList(tablet.ownjob)
			var/list/their_depts = job_master.GetDeptList(T.ownjob)
			if(!my_depts || !their_depts)
				continue
			if(length(my_depts & their_depts))
				results.Add(T)
				continue
		if(!results.len)
			return null
		else
			return results

//assignment datum
/datum/assignment
	var/name = ""
	var/list/assigned_to = list()
	var/assigned_by = "" //format is "name (rank)"
	var/details = ""
	var/complete = 0 //completed, failed or not
	var/list/dept = list() //required departments
	var/list/heads = list() //required heads
	var/list/todo = list()

	proc/complete()
		complete = 1
		name = "COMPLETE: [name]"
		for(var/obj/item/device/tablet/T in tablets_list)
			var/auth = "[T.owner] ([T.ownjob])"
			if(auth == assigned_by)
				T.alert_self("Assignment Complete!","[src.name]","assignments")
		return 1

	//proc optimized by raptorblaze
	proc/can_view(var/obj/item/device/tablet/T)
		if(T.ownjob == "Captain")
			return 1
		if(T.ownjob in heads)
			return 1
		var/viewing = "[T.owner] ([T.ownjob])"
		if(viewing in assigned_to)
			return 1
		if(assigned_by == viewing)
			return 1

	Topic(href, href_list)
		//handled from assignment app in tablet
		var/datum/program/assignments/A = locate(href_list["app"])
		if(!A)
			return
		if(!A.tablet)
			return
		if(!A.tablet.core)
			return
		if(!A.tablet.can_use(usr))
			return
		switch(href_list["choice"])
			if("name")
				var/t = copytext(sanitize(input("Name", "Name", null, null)  as text),1,MAX_MESSAGE_LEN)
				name = t
			if("details")
				var/t = copytext(sanitize(input("Details", "Details", null, null)  as text),1,MAX_MESSAGE_LEN)
				details = t
			if("step")
				var/t = copytext(sanitize(input("Step", "Step", null, null)  as text),1,MAX_MESSAGE_LEN)
				todo.Add(t)
			if("cancel")
				if(complete)
					A.use_app()
					A.tablet.attack_self(usr)
					return
				A.temp = "Assignment canceled"
				A.use_app()
				A.tablet.attack_self(usr)
				qdel(src)
				return
			if("users")
				var/list/D = list()
				D["Cancel"] = "Cancel"
				D["[A.tablet.owner] ([A.tablet.ownjob])"] = A.tablet //add self
				for(var/obj/item/device/tablet/T in A.gather_assignees())
					if(!T.core) continue
					if(!T.network()) continue
					if(!("[T.owner] ([T.ownjob])" in assigned_to))
						D["[T.owner] ([T.ownjob])"] = T
				var/t = input(usr, "Add who?") as null|anything in D
				if(t && t != "Cancel")
					var/obj/item/device/tablet/chosen = D[t]
					var/chosen_text = "[chosen.owner] ([chosen.ownjob])"
					if(!(chosen_text in assigned_to))
						assigned_to.Add(chosen_text)
			if("report_complete")
				if(!complete)
					src.complete()
				A.temp = null
		A.use_app()
		A.tablet.attack_self(usr)
