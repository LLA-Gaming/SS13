// Edit motto verb disabled per request of taicho

/*
/client/proc/edit_motd()
	set name = "Edit MOTD"
	set category = "Server"
	if(!check_rights(0))	return
	var/F = file("config/motd.txt")
	if(F)
		var/motd = input(src,"Edit the MOTD","Edit MOTD",join_motd) as null|message
		switch(motd)
			if(null)
				return
			if("")
				return
		message_admins("[key] has edited the motd")
		log_admin("[key] has edited the motd")
		join_motd = motd
		fdel(F)
		F << motd
*/