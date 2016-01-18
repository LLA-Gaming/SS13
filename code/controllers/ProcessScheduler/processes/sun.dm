/datum/controller/process/sun/setup()
	name = "sun"
	schedule_interval = 20

	if(!sun)
		sun = new

/datum/controller/process/sun/doWork()
	sun.calc_position()
	scheck()