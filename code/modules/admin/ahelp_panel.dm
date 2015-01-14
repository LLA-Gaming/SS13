/datum/admin_conversation
	var/list/participants = list()
	var/list/messages = list()
	var/original_adminhelp = 0

	var/id = 0 // The 'id' column in the database.

	var/round_id = 0

	New(var/_id = 0)
		..()

		if(!_id)
			return 0

		if(!isnum(_id))
			_id = sanitizeSQL(_id)
			_id = text2num(_id)

		id = _id

	/*
	* This is used to RETRIEVE data from the database.
	*/

	proc/Populate()
		if(!config.sql_enabled)
			return 0

		/******/

		var/DBQuery/convo_qry = dbcon.NewQuery("SELECT * FROM admin_conversations WHERE id = [id]")

		if(!convo_qry.Execute())
			log_game("SQL Error in 'Populate:/datum/admin_conversation': [convo_qry.ErrorMsg()]")
			return

		convo_qry.NextRow()

		var/admin_ckey = sanitizeSQL(convo_qry.item[3])
		var/player_ckey = sanitizeSQL(convo_qry.item[4])
		var/adminhelp = sanitizeSQL(convo_qry.item[6])

		participants += list("admin", admin_ckey != "" ? admin_ckey : "No Admin")
		participants += list("player", player_ckey)

		round_id = text2num(sanitizeSQL(convo_qry.item[2]))

		original_adminhelp = sanitizeSQL(adminhelp)

		/******/

		var/DBQuery/pm_qry = dbcon.NewQuery("SELECT * FROM admin_pm WHERE conversation_id = [id]")
		pm_qry.Execute()

		while(pm_qry.NextRow())
			var/sender = pm_qry.item[4]
			var/message = pm_qry.item[3]
			var/recipient = pm_qry.item[5]

			messages += list(sender, recipient, message)

	proc/IsAdminParticipating()
		if(!config.sql_enabled)
			return 0

		var/DBQuery/is_participating_qry = dbcon.NewQuery("SELECT admin_ckey FROM admin_conversations WHERE id = [id]")
		is_participating_qry.Execute()
		is_participating_qry.NextRow()

		if(!isnum(is_participating_qry.item[1]))
			return 0
		else
			var/result = is_participating_qry.item[1]
			if(!result)
				return 0

		return 1

	proc/SetAdminParticipant(var/ckey = 0)
		if(!config.sql_enabled)
			return 0

		if(IsAdminParticipating() || !ckey)	return

		if(!config.sql_enabled)
			return

		participants += list("admin", ckey)

		var/DBQuery/insert_into_database_qry = dbcon.NewQuery("UPDATE admin_conversations SET admin_ckey = '[sanitizeSQL(ckey)]' WHERE id = [id]")
		insert_into_database_qry.Execute()

	proc/GetPlayerCkey()
		if(!config.sql_enabled)
			return 0

		var/DBQuery/player_ckey_qry = dbcon.NewQuery("SELECT player_ckey FROM admin_conversations WHERE id = [id]")

		player_ckey_qry.Execute()
		player_ckey_qry.NextRow()

		var/player_ckey = sanitizeSQL(player_ckey_qry.item[1])

		if(!player_ckey)
			return "No Player"

		return player_ckey


	proc/LogReply(var/ckey, var/recipient_ckey, var/message)
		if(!ckey || !message)
			return

		if(!config.sql_enabled)
			return

		var/DBQuery/pm_qry = dbcon.NewQuery("INSERT INTO admin_pm (conversation_id, message, sender_ckey, recipient_ckey, date) VALUES ('[id]', '[sanitizeSQL(message)]', '[sanitizeSQL(ckey)]', '[sanitizeSQL(recipient_ckey)]', Now())")
		pm_qry.Execute()

	proc/GetLink()
		return "http://www.webpanel.arctys-boreas.com/index.php?conversation=1&id=[id]"

/proc/GetCurrentAdminConversations()

	var/round_id = GetCurrentRoundID()
	var/DBQuery/convo_qry = dbcon.NewQuery("SELECT id FROM admin_conversations WHERE round_id = [round_id]")
	convo_qry.Execute()

	var/list/conversations = list()

	while(convo_qry.NextRow())
		var/id = convo_qry.item[1]
		conversations += new /datum/admin_conversation(id)

	for(var/datum/admin_conversation/A in conversations)
		A.Populate()

	return conversations

/*
/client/proc/GetAdminButtons(var/mob/M, var/datum/A)
	var/dat = ""

	dat += "<a href='?_src_=holder;adminmoreinfo=\ref[M]'>?</a>"
	dat += " <a href='?_src_=holder;adminplayeropts=\ref[M]'>PP</a>"
	dat += " <a href='?_src_=vars;Vars=\ref[M]'>VV</a>"
	dat += " <a href='?_src_=holder;subtlemessage=\ref[M]'>SM</a>"
	dat += " <a href='?_src_=holder;adminplayerobservejump=\ref[M]'>JMP</a>"
	dat += " <a href='?_src_=holder;secretsadmin=check_antagonist'>CA</a>"

	if(istype(M, /mob/living/silicon/ai))
		dat += " <a href='?_src_=holder;adminchecklaws=\ref[M]'>CL</a>"

	return dat
*/

/*
* The actual verb for admins to view current conversations.
*/

/client/proc/ViewAdminhelps()
	set name = "View Adminhelps"
	set category = "Admin"

	var/datum/browser/popup = new(mob, "ahelps", "Adminhelps", 640, 480)

	var/dat = {"
				<script type='text/css'>

					td {
						border: 1px solid black;
						border-collapse: collapse;
					}

					tr {
						border: 2px solid black;
					}

				</script>

				<table width=100% height=100% style='border: 1px solid black; border-collapse: collapse'>
					<tr>

						<td><center><b>By</b></center></td>
						<td><center><b>Message</b></center></td>
						<td><center><b>Misc</b></center></td>

					</tr>
				"}

	for(var/datum/admin_conversation/A in GetCurrentAdminConversations())

		dat += {"
				<tr>
					<td><center>[A.GetPlayerCkey()]</center></td>
					<td><center>[A.original_adminhelp]</center></td>
					<td><center><a href='about:blank'>View In Browser (todo)</a></center></td>
				</tr>
				<br>
				</font>
				"}

	dat += "</table>"

	popup.set_content(dat)
	popup.open()

var/list/CurrentAdminConversations = list()

/proc/CreateAdminConversation(var/ckey, var/message, var/AddToList = 1)
	if(!ckey || !message)
		return 0

	if(!config.sql_enabled)
		return

	var/round_id = text2num(GetCurrentRoundID())
	var/player_ckey = sanitizeSQL(ckey)
	var/adminhelp = sanitizeSQL(message)

	var/DBQuery/insert_qry = dbcon.NewQuery("INSERT INTO admin_conversations (round_id, player_ckey, date, adminhelp) VALUES ('[round_id]', '[player_ckey]', Now(), '[adminhelp]')")
	var/DBQuery/last_insert_id_qry = dbcon.NewQuery("SELECT MAX(id) FROM admin_conversations")

	insert_qry.Execute()

	var/id = 0

	last_insert_id_qry.Execute()
	last_insert_id_qry.NextRow()
	if(last_insert_id_qry.item[1])
		id = last_insert_id_qry.item[1]
	else
		id = 1

	var/datum/admin_conversation/A = new /datum/admin_conversation(id)

	if(AddToList)
		CurrentAdminConversations += A

	message_admins("Admin Conversation created with ID: [id]")

	return A
