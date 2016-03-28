/datum/admins/proc/event_panel()
	set name = "Event Panel"
	set category = "Fun"
	var/dat = ""
	var/datum/browser/popup = new(usr, "event_panel", "Event Panel", 700, 480)
	if(!check_rights(0))	return
	if(!events.setup_events)
		dat = "Events manager is not active yet."
		popup.set_content(dat)
		popup.open()
		return

	dat += "\[Add Cycler\]"

	dat += "<table><tr>"
	var/datum/event_cycler/rotated
	var/list/cyclers = list()
	for(var/datum/event_cycler/C in events.event_cyclers)
		if(C.in_rotation)
			rotated = C
		else
			cyclers.Add(C)
	cyclers.Insert(1,rotated)
	for(var/datum/event_cycler/C in cyclers)
		dat += "<td style='width:250px' valign='top'>"
		dat += "<h3>[C.npc_name] [C.in_rotation ? "" : "\[Rename\] \[X\]"]</h3>"
		if(!C.endless)
			dat += "Lifetime: [C.lifetime]<br>"
		dat += "Status: \[On\]<br>"
		dat += "Playlist:<br>"
		if(C.playlist.len)
			for(var/datum/round_event_control/E in C.playlist)
				if(E.event_flags & C.events_allowed)
					dat += "--[E] \[X\]<br>"
		else
			for(var/datum/round_event_control/E in events.all_events)
				if(E.event_flags & C.events_allowed)
					dat += "--[E]<br>"
		if(istype(C,/datum/event_cycler/admin_playlist)
			dat += "--\[Add\]<br>"
		dat += "</td>"


	dat += "</tr></table>"

	popup.set_content(dat)
	popup.open()
	return
