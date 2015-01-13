var/global/list/obj/machinery/nanonet_server/nanonet_servers = list()
var/global/list/obj/machinery/nanonet_router/nanonet_routers = list()

/obj/machinery/nanonet_server
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "server"
	name = "NanoNet Server"
	density = 1
	anchored = 1.0
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 100

	var/active = 1

/obj/machinery/nanonet_server/New()
	nanonet_servers += src
	new /obj/item/device/thinktronic_parts/nanostore/(src)
	..()
	return

/obj/machinery/nanonet_server/Destroy()
	nanonet_servers -= src
	..()
	return

/obj/machinery/nanonet_server/proc/SendAlert(var/alerttext, var/app, var/donotskip)
	if(active)
		for(var/obj/item/device/thinktronic/devices in thinktronic_devices)
			if(!devices.HDD) continue
			if(!devices.network()) continue
			var/obj/item/device/thinktronic_parts/core/hdd = devices.HDD
			var/obj/item/device/thinktronic/PDA = hdd.loc // variable for interacting with the Device itself
			if(!hdd.neton) continue
			if(!hdd.owner) continue
			for(var/obj/item/device/thinktronic_parts/program/P in hdd)
				if(P.name == app)
					if(P.alerts)
						var/mob/living/L = null
						if(devices.loc && isliving(devices.loc))
							L = devices.loc
						if (PDA.volume)
							playsound(devices.loc, 'sound/machines/twobeep.ogg', 50, 1)
						var/alertfulltext = "[P.name] - \"[alerttext]\""
						var/exists = 0
						for (var/mob/O in hearers(3, devices.loc))
							if(PDA.volume == 1)
								O.show_message(text("\icon[devices] *[hdd.ttone]*"))
							if(PDA.volume == 2)
								if(PDA.volume) O.show_message(text("\icon[devices] *[hdd.ttone]*"))
						for (var/mob/O in hearers(1, devices.loc))
							if(PDA.devicetype == "Laptop")
								if(!hdd.activeprog)
									O.show_message(text("\icon[devices] <b>Alert</b> - [alertfulltext]"))
								if(hdd.activeprog)
									if(!hdd.activeprog.name == app || donotskip)
										O.show_message(text("\icon[devices] <b>Alert</b> - [alertfulltext]"))
						if (PDA.devicetype == "Tablet")
							if(!hdd.activeprog)
								L << "\icon[devices] <b>Alert</b> - [alertfulltext]"
							if(hdd.activeprog)
								if(!hdd.activeprog.name == app || donotskip)
									L << "\icon[devices] <b>Alert</b> - [alertfulltext]"
								else

						for(var/obj/item/device/thinktronic_parts/data/alert/alert in hdd)
							if(alert.alertmsg == "[alertfulltext]")
								exists = 1
								if(hdd.activeprog)
									if(hdd.activeprog.name == app)
										if(!PDA.ForceRefresh())
											PDA.alertnotif = 1
											PDA.alerted()
									else
										PDA.alertnotif = 1
										PDA.alerted()
								else
									PDA.alertnotif = 1
									PDA.alerted()
								break
						if(!exists)
							var/obj/item/device/thinktronic_parts/data/alert/alert = new /obj/item/device/thinktronic_parts/data/alert(hdd)
							alert.alertmsg = "[alertfulltext]"
							if(hdd.activeprog)
								if(hdd.activeprog.name == app)
									if(!donotskip) qdel(alert)
									if(!PDA.ForceRefresh())
										if(!donotskip) PDA.alertnotif = 1
										if(!donotskip) PDA.alerted()
								else
									PDA.alertnotif = 1
									PDA.alerted()
							else
								PDA.alertnotif = 1
								PDA.alerted()
					if(!P.alerts)
						if(hdd.activeprog)
							if(hdd.activeprog.name == app)
								PDA.ForceRefresh()

/obj/machinery/nanonet_server/proc/SendAlertSolo(var/alerttext, var/device)
	if(active)
		for(var/obj/item/device/thinktronic/devices in thinktronic_devices)
			if(!devices.HDD) continue
			if(!devices.network()) continue
			var/obj/item/device/thinktronic_parts/core/hdd = devices.HDD
			var/obj/item/device/thinktronic/PDA = hdd.loc // variable for interacting with the Device itself
			if(!hdd.neton) continue
			if(!hdd.owner) continue
			if(devices.device_ID == device)
				var/mob/living/L = null
				if(devices.loc && isliving(devices.loc))
					L = devices.loc
				if (PDA.volume)
					playsound(devices.loc, 'sound/machines/twobeep.ogg', 50, 1)
				var/alertfulltext = "\"[alerttext]\""
				var/exists = 0
				for (var/mob/O in hearers(3, devices.loc))
					if(PDA.volume == 1)
						O.show_message(text("\icon[devices] *[hdd.ttone]*"))
					if(PDA.volume == 2)
						if(PDA.volume) O.show_message(text("\icon[devices] *[hdd.ttone]*"))
				for (var/mob/O in hearers(1, devices.loc))
					if(PDA.devicetype == "Laptop")
						O.show_message(text("\icon[devices] <b>Alert</b> - [alertfulltext]"))
				if (PDA.devicetype == "Tablet") L << "\icon[devices] <b>Alert</b> - [alertfulltext]"
				for(var/obj/item/device/thinktronic_parts/data/alert/alert in hdd)
					if(alert.alertmsg == "[alertfulltext]")
						exists = 1
						break
				if(!exists)
					var/obj/item/device/thinktronic_parts/data/alert/alert = new /obj/item/device/thinktronic_parts/data/alert(hdd)
					alert.alertmsg = "[alertfulltext]"
					PDA.alertnotif = 1
					PDA.alerted()

/obj/machinery/nanonet_server/proc/SendAlertAll(var/alerttext)
	if(active)
		for(var/obj/item/device/thinktronic/devices in thinktronic_devices)
			if(!devices.HDD) continue
			if(!devices.network()) continue
			var/obj/item/device/thinktronic_parts/core/hdd = devices.HDD
			var/obj/item/device/thinktronic/PDA = hdd.loc // variable for interacting with the Device itself
			if(!hdd.neton) continue
			if(!hdd.owner) continue
			var/mob/living/L = null
			if(devices.loc && isliving(devices.loc))
				L = devices.loc
			if (PDA.volume)
				playsound(devices.loc, 'sound/machines/twobeep.ogg', 50, 1)
			var/alertfulltext = "\"[alerttext]\""
			var/exists = 0
			for (var/mob/O in hearers(3, devices.loc))
				if(PDA.volume == 1)
					O.show_message(text("\icon[devices] *[hdd.ttone]*"))
				if(PDA.volume == 2)
					if(PDA.volume) O.show_message(text("\icon[devices] *[hdd.ttone]*"))
			for (var/mob/O in hearers(1, devices.loc))
				if(PDA.devicetype == "Laptop")
					O.show_message(text("\icon[devices] <b>Alert</b> - [alertfulltext]"))
			if (PDA.devicetype == "Tablet") L << "\icon[devices] <b>Alert</b> - [alertfulltext]"
			for(var/obj/item/device/thinktronic_parts/data/alert/alert in hdd)
				if(alert.alertmsg == "[alertfulltext]")
					exists = 1
					break
			if(!exists)
				var/obj/item/device/thinktronic_parts/data/alert/alert = new /obj/item/device/thinktronic_parts/data/alert(hdd)
				alert.alertmsg = "[alertfulltext]"
				PDA.alertnotif = 1
				PDA.alerted()




/obj/machinery/nanonet_server/process()
	if(active && (stat & (BROKEN|NOPOWER)))
		active = 0
		return
	update_icon()
	return

/obj/machinery/nanonet_server/attack_hand(user as mob)
	user << "You toggle the NanoNet server from [active ? "On" : "Off"] to [active ? "Off" : "On"]"
	active = !active
	update_icon()

	return

/obj/machinery/nanonet_server/update_icon()
	if((stat & (BROKEN|NOPOWER)))
		icon_state = "server-nopower"
	else if (!active)
		icon_state = "server-off"
	else
		icon_state = "server-on"

	return

/obj/machinery/nanonet_router
	icon = 'icons/obj/objects.dmi'
	icon_state = "oldshieldoff"
	name = "NanoNet Router"
	anchored = 1
	var/active = 1

	off
		active = 0

/obj/machinery/nanonet_router/New()
	nanonet_routers += src
	..()
	return

/obj/machinery/nanonet_router/Destroy()
	nanonet_routers -= src
	..()
	return

/obj/machinery/nanonet_router/attack_hand(user as mob)
	user << "You toggle the NanoNet router from [active ? "On" : "Off"] to [active ? "Off" : "On"]"
	active = !active
	update_icon()

	return

/obj/machinery/nanonet_router/update_icon()
	if((stat & (BROKEN|NOPOWER)))
		icon_state = "oldshieldoff"
	else if (!active)
		icon_state = "oldshieldoff"
	else
		icon_state = "oldshieldon"

	return

/obj/machinery/nanonet_router/process()
	if(active && (stat & (BROKEN|NOPOWER)))
		active = 0
		return
	update_icon()
	return

/obj/item/device/thinktronic_parts/nanostore/
	name = "NanoStore"

	New()
		//downloads
		new /obj/item/device/thinktronic_parts/nanonet/store_items/timer(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/notekeeper(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/ntrc(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/taskmanager(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/GPS(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/theoriontrail(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/spacebattle(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/cubanpete(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/enginebuddy(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/honk(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/crewmanifest(src)


/obj/item/device/thinktronic_parts/nanonet/
	name = "NanoNet"

//server//
/obj/item/device/thinktronic_parts/nanonet/managerserver/
	name = "Management Server"
	var/department = "none"
	var/list/users = list()

//NanoStore items//

/obj/item/device/thinktronic_parts/nanonet/store_items/
	name = "item name"
	desc = "item description"
	var/item = null
	var/price = 0

/obj/item/device/thinktronic_parts/nanonet/store_items/timer
	name = "Timer"
	desc = "Stopwatch for your device"
	item = /obj/item/device/thinktronic_parts/program/general/timer
	price = 10

/obj/item/device/thinktronic_parts/nanonet/store_items/GPS
	name = "Global Positioning System"
	desc = "Locate yourself"
	item = /obj/item/device/thinktronic_parts/program/general/GPS
	price = 10

/obj/item/device/thinktronic_parts/nanonet/store_items/notekeeper
	name = "NoteKeeper Pro"
	desc = "Write documents and share them with your friends and family!"
	item = /obj/item/device/thinktronic_parts/program/general/notekeeper
	price = 10

/obj/item/device/thinktronic_parts/nanonet/store_items/ntrc
	name = "Nanotrasen Relay Chat"
	desc = "Create and participate in relay chats"
	item = /obj/item/device/thinktronic_parts/program/general/chatroom
	price = 10

/obj/item/device/thinktronic_parts/nanonet/store_items/taskmanager
	name = "General Task Manager"
	desc = "Keep up with tasks and jobs"
	item = /obj/item/device/thinktronic_parts/program/general/taskmanager
	price = 10

/obj/item/device/thinktronic_parts/nanonet/store_items/theoriontrail
	name = "The Orion Trail"
	desc = "You start out with four people, 80 food, 60 fuel, and one each of engine parts, hull panels and electronics. Your goal is to make it to Orion."
	item = /obj/item/device/thinktronic_parts/program/general/theoriontrail
	price = 10

/obj/item/device/thinktronic_parts/nanonet/store_items/spacebattle
	name = "Space Battle"
	desc = "You and your CPU-controlled opponent in a RPG styled battle. Oh my!"
	item = /obj/item/device/thinktronic_parts/program/general/spacebattle
	price = 10

/obj/item/device/thinktronic_parts/nanonet/store_items/cubanpete
	name = "Outbomb Cuban Pete"
	desc = "Can you Outbomb Cuban Pete?"
	item = /obj/item/device/thinktronic_parts/program/general/spacebattle/cubanpete
	price = 30

/obj/item/device/thinktronic_parts/nanonet/store_items/enginebuddy
	name = "Engine Buddy"
	desc = "Interactive app helps you setup the engine!"
	item = /obj/item/device/thinktronic_parts/program/eng/enginebuddy
	price = 10

/obj/item/device/thinktronic_parts/nanonet/store_items/honk
	name = "HONK!"
	desc = "HONK!"
	item = /obj/item/device/thinktronic_parts/program/general/honk
	price = 25

/obj/item/device/thinktronic_parts/nanonet/store_items/crewmanifest
	name = "Crew Manifest"
	desc = "A list of everyone on the station"
	item = /obj/item/device/thinktronic_parts/program/general/crewmanifest
	price = 25

// Allows you to monitor messages that passes the server.




/obj/machinery/computer/thinktronic_monitor
	name = "ThinkTronic Server console"
	desc = "Used to administrate the crew's ThinkTronic server"
	icon_state = "comm_logs"
	circuit = /obj/item/weapon/circuitboard/thinktronic_monitor
	//Server linked to.
	var/obj/machinery/nanonet_server/linkedServer = null
	var/mode = 1

	initialize()
		//Is the server isn't linked to a server, and there's a server available, default it to the first one in the list.
		if(!linkedServer)
			for(var/obj/machinery/nanonet_server/server in nanonet_servers)
				linkedServer = server
				break
		return
	attack_ai(var/mob/user as mob)
		src.attack_hand(user)
		return

	attack_paw(var/mob/user as mob)
		src.attack_hand(user)
		return

	attack_hand(var/mob/user as mob)
		if(..())
			return
		if(!linkedServer)
			usr << "Locating NanoNet server..."
			for(var/obj/machinery/nanonet_server/server in nanonet_servers)
				linkedServer = server
				usr << "Server found..."
				break
			return
		user.set_machine(src)
		var/dat = ""
		dat += {"ThinkTronic Server is <A href='?src=\ref[src];choice=active'>[src.linkedServer && src.linkedServer.active ? "<font color='green'>\[On\]</font>":"<font color='red'>\[Off\]</font>"]</a></h4>"}
		if(linkedServer.active)
			dat += {"<br><a href='byond://?src=\ref[src];choice=alert'>Mass Alert</a> <a href='byond://?src=\ref[src];choice=NewTask'>Create Task</a><hr>"}
			if(mode == 0)
				dat += "<div class='statusDisplay'><center>Mode: <a href='byond://?src=\ref[src];choice=Mode'>Tasks</a></center></div>"
				for(var/obj/item/device/thinktronic_parts/data/task/task in linkedServer)
					dat += "<div class='statusDisplay'>"
					dat += {"<A href='?src=\ref[src];choice=ClearTask;target=\ref[task]'> <b>X</b> </a><br>"}
					dat += {"<b><u>[task.taskmsg]</b></u> [task.request ? "(Request)" : ""]<br>"}
					dat += {"Detail: [task.taskdetail]<br>"}
					dat += {"Assigned By: [task.assignedby]<br>"}
					dat += {"Assigned To: [task.dept]<br>"}
					dat += {"<a href='byond://?src=\ref[src];choice=EditTask;what=change_setting;task=\ref[task]'>[task.status]</a><br>"}
					dat += "</div>"
			if(mode == 1)
				dat += "<div class='statusDisplay'><center>Mode: <a href='byond://?src=\ref[src];choice=Mode'>Devices</a></center></div>"
				for(var/obj/item/device/thinktronic/devices in thinktronic_devices)
					var/obj/item/device/thinktronic_parts/core/D = devices.HDD
					if(!D) continue
					if(D.owner)
						for(var/obj/item/device/thinktronic_parts/program/general/hackingtools/PRG in D)
							continue
						for(var/obj/item/device/thinktronic_parts/program/sec/percimplants/PRG in D)
							continue
						dat += {"[D.owner] - [D.ownjob]<br>"}
						dat += {"Device: [devices.devicetype]<br>"}
						var/appcount= 0
						for(var/obj/item/device/thinktronic_parts/program/P in D)
							appcount++
						dat += {"Storage: [appcount]GB <br>"}
						dat += {"Options: "}
						if(D.banned)
							dat += {"<a href='byond://?src=\ref[src];choice=Ban;target=\ref[devices]'>Unban from Network</a>"}
						else
							dat += {"<a href='byond://?src=\ref[src];choice=alertsolo;target=\ref[devices]'>Alert</a>"}
							dat += {"<a href='byond://?src=\ref[src];choice=Ban;target=\ref[devices]'>Ban from Network</a>"}
						dat += {"<hr>"}
		var/datum/browser/popup = new(usr, "servermanager", "Server manager", 640, 480)
		popup.set_content(dat)
		popup.open()

/obj/machinery/computer/thinktronic_monitor/Topic(href, href_list)
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		//Authenticate
		switch(href_list["choice"])//Now we switch based on choice.
			if("EditTask")
				if(href_list["what"] == "change_setting")
					var/toWhat = input("What do you want to change it to?", "Input") as anything in list("Pending","Accepted", "Denied", "Completed", "Failed")
					var/obj/item/device/thinktronic_parts/data/task/T = locate(href_list["task"])
					if(!T)	return
					T.status = toWhat
					for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
						if(T.dept == "General")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status]","General Task Manager")
						if(T.dept == "Security")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status]","Security Task Manager")
						if(T.dept == "Engineering")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status]","Engineering Task Manager")
						if(T.dept == "Medbay")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status]","Medbay Task Manager")
						if(T.dept == "Research")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status]","Research Task Manager")
						if(T.dept == "Cargo Bay")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status]","Cargo Bay Task Manager")
						break
					if(T.request)
						for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
							for(var/obj/item/device/thinktronic/devices in thinktronic_devices)
								var/obj/item/device/thinktronic_parts/core/D = devices.HDD
								if(!D) continue
								for(var/obj/item/device/thinktronic_parts/data/task/request/req in D)
									if(req.assignedby == "[D.owner] ([D.ownjob])")
										MS.SendAlertSolo("Task Manager - <u><b>[T.taskmsg]</u></b> set to [T.status]",devices.device_ID)
										req.status = T.status
					src.attack_hand(usr)
			if ("Mode")
				mode = !mode
				src.attack_hand(usr)
			if("ClearTask")
				var/obj/item/device/thinktronic_parts/data/task/task = locate(href_list["target"])
				if(!task) return
				for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
					if(task.dept == "General")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted","General Task Manager")
					if(task.dept == "Security")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted","Security Task Manager")
					if(task.dept == "Engineering")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted","Engineering Task Manager")
					if(task.dept == "Medbay")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted","Medbay Task Manager")
					if(task.dept == "Research")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted","Research Task Manager")
					if(task.dept == "Cargo Bay")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted","Cargo Bay Task Manager")
					break
				if(task.request)
					for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
						for(var/obj/item/device/thinktronic/devices in thinktronic_devices)
							var/obj/item/device/thinktronic_parts/core/D = devices.HDD
							if(!D) continue
							for(var/obj/item/device/thinktronic_parts/data/task/request/req in D)
								if(req.assignedby == "[D.owner] ([D.ownjob])")
									MS.SendAlertSolo("Task Manager - <u><b>[task.taskmsg]</u></b> deleted",devices.device_ID)
									req.status = "DELETED"
				qdel(task)
				src.attack_hand(usr)
			if("NewTask")
				var/obj/item/device/thinktronic_parts/data/task/newtask = new /obj/item/device/thinktronic_parts/data/task(linkedServer)
				var/t = input(usr, "Please enter task title", name, null) as text
				t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
				if (!t)
					qdel(newtask)
					return
				newtask.taskmsg = t
				var/detail = input(usr, "Please enter task detail", name, null) as text
				if (!detail)
					qdel(newtask)
					return
				detail = copytext(sanitize(detail), 1, MAX_MESSAGE_LEN)
				var/dept = input("Who would you like to assign it to?", "Input") as anything in list("General","Security", "Engineering", "Medbay", "Research", "Cargo Bay")
				newtask.taskdetail = detail
				newtask.dept = dept
				var/assignedby = "root user"
				newtask.assignedby = assignedby
				for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
					if(dept == "General")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [assignedby]","General Task Manager")
					if(dept == "Security")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [assignedby]","Security Task Manager")
					if(dept == "Engineering")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [assignedby]","Engineering Task Manager")
					if(dept == "Medbay")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [assignedby]","Medbay Task Manager")
					if(dept == "Research")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [assignedby]","Research Task Manager")
					if(dept == "Cargo Bay")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [assignedby]","Cargo Bay Task Manager")
					break
				src.attack_hand(usr)
			if ("alert")
				var/t = input(usr, "Please enter message", name, null) as text
				t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
				if (!t)
					return
				linkedServer.SendAlertAll(t)
			if ("alertsolo")
				var/obj/item/device/thinktronic/P = locate(href_list["target"])
				var/t = input(usr, "Please enter message", name, null) as text
				t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
				if (!t)
					return
				linkedServer.SendAlertSolo(t, P.device_ID)
			if ("active")
				linkedServer.active = !linkedServer.active
				linkedServer.update_icon()
				src.attack_hand(usr)
				return
			if ("Ban")
				var/obj/item/device/thinktronic/P = locate(href_list["target"])
				if(P.HDD)
					if(P.HDD.banned)
						P.HDD.banned = 0
						var/mob/living/L = null
						src.attack_hand(usr)
						if(P.loc && isliving(P.loc))
							L = P.loc
							log_pda("[usr] unblocked [P.HDD.name] from the tablet network")
							L << "\icon[P] <b>You have been unblocked from the ThinkTronic Server</b>"
					else
						P.HDD.banned = 1
						P.HDD.neton = 0
						var/mob/living/L = null
						src.attack_hand(usr)
						if(P.loc && isliving(P.loc))
							L = P.loc
							log_pda("[usr] blocked [P.HDD.name] from the tablet network")
							L << "\icon[P] <b>You have been blocked from the ThinkTronic Server</b>"

/obj/item/weapon/circuitboard/thinktronic_monitor
	name = "circuit board (ThinkTronic Server Monitor)"
	build_path = /obj/machinery/computer/thinktronic_monitor
	origin_tech = "programming=3"
