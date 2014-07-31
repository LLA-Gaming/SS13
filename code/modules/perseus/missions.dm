var/list/perseusMissions = list()

/datum/perseus_mission
	var/mob/living/creator = 0 //ref to the mob that created the mission.
	var/creatorName = 0
	var/adminCreated = 0
	var/mission = 0
	var/timeCreated = 0
	var/status = "Pending"
	var/list/associatedUnits = list()

	proc/checkCompletion()
		return 0

	New(var/mob/living/_creator, var/_adminCreated, var/_mission, var/addToList = 0)
		..()
		if(_creator && _mission)
			creator = _creator
			creatorName = _creator.real_name
			mission = _mission
			adminCreated = _adminCreated
			status = "Pending"
			timeCreated = world.realtime

			for(var/mob/living/carbon/human/H in world)
				if(H.job in list("Perseus Security Enforcer", "Perseus Security Commander"))
					if(H.client)	associatedUnits += H

			if(addToList)
				perseusMissions += src

		else	return 0

	var/name = "DEFAULT MISSION"

	targets/
		var/mob/living/target

		protect/
			name = "Protect"
			checkCompletion()
				if(!target)	return 0
				if(target.stat == 2)	return 0

				return 1

		detain/
			name = "Detain"
			checkCompletion()
				if(!target)	return 0
				var/area/A = get_area(target)
				if(!A)	return 0

				if(A.type in list(/turf/simulated/shuttle/floor4, /area/security/perseus/mycenaeiii, /area/security/prison, /area/mine/laborcamp))
					return 1

				return 0

		New(var/_creator, var/_adminCreated, var/_mission, var/addToList = 0, var/mob/living/_target)
			..(_creator, _adminCreated, _mission, addToList)
			if(!_target)	return 0
			target = _target

	exterminate/
		xenos/
			name = "Exterminate Xenomorphs"

			checkCompletion()
				for(var/obj/item/clothing/mask/facehugger/F in world)
					if(F.z == 1)
						return 0

				for(var/mob/living/carbon/alien/humanoid/H in world)
					if(H.z == 1)
						return 0

				return 1
		carps/
			name = "Exterminate Space Carps"

			checkCompletion()
				for(var/mob/living/simple_animal/hostile/carp/C in world)
					if(C.z == 1)
						return 0

				return 1
		spiders/
			name = "Exterminate Spiders"


			checkCompletion()
				for(var/mob/living/simple_animal/hostile/giant_spider/G in world)
					if(G.z == 1)
						return 0

				return 1

		slimes/
			name = "Exterminate Slimes"

			checkCompletion()
				for(var/mob/living/simple_animal/slime/S in world)
					if(S.z == 1)
						return 0

				return 1

		blob/
			name = "Exterminate Blob"

			checkCompletion()
				for(var/obj/effect/blob/B in world)
					if(B.z == 1)
						return 0

				return 1

/*
* Get a list of missions (in Name - Type format)
*/

/proc/getAvailablePerseusMissions()
	var/list/names = list()
	for(var/type in typesof(/datum/perseus_mission) - list(/datum/perseus_mission, /datum/perseus_mission/targets, /datum/perseus_mission/exterminate))
		var/datum/perseus_mission/P = new type()
		names[P.name] = P.type
		del(P)
	return names

/*
* Log the missions to the database at the end of the round.
*/

/proc/logPerseusMissions()
	if(!config.sql_enabled)
		return
	establish_db_connection()
	if(!dbcon.IsConnected())
		log_game("SQL ERROR during perseus mission reporting. Failed to connect.")
		return
	for(var/datum/perseus_mission/P in perseusMissions)
		var/numberPrint = ""
		for(var/mob/living/L in P.associatedUnits)
			numberPrint += "[pnumbers[L.ckey]];"
		var/insertQuery = "INSERT INTO perseus_missions (creatorname, creatorckey, createdby, creatorjob, time, mission, success, numbers, ic_success, type) VALUES ('[sanitizeSQL(P.creator.real_name)]', '[sanitizeSQL(P.creator.ckey)]', '[P.adminCreated ? "ADMIN" : "PLAYER"]', '[sanitizeSQL(P.creator.job)]', '[time2text(P.timeCreated, "YYYY-MM-DD hh:mm:ss")]', '[sanitizeSQL(P.mission)]', '[P.checkCompletion() ? "SUCESS" : "FAILURE"]', '[sanitizeSQL(numberPrint)]', '[P.status]', '[P.type]')"
		var/DBQuery/query = dbcon.NewQuery(insertQuery)
		if(!query.Execute())
			var/err = query.ErrorMsg()
			log_game("Error while logging perseus missions: [err]")
			return

/*
* Admin Verb to create perseus missions.
*/

/client/proc/createPerseusMission()
	set name = "Create Perseus Mission"
	set category = "Fun"

	var/list/availableMissions = getAvailablePerseusMissions()
	var/selectedMission = input("Select a mission.", "Input") as anything in availableMissions
	if(!selectedMission)	return
	var/missionType = availableMissions[selectedMission]
	if(!missionType)	return
	if(selectedMission in list("Protect", "Detain"))
		var/mob/living/target
		var/list/names = list()
		for(var/datum/data/record/R in data_core.general)
			names += R.fields["name"]
		var/selectedName = input("Select") as anything in names
		if(!selectedName)	return
		for(var/mob/living/L in world)
			if(L.real_name == selectedName)
				target = L
				break
		if(!names.len)
			usr << "\red Error: No data core entries found."
			return
		if(!target)	return

		new missionType(usr, 1, "[selectedMission] [target.real_name], the [target.job]", 1, target)
	else
		new missionType(usr, 1, "[selectedMission]", 1)
 	usr << "\blue Mission created."
