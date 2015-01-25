/obj/machinery/door/airlock/glass_security/perma
	autoclose = 0
	New()
		..()
		spawn(15)
		open()

/obj/machinery/door/airlock/glass_security/perma/cell_1
	name = "Perma Cell 1"
	id_tag = "Perma Cell 1"

/obj/machinery/door/airlock/glass_security/perma/cell_2
	name = "Perma Cell 2"
	id_tag = "Perma Cell 2"

/obj/machinery/door/airlock/glass_security/perma/cell_3
	name = "Perma Cell 3"
	id_tag = "Perma Cell 3"


/obj/machinery/perma_monitor
	name = "door timer"
	icon = 'icons/obj/terminals.dmi'
	icon_state = "dorm_inside"
	desc = "A remote control for permabrig."
	req_access = list(access_brig)
	anchored = 1.0    		// can't pick it up
	density = 0       		// can walk through it.
	var/id = null     		// id of door it controls.
	var/list/obj/machinery/targets = list()
	var/activated = 0

	var/list/crimes = list()
	var/list/activecrimes = list()
	var/detail = ""
	var/prisoner = ""
	var/operating = 0
	var/saveddetail = ""
	var/savedprisoner = ""
	var/repeatoffender = 0

	New()
		..()
		// Populate the crime list:
		for(var/x in typesof(/datum/crime))
			var/datum/crime/F = new x(src)
			if(!F.name)
				del(F)
				continue
			else
				crimes.Add(F)

		spawn(20)
			for(var/obj/machinery/door/airlock/glass_security/M in world)
				if (M.id_tag == src.id)
					targets += M

			for(var/obj/machinery/flasher/F in world)
				if(F.id == src.id)
					targets += F

			for(var/obj/machinery/door/poddoor/B in world)
				if(B.id == src.id)
					targets += B

			if(targets.len==0)
				stat |= BROKEN
			update_icon()
			return
		return

//Main door timer loop, if it's timing and time is >0 reduce time by 1.
// if it's less than 0, open door, reset timer
// update the door_timer window and the icon
	process()
		if(stat & (NOPOWER|BROKEN))	return
		for(var/obj/machinery/door/airlock/glass_security/M in targets)
			if(M.z != 1)
				del(M)
				stat |= BROKEN
				update_icon()
		if(operating)
			for(var/obj/machinery/door/airlock/glass_security/M in targets)
				if(M.density)
					M.locked = 0
					M.open()
					M.locked = 1
					M.update_icon()
					operating = 0
					return
				if(!M.density)
					M.locked = 0
					M.close()
					M.locked = 1
					M.update_icon()
					if(M.density)
						operating = 0
						return
		return

// has the door power sitatuation changed, if so update icon.
	power_change()
		..()
		update_icon()
		return

//Allows AIs to use door_timer, see human attack_hand function below
	attack_ai(var/mob/user as mob)
		return src.attack_hand(user)

//Allows humans to use door_timer
//Opens dialog window when someone clicks on door timer
// Allows altering timer and the timing boolean.
// Flasher activation limited to 150 seconds
	attack_hand(var/mob/user as mob)
		if(..())
			return
		user.set_machine(src)
		var/dat = "<HTML><BODY><TT>"
		dat += {"<h3>[src.name] Occupant</h3></a>"}
		dat += {"Criminal: [savedprisoner]<br>"}
		dat += {"Crimes: [saveddetail]<br>"}
		dat += {"<table style="text-align:left">"}
		dat += {"<tr>"}
		dat += {"<th valign='top'>"}
		dat += {"</th><th valign='top'>"}
		dat += {"<h3>Capital Crimes</h3></a>"}
		for(var/datum/crime/capital/crime in crimes)
			if(crime.active)
				dat += {"<font size = 2>(*)<a href='?src=\ref[src];tp=[crime.time];detail=[crime.name]'>[crime.name]</a></font><br>"}
			else
				dat += {"<font size = 2><a href='?src=\ref[src];tp=[crime.time];detail=[crime.name]'>[crime.name]</a></font><br>"}
		if(repeatoffender)
			dat += {"<font size = 2>(*)<a href='?src=\ref[src];repeat=1'>Repeat Offender</a></font><br>"}
		else
			dat += {"<font size = 2><a href='?src=\ref[src];repeat=1'>Repeat Offender</a></font><br>"}
		dat += {"</th>"}
		if(repeatoffender)
			dat += {"</th><th valign='top'>"}
			dat += {"<h3>Medium Crimes</h3></a>"}
			for(var/datum/crime/medium/crime in crimes)
				if(crime.active)
					dat += {"<font size = 2>(*)<a href='?src=\ref[src];tp=[crime.time];detail=[crime.name]'>[crime.name]</a></font><br>"}
				else
					dat += {"<font size = 2><a href='?src=\ref[src];tp=[crime.time];detail=[crime.name]'>[crime.name]</a></font><br>"}
			dat += {"</th><th valign='top'>"}
			dat += {"<h3>Major Crimes</h3></a>"}
			for(var/datum/crime/major/crime in crimes)
				if(crime.active)
					dat += {"<font size = 2>(*)<a href='?src=\ref[src];tp=[crime.time];detail=[crime.name]'>[crime.name]</a></font><br>"}
				else
					dat += {"<font size = 2><a href='?src=\ref[src];tp=[crime.time];detail=[crime.name]'>[crime.name]</a></font><br>"}
			dat += {"</th><th valign='top'>"}
		dat += {"</tr>"}
		dat += "</table><hr>"
		//options
		dat += "<a href='?src=\ref[src];toggle=1'>Toggle Door</a> "
		if(activated)
			dat += "Closed - "
		if(!activated)
			dat += "Open - "
		dat += "<a href='?src=\ref[src];reset=1'>Clear Status</a><br/>"
		dat += "Prisoner: <a href='byond://?src=\ref[src];prisoner=1'>[prisoner ? prisoner : "None Listed."]</a>"
		dat += " - <a href='byond://?src=\ref[src];set=1'>Set Prisoner as occupant</a><br>"
		for(var/obj/machinery/flasher/F in targets)
			if(F.last_flash && (F.last_flash + 150) > world.time)
				dat += "<br/><A href='?src=\ref[src];fc=1'>Flash Charging</A>"
			else
				dat += "<br/><A href='?src=\ref[src];fc=1'>Activate Flash</A>"
		dat += "<br/><A href='?src=\ref[src];bd=1'>Toggle Blastdoors</A>"
		dat += "<br/><br/><a href='?src=\ref[user];mach_close=computer'>Close</a>"
		dat += "</TT></BODY></HTML>"
		var/datum/browser/popup = new(usr, "computer", "Brig Timer", 780, 550)
		popup.set_content(dat)
		popup.open()
		onclose(user, "computer")
		return

//Function for using door_timer dialog input, checks if user has permission
// href_list to
//  "timing" turns on timer
//  "tp" value to modify timer
//  "fc" activates flasher
// Also updates dialog window and timer icon

	examine()
		..()

		usr.send_text_to_tab("The [src] reads:", "ic")
		usr.send_text_to_tab("Current Crimes: [crimes].", "ic")
		usr.send_text_to_tab("Current Prisoner: [prisoner].", "ic")
		if(repeatoffender)
			usr.send_text_to_tab("Prisoner has been marked as a repeat offender.", "ic")

		usr << "The [src] reads:"
		usr << "Current Crimes: [detail]"
		usr << "Current Prisoner: [prisoner]"
		if(repeatoffender)
			usr << {"Prisoner has been marked as a repeat offender"}

	Topic(href, href_list)
		if(..())
			return
		if(!src.allowed(usr))
			return

		usr.set_machine(src)
		if(href_list["toggle"]) //switch between timing and not timing
			if(operating) return
			if(!savedprisoner)
				usr << "[src] requires a prisoner name"
				return
			if(!saveddetail)
				usr << "[src] requires crime details"
				return
			if(activated)
				operating = 1
				activated = 0
			if(!activated)
				operating = 1
				activated = 1
		else if(href_list["tp"]) //adjust timer
			var/crime = href_list["detail"]
			if(crime)
				for(var/datum/crime/x in crimes)
					if(x.name == crime && !x.active)
						if(detail)
							detail += "; [crime]"
							x.active = 1
						if(!detail)
							detail = "[crime]"
							x.active = 1
		else if(href_list["fc"])
			for(var/obj/machinery/flasher/F in targets)
				F.flash()
		else if(href_list["bd"])
			for(var/obj/machinery/door/poddoor/B in targets)
				var/openclose
				if(B.id == src.id)
					if(openclose == null)
						openclose = B.density
					spawn(0)
						if(B)
							if(openclose)	B.open()
							else			B.close()
						return
		else if(href_list["repeat"])
			if(repeatoffender)
				repeatoffender = 0
				for(var/datum/crime/x in crimes)
					x.active = 0
				activated = 0
				detail = ""
				operating = 0
				src.add_fingerprint(usr)
				src.updateUsrDialog()
				src.update_icon()
				return
			if(!repeatoffender)
				repeatoffender = 1
				src.add_fingerprint(usr)
				src.updateUsrDialog()
				src.update_icon()
				return

		else if(href_list["prisoner"])
			var/_prisoner = input("Who is in the cell?", "Prisoner") as text
			if(_prisoner)
				if(length(_prisoner) > 24)
					usr << "<div class='warning'>Error: Prisoner Name too long.</div>"
					return
				log_game("BRIG: [key_name(usr)] edited the [src]'s prisoner to: [_prisoner].")
				crimelogs.Add("[key_name(usr)] edited the [src]'s prisoner to: [_prisoner].")
				prisoner = _prisoner
			else
				prisoner = ""
		else if(href_list["reset"])
			if(operating || !activated) return
			operating = 1
			activated = 0
			detail = ""
			prisoner = ""
			repeatoffender = 0
			savedprisoner = ""
			saveddetail = ""

			for(var/datum/crime/x in crimes)
				x.active = 0
			src.add_fingerprint(usr)
			src.updateUsrDialog()
			src.update_icon()
			return
		else if(href_list["set"])
			savedprisoner = prisoner
			saveddetail = detail
			for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
				MS.SendAlert("[savedprisoner] has been permabrigged for the following crimes: [saveddetail]","Brig Control")
			log_game("BRIG: [key_name(usr)] permabrigged [savedprisoner] in [src] for: [saveddetail].")
			crimelogs.Add("[key_name(usr)] permabrigged [savedprisoner] in [src] for: [saveddetail].")
		src.add_fingerprint(usr)
		src.updateUsrDialog()
		src.update_icon()
		return


//icon update function
// if NOPOWER, display blank
// if BROKEN, display blue screen of death
	update_icon()
		if(stat & (NOPOWER))
			icon_state = "dorm_off"
			return
		if(stat & (BROKEN))
			icon_state = "dorm_error"
			return
		if(!stat)
			icon_state = "dorm_inside"
			return
		return

/obj/machinery/perma_monitor/cell_1
	name = "Perma Cell 1"
	id = "Perma Cell 1"
	dir = 2
	pixel_y = 32


/obj/machinery/perma_monitor/cell_2
	name = "Perma Cell 2"
	id = "Perma Cell 2"
	dir = 2
	pixel_y = 32


/obj/machinery/perma_monitor/cell_3
	name = "Perma Cell 3"
	id = "Perma Cell 3"
	dir = 2
	pixel_y = 32

