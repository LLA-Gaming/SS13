/datum/admins/proc/event_panel()
	set name = "Event Panel"
	set category = "Fun"
	var/dat = ""
	var/datum/browser/popup = new(usr, "event_panel", "Event Panel", 760, 600)

	if(!check_rights(0))	return
	if(!events.setup_events)
		dat = "Events manager is not active yet."
		popup.set_content(dat)
		popup.open()
		return

	dat += "<a href='?_src_=holder;event_panel=1'>Refresh</a> <a href='?_src_=holder;event_panel=1;add_cycler=1'>Add Cycler</a>"

	dat += "<table width=100%><tr>"
	var/datum/event_cycler/main
	var/list/custom = list()
	var/list/cyclers = list()
	for(var/datum/event_cycler/C in events.event_cyclers)
		if(istype(C,/datum/event_cycler/main))
			main = C
		else if (istype(C,/datum/event_cycler/admin_playlist))
			custom.Add(C)
		else
			cyclers.Add(C)
	for(var/datum/event_cycler/C in custom)
		cyclers.Insert(1,C)
	cyclers.Insert(1,main)
	for(var/datum/event_cycler/C in cyclers)
		if(C.hideme) continue
		if(C == main) continue
		dat += "<tr><td valign='top'>"
		dat += "<h3>[C.npc_name] <a href='?_src_=holder;event_panel=1;rename_cycler=\ref[C]'>Rename</a> [istype(C,/datum/event_cycler/admin_playlist) ? "<a href='?_src_=holder;event_panel=1;remove_cycler=\ref[C]'>X</a>" : ""]</h3>"
		dat += "<div class='statusDisplay'>"
		if(!C.endless)
			dat += "Lifetime: [C.lifetime]<br>"
		dat += "Timer: <a href='?_src_=holder;event_panel=1;status=\ref[C]'>[C.paused ? "Off" : "On"]</a><br>"
		var/next_fire = round((C.schedule - world.time) / 10 / 60,0.01)
		dat += "Next Fire in: [C.paused ? "PAUSED" : "[next_fire>=0 ? "[next_fire] minute(s)" : "NOW"]"]<br>"
		if(istype(C,/datum/event_cycler/admin_playlist))
			dat += "Shuffle: <a href='?_src_=holder;event_panel=1;shuffle=\ref[C]'>[C.shuffle ? "On" : "Off"]</a><br>"
			dat += "Story Generation: <a href='?_src_=holder;event_panel=1;prevent_story_generation=\ref[C]'>[C.prevent_stories ? "Off" : "On"]</a><br>"
			dat += "Alerts: <a href='?_src_=holder;event_panel=1;alerts=\ref[C]'>[C.alerts ? "On" : "Off"]</a><br>"
			dat += "Remove after fire: <a href='?_src_=holder;event_panel=1;remove_after_fire=\ref[C]'>[C.remove_after_fire ? "On" : "Off"]</a><br>"
		dat += "Next Fire Frequency (low): [round(C.frequency_lower / 10 / 60,0.01)] minute(s) <a href='?_src_=holder;event_panel=1;low_freq=\ref[C]'>Change</a><br>"
		dat += "Next Fire Frequency (high): [round(C.frequency_upper / 10 / 60,0.01)] minute(s) <a href='?_src_=holder;event_panel=1;high_freq=\ref[C]'>Change</a><br>"
		dat += "<a href='?_src_=holder;event_panel=1;force=\ref[C]'>Force Next Fire</a><br>"
		dat += "[C.playlist.len ? "Playlist:[C.shuffle ? "(Shuffle)":"(Order)"]" : "Possible:"] <br>"
		if(C.playlist.len)
			for(var/datum/round_event_control/E in C.playlist)
				dat += "[TAB][E] <a href='?_src_=holder;event_panel=1;remove_event=\ref[E];cycler=\ref[C]'>X</a><br>"
		else
			for(var/datum/round_event_control/E in events.all_events)
				if(E.event_flags & C.events_allowed)
					if(E.occurrences >= E.max_occurrences && E.max_occurrences >= 0) continue
					if(E.earliest_start >= world.time) continue
					if(E.typepath in events.last_event) continue
					if(E.holidayID)
						if(E.holidayID != holiday) continue
					if(E.weight <= 0) continue
					var/already_active = 0
					for(var/datum/round_event/R in events.active_events)
						if(R.type == E.typepath)
							already_active = 1
					if(!already_active)
						dat += "[TAB][E]<br>"
		if(istype(C,/datum/event_cycler/admin_playlist))
			dat += "[TAB]<a href='?_src_=holder;event_panel=1;add_event=\ref[C]'>Add</a><br>"
		dat += "</div>"
		if(C == main)
			dat += "</td>"
		else
			dat += "</td></tr>"

	dat += "</table>"

	popup.set_content(dat)
	popup.open()
	return
