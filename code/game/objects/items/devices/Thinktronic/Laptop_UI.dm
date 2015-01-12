/obj/item/device/thinktronic/laptop/attack_hand(mob/living/user)
	if(!mounted && !bolted)
		..()
	if(bolted && !mounted)
		usr << "It's bolted to the ground!"
	if(mounted)
		attack_self(usr)

/obj/item/device/thinktronic/laptop/verb_pickup()
	if(mounted && !bolted)
		toggle_mount()
		..()
	if(bolted)
		usr << "It's bolted to the ground!"

/obj/item/device/thinktronic/laptop/attack_self(mob/living/user)
	var/mob/U = user
	user.set_machine(src)
	var/dat = ""
	if(loc == user) return
	if(can_use(U))
		if(active_uplink_check(user))
			return
		if (!HDD)
			dat += "ERROR: No Hard Drive found.  Please insert Hard Drive.<br><br>"
		else
			if(HDD.implantlocked)
				if(!user.check_contents_for(HDD.implantlocked))
					var/datum/effect/effect/system/spark_spread/S = new/datum/effect/effect/system/spark_spread(get_turf(src))
					S.set_up(3, 0, get_turf(src))
					S.start()
					user << "<div class='warning'>The [src] shocks you.</div>"
					user.AdjustWeakened(2)
					return
			if (!HDD.owner)
				dat += "Warning: No owner information entered.  Please swipe card.<br><br>"
			else
				switch (HDD.mode)
					if (0) //Front screen
						if(alertnotif == 1)
							dat += {"
									<div class='statusDisplay'>
									<center>
									<A href='?src=\ref[src];choice=CheckAlerts'>New Alerts</a>
									</center>
									</div>
									"}
						dat += {"
								<div class='statusDisplay'>
								<center>
								Owner: [HDD.owner], [HDD.ownjob]<br>
								ID: <A href='?src=\ref[src];choice=Authenticate'>[id ? "[id.registered_name], [id.assignment]" : "----------"]</A><A href='?src=\ref[src];choice=UpdateInfo'>[id ? "Update Laptop Info" : ""]</A><br>
								[time2text(world.realtime, "MMM DD")] [year_integer+540]<br>[worldtime2text()]<br>
								<A href='?src=\ref[src];choice=files'>File Manager</a> <A href='?src=\ref[src];choice=messenger'>Messenger</a> <A href='?src=\ref[src];choice=downloads'>Downloads</a>
								<br><A href='?src=\ref[src];choice=wallet'>Wallet</a> <A href='?src=\ref[src];choice=store'>NanoStore</a> <A href='?src=\ref[src];choice=CheckAlerts'>Alerts</a> <a href='byond://?src=\ref[src];choice=Settings'>Settings</a>
								"}
						if(HDD.implantlocked == /obj/item/weapon/implant/enforcer) // IF THE TABLET HAS A PERSEUS LOCK
							for(var/obj/machinery/computer/perseus_shuttle_computer/P in world)
								dat += {"<br>Shuttle is [P.locked ? "<b>Locked</b>" : "<b>Unlocked</b>"]"}
								break
						dat += {"
								</center>
								</div>"}
						for(var/obj/item/device/thinktronic_parts/program/PRG in HDD)
							if (PRG.favorite == 1)
								dat += {"<h3>[HDD.primaryname]</h3>"}
								break
						for(var/obj/item/device/thinktronic_parts/program/PRG in HDD)
							if (PRG.favorite == 1)
								dat += {"<A href='?src=\ref[PRG];choice=Open'>[PRG.name]</a><br>"}
						for(var/obj/item/device/thinktronic_parts/program/PRG in HDD)
							if (PRG.favorite == 2)
								dat += {"<h3>[HDD.secondaryname]</h3>"}
								break
						for(var/obj/item/device/thinktronic_parts/program/PRG in HDD)
							if (PRG.favorite == 2)
								dat += {"<A href='?src=\ref[PRG];choice=Open'>[PRG.name]</a><br>"}
						for(var/obj/item/device/thinktronic_parts/program/PRG in HDD)
							if (PRG.favorite == 0 && PRG.utility == 0)
								dat += {"<br>   <A href='?src=\ref[src];choice=allapps'>All Applications</a></font>"}
								break
						dat += {"<h3>Utilities</h3>"}
						for(var/obj/item/device/thinktronic_parts/program/utility/PRG in HDD)
							if(!PRG.togglemode)
								dat += {"<A href='?src=\ref[PRG];choice=Open'>[PRG.name]</a><br>"}
						dat += " Flashlight: <a href='byond://?src=\ref[src];choice=Light'>[fon ? "On" : "Off"]</a><br>"
						dat += " Network: <a href='byond://?src=\ref[src];choice=network'>[HDD.neton ? "Enabled" : "Disabled"]</a>"
					if (1) //All Programs
						dat += {"<a href='byond://?src=\ref[src];choice=Return'>   Return</a>"}
						for(var/obj/item/device/thinktronic_parts/program/sec/PRG in HDD)
							dat += {"<h3>Security Functions</h3>"}
							break
						for(var/obj/item/device/thinktronic_parts/program/sec/PRG in HDD)
							dat += {"<A href='?src=\ref[PRG];choice=Open'>[PRG.name]</a><br>"}
						for(var/obj/item/device/thinktronic_parts/program/eng/PRG in HDD)
							dat += {"<br><h3>Engineering Functions</h3>"}
							break
						for(var/obj/item/device/thinktronic_parts/program/eng/PRG in HDD)
							dat += {"<A href='?src=\ref[PRG];choice=Open'>[PRG.name]</a><br>"}
						for(var/obj/item/device/thinktronic_parts/program/sci/PRG in HDD)
							dat += {"<br><h3>Science Functions</h3>"}
							break
						for(var/obj/item/device/thinktronic_parts/program/sci/PRG in HDD)
							dat += {"<A href='?src=\ref[PRG];choice=Open'>[PRG.name]</a><br>"}
						for(var/obj/item/device/thinktronic_parts/program/medical/PRG in HDD)
							dat += {"<br><h3>Medical Functions</h3>"}
							break
						for(var/obj/item/device/thinktronic_parts/program/medical/PRG in HDD)
							dat += {"<A href='?src=\ref[PRG];choice=Open'>[PRG.name]</a><br>"}
						for(var/obj/item/device/thinktronic_parts/program/cargo/PRG in HDD)
							dat += {"<br><h3>Cargo Functions</h3>"}
							break
						for(var/obj/item/device/thinktronic_parts/program/cargo/PRG in HDD)
							dat += {"<A href='?src=\ref[PRG];choice=Open'>[PRG.name]</a><br>"}
						for(var/obj/item/device/thinktronic_parts/program/general/PRG in HDD)
							dat += {"<br><h3>General Functions</h3>"}
							break
						for(var/obj/item/device/thinktronic_parts/program/general/PRG in HDD)
							dat += {"<A href='?src=\ref[PRG];choice=Open'>[PRG.name]</a><br>"}
						for(var/obj/item/device/thinktronic_parts/program/misc/PRG in HDD)
							dat += {"<br><h3>Misc Functions</h3>"}
							break
						for(var/obj/item/device/thinktronic_parts/program/misc/PRG in HDD)
							dat += {"<A href='?src=\ref[PRG];choice=Open'>[PRG.name]</a><br>"}
					if (2) //Settings
						dat += {"<a href='byond://?src=\ref[src];choice=Return'> Return</a>"}
						dat += {"<br><h3>System Settings</h3>"}
						dat += {"Processor: IntelliTech LW-S<br>"}
						dat += {"GPU: S-Vidya 2554-m<br>"}
						dat += {"System Ram: [ram]GB<br>"}
						dat += {"Core: <a href='byond://?src=\ref[src];choice=EjectHDD'>Eject</a><br>"}
						dat += {"<a href='byond://?src=\ref[src];choice=Ringtone'>Ringtone</a><br>"}
						dat += {"<a href='byond://?src=\ref[src];choice=Sound'>[volume ? "Sound: On" : "Sound: Off"]</a><br>"}
						dat += {"<h3>[HDD.primaryname] Settings - <A href='?src=\ref[src];choice=RenameCategory1'>Rename</a></h3>"}
						for(var/obj/item/device/thinktronic_parts/program/PRG in HDD)
							if (PRG.favorite == 1)
								if (PRG.deletable)
									dat += {"<A href='?src=\ref[src];choice=Delete;target=\ref[PRG]'> <b>X</b> </a>"}
								dat += {"[PRG.name] - "}
								if (!PRG.utility)
									dat += {"<A href='?src=\ref[PRG];choice=Favorite'>Favorite</a>"}
								if (PRG.usealerts)
									dat += {"<A href='?src=\ref[PRG];choice=Alerts'>[PRG.alerts ? "Alerts: On" : "Alerts: Off"]</a>"}
								dat += {"<br>"}
						dat += {"<h3>[HDD.secondaryname] Settings - <A href='?src=\ref[src];choice=RenameCategory2'>Rename</a></h3>"}
						for(var/obj/item/device/thinktronic_parts/program/PRG in HDD)
							if (PRG.favorite == 2)
								if (PRG.deletable)
									dat += {"<A href='?src=\ref[src];choice=Delete;target=\ref[PRG]'> <b>X</b> </a>"}
								dat += {"[PRG.name] - "}
								if (!PRG.utility)
									dat += {"<A href='?src=\ref[PRG];choice=Favorite'>Favorite</a>"}
								if (PRG.usealerts)
									dat += {"<A href='?src=\ref[PRG];choice=Alerts'>[PRG.alerts ? "Alerts: On" : "Alerts: Off"]</a>"}
								dat += {"<br>"}
						dat += {"<h3>Other Applications Settings</h3>"}
						for(var/obj/item/device/thinktronic_parts/program/PRG in HDD)
							if (PRG.favorite == 0)
								if (PRG.deletable && !PRG.utility)
									dat += {"<A href='?src=\ref[src];choice=Delete;target=\ref[PRG]'> <b>X</b> </a>"}
									dat += {"[PRG.name] - "}
									if (!PRG.utility)
										dat += {"<A href='?src=\ref[PRG];choice=Favorite'>Favorite</a>"}
									if (PRG.usealerts)
										dat += {"<A href='?src=\ref[PRG];choice=Alerts'>[PRG.alerts ? "Alerts: On" : "Alerts: Off"]</a>"}
									dat += {"<br>"}
						dat += {"<h3>Utility Settings</h3>"}
						for(var/obj/item/device/thinktronic_parts/program/utility/PRG in HDD)
							if (PRG.favorite == 0)
								if (PRG.deletable)
									dat += {"<A href='?src=\ref[src];choice=Delete;target=\ref[PRG]'> <b>X</b> </a>"}
								dat += {"[PRG.name]"}
								if (!PRG.utility || PRG.usealerts) // Checks to see if the app even has any options
									dat += {" - "}
								if (!PRG.utility)
									dat += {"<A href='?src=\ref[PRG];choice=Favorite'>Favorite</a>"}
								if (PRG.usealerts)
									dat += {"<A href='?src=\ref[PRG];choice=Alerts'>[PRG.alerts ? "Alerts: On" : "Alerts: Off"]</a>"}
								dat += {"<br>"}

					if (3) //Program Displaying
						var/obj/item/device/thinktronic_parts/program/PRG = HDD.activeprog
						if(!PRG)
							HDD.mode = 0
							attack_self(U)
							return
						if(PRG.usealerts)
							dat += {"<a href='byond://?src=\ref[src];choice=Return'>   Return</a><a href='byond://?src=\ref[PRG];choice=Alerts'>[PRG.alerts ? "Alerts: On" : "Alerts: Off"]</a><hr>"}
						else
							dat += {"<a href='byond://?src=\ref[src];choice=Return'>   Return</a><hr>"}
						PRG.use_app()
						dat += PRG.dat
					if (4) //File Manager
						dat += {"<a href='byond://?src=\ref[src];choice=Return'> Return</a>"}
						dat += {"<br>"}
						if(loadeddata)
							dat += "<div class='statusDisplay'>"
							if(loadeddata_photo)
								usr << browse_rsc(loadeddata, "tmp_photo.png")
								dat += "<center><img src='tmp_photo.png' width='192' style='-ms-interpolation-mode:nearest-neighbor' /></center>"
							else
								dat += "[loadeddata]"
							dat += "</div'>"
						else
							dat += {"<h2>File Manager</h2>"}
							for(var/obj/item/device/thinktronic_parts/data/DATA in HDD)
								if(DATA.document || DATA.photo || DATA.convo)
									dat += {"<A href='?src=\ref[src];choice=DeleteData;target=\ref[DATA]'> <b>X</b> </a>"}
									dat += {"[DATA.name]"}
									if (DATA.document)
										dat += {" - <A href='?src=\ref[src];choice=View;target=\ref[DATA]'>View</a>"}
										dat += {" - <A href='?src=\ref[src];choice=Rename;target=\ref[DATA]'>Rename</a>"}
									if (DATA.photo)
										dat += {" - <A href='?src=\ref[src];choice=View;target=\ref[DATA]'>View</a>"}
										dat += {" - <A href='?src=\ref[src];choice=Rename;target=\ref[DATA]'>Rename</a>"}
									if (DATA.convo)
										dat += {" - <A href='?src=\ref[src];choice=View;target=\ref[DATA]'>View</a>"}
										dat += {" - <A href='?src=\ref[src];choice=Rename;target=\ref[DATA]'>Rename</a>"}
									dat += {"<br>"}
					if (5) //Downloads
						dat += {"<a href='byond://?src=\ref[src];choice=Return'> Return</a><hr>"}
						for(var/obj/item/device/thinktronic_parts/data in cart)
							if(data.datatype == "Application")
								dat += {"<A href='?src=\ref[src];choice=CartDel;target=\ref[data]'> <b>X</b> </a>"}
								dat += {"File: [data.name]"}
								if(data.pro)
									dat += {" - (Manager)"}
								dat += {"<br>"}
								dat += {"Type: [data.datatype]<br>"}
								dat += {"Sent By: [data.sentby]<br>"}
								dat += {"<A href='?src=\ref[src];choice=CartSaveApp;target=\ref[data]'>Install Application</a>"}
								dat += {"<hr>"}
							else
								dat += {"<A href='?src=\ref[src];choice=CartDel;target=\ref[data]'> <b>X</b> </a>"}
								dat += {"File: [data.name]<br>"}
								dat += {"Type: [data.datatype]<br>"}
								dat += {"Sent By: [data.sentby]<br>"}
								dat += {"<A href='?src=\ref[src];choice=CartSave;target=\ref[data]'>Save to Core</a>"}
								dat += {"<hr>"}

					if (6) //Wallet
						dat += {"<a href='byond://?src=\ref[src];choice=Return'> Return</a>"}
						dat += {"<br><h3>NanoBank E-Wallet:</h3>"}
						dat += {"Holder: [HDD.owner]<br>"}
						dat += {"Space Cash: $[HDD.cash]<br>"}
						dat += {"Withdraw:"}
						if (HDD.cash>=10)
							dat += " <a href='?src=\ref[src];choice=Withdraw;amount=10'>$10</a>"
						if (HDD.cash>=20)
							dat += " <a href='?src=\ref[src];choice=Withdraw;amount=20'>$20</a>"
						if (HDD.cash>=50)
							dat += " <a href='?src=\ref[src];choice=Withdraw;amount=50'>$50</a>"
						if (HDD.cash>=100)
							dat += " <a href='?src=\ref[src];choice=Withdraw;amount=100'>$100</a>"
						if (HDD.cash>=200)
							dat += " <a href='?src=\ref[src];choice=Withdraw;amount=200'>$200</a>"
						if (HDD.cash>=500)
							dat += " <a href='?src=\ref[src];choice=Withdraw;amount=500'>$500</a>"
						if (HDD.cash>=1000)
							dat += " <a href='?src=\ref[src];choice=Withdraw;amount=1000'>$1000</a>"


					if (7) //Messenger
						dat += {"<a href='byond://?src=\ref[src];choice=Return'> Return</a><br>"}
						unalerted(0,1)
						dat += "<center><a href='byond://?src=\ref[src];choice=ToggleMessenger'>[HDD.messengeron ? "Messenger: On" : "Messenger: Off"]</a>"
						dat += "<a href='byond://?src=\ref[src];choice=Ringtone'>Ringtone</a></center>"
						var/obj/item/device/thinktronic_parts/data/convo/activechat = HDD.activechat
						if(!activechat)
							for(var/obj/item/device/thinktronic_parts/data/convo/chats in HDD)
								if(chats.activemsg)
									dat += {"<h2>Active Chats</h2>"}
									break
							for(var/obj/item/device/thinktronic_parts/data/convo/chats in HDD)
								if(chats.activemsg)
									dat += "<div class='statusDisplay'>"
									dat += {"[chats.activemsg]"}
									dat += "</div>"
							if (network())
								if (HDD.messengeron)
									dat += {"<h2>Users Online:</h2>"}
									dat += "<div class='statusDisplay'>"
									for(var/obj/item/device/thinktronic/devices in thinktronic_devices)
										var/obj/item/device/thinktronic_parts/core/D = devices.HDD
										if(!D) continue
										if(devices.network() && devices.hasmessenger == 1 && D.neton && D.owner && D.messengeron)
											if (devices.device_ID == src.device_ID)	continue
											dat += {" [D.owner] ([D.ownjob]/[devices.devicetype])"}
											dat += {" - "}
											dat += {"<a href='byond://?src=\ref[src];choice=Chat;target=\ref[devices]'>Chat</a>"}
											dat += {"<br>"}
									dat += "</div>"
								else
									dat += {"<br><h2>Messenger is OFF</h2>"}
							else
								dat += {"<br>Error: No connection to the NanoNet"}
						else
							for(var/obj/item/device/thinktronic/devices in thinktronic_devices)
								var/obj/item/device/thinktronic_parts/core/D = devices.HDD
								if(!D) continue
								if (HDD.messengeron)
									if (devices.device_ID == activechat.device_ID)
										dat += {"<br><h2>Chat with [D.owner]([D.ownjob]):</h2>"}
										dat += {"<a href='byond://?src=\ref[src];choice=Message;target=\ref[devices]'>Send Message</a> <a href='byond://?src=\ref[src];choice=SendFile;target=\ref[devices]'>Send File</a> <a href='byond://?src=\ref[src];choice=SaveLog'>Save Log</a> <a href='byond://?src=\ref[src];choice=ClearConvo;target=\ref[devices]'>End Conversation</a>"}
										dat += "<div class='statusDisplay'>"
										dat += activechat.mlog
										dat += "</div>"
										break
								else
									dat += {"<br><h2>Messenger is OFF</h2>"}
									break
					if (8) //Alerts
						dat += {"<a href='byond://?src=\ref[src];choice=Return'> Return</a> <A href='?src=\ref[src];choice=ClearAllAlert'>Clear All</a><hr>"}
						unalerted(1,0)
						for(var/obj/item/device/thinktronic_parts/data/alert/alert in HDD)
							dat += {"<A href='?src=\ref[src];choice=ClearAlert;target=\ref[alert]'> <b>X</b> </a>"}
							dat += {"[alert.alertmsg]<br>"}

					if (9) //App Store
						dat += {"<a href='byond://?src=\ref[src];choice=Return'> Return</a> Space Cash: $[HDD.cash]<hr>"}
						if(network())
							for(var/obj/machinery/nanonet_server/server in nanonet_servers)
								for(var/obj/item/device/thinktronic_parts/nanostore/store in server)
									for(var/obj/item/device/thinktronic_parts/nanonet/store_items/PRG in store)
										dat += "<div class='statusDisplay'>"
										dat += {"<A href='?src=\ref[src];choice=Buy;target=\ref[PRG]'>[PRG.name]</a> - $[PRG.price]<br>"}
										dat += {"Description: [PRG.desc]"}
										dat += "</div>"
						else
							dat += {"<br>Error: No connection to the NanoNet"}
					else
						dat += {"<a href='byond://?src=\ref[src];choice=Return'> Return</a>"}
						dat += {"ERROR: 404 Not Found."}
		popup = new(user, "thinktronic", "[src]")
		popup.set_content(dat)
		popup.title = {"<div align="left">[version]</div><div align="right"><a href='byond://?src=\ref[src];choice=Refresh'>Refresh</a><a href='byond://?src=\ref[src];choice=Close'>Close</a></div>"}
		popup.window_options = "window=thinktronic;size=640x480;border=0;can_resize=1;can_close=0;can_minimize=0"
		popup.open()
		return
	else
		U.set_machine(src)
		U << browse(null, "window=thinktronic")

/obj/item/device/thinktronic/laptop/Topic(href, href_list)
	var/mob/U = usr
	if(!mounted)
		popup.close()
		U.unset_machine()
		U << browse(null, "window=thinktronic")
		if(HDD)
			HDD.activechat = null
		loadeddata = null
		loadeddata_photo = null
		return
	if(can_use(U)) //Why reinvent the wheel? There's a proc that does exactly that.
		add_fingerprint(U)
		U.set_machine(src)
		switch(href_list["choice"])//Now we switch based on choice.
			if ("Close")
				popup.close()
				U.unset_machine()
				U << browse(null, "window=thinktronic")
				if(HDD)
					HDD.activechat = null
					HDD.mode = 0
					HDD.activeprog = null
				loadeddata = null
				loadeddata_photo = null
				return
			if ("Authenticate")//Checks for ID
				id_check(U, 1)
				attack_self(usr)
			if("UpdateInfo")
				if(shared) return
				HDD.ownjob = id.assignment
				update_label()
				attack_self(usr)
			if("Return")//Self explanatory
				if(HDD)
					if(HDD.activechat)
						HDD.activechat = null
						attack_self(usr)
						return
					if(loadeddata)
						loadeddata = null
						attack_self(usr)
						return
					if(loadeddata_photo)
						loadeddata_photo = null
						attack_self(usr)
						return
					if(HDD.activeprog)
						HDD.activeprog = null
						attack_self(usr)
					HDD.mode = 0
				attack_self(usr)
			if("allapps")//Self explanatory
				HDD.mode = 1
				attack_self(usr)
			if("files")
				HDD.mode = 4
				attack_self(usr)
			if("messenger")
				HDD.mode = 7
				attack_self(usr)
			if("downloads")
				HDD.mode = 5
				attack_self(usr)
			if("wallet")
				HDD.mode = 6
				attack_self(usr)
			if("Withdraw")
				var/cash = href_list["amount"]
				if (cash == "10")
					var/obj/item/weapon/spacecash/dosh = new /obj/item/weapon/spacecash/c10(usr.loc)
					if(usr.put_in_hands(dosh) && HDD.cash >= dosh.credits)
						HDD.cash -=10
					else
						usr << "<span class='notice'>You couldn't withdraw because your hands are full.</span>"
						qdel(dosh)
						attack_self(usr)
				if (cash == "20")
					var/obj/item/weapon/spacecash/dosh = new /obj/item/weapon/spacecash/c20(usr.loc)
					if(usr.put_in_hands(dosh) && HDD.cash >= dosh.credits)
						HDD.cash -=20
					else
						usr << "<span class='notice'>You couldn't withdraw because your hands are full.</span>"
						qdel(dosh)
						attack_self(usr)
				if (cash == "50")
					var/obj/item/weapon/spacecash/dosh = new /obj/item/weapon/spacecash/c50(usr.loc)
					if(usr.put_in_hands(dosh) && HDD.cash >= dosh.credits)
						HDD.cash -=50
					else
						usr << "<span class='notice'>You couldn't withdraw because your hands are full.</span>"
						qdel(dosh)
						attack_self(usr)
				if (cash == "100")
					var/obj/item/weapon/spacecash/dosh = new /obj/item/weapon/spacecash/c100(usr.loc)
					if(usr.put_in_hands(dosh) && HDD.cash >= dosh.credits)
						HDD.cash -=100
					else
						usr << "<span class='notice'>You couldn't withdraw because your hands are full.</span>"
						qdel(dosh)
						attack_self(usr)
				if (cash == "200")
					var/obj/item/weapon/spacecash/dosh = new /obj/item/weapon/spacecash/c200(usr.loc)
					if(usr.put_in_hands(dosh) && HDD.cash >= dosh.credits)
						HDD.cash -=200
					else
						usr << "<span class='notice'>You couldn't withdraw because your hands are full.</span>"
						qdel(dosh)
						attack_self(usr)
				if (cash == "500")
					var/obj/item/weapon/spacecash/dosh = new /obj/item/weapon/spacecash/c500(usr.loc)
					if(usr.put_in_hands(dosh) && HDD.cash >= dosh.credits)
						HDD.cash -=500
					else
						usr << "<span class='notice'>You couldn't withdraw because your hands are full.</span>"
						qdel(dosh)
						attack_self(usr)
				if (cash == "1000")
					var/obj/item/weapon/spacecash/dosh = new /obj/item/weapon/spacecash/c1000(usr.loc)
					if(usr.put_in_hands(dosh) && HDD.cash >= dosh.credits)
						HDD.cash -=1000
					else
						usr << "<span class='notice'>You couldn't withdraw because your hands are full.</span>"
						qdel(dosh)
						attack_self(usr)
				attack_self(usr)
			if("store")
				HDD.mode = 9
				attack_self(usr)
			if("Light")
				if(fon)
					fon = 0
					if(src in U.contents)	U.AddLuminosity(-f_lum)
					else					SetLuminosity(0)
					attack_self(usr)
				else
					fon = 1
					if(src in U.contents)	U.AddLuminosity(f_lum)
					else					SetLuminosity(f_lum)
					attack_self(usr)
			if("Refresh")
				attack_self(usr)
			//Settings
			if("Settings")
				HDD.mode = 2
				attack_self(usr)
			if("ToggleMessenger")
				if(HDD.messengeron)
					HDD.messengeron = 0
					attack_self(usr)
				else
					HDD.messengeron = 1
					attack_self(usr)
				attack_self(usr)
			if("Ringtone")
				var/t = input(U, "Please enter message", name, null) as text
				if (t)
					if(src.hidden_uplink && hidden_uplink.check_trigger(U, trim(lowertext(t)), trim(lowertext(lock_code))))
						U << "The tablet flashes red."
						attack_self(usr)
						HDD.mode = 0
						popup.close()
						U.unset_machine()
						U << browse(null, "window=thinktronic")
						HDD.activechat = null
						loadeddata = null
						loadeddata_photo = null
					else
						t = copytext(sanitize(t), 1, 20)
						HDD.ttone = t
						attack_self(usr)
			if("Sound")
				if(volume)
					volume = 0
					attack_self(usr)
				else
					volume = 2
					attack_self(usr)
			if("network")
				if(!HDD.banned)
					if(HDD.neton)
						HDD.neton = 0
						attack_self(usr)
					else
						HDD.neton = 1
						attack_self(usr)
				if(HDD.banned)
					usr << "<span class='notice'>You have been blocked from the ThinkTronic Server</span>"
				attack_self(usr)
			if("EjectHDD")
				if(shared)
					usr << "<span class='notice'>You cannot remove the Core from a shared laptop</span>"
				else
					popup.close()
					U.unset_machine()
					U << browse(null, "window=thinktronic")
					if(HDD)
						HDD.activechat = null
						HDD.mode = 0
						HDD.activeprog = null
					loadeddata = null
					loadeddata_photo = null
					HDD.loc = get_turf(src.loc)
					if(id)
						src.id.loc = get_turf(src.loc)
						id = null
					usr << "<span class='notice'>You remove the Core from the [name].</span>"
					HDD.mode = 0
					HDD = null
					name = devicetype
					ForceRefresh()
			if("Message")
				var/obj/item/device/thinktronic/P = locate(href_list["target"])
				if(!P.HDD.messengeron || !P.network())
					usr << "ERROR: Client not found"
					attack_self(usr)
					return
				if(spamcheck)
					return
				src.create_message(U, P)
				attack_self(usr)
			if("SendFile")
				var/obj/item/device/thinktronic/P = locate(href_list["target"])
				if(!P.HDD.messengeron || !P.network())
					usr << "ERROR: Client not found"
					attack_self(usr)
					return
				if(spamcheck)
					return
				src.create_file(U, P)
				attack_self(usr)
			if("QuikMessage")
				var/obj/item/device/thinktronic/P = locate(href_list["target"])
				var/obj/item/device/thinktronic_parts/core/MyHDD = HDD
				var/obj/item/device/thinktronic_parts/core/TheirHDD = P.HDD
				var/existing = 0
				if(!P.HDD.messengeron || !P.network())
					usr << "ERROR: Client not found"
					return
				for(var/obj/item/device/thinktronic_parts/data/convo/C in MyHDD)
					if(C.mlogowner == TheirHDD.owner)
						existing = 1
						break
				if(!existing)
					var/obj/item/device/thinktronic_parts/data/convo/D = new /obj/item/device/thinktronic_parts/data/convo(MyHDD)
					D.mlog = "--Conversation opened by [MyHDD.owner]--<br>"
					D.opened = 1
					D.mlogowner = TheirHDD.owner
					D.device_ID = P.device_ID
				if(spamcheck)
					return
				src.create_message(U, P, 1)
				if(HDD)
					if(HDD.mode == 7)
						ForceRefresh()
			if("QuikReply")
				var/obj/item/device/thinktronic/P = locate(href_list["target"])
				var/obj/item/device/thinktronic_parts/core/MyHDD = HDD
				var/obj/item/device/thinktronic_parts/core/TheirHDD = P.HDD
				var/existing = 0
				if(!P.HDD.messengeron || !P.network())
					usr << "ERROR: Client not found"
					attack_self(usr)
					return
				for(var/obj/item/device/thinktronic_parts/data/convo/C in MyHDD)
					if(C.mlogowner == TheirHDD.owner)
						existing = 1
						break
				if(!existing)
					var/obj/item/device/thinktronic_parts/data/convo/D = new /obj/item/device/thinktronic_parts/data/convo(MyHDD)
					D.mlog = "--Conversation opened by [MyHDD.owner]--<br>"
					D.opened = 1
					D.mlogowner = TheirHDD.owner
					D.device_ID = P.device_ID
				if(spamcheck)
					return
				src.create_message(U, P, 1)
				attack_self(usr)
			if("Chat")
				var/obj/item/device/thinktronic/P = locate(href_list["target"])
				var/obj/item/device/thinktronic_parts/core/MyHDD = HDD
				var/obj/item/device/thinktronic_parts/core/TheirHDD = P.HDD
				var/existing = 0
				for(var/obj/item/device/thinktronic_parts/data/convo/C in MyHDD)
					if(C.device_ID == TheirHDD.device_ID)
						existing = 1
						break
				if(existing)
					for(var/obj/item/device/thinktronic_parts/data/convo/C in MyHDD)
						if(C.device_ID == TheirHDD.device_ID)
							MyHDD.activechat = C
							break
				else
					var/obj/item/device/thinktronic_parts/data/convo/D = new /obj/item/device/thinktronic_parts/data/convo(MyHDD)
					D.mlog = "--Conversation opened by [MyHDD.owner]--<br>"
					D.opened = 1
					D.mlogowner = TheirHDD.owner
					D.device_ID = P.device_ID
					for(var/obj/item/device/thinktronic_parts/data/convo/C in MyHDD)
						if(C.device_ID == P.device_ID)
							MyHDD.activechat = C
							break
				attack_self(usr)
			if("SaveLog")
				var/obj/item/device/thinktronic_parts/data/savedconvo/D = new /obj/item/device/thinktronic_parts/data/savedconvo(HDD)
				D.mlog = HDD.activechat.mlog
				D.mlog += "--Conversation saved by [HDD.owner]--<br>"
				D.name = "Conversation Log - [HDD.activechat.mlogowner]/[HDD.owner]"
				usr << "Log saved to File Manager"
				attack_self(usr)
			if("ClearConvo")
				var/obj/item/device/thinktronic/P = locate(href_list["target"])
				if(HDD.activechat)
					var/closer = device_ID
					if(P.HDD)
						P.close_message(closer, HDD.owner)
					qdel(HDD.activechat)
					HDD.activechat = null
				attack_self(usr)
			if("View")
				var/obj/item/device/thinktronic_parts/data/D = locate(href_list["target"])
				if (D.document)
					if(D.doc)
						loadeddata = D.doc
					else
						U << "ERROR: Document Empty"
				if (D.photo)
					if(D.photoinfo)
						loadeddata = D.photoinfo
						loadeddata_photo = 1
					else
						U << "ERROR: Photo Empty"
				if (D.convo)
					if(D.mlog)
						loadeddata = D.mlog
					else
						U << "ERROR: Log Empty"
				attack_self(usr)
			if("Rename")
				var/obj/item/device/thinktronic_parts/data/D = locate(href_list["target"])
				var/t = input(usr, "Name", name, null) as text
				t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
				if (!t || !istype(D))
					return
				if (!in_range(src, usr) && loc != usr)
					return
				if(!can_use(usr))
					return
				D.name = t
				attack_self(usr)
			if("DeleteData")
				var/obj/item/device/thinktronic_parts/data/D = locate(href_list["target"])
				qdel(D)
				attack_self(usr)
			if("CartDel")
				var/obj/item/device/thinktronic_parts/D = locate(href_list["target"])
				qdel(D)
				attack_self(usr)
			if("CartSave")
				var/obj/item/device/thinktronic_parts/D = locate(href_list["target"])
				D.loc = HDD
				attack_self(usr)
			if("CartSaveApp")
				var/obj/item/device/thinktronic_parts/program/D = locate(href_list["target"])
				var/exists = 0
				if(!D)
					usr << "ERROR: Application files not found"
					attack_self(usr)
					return
				for(var/obj/item/device/thinktronic_parts/program/C in HDD)
					if(!C) continue
					if(C.name == D.name)
						exists = 1
						if(!C.pro == D.pro)
							exists = 2
							C.pro = D.pro
						break
				if(exists)
					if(exists == 1)
						usr << "ERROR: Duplicate Applications, Unable to install"
						qdel(D)
						attack_self(usr)
						return
					if(exists == 2)
						usr << "PRO version installed"
						qdel(D)
				else
					D.loc = HDD
					if(!D.utility)
						D.favorite = 2
					attack_self(usr)
					return
				attack_self(usr)
			if("Buy")
				if(network())
					var/obj/item/device/thinktronic_parts/nanonet/store_items/D = locate(href_list["target"])
					if(D.price <= HDD.cash)
						HDD.cash -= D.price
						if (volume == 1)
							playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
						for (var/mob/O in hearers(3, loc))
							if(volume == 1)
								O.show_message(text("\icon[src] *[HDD.ttone]*"))
							if(volume == 2)
								O.show_message(text("\icon[src] *[HDD.ttone]*"))
						usr << "Application Purchased, Saved to downloads"
						var/obj/item/device/thinktronic_parts/program/NewD = new D.item(cart)
						NewD.sentby = "NanoStore"
						attack_self(usr)
					else
						usr << "ERROR: Insufficient Funds"
				else
					usr << "ERROR: Connection Lost!"
					attack_self(usr)
			if("CheckAlerts")
				HDD.mode = 8
				attack_self(usr)
			if("ClearAlert")
				var/obj/item/device/thinktronic_parts/data/alert/alert = locate(href_list["target"])
				qdel(alert)
				attack_self(usr)
			if("ClearAllAlert")
				for(var/obj/item/device/thinktronic_parts/data/alert/alert in HDD)
					qdel(alert)
				attack_self(usr)
			if("Delete")
				var/obj/item/device/thinktronic_parts/P = locate(href_list["target"])
				qdel(P)
				attack_self(usr)
				return
			if("RenameCategory1")
				var/t = input(usr, "Category Name", name, null) as text
				t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
				if (!t)
					return
				if (!in_range(src, usr) && loc != usr)
					return
				if(!can_use(usr))
					return
				HDD.primaryname = t
				attack_self(usr)
			if("RenameCategory2")
				var/t = input(usr, "Category Name", name, null) as text
				t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
				if (!t)
					return
				if (!in_range(src, usr) && loc != usr)
					return
				if(!can_use(usr))
					return
				HDD.secondaryname = t
				attack_self(usr)
	else
		U.set_machine(src)
		U << browse(null, "window=thinktronic")
