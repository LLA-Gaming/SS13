#define USE_MEDALS 1

/*
* Award Medal
*/

/client/proc/AwardMedal(var/id = "")

	#ifndef USE_MEDALS
	return
	#endif

	if(!config.sql_enabled)
		return
	establish_db_connection()
	if(!dbcon.IsConnected())
		log_game("Failed to award medal '[id]' to '[ckey]', couldn't connect.")
		return

	// Check if the medal exists
	var/existsTxt = "SELECT * FROM medals WHERE medalid = '[sanitizeSQL(id)]'"
	var/DBQuery/existsQuery = dbcon.NewQuery(existsTxt)
	if(!existsQuery.Execute())
		log_game("Query Error while medal checking: [existsQuery.ErrorMsg()]")
		return 0

	var/exists = 0
	while(existsQuery.NextRow())
		exists = 1
		break

	if(!exists)
		log_game("Medal with ID '[id]' doesn't exist. Returning.")
		return 0

	if(HasMedal(id))	return 0

	/*
	// Check if client has the Medal
	var/hasMedal = "SELECT * FROM medals_awarded WHERE medalid = '[id]' AND ckey = '[sanitizeSQL(ckey)]'"
	var/DBQuery/hasMedalQuery = dbcon.NewQuery(hasMedal)
	if(!hasMedalQuery.Execute())
		log_game("Query Error while medal awarding: [hasMedalQuery.ErrorMsg()]")
		return 0

	// Got the medal, exit
	while(hasMedalQuery.NextRow())
		return 0
	*/

	// Award the Medal
	var/award = "INSERT INTO medals_awarded (ckey, medalid, date) VALUES ('[sanitizeSQL(ckey)]', '[sanitizeSQL(id)]', '[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]')"
	var/DBQuery/awardQuery = dbcon.NewQuery(award)
	if(!awardQuery.Execute())
		log_game("Error while inserting medal. [awardQuery.ErrorMsg()]")
		return 0

	mob << "<font color='#FFC125'><b>You earned a medal.</b></font>"

	//dbcon.Disconnect()

	return 1

/*
* Award Medal Debug Verb
*/

/client/proc/AwardMedalVerb(var/client/C in clients, var/id as text)
	set name = "Give Medal"
	set category = "Debug"

	if(!C || !id)
		usr << "Either no client or no id."
		return

	if(alert(usr, "This feature is for debug purposes only, not for rewarding. Do you understand?", "Confirmation", "Yes", "Abort") == "Abort")
		return

	if(C.AwardMedal(id))
		message_admins("[key_name(src)] gave medal '[id]' to '[key_name(C.ckey)]'")
		log_admin("[key_name(src)] gave medal '[id]' to '[key_name(C.ckey)]'")
	else
		usr << "\red Failed."
		return 0

	usr << "\blue Succeeded."

	return 0

/*
* Has Medal
*/

/client/proc/HasMedal(var/id)
	if(!id)	return 0

	if(!config.sql_enabled)
		return 0
	establish_db_connection()
	if(!dbcon.IsConnected())
		log_game("Failed to award medal '[id]' to '[ckey]', couldn't connect.")
		return 0

	// Check if client has the Medal
	var/hasMedal = "SELECT * FROM medals_awarded WHERE medalid = '[sanitizeSQL(id)]' AND ckey = '[sanitizeSQL(ckey)]'"
	var/DBQuery/hasMedalQuery = dbcon.NewQuery(hasMedal)
	if(!hasMedalQuery.Execute())
		log_game("Query Error while has-medal checking: [hasMedalQuery.ErrorMsg()]")
		return 0

	// Got the medal, exit
	while(hasMedalQuery.NextRow())
		log_game("Failed to award medal '[id]' to '[ckey]', already owned.")
		return 1

	return 0

/*
* Show Medals Verb
*/

/mob/verb/show_medals()
	set name = "Show Medals"
	set category = "OOC"

	if(!config.sql_enabled)
		return
	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/datum/browser/popup = new(usr, "medals", "[key]'s Medals", 720, 540)
	popup.set_content("<b>Polling...</b>")
	popup.open()

	var/dat = ""
	var/medalAmt = 0

	var/DBQuery/medalsQuery = dbcon.NewQuery("SELECT medalid, date FROM medals_awarded WHERE ckey = '[sanitizeSQL(ckey)]'")
	if(!medalsQuery.Execute())
		return

	while(medalsQuery.NextRow())
		var/DBQuery/infoQuery = dbcon.NewQuery("SELECT name, description FROM medals WHERE medalid = '[medalsQuery.item[1]]'")
		if(!infoQuery.Execute())
			log_game("Failed line  [infoQuery.ErrorMsg()]")
			return
		while(infoQuery.NextRow())
			dat += {"
						<div style='float: left; margin-right: 48px;'>
							<font color='#FFC125'>
								[infoQuery.item[1]][infoQuery.item[2] ? " - [infoQuery.item[2]]" : ""]
							</font>
						</div>
						<font color='white'>
							<div style='float: right; position: absoulute; right: 0;'>
								Date Aquired: [medalsQuery.item[2] ? time2text(medalsQuery.item[2], "DD-MMM-YYYY") : "Date Unknown"]
							</div>
						</font>
						<br>
					"}
			medalAmt++

	dat += "<br><b>You have [medalAmt] medal[medalAmt != 1 ? "s" : ""].</b>"

	popup.set_content(dat)
	popup.open()


/*	Not adding any actual medals for now.
/*
* Medals which can be achieved at round end will be awarded here.
*/

// @MEDAL
/proc/AwardEndRoundMedals()

	for(var/mob/living/L in world)
		if(!L.client)	continue

		// Give Janitors a medal when they have cleaned this (insane) amount of cleanables. (~400 at round-start)
		if(L.job == "Janitor")
			var/cleanableCount = 0
			for(var/obj/effect/decal/cleanable/C in world)
				if(C.z == 1)
					cleanableCount++
				continue
			if(cleanableCount <= 30)
				L.client.AwardMedal("cleanstation")
			continue
	return 0
*/
