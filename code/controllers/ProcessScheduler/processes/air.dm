var/global/air_processing_killed = 0

/datum/controller/process/air/setup()
	name = "air"
	schedule_interval = 20

	if(!air_master)
		air_master = new

	air_master.setup()

/datum/controller/process/air/doWork()
	if(air_processing_killed) return
	air_master.process()
	scheck()