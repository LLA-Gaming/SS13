/datum/controller/process/supply_shuttle/setup()
	name = "supply shuttle"
	schedule_interval = 20

	if(!supply_shuttle)
		supply_shuttle = new

/datum/controller/process/supply_shuttle/doWork()
	supply_shuttle.process()
	scheck()