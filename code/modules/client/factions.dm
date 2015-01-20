/client/proc/GetCurrentFaction(var/id_only = 0)
	establish_db_connection()
	if(!dbcon.IsConnected())
		log_game("SQL ERROR during 'GetCurrentFaction'. Failed to connect.")
	else
		var/DBQuery/faction_id_qry = dbcon.NewQuery("SELECT faction_id FROM syndicate_faction_members WHERE ckey = '[sanitizeSQL(ckey)]'")
		if(faction_id_qry.Execute())
			faction_id_qry.NextRow()
			if(!faction_id_qry.item.len)
				return
			var/faction_id = faction_id_qry.item[1]
			if(!faction_id)
				return 0

			if(id_only)
				return faction_id

			var/DBQuery/faction_name_qry = dbcon.NewQuery("SELECT name FROM syndicate_factions WHERE id = [sanitizeSQL(faction_id)]")
			if(faction_name_qry.Execute())
				faction_name_qry.NextRow()
				if(!faction_name_qry.item.len)
					return 0
				var/faction_name = faction_name_qry.item[1]
				return faction_name
	return 0

/client/proc/UpdateFaction(var/faction_name)
	establish_db_connection()
	if(!dbcon.IsConnected())
		log_game("SQL ERROR during 'UpdateFaction'. Failed to connect.")
	else
		if(faction_name == GetCurrentFaction())
			mob << "<font color='red'>You're already in that faction!</font>"
			return

		var/new_signup = 1
		var/DBQuery/new_signup_qry = dbcon.NewQuery("SELECT id FROM syndicate_faction_members WHERE ckey = '[sanitizeSQL(ckey)]'")
		if(new_signup_qry.Execute())
			new_signup_qry.NextRow()
			if(new_signup_qry.item.len)	new_signup = 0

		var/sqltime = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
		var/faction_id = 0
		if(faction_name != "None")
			var/DBQuery/faction_id_qry = dbcon.NewQuery("SELECT id FROM syndicate_factions WHERE name = '[sanitizeSQL(faction_name)]'")
			if(faction_id_qry.Execute())
				faction_id_qry.NextRow()
				if(faction_id_qry.item.len)
					faction_id = faction_id_qry.item[1]

		if(faction_name == "None" && new_signup)
			return

		if(new_signup)
			var/DBQuery/insert_faction_qry = dbcon.NewQuery("INSERT INTO syndicate_faction_members (faction_id, ckey, signup_date) VALUES ([faction_id], '[sanitizeSQL(ckey)]', '[sanitizeSQL(sqltime)]')")
			insert_faction_qry.Execute()
		else
			var/DBQuery/id_qry = dbcon.NewQuery("SELECT id FROM syndicate_faction_members WHERE ckey = '[sanitizeSQL(ckey)]'")
			var/id = 0
			if(id_qry.Execute())
				id_qry.NextRow()
				if(id_qry.item.len)
					id = id_qry.item[1]
			if(!id)
				return
			var/DBQuery/update_faction_qry = dbcon.NewQuery("UPDATE syndicate_faction_members SET faction_id = [faction_id], ckey = '[sanitizeSQL(ckey)]', signup_date = '[sqltime]' WHERE id = [id]")
			update_faction_qry.Execute()

		log_game("FACTION UPDATE: New Signup: [new_signup] ID: [faction_id] CKEY: [ckey]")
		mob << "<div class='info'>Faction updated.</div>"

/proc/GetFactionList()
	var/list/factions = list()
	establish_db_connection()
	if(!dbcon.IsConnected())
		log_game("SQL ERROR during 'GetFactionList'. Failed to connect.")
	else
		var/DBQuery/faction_query = dbcon.NewQuery("SELECT name FROM syndicate_factions")
		if(faction_query.Execute())
			while(faction_query.NextRow())
				factions += faction_query.item[1]

	return factions

/client/proc/GetFactionJoinDate()
	establish_db_connection()
	if(!dbcon.IsConnected())
		log_game("SQL ERROR during 'GetFactionJoinDate'. Failed to connect.")
	else
		if(GetCurrentFaction()) // Is currently in a faction
			var/join_date
			var/DBQuery/join_date_qry = dbcon.NewQuery("SELECT signup_date FROM syndicate_faction_members WHERE ckey = '[sanitizeSQL(ckey)]'")
			if(join_date_qry.Execute())
				join_date_qry.NextRow()
				if(join_date_qry.item.len)
					join_date = join_date_qry.item[1]

			if(join_date)
				return join_date
			else
				return 0

/client/proc/GetFactionJoinDifference() // Hours
	establish_db_connection()
	if(!dbcon.IsConnected())
		log_game("SQL ERROR during 'GetFactionJoinDifference'. Failed to connect.")
	else
		var/difference
		var/DBQuery/difference_qry = dbcon.NewQuery("SELECT HOUR(TIMEDIFF(NOW(), (SELECT signup_date FROM feedback.syndicate_faction_members WHERE ckey = '[sanitizeSQL(ckey)]')))")
		if(difference_qry.Execute())
			difference_qry.NextRow()
			if(difference_qry.item.len)
				difference = difference_qry.item[1]

		difference = text2num(difference)

		if(difference)
			return difference
		else
			return -1 // Since 0 is a possible option.