var/datum/controller/event/events

/datum/controller/event
	var/list/all_events = list() //list of all events in existance, the master event list
	var/list/active_events = list() //list of all active events
	var/list/event_cyclers = list() //list of /datum/event_cycler, the datum that decides what event to fire next.

	var/setup_events = 0 //the game sets this to 1 on the first process()

	var/list/awards = list() //DB medals

	var/last_event		//last event to run, 2 events wont be the same in a row
	var/list/events_log = list()

	var/list/story = list() //a story that molds itself together at the end of the round
	var/story_end = 0		//when non-zero, the event story list prevents any new additions

//Initial controller setup.
/datum/controller/event/New()
	//There can be only one events manager. Out with the old and in with the new.
	if(events != src)
		if(istype(events))
			del(events)
		events = src
	var/list/deferred_types = list()
	for(var/type in typesof(/datum/round_event_control))
		var/datum/round_event_control/E = new type()
		if(!E.typepath)
			continue				//don't want this one! leave it for the garbage collector
		if(E.deferred_creation)
			deferred_types.Add(E.type)
			continue
		all_events += E				//add it to the list of all events

	for(var/type in deferred_types)
		var/datum/round_event_control/E = new type()
		if(!E.typepath)
			continue				//don't want this one! leave it for the garbage collector
		all_events += E				//add it to the list of all events

	SetupConfigs()

/datum/controller/event/proc/spawn_orphan_event(var/event_type,var/false_alarm = 0)
	var/datum/round_event/E
	if(istype(event_type,/datum/round_event))
		E = event_type
	else
		E = new event_type
	E.false_alarm = false_alarm
	E.PreSetup()
	return E

/datum/controller/event/proc/call_shuttle(var/called_from,var/prevent)
	if(!emergency_shuttle.online && emergency_shuttle.direction == 1) //we don't call the shuttle if it's already coming
		if (seclevel2num(get_security_level()) == SEC_LEVEL_RED) // There is a serious threat we gotta move no time to give them five minutes.
			emergency_shuttle.incall(0.6)
			priority_announce("The emergency shuttle has been called. Red Alert state confirmed: Dispatching priority shuttle. It will arrive in [round(emergency_shuttle.timeleft()/60)] minutes.", null, 'sound/AI/shuttlecalled.ogg', "Priority")
		else
			emergency_shuttle.incall(1)
			priority_announce("The emergency shuttle has been called. It will arrive in [round(emergency_shuttle.timeleft()/60)] minutes.", null, 'sound/AI/shuttlecalled.ogg', "Priority")
		if(prevent)
			emergency_shuttle.prevent_recall = 1
			EventStory("In a last ditch effort to save any remaining crewmembers, Central Command dispatched the Emergency Shuttle.")
		log_game("The crew failed the [called_from] event failed. shuttle auto-called")
		message_admins("The crew failed the [called_from] event failed. shuttle auto-called", 1)

/proc/EventStory(var/X,var/conclude)
	if(!events.story_end || conclude==2)
		events.story.Add(X)
	if(conclude)
		events.story_end = 1

/datum/controller/event/proc/AddAwards(var/id,var/keys)
	if(!islist(awards[id]))
		awards[id] = list()
	if(islist(keys))
		var/list/L = keys
		for(var/key in L)
			awards[id] |= key
	else
		if(keys) awards[id] |= keys
	listclearnulls(awards[id])


//allows a client to trigger an event (For Debugging Purposes)
/client/proc/forceEvent(var/datum/round_event_control/E in events.all_events)
	set name = "Trigger Event (Debug Only)"
	set category = "Debug"

	if(!holder)
		return

	if(istype(E))
		message_admins("[key_name_admin(usr)] has triggered an event. ([E.name])", 1)
		E.RunEvent()

/proc/FindEventArea(var/list/exclude) //Here's a nice proc to use to find an area for your event to land in!
	for(var/i=0, i<=50, i++)
		var/list/areas = (the_station_areas - the_station_areas_safe) + the_station_areas_danger
		for(var/X in exclude)
			areas.Remove(X)
		var/area/A = locate(safepick(areas))
		if(A.get_apc()) //generally this place should be a room and not a shuttle. sometimes locate() returns areas that do not exist.. somehow
			return A

/proc/FindEventAreaNearPeople(var/list/exclude)
	var/list/people_areas = list()
	var/list/good_areas = (the_station_areas - the_station_areas_safe) + the_station_areas_danger

	for(var/mob/living/L in player_list)
		if(L.stat == 2) continue
		var/area/A = get_area(L)
		if(A)
			var/obj/machinery/power/apc/apc = A.get_apc()
			if(apc && apc.z == 1)
				var/good = 0
				for(var/X in good_areas)
					if(istype(A,X))
						good = 1
				if(good)
					people_areas.Add(A.type)


	if(people_areas.len)
		for(var/X in exclude)
			people_areas.Remove(X)
		for(var/i=0, i<=50, i++)
			var/area/A = locate(safepick(people_areas))
			if(A && A.get_apc()) //generally this place should be a room and not a shuttle. sometimes locate() returns areas that do not exist.. somehow
				return A
	else
		return FindEventArea()

/proc/FindEventAreaAwayFromPeople(var/list/exclude)
	var/list/people_areas = list()
	var/list/good_areas = (the_station_areas - the_station_areas_safe) + the_station_areas_danger

	for(var/mob/living/L in player_list)
		if(L.stat == 2) continue
		var/area/A = get_area(L)
		if(A)
			var/obj/machinery/power/apc/apc = A.get_apc()
			if(apc && apc.z == 1)
				var/good = 0
				for(var/X in good_areas)
					if(istype(A,X))
						good = 1
				if(good)
					people_areas.Add(A.type)

	var/list/vacant_areas = (good_areas - people_areas)

	if(vacant_areas.len)
		for(var/X in exclude)
			vacant_areas.Remove(X)
		for(var/i=0, i<=50, i++)
			var/area/A = locate(safepick(vacant_areas))
			if(A && A.get_apc()) //generally this place should be a room and not a shuttle. sometimes locate() returns areas that do not exist.. somehow
				return A
	else
		return FindEventArea()

/proc/FindImpactTurfs(var/area/Ar)
	var/list/impact_turfs = list()
	for(var/turf/T in get_area_all_atoms(Ar))
		var/not_dense = 0
		if(!T.density)
			not_dense = 1
			for(var/atom/A in T.contents)
				if(A.density)
					not_dense = 0
		if(not_dense)
			impact_turfs.Add(T)
	return impact_turfs



/*
//////////////
// HOLIDAYS //
//////////////
//Uncommenting ALLOW_HOLIDAYS in config.txt will enable holidays

//It's easy to add stuff. Just modify getHoliday to set holiday to something using the switch for DD(#day) MM(#month) YY(#year).
//You can then check if it's a special day in any code in the game by doing if(events.holiday == "MyHolidayID")

//You can also make holiday random events easily thanks to Pete/Gia's system.
//simply make a random event normally, then assign it a holidayID string which matches the one you gave it in getHolday.
//Anything with a holidayID, which does not match the holiday string, will never occur.

//Please, Don't spam stuff up with stupid stuff (key example being april-fools Pooh/ERP/etc),
//And don't forget: CHECK YOUR CODE!!!! We don't want any zero-day bugs which happen only on holidays and never get found/fixed!

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//ALSO, MOST IMPORTANTLY: Don't add stupid stuff! Discuss bonus content with Project-Heads first please!//
//////////////////////////////////////////////////////////////////////////////////////////////////////////
~Carn */

//sets up the holiday string in the events manager.
/proc/getHoliday()
	if(!config.allow_holidays)	return		// Holiday stuff was not enabled in the config!
	holiday = null

	var/YY	=	text2num(time2text(world.timeofday, "YY")) 	// get the current year
	var/MM	=	text2num(time2text(world.timeofday, "MM")) 	// get the current month
	var/DD	=	text2num(time2text(world.timeofday, "DD")) 	// get the current day

	//Main switch. If any of these are too dumb/inappropriate, or you have better ones, feel free to change whatever
	switch(MM)
		if(1)	//Jan
			switch(DD)
				if(1)							holiday = "New Year"

		if(2)	//Feb
			switch(DD)
				if(2)							holiday = "Groundhog Day"
				if(14)							holiday = "Valentine's Day"
				if(17)							holiday = "Random Acts of Kindness Day"

		if(3)	//Mar
			switch(DD)
				if(14)							holiday = "Pi Day"
				if(17)							holiday = "St. Patrick's Day"
				if(27)
					if(YY == 16)
						holiday = "Easter"
				if(31)
					if(YY == 13)
						holiday = "Easter"

		if(4)	//Apr
			switch(DD)
				if(1)
					holiday = "April Fool's Day"
					if(YY == 18 && prob(50)) 	holiday = "Easter"
				if(5)
					if(YY == 15)				holiday = "Easter"
				if(16)
					if(YY == 17)				holiday = "Easter"
				if(20)
					holiday = "Four-Twenty"
					if(YY == 14 && prob(50))	holiday = "Easter"
				if(22)							holiday = "Earth Day"

		if(5)	//May
			switch(DD)
				if(1)							holiday = "Labour Day"
				if(4)							holiday = "FireFighter's Day"
				if(12)							holiday = "Owl and Pussycat Day"	//what a dumb day of observence...but we -do- have costumes already :3

		if(6)	//Jun

		if(7)	//Jul
			switch(DD)
				if(1)							holiday = "Doctor's Day"
				if(2)							holiday = "UFO Day"
				if(8)							holiday = "Writer's Day"
				if(30)							holiday = "Friendship Day"

		if(8)	//Aug
			switch(DD)
				if(5)							holiday = "Beer Day"

		if(9)	//Sep
			switch(DD)
				if(19)							holiday = "Talk-Like-a-Pirate Day"
				if(28)							holiday = "Stupid-Questions Day"

		if(10)	//Oct
			switch(DD)
				if(4)							holiday = "Animal's Day"
				if(7)							holiday = "Smiling Day"
				if(16)							holiday = "Boss' Day"
				if(31)							holiday = "Halloween"

		if(11)	//Nov
			switch(DD)
				if(1)							holiday = "Vegan Day"
				if(13)							holiday = "Kindness Day"
				if(19)							holiday = "Flowers Day"
				if(21)							holiday = "Saying-'Hello' Day"

		if(12)	//Dec
			switch(DD)
				if(10)							holiday = "Human-Rights Day"
				if(14)							holiday = "Monkey Day"
				if(21)							holiday = "Mayan Doomsday Anniversary"
				if(22)							holiday = "Orgasming Day"		//lol. These all actually exist
				if(24)							holiday = "Xmas"
				if(25)							holiday = "Xmas"
				if(26)							holiday = "Boxing Day"
				if(31)							holiday = "New Year"

	if(!holiday)
		//Friday the 13th
		if(DD == 13)
			if(time2text(world.timeofday, "DDD") == "Fri")
				holiday = "Friday the 13th"

	world.update_status()