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
	var/decryptkey = "password"

/obj/machinery/nanonet_server/New()
	nanonet_servers += src
	new /obj/item/device/thinktronic_parts/nanostore/(src)
	..()
	return

/obj/machinery/nanonet_server/Destroy()
	nanonet_servers -= src
	..()
	return

/obj/machinery/nanonet_server/proc/SendAlert(var/alerttext, var/app)
	if(active)
		for(var/obj/item/device/thinktronic/devices in thinktronic_devices)
			if(!devices.HDD) continue
			if(!devices.network()) continue
			var/obj/item/device/thinktronic_parts/HDD/hdd = devices.HDD
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
								O.show_message(text("\icon[devices] *[hdd.ttone]*"))
								O.show_message(text("\icon[devices] <b>Alert</b> - [alertfulltext]"))
						L << "\icon[devices] <b>Alert</b> - [alertfulltext]"
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
			var/obj/item/device/thinktronic_parts/HDD/hdd = devices.HDD
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
					O.show_message(text("\icon[devices] *[hdd.ttone]*"))
					O.show_message(text("\icon[devices] <b>Alert</b> - [alertfulltext]"))
			L << "\icon[devices] <b>Alert</b> - [alertfulltext]"
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
		new /obj/item/device/thinktronic_parts/nanonet/store_items/notekeeper(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/taskmanager(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/theoriontrail(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/spacebattle(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/setstatus(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/custodiallocator(src)
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

/obj/item/device/thinktronic_parts/nanonet/store_items/notekeeper
	name = "NoteKeeper Pro"
	desc = "Write documents and share them with your friends and family!"
	item = /obj/item/device/thinktronic_parts/program/general/notekeeper
	price = 10

/obj/item/device/thinktronic_parts/nanonet/store_items/taskmanager
	name = "Task Manager"
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
	desc = "You and your CPU-controlled opponent in a RPG styled battle. oh my!"
	item = /obj/item/device/thinktronic_parts/program/general/spacebattle
	price = 10

/obj/item/device/thinktronic_parts/nanonet/store_items/setstatus
	name = "Station Display"
	desc = "set the various screens on the station to whatever you wish!"
	item = /obj/item/device/thinktronic_parts/program/general/setstatus
	price = 100

/obj/item/device/thinktronic_parts/nanonet/store_items/custodiallocator
	name = "Custodial Locator"
	desc = "Locate your mop and bucket"
	item = /obj/item/device/thinktronic_parts/program/general/custodiallocator
	price = 10

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
		user.set_machine(src)
		var/dat = ""
		dat += {"ThinkTronic Server is <A href='?src=\ref[src];choice=active'>[src.linkedServer && src.linkedServer.active ? "<font color='green'>\[On\]</font>":"<font color='red'>\[Off\]</font>"]</a></h4><br><a href='byond://?src=\ref[src];choice=alert'>Mass Alert</a><hr>"}
		for(var/obj/item/device/thinktronic/devices in thinktronic_devices)
			var/obj/item/device/thinktronic_parts/HDD/D = devices.HDD
			if(!D) continue
			if(devices.network() && D.owner)
				dat += {"[D.owner] - [D.ownjob]<br>"}
				dat += {"Device: [devices.devicetype]<br>"}
				dat += {"Storage: [D.contents.len]GB <br>"}
				for(var/obj/item/device/thinktronic_parts/program/general/hackingtools/PRG in D)
					dat += {"-Unauthorized Application Detected: [PRG.name]-<br>"}
					break
				dat += {"Options: "}
				dat += {"<a href='byond://?src=\ref[src];choice=Ban;target=\ref[devices]'>Ban from Network</a>"}
				dat += {"<hr>"}
		var/datum/browser/popup = new(usr, "servermanager", "Server manager", 640, 480)
		popup.set_content(dat)
		popup.open()


/obj/machinery/computer/thinktronic_monitor/Topic(href, href_list)
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		//Authenticate
		switch(href_list["choice"])//Now we switch based on choice.
			if ("alert")
				var/t = input(usr, "Please enter message", name, null) as text
				t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
				if (!t)
					return
				linkedServer.SendAlertAll(t)
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
						if(P.loc && isliving(P.loc))
							L = P.loc
							log_pda("[usr] unblocked [P.HDD.name] from the tablet network")
							L << "\icon[P] <b>You have been unblocked from the ThinkTronic Server</b>"
					else
						P.HDD.banned = 1
						P.HDD.neton = 0
						var/mob/living/L = null
						if(P.loc && isliving(P.loc))
							L = P.loc
							log_pda("[usr] blocked [P.HDD.name] from the tablet network")
							L << "\icon[P] <b>You have been blocked from the ThinkTronic Server</b>"

/obj/item/weapon/circuitboard/thinktronic_monitor
	name = "circuit board (ThinkTronic Server Monitor)"
	build_path = /obj/machinery/computer/thinktronic_monitor
	origin_tech = "programming=3"
