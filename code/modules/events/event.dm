//this datum is used by the events controller to dictate how it selects events
/datum/round_event_control
	var/name
	var/typepath
	var/holidayID
	var/event_flags
	var/max_occurrences = -1		//how many times this event is allowed to fire before before, -1 for infinite
	var/earliest_start = 12000		//when in world.time can this event be considered
	var/weight = 10				//how much weight this event has to spawn. the higher the more of a chance it has
	var/occurrences				//how many times this event has already been fired
	var/needs_ghosts = 0		//if non-zero the event needs ghosts to even be considered.
	var/candidate_flag = null
	var/candidate_afk_bracket = 3000
	var/candidates_needed = 0
	var/deferred_creation = 0	//if this event control needs to be made after all other events were made

	proc/RunEvent(var/datum/event_cycler/came_from)
		if(!ispath(typepath,/datum/round_event))
			return PROCESS_KILL
		var/datum/round_event/E = new typepath
		events.last_event = typepath
		if(came_from)
			came_from.lifetime--
			E.cycler = came_from
			E.prevent_stories = came_from.prevent_stories
			E.sends_alerts = came_from.alerts
			occurrences++
		E.control = src
		E.PreSetup(src,came_from)
		if(E && (E.sends_alerts && !istype(E,/datum/round_event/task)))
			if(!E.false_alarm)
				log_game("EVENTS: [src] was fired")
				events.events_log.Add("[worldtime2text()] - [src]")

/datum/round_event
	var/datum/round_event_control/control //This is setup elsewhere, the parent controller of this event
	var/datum/event_cycler/cycler			//the cycler who spawned this event
	var/special_npc_name					//sometimes centcomm arent the ones to announce this event, put a special npc name here for who will be sending alerts to crew
	var/processing 		= 1 //if the event is processing, You don't need to change this
	var/false_alarm = 0		//boolean: if the event ends up being a false alarm.

	var/list/candidates = list() //candidates for the event

	var/start_when		= 0	//When in the world.time to call start().
	var/alert_when		= 0	//When in the world.time to call alert().
	var/end_when		= 0	//When in the world.time the event should end.

	var/active_for = 0 //how many ticks the event has been active for. you don't need to touch this variable
	var/endless = 0 //if the event never ends unless told to. you don't need to touch this variable
	var/prevent_stories = 0
	var/sends_alerts = 1

	New()
		..()
		SetTimers()
		if(start_when >=0) start_when = world.time + start_when
		if(alert_when >=0) alert_when = world.time + alert_when
		if(end_when >=0) end_when = world.time + end_when
		if(end_when < 0) endless = 1

	proc/PreSetup(var/datum/round_event_control/C,var/datum/event_cycler/came_from) //To decide if the event is a false alarm or not do not override this, override Setup()
		control = C
		if(!special_npc_name && came_from)
			special_npc_name = came_from.npc_name
		events.active_events.Add(src)
		//candidates
		if(control && control.candidate_flag)
			candidates = get_candidates_event(control.candidate_flag, control.candidate_afk_bracket)
			if(candidates.len < control.candidates_needed)
				CancelSelf()
		//candidates end
		Setup()
		return
	proc/SetTimers()
		return

	proc/AbruptEnd() //Called at certain times when the event needs to end but isn't scheduled to end yet
		End()
		qdel(src)
		return
	proc/CancelSelf() //Called at certain times when the event needs to die and not run End()
		if(control)
			control.occurrences-- //refund
		if(cycler) //it was a false alarm or not able to setup, make the next event soon. also refund a lifetime
			cycler.lifetime++
			cycler.schedule = world.time + cycler.frequency_lower
		if(!false_alarm)
			message_admins("Couldn't run event: [src]")
			log_game("EVENTS: Couldn't run event: [src]")
		qdel(src)
		return

	proc/Setup() //Ran at New()
		return
	proc/Start() //When the lifetime is equal to start_when, this fires
		return
	proc/Alert() //When the lifetime is equal to alert_when, this fires
		return
	proc/Tick() //When the lifetime is equal to alert_when, this fires
		return
	proc/End()   //When the lifetime is equal to end_when, this fires
		return
	proc/OnPass()
		return
	proc/OnFail()
		return

//Do not override this proc, instead use the appropiate procs.
//This proc will handle the calls to the appropiate procs.
/datum/round_event/proc/process()
	if(!processing)
		return

	if(world.time >= start_when && start_when >= 0 && !false_alarm)
		Start()
		start_when = -1

	if(world.time >= alert_when && alert_when >= 0)
		if(sends_alerts)
			Alert()
		alert_when = -1
		if(false_alarm)
			CancelSelf()
			return

	if((world.time >= start_when && world.time <= end_when && !false_alarm) || (world.time >= start_when && end_when < 0 && !false_alarm))
		Tick()

	if(world.time >= end_when && end_when >= 0 && !false_alarm)
		End()
		end_when = -1

	if(end_when == -1 && start_when == -1 && alert_when == -1 && !endless)
		qdel(src)
		return
	active_for++

/datum/round_event/proc/send_alerts(var/msg)
	if (!sends_alerts) return
	send_tablet_alerts(msg)
	send_newscaster_alerts(msg)

/datum/round_event/proc/send_tablet_alerts(var/msg)
	if (!sends_alerts) return
	for(var/obj/item/device/tablet/T in tablets_list)
		T.alert_self("Alert from \<[special_npc_name]\>", msg)

/datum/round_event/proc/send_newscaster_alerts(var/msg)
	if (!sends_alerts) return
	news_network.SubmitArticle(msg, "[special_npc_name]", "Station Alerts", null)