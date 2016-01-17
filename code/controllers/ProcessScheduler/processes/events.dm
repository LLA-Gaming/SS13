/datum/controller/process/events/setup()
	name = "events"
	schedule_interval = 20

	if(!events)
		events = new

/datum/controller/process/events/doWork()
	events.process()