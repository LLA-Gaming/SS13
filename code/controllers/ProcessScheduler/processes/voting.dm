/datum/controller/process/voting/setup()
	name = "vote"
	schedule_interval = 20

	if(!vote)
		vote = new

/datum/controller/process/voting/doWork()
	vote.process()
	scheck()