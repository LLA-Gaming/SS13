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
	decryptkey = GenerateKey()
	new /obj/item/device/thinktronic_parts/nanostore/(src)
	..()
	return

/obj/machinery/nanonet_server/Destroy()
	nanonet_servers -= src
	..()
	return

/obj/machinery/nanonet_server/proc/GenerateKey()
	//Feel free to move to Helpers.
	var/newKey
	newKey += pick("the", "if", "of", "as", "in", "a", "you", "from", "to", "an", "too", "little", "snow", "dead", "drunk", "rosebud", "duck", "al", "le")
	newKey += pick("diamond", "beer", "mushroom", "assistant", "clown", "captain", "twinkie", "security", "nuke", "small", "big", "escape", "yellow", "gloves", "monkey", "engine", "nuclear", "ai")
	newKey += pick("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	return newKey

/obj/machinery/nanonet_server/proc/SendAlert(var/alerttext, var/obj/item/device/thinktronic_parts/program/P)
	if(active)
		for(var/obj/item/device/thinktronic/devices in thinktronic_devices)
			if(!devices.HDD) continue
			if(!devices.network()) continue
			var/obj/item/device/thinktronic_parts/HDD/hdd = devices.HDD
			if(!hdd.neton) continue
			if(!hdd.owner) continue
			for(P in hdd)
				if(P.alerts)
					var/mob/living/L = null
					if(devices.loc && isliving(devices.loc))
						L = devices.loc
					if (hdd.volume == 1)
						playsound(devices.loc, 'sound/machines/twobeep.ogg', 50, 1)
					for (var/mob/O in hearers(3, devices.loc))
						if(hdd.volume == 1)
							O.show_message(text("\icon[devices] *[hdd.ttone]*"))
					var/alertfulltext = "[P.name] - \"[alerttext]\""
					var/exists = 0
					L << "\icon[devices] <b>Alert</b> - [alertfulltext]"
					for(var/obj/item/device/thinktronic_parts/data/alert/alert in hdd)
						if(alert.alertmsg == "[alertfulltext]")
							exists = 1
							break
					if(!exists)
						var/obj/item/device/thinktronic_parts/data/alert/alert = new /obj/item/device/thinktronic_parts/data/alert(hdd)
						alert.alertmsg = "[alertfulltext]"




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

/obj/item/weapon/paper/nanonet_server_key
	//..()
	name = "NanoNet server decryption key"
	var/obj/machinery/message_server/server = null

/obj/item/weapon/paper/nanonet_server_key/New()
	..()
	spawn(10)
		if(nanonet_servers)
			for(var/obj/machinery/nanonet_server/server in nanonet_servers)
				if(!isnull(server))
					if(!isnull(server.decryptkey))
						info = "<center><h2>Daily Key Reset</h2></center><br>The new NanoNet server monitor key is '[server.decryptkey]'.<br>Please keep this a secret and away from the clown.<br>If necessary, change the password to a more secure one."
						info_links = info
						overlays += "paper_words"
						break

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
		new /obj/item/device/thinktronic_parts/nanonet/store_items/spacebattle(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/theoriontrail(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/notekeeper(src)
		new /obj/item/device/thinktronic_parts/nanonet/store_items/magic8ball(src)

/obj/item/device/thinktronic_parts/nanonet/
	name = "NanoNet"


//NanoStore items//

/obj/item/device/thinktronic_parts/nanonet/store_items/
	name = "item name"
	desc = "item description"
	var/item = null
	var/price = 0

/obj/item/device/thinktronic_parts/nanonet/store_items/notekeeper
	name = "NoteKeeper Pro"
	desc = "TODO: desc"
	item = /obj/item/device/thinktronic_parts/program/general/notekeeper
	price = 0

/obj/item/device/thinktronic_parts/nanonet/store_items/theoriontrail
	name = "The Orion Trail"
	desc = "TODO: desc"
	item = /obj/item/device/thinktronic_parts/program/general/theoriontrail
	price = 10

/obj/item/device/thinktronic_parts/nanonet/store_items/spacebattle
	name = "Space Battle"
	desc = "TODO: desc"
	item = /obj/item/device/thinktronic_parts/program/general/spacebattle
	price = 10

/obj/item/device/thinktronic_parts/nanonet/store_items/magic8ball
	name = "Magic Space Ball"
	desc = "TODO: desc"
	item = /obj/item/device/thinktronic_parts/program/general/magic8ball
	price = 10

