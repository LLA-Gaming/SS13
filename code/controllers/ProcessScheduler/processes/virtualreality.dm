/datum/controller/process/virtualreality/setup()
	name = "VR"
	schedule_interval = 20

	if(!vr_controller)
		vr_controller = new

/datum/controller/process/vr_controller/doWork()
	vr_controller.process()