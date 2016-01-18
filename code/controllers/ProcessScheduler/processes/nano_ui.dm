/datum/controller/process/nano_ui/setup()
	name = "nano ui"
	schedule_interval = 20

/datum/controller/process/nano_ui/doWork()
	for(var/datum/nanoui/ui in nanomanager.processing_uis)
		if(istype(ui) && !ui.gc_destroyed)
			ui.process()
			scheck()
		else
			nanomanager.processing_uis -= ui