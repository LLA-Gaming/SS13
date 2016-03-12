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
	var/list/convos = list()
	var/active = 1
	var/list/programs = list()
	var/list/assignments = list()

/obj/machinery/nanonet_server/New()
	nanonet_servers += src
	for(var/x in typesof(/datum/program/))
		var/datum/program/A = new x(src)
		if(!A.app_id)
			del(A)
			continue
		programs.Add(A)
	..()
	return

/obj/machinery/nanonet_server/Destroy()
	nanonet_servers -= src
	..()
	return

/obj/machinery/nanonet_server/process()
	if(active && (stat & (BROKEN|NOPOWER|EMPED)))
		update_icon()
		return
	update_icon()
	return

/obj/machinery/nanonet_server/emp_act(severity)
	if(prob(100/severity))
		if(!(stat & EMPED))
			stat |= EMPED
			var/duration = (300 * 10)/severity
			spawn(rand(duration - 20, duration + 20)) // Takes a long time for the machines to reboot.
				stat &= ~EMPED
	..()

/obj/machinery/nanonet_server/attack_hand(user as mob)
	user << "You toggle the NanoNet server from [active ? "On" : "Off"] to [active ? "Off" : "On"]"
	active = !active
	update_icon()

	return

/obj/machinery/nanonet_server/update_icon()
	if((stat & (BROKEN|NOPOWER|EMPED)))
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

/obj/machinery/computer/thinktronic_monitor
	name = "ThinkTronic Server console"
	desc = "Used to administrate the crew's ThinkTronic server"
	icon_state = "comm_logs"
	circuit = /obj/item/weapon/circuitboard/thinktronic_monitor
	//Server linked to.
	var/obj/machinery/nanonet_server/linkedServer = null
	var/datum/tablet_data/conversation/loaded_convo = null
	var/spamcheck = 0

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

		if(loaded_convo)
			dat += "<a href='byond://?src=\ref[src];choice=Close Chat'>Close</a><br>"
			dat += "<h3>[loaded_convo.name]</a> - [loaded_convo.users.len] users in this chat</h3>"
			dat += "<div class='statusDisplay'>"
			dat += "[loaded_convo.raw_log]"
			dat += "</div>"
		else
			dat += "<h3>NanoNet Messenger Logs</h3>"
			dat += "<div class='statusDisplay'>"
			for(var/datum/tablet_data/conversation/C in linkedServer.convos)
				dat += "[C.name] - <a href='byond://?src=\ref[src];choice=Open Chat;target=\ref[C]'>Open</a><br>"
			dat += "</div>"
			dat += "<h3>Network Users - <a href='byond://?src=\ref[src];choice=Mass Alert'>Alert All</a></h3>"
			for(var/obj/item/device/tablet/T in tablets_list)
				if(T.core && T.core.owner)
					if(!T.core.neton) continue
					if(istype(T,/obj/item/device/tablet/syndi)) continue
					dat += "[T.owner] ([T.ownjob]) - <a href='byond://?src=\ref[src];choice=Alert;target=\ref[T]'>Alert</a> - <a href='byond://?src=\ref[src];choice=Ban;target=\ref[T]'>[T.banned ? "Unban" : "Ban"]</a><br>"

		var/datum/browser/popup = new(usr, "servermanager", "Server manager", 640, 480)
		popup.set_content(dat)
		popup.open()
		onclose(user, "servermanager")

	Topic(href, href_list)
		if(..())
			return
		switch(href_list["choice"])
			if("Open Chat")
				var/datum/tablet_data/conversation/C = locate(href_list["target"])
				loaded_convo = C
			if("Close Chat")
				loaded_convo = null
			if("Ban")
				var/obj/item/device/tablet/T = locate(href_list["target"])
				T.banned = !T.banned
				T.alert_self("Tablet Network:","You have been [T.banned ? "Banned" : "Unbanned"] from the tablet network!","settings")
			if("Alert")
				spamcheck = 1
				var/obj/item/device/tablet/T = locate(href_list["target"])
				var/t = copytext(sanitize(input("Alert", "Alert", null, null)  as text),1,MAX_MESSAGE_LEN)
				if(t)
					T.alert_self("Alert:","[t]")
				spamcheck = 0
			if("Mass Alert")
				spamcheck = 1
				var/t = copytext(sanitize(input("Mass Alert:", "Alert", null, null)  as text),1,MAX_MESSAGE_LEN)
				if(t)
					for(var/obj/item/device/tablet/T in tablets_list)
						if(T.core && T.core.owner)
							T.alert_self("Alert:","[t]")
				spamcheck = 0

		src.updateUsrDialog()
		return
/obj/item/weapon/circuitboard/thinktronic_monitor
	name = "circuit board (ThinkTronic Server Monitor)"
	build_path = /obj/machinery/computer/thinktronic_monitor
	origin_tech = "programming=3"


