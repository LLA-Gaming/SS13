var/datum/controller/assignment/assignments

/datum/controller/assignment
	var/frequency_lower = 3000	//5 minutes lower bound.
	var/frequency_upper = 9000	//15 minutes upper bound.
	var/scheduled = 0

	var/tier = 0

	var/list/active = list() //assignments currently active (and processing)
	var/list/passive = list() //these assignments do not process and (for the most part) are customized by the crew themselves
	var/list/complete = list() //completed assignments

	var/list/available = list()

	var/list/possible = list()

	var/list/all = list() //this is generated when it needs to generate


//Initial controller setup.
datum/controller/assignment/New()
	//There can be only one assignments controller. Out with the old and in with the new.
	if(assignments != src)
		if(istype(assignments))
			del(assignments)
		assignments = src

	build_assignment_lists()
	reschedule()

/datum/controller/assignment/proc/process()
	CheckMilestone()
	for(var/datum/assignment/A in active)
		A.tick()
	return

/datum/controller/assignment/proc/CheckMilestone()
	if(scheduled <= world.time)
		//put assignment spawning here.
		reschedule()

/datum/controller/assignment/proc/reschedule()
	scheduled = world.time + rand(frequency_lower, max(frequency_lower,frequency_upper))

/datum/controller/assignment/proc/update_assignments()
	all = active + passive
	all = sortAtom(all)
	return

/datum/controller/assignment/proc/build_assignment_lists()
	//Available at start
	spawn_assignment(/datum/assignment/engine_setup) //Engineering
	//spawn_assignment(/datum/assignment/solars_setup) //Engineering

	//possible
//tier3 (usage)
	possible.Add(new /datum/assignment/hostile_takeover) //security
	//possible.Add(new /datum/assignment/derelict_exploration) //all
//tier2 (production)
	//possible.Add(new /datum/assignment/upgrade_machines) //research
	//possible.Add(new /datum/assignment/asteroid_hunting) //supply
//tier1 (raw material acquisition/research)
	possible.Add(new /datum/assignment/mining_points) //supply
	//possible.Add(new /datum/assignment/research_design) //research
	//possible.Add(new /datum/assignment/recall_item) //supply
	possible.Add(new /datum/assignment/sample_item/med) //medbay
	possible.Add(new /datum/assignment/sample_item/bar) //civilian
	possible.Add(new /datum/assignment/sample_item/kitchen) //civilian
	possible.Add(new /datum/assignment/sample_item/botany) //civilian

/datum/controller/assignment/proc/get_hotzones(var/category) //this proc returns a list of possible places to screw up with progressive events
	var/list/hotzones = list()
	switch(category)
		if("station")
			var/list/safe_areas = list(
			/area/turret_protected/ai,
			/area/turret_protected/ai_upload,
			/area/engine,
			/area/solar,
			/area/holodeck,
			/area/shuttle/arrival,
			/area/shuttle/escape/station,
			/area/shuttle/escape_pod1/station,
			/area/shuttle/escape_pod2/station,
			/area/shuttle/escape_pod3/station,
			/area/shuttle/escape_pod4/station,
			/area/shuttle/mining/station,
			/area/shuttle/transport1/station,
			/area/shuttle/specops/station,
			/area/security/perseus/,
			/area/security/perseus/mycenae_centcom,
			/area/security/perseus/mycenaeiii)

			//These are needed because /area/engine has to be removed from the list, but we still want these areas to get fucked up.
			var/list/danger_areas = list(
			/area/engine/break_room,
			/area/engine/chiefs_office)

			//Need to locate() as it's just a list of paths.
			hotzones = (the_station_areas - safe_areas) + danger_areas
		if("mine")
			hotzones = list(
			/area/mine/laborcamp,
			/area/mine/north_outpost,
			/area/mine/west_outpost,
			)
		if("derelict")
			hotzones = list(
			/area/derelict/ship,
			/area/derelict/bridge,
			/area/derelict/solar_control,
			/area/derelict/medical/chapel,
			/area/djstation
			)
		if("derelict_noair")
			hotzones = list(
			/area/derelict/,
			/area/tcommsat,
			/area/mine/abandoned
			)
	return hotzones

/proc/spawn_assignment(var/assign_type,var/activate=0)
	if(!assignments)
		return
	if(!assign_type)
		return
	var/datum/assignment/A = new assign_type
	if(A)
		if(istype(A,/datum/assignment))
			if(!A.pre_setup())
				return
			if(activate)
				if(A.setup())
					if(A.passive)
						assignments.passive.Add(A)
						assignments.update_assignments()
					else
						assignments.active.Add(A)
						assignments.update_assignments()
					A.start()
					return A
				qdel(A)
				return
			else
				assignments.available.Add(A)
				assignments.update_assignments()
				return A
		qdel(A)
		return