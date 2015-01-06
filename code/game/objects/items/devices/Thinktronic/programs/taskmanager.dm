/obj/item/device/thinktronic_parts/program/general/taskmanager
	name = "Task Manager"
	usealerts = 1
	alerts = 1
	var/dept = "General"

	New()
		for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
			server = MS
			break
	use_app() //Put all the HTML here
		if(network())
			dat = "<h4>[dept] Task List</h4>"
			dat += " <a href='?src=\ref[src];choice=NewTask'>New Task</a> - <a href='?src=\ref[src];choice=NewRequest'>New Request</a><br>"
			for(var/obj/item/device/thinktronic_parts/data/task/task in server)
				if(task.dept == dept)
					dat += "<div class='statusDisplay'>"
					dat += {"<A href='?src=\ref[src];choice=ClearTask;target=\ref[task]'> <b>X</b> </a><br>"}
					dat += {"<b><u>[task.taskmsg]</b></u> [task.request ? "(Request)" : ""]<br>"}
					dat += {"Detail: [task.taskdetail]<br>"}
					dat += {"Assigned By: [task.assignedby]<br>"}
					dat += {"Assigned To: [task.dept]<br>"}
					dat += {"<a href='byond://?src=\ref[src];choice=EditTask;what=change_setting;task=\ref[task]'>[task.status]</a><br>"}
					dat += "</div>"
		else
			dat += "ERROR: No connection to the server"



	Topic(href, href_list) // This is here
		..()
		var/obj/item/device/thinktronic_parts/HDD/hdd = loc // variable for interactin with the HDD
		var/obj/item/device/thinktronic/PDA = hdd.loc // variable for interacting with the Device itself
		switch(href_list["choice"])
			if("EditTask")
				if(href_list["what"] == "change_setting")
					var/toWhat = input("What do you want to change it to?", "Input") as anything in list("Pending","Accepted", "Denied", "Completed", "Failed")
					var/obj/item/device/thinktronic_parts/data/task/T = locate(href_list["task"])
					if(!T)	return
					T.status = toWhat
					for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
						if(dept == "General")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status] by [hdd.owner]","Task Manager")
						if(dept == "Security")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status] by [hdd.owner]","Security Task Manager")
						if(dept == "Engineering")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status] by [hdd.owner]","Engineering Task Manager")
						if(dept == "Medbay")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status] by [hdd.owner]","Medbay Task Manager")
						if(dept == "Research")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status] by [hdd.owner]","Research Task Manager")
						if(dept == "Cargo Bay")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status] by [hdd.owner]","Cargo Bay Task Manager")
						break
					PDA.attack_self(usr)
			if("ClearTask")
				var/obj/item/device/thinktronic_parts/data/task/task = locate(href_list["target"])
				for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
					if(dept == "General")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","Task Manager")
					if(dept == "Security")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","Security Task Manager")
					if(dept == "Engineering")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","Engineering Task Manager")
					if(dept == "Medbay")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","Medbay Task Manager")
					if(dept == "Research")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","Research Task Manager")
					if(dept == "Cargo Bay")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","Cargo Bay Task Manager")
					break
				qdel(task)
				PDA.attack_self(usr)
			if("NewTask")
				var/obj/item/device/thinktronic_parts/data/task/newtask = new /obj/item/device/thinktronic_parts/data/task(server)
				var/t = input(usr, "Please enter task title", name, null) as text
				t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
				newtask.taskmsg = t
				newtask.dept = dept
				var/detail = input(usr, "Please enter task detail", name, null) as text
				detail = copytext(sanitize(detail), 1, MAX_MESSAGE_LEN)
				newtask.taskdetail = detail
				newtask.assignedby = "[hdd.owner] ([hdd.ownjob])"
				for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
					if(dept == "General")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","Task Manager")
					if(dept == "Security")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","Security Task Manager")
					if(dept == "Engineering")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","Engineering Task Manager")
					if(dept == "Medbay")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","Medbay Task Manager")
					if(dept == "Research")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","Research Task Manager")
					if(dept == "Cargo Bay")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","Cargo Bay Task Manager")
					break
				PDA.attack_self(usr)
			if("NewRequest")
				var/obj/item/device/thinktronic_parts/data/task/newtask = new /obj/item/device/thinktronic_parts/data/task(server)
				var/t = input(usr, "Please enter message", name, null) as text
				t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
				newtask.taskmsg = t
				var/detail = input(usr, "Please enter request detail", name, null) as text
				detail = copytext(sanitize(detail), 1, MAX_MESSAGE_LEN)
				newtask.taskdetail = detail
				var/selectdept = input("Who would you like to assign it to?", "Input") as anything in list("General","Security", "Engineering", "Medbay", "Research", "Cargo Bay")
				newtask.dept = selectdept
				newtask.request = 1
				newtask.assignedby = "[hdd.owner] ([hdd.ownjob])"
				for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
					if(dept == "General")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [usr]","Task Manager")
					if(dept == "Security")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [usr]","Security Task Manager")
					if(dept == "Engineering")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [usr]","Engineering Task Manager")
					if(dept == "Medbay")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [usr]","Medbay Task Manager")
					if(dept == "Research")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [usr]","Research Task Manager")
					if(dept == "Cargo Bay")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [usr]","Cargo Bay Task Manager")
					break
				PDA.attack_self(usr)


/obj/item/device/thinktronic_parts/program/general/taskmanager/sec
	name = "Security Task Manager"
	dept = "Security"
/obj/item/device/thinktronic_parts/program/general/taskmanager/engineering
	name = "Engineering Task Manager"
	dept = "Engineering"
/obj/item/device/thinktronic_parts/program/general/taskmanager/medbay
	name = "Medbay Task Manager"
	dept = "Medbay"
/obj/item/device/thinktronic_parts/program/general/taskmanager/science
	name = "Research Task Manager"
	dept = "Research"
/obj/item/device/thinktronic_parts/program/general/taskmanager/cargo
	name = "Cargo Bay Task Manager"
	dept = "Cargo Bay"
