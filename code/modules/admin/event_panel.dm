/datum/admins/proc/event_panel()
	set name = "Event Panel"
	set category = "Fun"
	var/dat = ""
	var/datum/browser/popup = new(usr, "event_panel", "Event Panel", 600, 700)
	if(!check_rights(0))	return
	if(events)
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

	popup.set_content(dat)
	popup.open()
	return
