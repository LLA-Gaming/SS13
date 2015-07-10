var/list/mentors = list()
var/mentor_salt = 0

/proc/LoadMentors(var/override = 0)
	if(!config.sql_enabled || override)
		var/list/lines = file2list("config/mentors.txt")
		for(var/line in lines)
			if(!length(line))
				continue

			if(findtextEx(line, "#", 1, 2))
				continue

			mentors += ckey(trim(line))
	else
		establish_db_connection()
		if(!dbcon.IsConnected())
			LoadMentors(1)
			return 0

		var/DBQuery/query = dbcon.NewQuery("SELECT * FROM feedback.mentors")
		if(!query.Execute())
			LoadMentors(1)
			var/error = query.ErrorMsg()
			message_admins("Error while polling mentors: [error]")
			return 0
		else
			while(query.NextRow())
				mentors += ckey(query.item[2])

/client/verb/mentor_help(var/msg as text)
	set name = "Mentorhelp"
	set category = "Admin"

	if(say_disabled)
		usr << "\red Speech is currently admin-disabled."
		return 0

	if(prefs.muted & MUTE_MENTORHELP)
		src << "<font color='red'>Error: Admin-PM: You cannot send mentorhelps. (Muted).</font>"
		return 0

	if(src.handle_spam_prevention(msg, MUTE_MENTORHELP))
		return 0

	src.verbs -= /client/verb/mentor_help
	spawn(200)
		src.verbs += /client/verb/mentor_help

	if(!msg)
		return 0

	msg = sanitize(copytext(msg, 1, MAX_MESSAGE_LEN))

	if(!msg)
		return 0

	if(!mentor_salt)
		mentor_salt = random_string(16, alphabet + list("0", "1", "2", "3", "4", "5", "6", "7", "8", "9"))

	var/id = copytext(md5(src.ckey + mentor_salt), 1, 5)

	var/mentor_formatted = "<font color='#91219E'><b>MENTORHELP by '[id]':</b> [msg] - <a href='?src=\ref[src];mentor_reply=\ref[src]'>Reply</a><font>"
	for(var/client/C in clients)
		if(C.ckey in mentors)
			C << mentor_formatted

	var/admin_formatted = "<font color='#91219E'><b>MENTORHELP by [key_name(src)]:</b> [msg] - <a href='?src=\ref[src];mentor_reply=\ref[src]'>Reply</a><font>"
	admins << admin_formatted

	var/player_formatted = "<font color='#91219E'><i>To-</i><b>MENTOR:</b> [msg]"
	src << player_formatted

	diary << "\[[time_stamp()]\]MENTORHELP: Created by '[key_name(src)]', message: '[msg]'"

/client/verb/mentorwho()
	set name = "Mentorwho"
	set category = "Admin"

	if(!holder)
		var/num = 0
		for(var/client/C in clients)
			if(C.ckey in mentors)
				num++

		usr << "<span class='info'>There [num == 1 ? "is" : "are"] currently [num] mentor[num == 1 ? "" : "s"] online.</span>"
	else
		usr << "<b>Current Mentors:</b>"
		for(var/client/C in clients)
			if(C.ckey in mentors)
				usr << "\t [C]"

// The player identification is the result of md5 + random salt for one conversation, reduced to the first 4 chars of the hash.
/client/proc/cmd_mentor_reply(var/target_pointer)
	var/client/target = locate(target_pointer)
	if(!target)
		return 0

	var/as_player = !(ckey in mentors)

	if(!mentor_salt)
		mentor_salt = random_string(16, alphabet + list("0", "1", "2", "3", "4", "5", "6", "7", "8", "9"))

	var/id
	if(as_player)
		id = copytext(md5(src.ckey + mentor_salt), 1, 5)
	else
		id = copytext(md5(target.ckey + mentor_salt), 1, 5)

	if(say_disabled)
		usr << "\red Speech is currently admin-disabled."
		return 0

	if(prefs.muted & MUTE_MENTORHELP)
		src << "<font color='red'>Error: Admin-PM: You cannot send mentorhelps. (Muted).</font>"
		return 0

	var/msg = input("Enter message", "Input") as text
	if(!msg)
		return 0

	if(src.handle_spam_prevention(msg, MUTE_MENTORHELP))
		return 0

	msg = sanitize(copytext(msg, 1, MAX_MESSAGE_LEN))

	if(!msg)
		return 0

	if(as_player)
		target << "<font color='#91219E'><b>MENTOR</b><i>-Reply from '[id]':</i> [msg] - <a href='?src=\ref[src];mentor_reply=\ref[src];as_player=0'>Reply</a></font>"
		admins << "<font color='#91219E'><b>MENTOR:</b><i> [key_name(src)] (player, id: '[id]') replied to [key_name(target, 1)] (mentor):</i> [msg]</font>"
	else
		target << "<font color='#91219E'><b>Reply from MENTOR:</b> [msg] - <a href='?src=\ref[src];mentor_reply=\ref[src]'>Reply</a></font>"
		admins << "<font color='#91219E'><b>MENTOR:</b><i> [key_name(src, 1)] (mentor) replied to [key_name(target)] (player, id: '[id]'):</i> [msg]</font>"

	src << "<font color='#91219E'><i>To-</i><b>[as_player ? "MENTOR" : id]:</b> [msg]"

	diary << "\[[time_stamp()]\]MENTORHELP: Reply to [key_name(target)] from [key_name(src)], message: '[msg]', id: '[id]'"

/client/proc/cmd_mentor_say(var/msg as text)
	set category = "Special Verbs"
	set name = "msay"
	set hidden = 1

	if(!(ckey in mentors))
		return 0

	if(say_disabled)
		usr << "\red Speech is currently admin-disabled."
		return 0

	if(prefs.muted & MUTE_MENTORHELP)
		src << "<font color='red'>Error: Admin-PM: You cannot send mentorhelps. (Muted).</font>"
		return 0

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)	return

	src << "<font color='#660198'><i>To-</i><b>MENTORS:</b> [msg]</font>"
	var/mentor_formatted = "<font color='#660198'><b>MENTORSAY:</b> [msg]</font>"
	var/admin_formatted = "<font color='#660198'><b>MENTORSAY - ([key_name(src)]):</b> [msg]</font>"

	for(var/client/C in clients)
		if(C.ckey in mentors)
			C << mentor_formatted

	admins << admin_formatted

	diary << "\[[time_stamp()]\]MENTORSAY: [key_name(src)] : [msg]"
