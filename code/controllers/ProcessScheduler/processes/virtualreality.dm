/datum/controller/process/virtualreality/setup()
	name = "VR"
	schedule_interval = 20

	if(!vr_controller)
		vr_controller = new

/datum/controller/process/virtualreality/doWork()
	vr_controller.process()
	scheck()