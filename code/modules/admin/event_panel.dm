/datum/admins/proc/event_panel()
	set name = "Event Panel"
	set category = "Fun"
	var/dat = ""
	var/datum/browser/popup = new(usr, "event_panel", "Event Panel", 600, 700)
	if(!check_rights(0))	return
	if(events)
		dat += "<table width='100%' cellpadding='1' cellspacing='0'><td width = 50% valign='top'>"
		dat += "<h3>Adjust Difficulty ratings</h3>"
		for(var/V in events.rating)
			dat += "[V]: <A href='?_src_=holder;event_panel=edit;value=[V]'>[events.rating[V]]</A><br>"
		dat += "</td><td valign='top'>"
		dat += "<h3>Settings</h3>"
		dat += "<A href='?_src_=holder;event_panel=settings;mode=auto'>Auto-Ratings [events.autoratings ? "\[ON\]" : "\[OFF\]"]</A><br>"
		dat += "<A href='?_src_=holder;event_panel=settings;mode=unlucky'>Increased Events Mode [events.spawnrate_mode ? "\[ON\]" : "\[OFF\]"]</A><br>"
		dat += "<A href='?_src_=holder;event_panel=settings;mode=random'>True Random Mode [events.true_random ? "\[ON\]" : "\[OFF\]"]</A><br>"
		//dat += "<A href='?_src_=holder;event_panel=settings;mode=ender'>Allow Game Enders [events.allow_enders ? "\[ON\]" : "\[OFF\]"]</A><br>"
		dat += "</td></table>"
		//available events
		var/index = 0
		var/limit = 12
		dat += "<hr><h3>Spawn Event - <A href='?_src_=holder;event_panel=next'>Fire Next Event</A></h3><table width='100%' cellpadding='1' cellspacing='0'><td valign='top'>"
		for(var/datum/round_event_control/C in events.control)
			if(index > limit)
				index = 0
				dat += "</td><td valign='top'>"
			dat += "<A href='?_src_=holder;event_panel=spawnevent;event=\ref[C]'>[C.name]</A><BR>"
			index++
		dat += "</td></table>"
		//possible events
		dat += "<h3>Next Possible Events</h3>"
		var/number = 1
		var/list/possible = events.possible_events()
		for(var/X in possible)
			dat += "[number]) [X]<BR>"
			number++

	popup.set_content(dat)
	popup.open()
	return
