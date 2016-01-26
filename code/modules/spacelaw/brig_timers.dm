#define CHARS_PER_LINE 5
#define FONT_SIZE "5pt"
#define FONT_COLOR "#09f"
#define FONT_STYLE "Arial Black"

/////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/brig_timer
	name = "door timer"
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	desc = "A remote control for a door."
	req_access = list(access_brig)
	anchored = 1.0    		// can't pick it up
	density = 0       		// can walk through it.
	var/id = null     		// id of door it controls.
	var/releasetime = 0		// when world.time reaches it - release the prisoneer
	var/timelength = 0		// the length of time this door will be set for
	var/timing = 1    		// boolean, true/1 timer is on, false/0 means it's not timing
	var/picture_state		// icon_state of alert picture, if not displaying text/numbers
	var/list/obj/machinery/targets = list()

	var/reset = 0 //This should be 0 unless the reset button is pressed or the timer runs out naturally.

	var/list/crimes = list()
	var/detail = ""
	var/prisoner = ""

	var/startup = 0			//this is set when the round starts to prevent spaming sec HUDs immediately

	maptext_height = 26
	maptext_width = 32

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

		pixel_x = ((src.dir & 3)? (0) : (src.dir == 4 ? 32 : -32))
		pixel_y = ((src.dir & 3)? (src.dir ==1 ? 24 : -32) : (0))

		spawn(20)
			for(var/obj/machinery/door/window/brigdoor/M in world)
				if (M.id == src.id)
					targets += M

			for(var/obj/machinery/flasher/F in world)
				if(F.id == src.id)
					targets += F

			for(var/obj/structure/closet/secure_closet/brig/C in world)
				if(C.id == src.id)
					targets += C

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
		if(timing)
			if(world.time > src.releasetime)
				src.timer_end() // open doors, reset timer, clear status screen
				timing = 0
				timeset(0)
				if(startup) //this should send alerts after the round has started, not before.
					var/datum/data/record/R = find_record("name", prisoner, data_core.security)
					if(R)
						R.fields["criminal"] = "Released"
						broadcast_hud_message("[src] deactivated! [prisoner] has been released! <b>*Record Updated*</b>", src)
					else
						broadcast_hud_message("[src] deactivated! [prisoner] has been released! <b>*No Record Found*</b>", src)
				else
					startup = 1
				detail = ""
				prisoner = ""
				reset = 0
				for(var/datum/crime/x in crimes)
					x.active = 0
			src.updateUsrDialog()
			src.update_icon()
		else
			timer_end()
		return

// has the door power sitatuation changed, if so update icon.
	power_change()
		..()
		update_icon()
		return

// open/closedoor checks if door_timer has power, if so it checks if the
// linked door is open/closed (by density) then opens it/closes it.
	proc/timer_start()
		if(stat & (NOPOWER|BROKEN))	return 0

		for(var/obj/machinery/door/window/brigdoor/door in targets)
			if(door.density)	continue
			spawn(0)
				door.close()

		for(var/obj/structure/closet/secure_closet/brig/C in targets)
			if(C.broken)	continue
			if(C.opened && !C.close())	continue
			C.locked = 1
			C.icon_state = C.icon_locked
		return 1

	proc/timer_end()
		if(stat & (NOPOWER|BROKEN))	return 0
		for(var/obj/machinery/door/window/brigdoor/door in targets)
			if(!door.density)	continue
			spawn(0)
				door.open()

		for(var/obj/structure/closet/secure_closet/brig/C in targets)
			if(C.broken)	continue
			if(C.opened)	continue
			C.locked = 0
			C.icon_state = C.icon_closed

		return 1

	proc/timeleft()
		. = (timing ? (releasetime-world.time) : timelength)/10
		if(. < 0)
			. = 0

	proc/timeset(var/seconds)
		if(timing)
			releasetime=world.time+seconds*10
		else
			timelength=seconds*10
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
		var/second = round(timeleft() % 60)
		var/minute = round((timeleft() - second) / 60)
		user.set_machine(src)
		var/dat = "<HTML><BODY><TT>"
		dat += {"<table style="text-align:left">"}
		dat += {"<tr>"}
		dat += {"<th valign='top'>"}
		dat += {"<h3>Minor Crimes</h3></a>"}
		for(var/datum/crime/minor/crime in crimes)
			if(crime.active)
				dat += {"<font size = 2>(*)<a href='?src=\ref[src];tp=[crime.time];detail=[crime.name]'>[crime.name]</a></font><br>"}
			else
				dat += {"<font size = 2><a href='?src=\ref[src];tp=[crime.time];detail=[crime.name]'>[crime.name]</a></font><br>"}
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
		dat += {"</th>"}
		dat += {"</tr>"}
		dat += "</table>"
		//options
		if (timing)
			dat += "<a href='?src=\ref[src];timing=0'>Pause Timer</a> - "
		else
			dat += "<a href='?src=\ref[src];timing=1'>Start Timer</a> - "
		dat += "<a href='?src=\ref[src];reset=1'>Reset</a><br/>"
		dat += "Edit Time: <a href='?src=\ref[src];tp=-60'>-</a> <a href='?src=\ref[src];tp=-1'>-</a>[minute]:[second]<a href='?src=\ref[src];tp=1'>+</a> <A href='?src=\ref[src];tp=60'>+</a><br/>"
		dat += "Prisoner: <a href='byond://?src=\ref[src];prisoner=1'>[prisoner ? prisoner : "None Listed."]</a><br>"
		for(var/obj/machinery/flasher/F in targets)
			if(F.last_flash && (F.last_flash + 150) > world.time)
				dat += "<br/><A href='?src=\ref[src];fc=1'>Flash Charging</A>"
			else
				dat += "<br/><A href='?src=\ref[src];fc=1'>Activate Flash</A>"
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
		usr.send_text_to_tab("Current Crimes: [detail].", "ic")
		usr.send_text_to_tab("Current Prisoner: [prisoner].", "ic")

		usr << "The [src] reads:"
		usr << "Current Crimes: [detail]"
		usr << "Current Prisoner: [prisoner]"

	Topic(href, href_list)
		if(..())
			return
		if(!src.allowed(usr))
			return

		usr.set_machine(src)
		if(href_list["timing"]) //switch between timing and not timing
			var/timeleft = timeleft()
			if(!prisoner)
				usr << "[src] requires a prisoner name"
				return
			if(!detail)
				usr << "[src] requires crime details"
				return
			timeleft = min(max(round(timeleft), 0), 3599)
			timing = text2num(href_list["timing"])
			timeset(timeleft)
			if(!reset)
				log_game("BRIG: [key_name(usr)] arrested [prisoner] in [src] for: [detail].")
				crimelogs.Add("BRIG: [key_name(usr)] arrested [prisoner] in [src] for: [detail].")
				var/datum/data/record/R = find_record("name", prisoner, data_core.security)
				if(R)
					R.fields["criminal"] = "Incarcerated"
					broadcast_hud_message("[src] activated! Prisoner: [prisoner] <b>*Record Updated*</b>", src)
					reset = 1
					for(var/datum/crime/minor/x in crimes)
						if(x.active)
							var/record = data_core.createCrimeEntry(x.name, "AUTO: Brigged in [src]", usr.name, worldtime2text(), prisoner, src, 1)
							data_core.addMinorCrime(R.fields["id"], record)
					for(var/datum/crime/medium/x in crimes)
						if(x.active)
							var/record = data_core.createCrimeEntry(x.name, "AUTO: Brigged in [src]", usr.name, worldtime2text(), prisoner, src, 1)
							data_core.addMediumCrime(R.fields["id"], record)
					for(var/datum/crime/major/x in crimes)
						if(x.active)
							var/record = data_core.createCrimeEntry(x.name, "AUTO: Brigged in [src]", usr.name, worldtime2text(), prisoner, src, 1)
							data_core.addMajorCrime(R.fields["id"], record)
					for(var/datum/crime/capital/x in crimes)
						if(x.active)
							var/record = data_core.createCrimeEntry(x.name, "AUTO: Brigged in [src]", usr.name, worldtime2text(), prisoner, src, 1)
							data_core.addCapitalCrime(R.fields["id"], record)
				else
					broadcast_hud_message("[src] activated, Prisoner: [prisoner] <b>*No Record Found*</b>", src)
					reset = 1
		else if(href_list["tp"]) //adjust timer
			var/timeleft = timeleft()
			var/tp = text2num(href_list["tp"])
			var/crime = href_list["detail"]
			if(crime)
				for(var/datum/crime/x in crimes)
					if(x.name == crime && !x.active)
						if(detail)
							detail += "; [crime]"
							x.active = 1
							timeleft += tp
						if(!detail)
							detail = "[crime]"
							x.active = 1
							timeleft += tp
			if(!crime)
				timeleft += tp
			timeleft = min(max(round(timeleft), 0), 3599)
			timeset(timeleft)
			//src.timing = 1
			//src.closedoor()
		else if(href_list["fc"])
			for(var/obj/machinery/flasher/F in targets)
				F.flash()
		else if(href_list["prisoner"])
			var/_prisoner = stripped_input("Who is in the cell?", "Prisoner") as text
			if(_prisoner)
				if(length(_prisoner) > 24)
					usr << "<div class='warning'>Error: Prisoner Name too long.</div>"
					return
				log_game("BRIG: [key_name(usr)] edited the [src]'s prisoner to: [_prisoner].")
				crimelogs.Add("BRIG: [key_name(usr)] edited the [src]'s prisoner to: [_prisoner].")
				prisoner = _prisoner
				reset = 0
			else
				prisoner = ""
		else if(href_list["reset"])
			src.timer_end() // open doors, reset timer, clear status screen
			timing = 0
			timeset(0)
			var/datum/data/record/R = find_record("name", prisoner, data_core.security)
			if(reset)
				if(R)
					R.fields["criminal"] = "Released"
					broadcast_hud_message("[src] deactivated! [prisoner] has been released! <b>*Record Updated*</b>", src)
				else
					broadcast_hud_message("[src] deactivated! [prisoner] has been released! <b>*No Record Found*</b>", src)
			detail = ""
			prisoner = ""
			reset = 0
			for(var/datum/crime/x in crimes)
				x.active = 0
		src.add_fingerprint(usr)
		src.updateUsrDialog()
		src.update_icon()
		if(timing)
			src.timer_start()
		else
			src.timer_end()
		return


//icon update function
// if NOPOWER, display blank
// if BROKEN, display blue screen of death icon AI uses
// if timing=true, run update display function
	update_icon()
		if(stat & (NOPOWER))
			icon_state = "frame"
			return
		if(stat & (BROKEN))
			set_picture("ai_bsod")
			return
		if(timing)
			var/disp1 = id
			var/timeleft = timeleft()
			var/disp2 = "[add_zero(num2text((timeleft / 60) % 60),2)]~[add_zero(num2text(timeleft % 60), 2)]"
			if(length(disp2) > CHARS_PER_LINE)
				disp2 = "Error"
			update_display(disp1, disp2)
		else
			if(maptext)	maptext = ""
		return


// Adds an icon in case the screen is broken/off, stolen from status_display.dm
	proc/set_picture(var/state)
		if(maptext)	maptext = ""
		picture_state = state
		overlays.Cut()
		overlays += image('icons/obj/status_display.dmi', icon_state=picture_state)


//Checks to see if there's 1 line or 2, adds text-icons-numbers/letters over display
// Stolen from status_display
	proc/update_display(line1, line2)
		var/new_text = {"<div style="font-size:[FONT_SIZE];color:[FONT_COLOR];font:'[FONT_STYLE]';text-align:center;" valign="top">[line1]<br>[line2]</div>"}
		if(maptext != new_text)
			maptext = new_text


/obj/machinery/brig_timer/cell_1
	name = "Cell 1"
	id = "Cell 1"
	dir = 2
	pixel_y = -32


/obj/machinery/brig_timer/cell_2
	name = "Cell 2"
	id = "Cell 2"
	dir = 2
	pixel_y = -32


/obj/machinery/brig_timer/cell_3
	name = "Cell 3"
	id = "Cell 3"
	dir = 2
	pixel_y = -32


/obj/machinery/brig_timer/cell_4
	name = "Cell 4"
	id = "Cell 4"
	dir = 2
	pixel_y = -32

#undef FONT_SIZE
#undef FONT_COLOR
#undef FONT_STYLE
#undef CHARS_PER_LINE
