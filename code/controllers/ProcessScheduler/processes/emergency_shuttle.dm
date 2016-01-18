/datum/controller/process/emergency_shuttle/setup()
	name = "emergency shuttle"
	schedule_interval = 20

	if(!emergency_shuttle)
		emergency_shuttle = new

/datum/controller/process/emergency_shuttle/doWork()
	emergency_shuttle.process()
	scheck()