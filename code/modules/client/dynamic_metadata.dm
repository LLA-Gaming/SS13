/*
* # WIP: Interface only
*/

/proc

	LoadMetadata(var/ckey, var/id)
		if(!config.sql_enabled)
			return

		establish_db_connection()
		if(!dbcon.IsConnected())
			log_game("Failed to connect to database in 'LoadMetadata'")
			return

		var/loadQueryTxt = "SELECT value FROM metadata WHERE ckey = '[sanitizeSQL(ckey)]' AND id = '[sanitizeSQL(id)]'"
		var/DBQuery/loadQuery = dbcon.NewQuery(loadQueryTxt)
		if(!loadQuery.Execute())
			log_game("Query error in 'LoadMetadata': [loadQuery.ErrorMsg()]")
			return 0
		loadQuery.NextRow()

		return (length(loadQuery.item) ? loadQuery.item[1] : "ERROR LOADING DATA")

	// Will override previous entries
	SaveMetadata(var/ckey, var/id, var/value)
		if(!config.sql_enabled)
			return

		establish_db_connection()
		if(!dbcon.IsConnected())
			log_game("Failed to connect to database in 'SaveMetadata'")
			return

		var/hasIDQueryTxt = "SELECT * FROM metadata WHERE id = '[sanitizeSQL(id)]' AND ckey = '[sanitizeSQL(ckey)]'"
		var/DBQuery/hasIDQuery = dbcon.NewQuery(hasIDQueryTxt)
		if(!hasIDQuery.Execute())
			log_game("Query error in 'SaveMetadata:hasIDQuery': [hasIDQuery.ErrorMsg()]")
			return 0

		hasIDQuery.NextRow()

		// Already an entry -- Update
		if(length(hasIDQuery.item) > 0)
			var/updateQueryTxt = "UPDATE metadata SET value = '[sanitizeSQL(value)]' WHERE ckey = '[sanitizeSQL(ckey)]' AND id = '[sanitizeSQL(id)]'"
			var/DBQuery/updateQuery = dbcon.NewQuery(updateQueryTxt)
			if(!updateQuery.Execute())
				log_game("Query error in 'SaveMetadata:updateQuery': [updateQuery.ErrorMsg()]")
				return 0

			return 1

		else
			var/saveQueryTxt = "INSERT INTO metadata SET id = '[sanitizeSQL(id)]', ckey = '[sanitizeSQL(ckey)]', value = '[sanitizeSQL(value)]'"
			var/DBQuery/saveQuery = dbcon.NewQuery(saveQueryTxt)
			if(!saveQuery.Execute())
				log_game("Query error in 'SaveMetadata:saveQuery': [saveQuery.ErrorMsg()]")
				return 0

			return 1

	ModifyMetadata(var/ckey, var/id, var/change = 1)
		if(!config.sql_enabled)
			return

		establish_db_connection()
		if(!dbcon.IsConnected())
			log_game("Failed to connect to database in 'ModifyMetadata'")
			return

		var/value = LoadMetadata(ckey, id)

		if(istext(value))
			value = text2num(value)

		var/new_value = (value + change)

		new_value = num2text(new_value)

		if(!SaveMetadata(ckey, id, new_value))
			return 0

		return 1

	// Wrapper for ModifyMetadata
	IncrementMetadata(var/ckey, var/id, var/increment = 1)
		return ModifyMetadata(id, abs(increment))

	// Wrapper for ModifyMetadata
	DecrementMetadata(var/ckey, var/id, var/decrement = 1)
		return ModifyMetadata(id, -abs(decrement))
