/client/proc/barewho()
	set name = "WhoBasic"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	for(var/client/C in clients)
		var/entry = "\t[C.key]"
		if(C.holder && C.holder.fakekey)
			entry += " <i>(as [C.holder.fakekey])</i>"
		Lines += entry

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	src << msg

