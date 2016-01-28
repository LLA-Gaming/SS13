/client/proc/metawho()
	set name = "MetaWho"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	if(holder)
		if(check_rights(R_ADMIN,0))
			for(var/client/C in clients)
				var/entry = "\t[C.key]"
				if(C.holder && C.holder.fakekey)
					entry += " <i>(as [C.holder.fakekey])</i>"
				entry += " - Playing as [C.mob.real_name]"
				switch(C.mob.stat)
					if(UNCONSCIOUS)
						entry += " - <font color='darkgray'><b>Unconscious</b></font>"
					if(DEAD)
						if(isobserver(C.mob))
							var/mob/dead/observer/O = C.mob
							if(O.started_as_observer)
								entry += " - <font color='gray'>Observing</font>"
							else
								entry += " - <font color='black'><b>DEAD</b></font>"
						else if(istype(C.mob,/mob/new_player))
							entry += " - <font color='black'><b>In Lobby</b></font>"
						else
							entry += " - <font color='black'><b>DEAD</b></font>"
				if(C.mob && C.mob.mind && C.mob.mind.assigned_role == "FIREDOME")
					entry += " - <b><font color='purple'>Firedome</font></b>"
				else
					if(is_special_character(C.mob))
						entry += " - <b><font color='red'>Antagonist</font></b>"
				entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
				Lines += entry

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	src << msg