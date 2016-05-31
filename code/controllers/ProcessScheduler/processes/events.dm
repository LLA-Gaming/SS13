/datum/controller/process/events/setup()
	name = "events"
	schedule_interval = 20

	if(!events)
		events = new

/datum/controller/process/events/doWork()
	//initial setup
	if(!events.setup_events)
		new /datum/event_cycler/main(6600,null,null,1) //Make the first cycler fire in 11 minutes.
		new /datum/event_cycler/roundstart(10,"Central","Command") //Make the round-start cycler fire a round start event
		new /datum/event_cycler/holiday(3000,"???") //spawn holidays if they exist
		events.spawn_orphan_event(/datum/round_event/engine_setup)	//spawn the engine setup "event"
		events.setup_events = 1
		return
	//Process everything
	process_cyclers()
	process_events()

/datum/controller/process/events/proc/process_cyclers()
	var/i = 1
	while(i<=events.event_cyclers.len)
		var/datum/event_cycler/E = events.event_cyclers[i]
		if(E)
			setLastTask("process()", "[E]")
			E.process()
			scheck()
			i++
			continue
		events.event_cyclers.Cut(i,i+1)

/datum/controller/process/events/proc/process_events()
	var/i = 1
	while(i<=events.active_events.len)
		var/datum/round_event/Event = events.active_events[i]
		if(Event)
			setLastTask("process()", "[Event]")
			Event.process()
			scheck()
			i++
			continue
		events.active_events.Cut(i,i+1)