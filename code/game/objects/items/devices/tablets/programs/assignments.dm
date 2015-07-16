/datum/program/assignments
	name = "Assignments"
	app_id = "assignments"
	usesalerts = 1
	var/mode = 0

	var/list/deptlist = list("None")
	var/command = 0

	var/datum/assignment/new_task = null

	var/temp = null //Used for error messages
	var/spamcheck = 0

	use_app()
		if(!ticker || !job_master)
			dat = "Error: Contact a system administrator"
			return
		if(!tablet.network())
			dat = "Error: Connection not found"
			return
		verify_user()
		dat = ""
		if(new_task)
			dat += "<A href='?src=\ref[src];choice=cancel_task;target=\ref[new_task]'>Cancel</a> "
			if(temp)
				dat += "<div class='statusDisplay'>"
				dat += "ERROR: [temp]"
				dat += "</div>"
			dat += "<div class='statusDisplay'>"
			dat += new_task.display()
			dat += "</div>"
			if(new_task.options.len)
				dat += "<A href='?src=\ref[src];choice=newtask_addgoal'>Add Goal</a><br>"
			if(new_task.custom)
				dat += "<A href='?src=\ref[src];choice=newtask_addgoal'>Add Details</a><br>"
			dat += "<A href='?src=\ref[src];choice=newtask_addusers'>Assign Users</a><br>"
			dat += "<A href='?src=\ref[src];choice=newtask_finalize'>Create Task</a><br>"
			return
		temp = null // clear this if there is no "new task" in production
		if(command)
			dat += "<center>"
			dat += "<A href='?src=\ref[src];choice=assignments'>Assignments</a> "
			dat += "<A href='?src=\ref[src];choice=manage'>Management</a> "
			dat += "</center>"
		switch(mode)
			if(0) // Front page
				dat += "<h4>Assignments</h4>"
				for(var/datum/assignment/A in ticker.assignments)
					if(A.subtask) continue
					if(A.assigned_to.Find(tablet))
						dat += "<div class='statusDisplay'>"
						dat += A.display()
						dat += "<br> <a href='byond://?src=\ref[src];choice=optout_task;target=\ref[A]'>Decline</a><br>"
						dat += "</div>"
				dat += "<h4>Tasks</h4>"
				for(var/datum/assignment/A in ticker.assignments)
					if(!A.subtask) continue
					if(A.assigned_to.Find(tablet))
						dat += "<div class='statusDisplay'>"
						dat += A.display()
						dat += "<br> <a href='byond://?src=\ref[src];choice=optout_task;target=\ref[A]'>Decline</a><br>"
						dat += "</div>"
			if(1) // Manage assignments
				if(!command)
					mode = 0
				dat += "<h4>Manage Assignments - <a href='byond://?src=\ref[src];choice=new_task'>New</a></h4>"
				for(var/datum/assignment/A in ticker.assignments)
					if(A.subtask) continue
					if(A.assigned_by == tablet)
						dat += "<div class='statusDisplay'>"
						dat += A.display()
						dat += "<br><a href='byond://?src=\ref[src];choice=delete_task;target=\ref[A]'>Cancel</a><br>"
						dat += "</div>"
				dat += "<h4>Manage Tasks</h4>"
				for(var/datum/assignment/A in ticker.assignments)
					if(!A.subtask) continue
					if(A.assigned_by == tablet)
						dat += "<div class='statusDisplay'>"
						dat += A.display()
						dat += " <a href='byond://?src=\ref[src];choice=delete_task;target=\ref[A]'>Cancel</a>/<a href='byond://?src=\ref[src];choice=complete_task;target=\ref[A]'>Complete</a><br>"
						dat += "</div>"
			if(2) // Creating a new task
				if(!command)
					mode = 0
				dat += "<h4>New Assignment</h4>"
				dat += "<div class='statusDisplay'>"
				for(var/datum/assignment/A in crew_objectives)
					if(length(A.possible_departments & deptlist))
						dat += "<a href='byond://?src=\ref[src];choice=create_task;target=\ref[A]'>[A.name]</a> - [A.detail]<br>"
				dat += "</div>"
			else
				mode = 0

	Topic(href, href_list)
		if (!..()) return
		if (!ticker) return
		switch(href_list["choice"])
			if("assignments")
				mode = 0
			if("manage")
				mode = 1
			if("new_task")
				mode = 2
			if("cancel_task")
				qdel(locate(href_list["target"]))
				mode = 1
			if("delete_task")
				var/datum/assignment/A = locate(href_list["target"])
				for(var/obj/item/device/tablet/T in A.assigned_to)
					T.alert_self("Assignments","Assignment Canceled - [A.name]","assignments")
				qdel(A)
				mode = 1
			if("complete_task")
				var/datum/assignment/A = locate(href_list["target"])
				for(var/obj/item/device/tablet/T in A.assigned_to)
					T.alert_self("Assignments","Assignment Complete - [A.name]","assignments")
				qdel(A)
				mode = 1
			if("optout_task")
				mode = 0
				var/datum/assignment/A = locate(href_list["target"])
				A.assigned_to.Remove(tablet)
				A.assigned_by.alert_self("Assignments","[tablet.owner] declined \"[A.name]\"","assignments")
				if(!A.assigned_to.len)
					ticker.assignments.Remove(A)
					qdel(A)

			if("create_task")
				var/datum/assignment/A = locate(href_list["target"])
				new_task = new A.type
				new_task.generate_options()
				new_task.assigned_by = tablet
				//Fraud check
				var/mob/living/carbon/human/user = usr
				if(istype(user,/mob/living/carbon/human))
					if(user.real_name != tablet.owner)
						new_task.assigned_by_actual = "[user.real_name] as \"[new_task.assigned_by]\""
			//assignment_creation hrefs
			if("newtask_addgoal")
				if(!new_task.custom)
					spamcheck = 1
					var/t = input(usr, "Select which goal?") as null|anything in new_task.options
					spamcheck = 0
					if(t && t != "Cancel")
						new_task.add_goal(t)
				if(new_task.custom)
					spamcheck = 1
					new_task.name = copytext(sanitize(input("Name", "Name", null, null)  as text),1,MAX_MESSAGE_LEN)
					new_task.detail = copytext(sanitize(input("Details", "Details", null, null)  as text),1,MAX_MESSAGE_LEN)
					spamcheck = 0
			if("newtask_addusers")
				spamcheck = 1
				var/list/D = list()
				D["Cancel"] = "Cancel"
				for(var/obj/item/device/tablet/T in gather_coworkers())
					if(!T.core) continue
					if(!T.network()) continue
					if(!(locate(T) in new_task.assigned_to))
						D["[T.owner] ([T.ownjob])"] = T
				var/t = input(usr, "Add who?") as null|anything in D
				spamcheck = 0
				if(t && t != "Cancel")
					var/obj/item/device/tablet/chosen = D[t]
					new_task.assigned_to.Add(chosen)
			if("newtask_finalize")
				var/count = 0
				for(var/datum/assignment/A in ticker.assignments)
					if(A.assigned_by == tablet)
						count += A.cost
				if(count < 5 && ticker.assignments.len <= 999)
					temp = new_task.validate(tablet)
					if(!temp)
						for(var/obj/item/device/tablet/T in new_task.assigned_to)
							T.alert_self("Assignments","New Assignment - [new_task.name]","assignments")
						new_task.options = list()
						new_task = null
						usr << "Assignment Created!"
						mode = 1
				else
					temp = "You have created the maximum amount of assignments, please remove some before continuing"

		use_app()
		tablet.attack_self(usr)

	proc/verify_user()
		deptlist = job_master.GetDeptList(tablet.ownjob)
		if(!deptlist || !deptlist.len)
			deptlist = list("None")
		command = 0
		for(var/X in deptlist)
			if(X == "Command")
				command = 1

	proc/gather_coworkers()
		var/list/results = list()
		for(var/obj/item/device/tablet/T in sortAtom(tablets_list))
			if(!(locate(/datum/program/assignments) in T.core.programs))
				continue
			var/list/depts = job_master.GetDeptList(T.ownjob)
			if(!depts)
				continue
			if(length(depts & deptlist))
				if(!(depts.Find("Command")) || T == tablet || tablet.ownjob == "Captain")
					results.Add(T)
					continue
		if(!results.len)
			return null
		else
			return results