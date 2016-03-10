/datum/admins/proc/event_panel()
	set name = "Event Panel"
	set category = "Fun"
	var/dat = ""
	var/datum/browser/popup = new(usr, "event_panel", "Event Panel", 600, 700)
	if(!check_rights(0))	return
	//PLEASE RETURN TO THIS AFTER EVENT REWRITE

	popup.set_content(dat)
	popup.open()
	return
