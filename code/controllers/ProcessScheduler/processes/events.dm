/datum/controller/process/events/setup()
	name = "events"
	schedule_interval = 20

	if(!events)
		events = new

/datum/controller/process/events/doWork()
	events.checkEvent()
	var/i = 1
	while(i<=events.running.len)
		var/datum/round_event/Event = events.running[i]
		if(Event)
			Event.process()
			scheck()
			i++
			continue
		events.running.Cut(i,i+1)
	//pick one lovely event from the queue to possibly unqueue
	if(events.queue_scheduled <= world.time)
		for(var/datum/round_event/Event in shuffle(events.queue))
			Event.tick_queue()
			scheck()
			break
		events.queue_scheduled = world.time + rand(events.frequency_lower, max(events.frequency_lower,events.frequency_upper))