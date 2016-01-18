/datum/controller/process/firedome/setup()
	name = "firedome"
	schedule_interval = 20

	if(!firedome)
		firedome = new

/datum/controller/process/firedome/doWork()
	firedome.process()
	scheck()