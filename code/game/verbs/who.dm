
/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	if(holder)
		if(check_rights(R_ADMIN,0))//If they have +ADMIN, show hidden admins, player IC names and IC status
			for(var/client/C in clients)
				var/entry = "\t[C.key]"
				if(C.holder && C.holder.fakekey)
					entry += " <i>(as [C.holder.fakekey])</i>"
				entry += " - Playing as [C.mob.real_name]"
				switch(C.mob.stat)
					if(UNCONSCIOUS)
						entry += " - <font color='darkgray'><b>Unconscious</b></font>"
					if(DEAD)
						if(istype(C.mob, /mob/new_player))
							entry += " - <font color='gray'>In Lobby</font>"
						else if(isobserver(C.mob))
							var/mob/dead/observer/O = C.mob
							if(O.started_as_observer)
								entry += " - <font color='gray'>Observing</font>"
							else
								entry += " - <font color='black'><b>DEAD</b></font>"
						else
							entry += " - <font color='black'><b>DEAD</b></font>"
				if(C.mob && C.mob.mind && C.mob.mind.assigned_role == "FIREDOME")
					entry += " - <b><font color='purple'>Firedome</font></b>"
				else
					if(is_special_character(C.mob))
						entry += " - <b><font color='red'>Antagonist</font></b>"
				entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
				Lines += entry
		else//If they don't have +ADMIN, only show hidden admins
			for(var/client/C in clients)
				var/entry = "\t[C.key]"
				if(C.holder && C.holder.fakekey)
					entry += " <i>(as [C.holder.fakekey])</i>"
				Lines += entry
	else
		for(var/client/C in clients)
			if(C.holder && C.holder.fakekey)
				Lines += C.holder.fakekey
			else
				Lines += C.key

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	src << msg

/client/verb/adminwho()
	set category = "Admin"
	set name = "Adminwho"
	var/admins_on = 0
	var/msg = "<b>Current Admins:</b>\n"
	if(holder)
		admins_on = 1
		for(var/client/C in admins)
			msg += "\t[C] is a [C.holder.rank]"

			if(C.holder.fakekey)
				msg += " <i>(as [C.holder.fakekey])</i>"

			if(isobserver(C.mob))
				msg += " - Observing"
			else if(istype(C.mob,/mob/new_player))
				msg += " - Lobby"
			else
				msg += " - Playing"

			if(C.is_afk())
				msg += " (AFK)"
			msg += "\n"
	else
		for(var/client/C in admins)
			if(!C.holder.fakekey)
				msg += "\t[C] is a [C.holder.rank]\n"
				admins_on = 1
	src << msg
	if(!admins_on)
		src << "<b>There are currently no administrators online.</b>"
		//remove this line below if you are running this source not as a LLA server. ahelps on our server redirect to our discord
		src << "<b>Adminhelps sent when no admins are online <font color = 'red'>will be redirected</font> to proper channels.</b>"
		if(config.banrequest)
			src << "<b>You may also file a report here:</b> <a href='[config.banrequest]'>[config.banrequest]</a>"