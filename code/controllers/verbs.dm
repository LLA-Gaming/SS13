//TODO: rewrite and standardise all controller datums to the datum/controller type
//TODO: allow all controllers to be deleted for clean restarts (see WIP master controller stuff) - MC done - lighting done

/client/proc/restart_controller(controller in processScheduler.processes)
	set category = "Debug"
	set name = "Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if(!holder)	return
	//usr = null
	src = null

	var/restarting = controller:name

	processScheduler.killProcess(restarting)

	message_admins("Admin [key_name_admin(usr)] has restarted the [restarting] controller.")
	feedback_add_details("admin_verb", "RPS")
	return


/client/proc/debug_controller(controller in list("Process Scheduler","Ticker","Garbage","Air","Jobs","Sun","Radio","Supply Shuttle","Emergency Shuttle","Configuration","pAI", "Cameras", "Events", "Virtual Reality","Firedome", "Pod Configuration", "Templates", "Template Config", "Space Grid"))
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the various periodic loop controllers for the game (be careful!)"

	if(!holder)	return
	switch(controller)
		if("Process Scheduler")
			debug_variables(processScheduler)
			feedback_add_details("admin_verb","DMC")
		if("Ticker")
			debug_variables(ticker)
			feedback_add_details("admin_verb","DTicker")
		if("Garbage")
			debug_variables(garbage)
			feedback_add_details("admin_verb","DGarbage")
		if("Air")
			debug_variables(air_master)
			feedback_add_details("admin_verb","DAir")
		if("Jobs")
			debug_variables(job_master)
			feedback_add_details("admin_verb","DJobs")
		if("Sun")
			debug_variables(sun)
			feedback_add_details("admin_verb","DSun")
		if("Radio")
			debug_variables(radio_controller)
			feedback_add_details("admin_verb","DRadio")
		if("Supply Shuttle")
			debug_variables(supply_shuttle)
			feedback_add_details("admin_verb","DSupply")
		if("Emergency Shuttle")
			debug_variables(emergency_shuttle)
			feedback_add_details("admin_verb","DEmergency")
		if("Configuration")
			debug_variables(config)
			feedback_add_details("admin_verb","DConf")
		if("pAI")
			debug_variables(paiController)
			feedback_add_details("admin_verb","DpAI")
		if("Cameras")
			debug_variables(cameranet)
			feedback_add_details("admin_verb","DCameras")
		if("Events")
			debug_variables(events)
			feedback_add_details("admin_verb","DEvents")
		if("Virtual Reality")
			debug_variables(vr_controller)
			feedback_add_details("admin_verb", "VRevents")
		if("Firedome")
			debug_variables(firedome)
			feedback_add_details("admin_verb", "FDevents")
		if("Pod Configuration")
			debug_variables(pod_config)
		if("Templates")
			debug_variables(template_controller)
		if("Template Config")
			debug_variables(template_config)
		if("Space Grid")
			debug_variables(space_grid)

	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
	return
