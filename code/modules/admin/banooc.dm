//ban people from using OOC forever

var/oocban_runonce	//Updates legacy bans with new info
var/ooc_keylist[0]	//to store the keys

/proc/ooc_fullban(mob/M, reason)
	if (!M || !M.key) return
	ooc_keylist[M.ckey] = reason
	ooc_savebanfile()

/proc/ooc_client_fullban(ckey)
	if (!ckey) return
	ooc_keylist.Add("[ckey]")
	ooc_savebanfile()

//returns a reason if M is banned, returns 0 otherwise
/proc/ooc_isbanned(client/M)
	if(M)
		for(var/s in ooc_keylist)
			if(M.ckey != s) continue
			if(ooc_keylist[s])
				return ooc_keylist[s]
			return "Reason Unspecified"
	return 0

/*
DEBUG
/mob/verb/list_all_oocs()
	set name = "list all oocs"

	for(var/s in ooc_keylist)
		world << s

/mob/verb/reload_oocs()
	set name = "reload oocs"

	ooc_loadbanfile()
*/

/proc/ooc_loadbanfile()
	if(config.ban_legacy_system)
		var/savefile/S=new("data/ooc_full.ban")
		S["keys[0]"] >> ooc_keylist
		log_admin("Loading ooc_rank")
		S["runonce"] >> oocban_runonce

		if (!length(ooc_keylist))
			ooc_keylist=list()
			log_admin("ooc_keylist was empty")
	else
		if(!establish_db_connection())
			world.log << "Database connection failed. Reverting to the legacy ban system."
			diary << "Database connection failed. Reverting to the legacy ban system."
			config.ban_legacy_system = 1
			ooc_loadbanfile()
			return

		//ooc bans
		var/DBQuery/query = dbcon.NewQuery("SELECT ckey FROM erro_ban WHERE bantype = 'ooc_PERMABAN' AND NOT unbanned = 1")
		query.Execute()

		while(query.NextRow())
			var/ckey = query.item[1]

			ooc_keylist.Add("[ckey]")

/proc/ooc_savebanfile()
	var/savefile/S=new("data/ooc_full.ban")
	S["keys[0]"] << ooc_keylist

/proc/ooc_unban(mob/M)
	ooc_remove("[M.ckey]")
	ooc_savebanfile()


/proc/ooc_updatelegacybans()
	if(!oocban_runonce)
		log_admin("Updating oocfile!")
		// Updates bans.. Or fixes them. Either way.
		for(var/T in ooc_keylist)
			if(!T)	continue
		oocban_runonce++	//don't run this update again


/proc/ooc_remove(X)
	if(ooc_keylist.Remove(X))
		ooc_savebanfile()
		return 1
	return 0

/*
proc/DB_ban_isoocbanned(var/playerckey)
	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/sqlplayerckey = sql_sanitize_text(ckey(playerckey))

	var/DBQuery/query = dbcon.NewQuery("SELECT id FROM erro_ban WHERE CKEY = '[sqlplayerckey]' AND ((bantype = 'ooc_PERMABAN') OR (bantype = 'ooc_TEMPBAN' AND expiration_time > Now())) AND unbanned != 1")
	query.Execute()
	while(query.NextRow())
		return 1
	return 0
*/