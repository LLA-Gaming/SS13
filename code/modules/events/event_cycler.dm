///variations of the cycler event.

/datum/event_cycler/rotation
	in_rotation = 1
/datum/event_cycler/endless
	endless = 1
/datum/event_cycler/admin_playlist
	paused = 1
	prevent_stories = 1
	alerts = 0
	remove_after_fire = 1
	branching = 0
	shuffle = 0
	endless = 1
	events_allowed = null
/datum/event_cycler/roundstart
	hideme = 1
	lifetime = 1
	events_allowed = EVENT_ROUNDSTART

/datum/event_cycler/holiday
	hideme = 1
	endless = 1
	remove_after_fire = 1
	frequency_lower = 3000
	frequency_upper = 3000
	events_allowed = EVENT_SPECIAL

	pickevent()
		if(!..())
			qdel(src)

	cycler_modifier(var/list/L)
		for(var/datum/round_event_control/E in L)
			if(!E.holidayID)
				L.Remove(E)
		return L


/datum/event_cycler/task_cycler
	frequency_lower = 2000	//3.33 minutes lower bound
	frequency_upper = 4000	//6.66 minutes upper bound.
	events_allowed = EVENT_TASK
	max_children = 2		//only 2 events are allowed to be active at the same time.
	endless = 1
	hideme = 1
	var/task_level = 1

	New()
		..(rand(frequency_lower,frequency_upper),"CentComm Supply","Exports")
		return

	cycler_modifier(var/list/L)
		for(var/datum/round_event_control/task/T in L)
			if(T.task_level > task_level)
				L.Remove(T)
		return L

///The cycler code itself.
/datum/event_cycler/
	var/events_allowed = EVENT_MINOR
	var/stress_level = 1
	var/schedule = 0
	var/npc_name = "Centcomm Officer Tom"
	var/frequency_lower = 3000	//5 minutes lower bound.
	var/frequency_upper = 6600	//11 minutes upper bound.
	var/in_rotation = 0			//this cycler makes another cycler when it's lifetime is 0 or less
	var/endless = 0				//doesn't check lifetime
	var/lifetime = 1			//how many events this cycler can fire until it retires (in_rotation must be 1)
	var/list/playlist = list()  //For custom, admin created cyclers. if any events are in this playlist the events allowed, stress level, and in_rotation are ignored
	var/remove_after_fire = 1	//For custom, admin created cyclers. if the event is removed after being fired
	var/prevent_stories = 0	    //For when an admin wants to make 600 gravitational anomalies without spamming the round story
	var/alerts = 1				//For when an admin doesn't want the events to send alerts
	var/branching = 1			//prevent an event from branching
	var/shuffle = 1				//if a cycler with a playlist fires in order or shuffles
	var/paused = 0				//When a cycler is paused.
	var/delete_warning = 0		//If the event scheduler cant fire a event in 2 tries it ends itself.
	var/max_children = -1		//0 and above are how many active events are allowed at the same time (used with task events)
	var/hideme

	New(var/schedule_arg, var/prefix, var/suffix, var/stress_arg) //argument: schedule_arg: how long in deciseconds for the initial fire of this cycler
		..()										//prefix and suffix determine the npc_name of the cycler. stress_arg is for rotation events to decide the stress
		stress_level = stress_arg
		if(in_rotation)
			switch(stress_level)
				if(1)
					events_allowed = EVENT_MINOR
					lifetime = rand(1,3)
					prefix = "CentComm Officer"
				if(2)
					events_allowed = EVENT_MAJOR
					lifetime = rand(1,2)
					prefix = "CentComm Lieutenant"
				if(3)
					events_allowed = EVENT_ENDGAME
					lifetime = 1
					prefix = "CentComm Commander"
			//setup the fluff name of the event cycler
			if(!suffix)
				suffix = pick(last_names)
		if(prefix && suffix)
			npc_name = "[prefix] [suffix]"
		else if (prefix && !suffix)
			npc_name = prefix
		else if (!prefix && suffix)
			npc_name = suffix
		else
			npc_name = prefix
		schedule = world.time + schedule_arg
		if(events)
			events.event_cyclers.Add(src)
		else
			qdel(src)

	proc/process()
		if(!events_allowed && !playlist.len && !in_rotation && !paused && !istype(src,/datum/event_cycler/admin_playlist))
			qdel(src)
			return
		if(paused) return
		if(!endless)
			if(lifetime <= 0) //It's time to move on and replace itself
				if(in_rotation)
					var/stress = 1
					switch(stress_level)
						if(1)
							stress = 2
						if(2)
							stress = 3
						else
							stress = 1
					var/datum/event_cycler/E = new /datum/event_cycler/rotation(rand(frequency_lower,frequency_upper),null,null,stress)
					E.frequency_lower = frequency_lower
					E.frequency_upper = frequency_upper
				qdel(src)
				return
		if(schedule <= world.time)
			var/playerC = 0
			for(var/mob/living/L in player_list)
				if(L.stat == 2) continue
				playerC++
			var/children_count = 0
			for(var/datum/round_event/event in events.active_events)
				if(event.cycler == src)
					children_count++
			if(max_children < 0 || children_count < max_children)
				if(playerC || !in_rotation)
					pickevent()
				schedule = world.time + rand(frequency_lower,frequency_upper)
			else //too many children, reschedule quicker
				schedule = world.time + rand(frequency_lower/2,frequency_upper/2) //half frequency

	proc/force_fire()
		if(playlist.len)
			if(pickevent())
				schedule = world.time + rand(frequency_lower,frequency_upper)
			else
				schedule = world.time + 10 // try again in a second
		else
			schedule = 0


	proc/pickevent()
		var/list/possible = list()
		if(!playlist.len)
			for(var/datum/round_event_control/E in events.all_events)
				if(E.event_flags & events_allowed)
					if(E.occurrences >= E.max_occurrences && E.max_occurrences >= 0) continue
					if(E.earliest_start >= world.time) continue
					if(E.typepath in events.last_event) continue
					if(E.holidayID)
						if(E.holidayID != holiday) continue
					if(E.weight <= 0) continue
					var/already_active = 0
					for(var/datum/round_event/R in events.active_events)
						if(R.type == E.typepath)
							already_active = 1
					if(!already_active)
						possible.Add(E)
		else
			var/datum/round_event_control/E
			if(!shuffle)
				E = playlist[1]
			else
				E = pick(playlist)
			if(E)
				if(E.RunEvent(src) == PROCESS_KILL)//we couldn't run this event for some reason, set its max_occurrences to 0
					E.max_occurrences = 0
					return
				else if(E in playlist)
					if(remove_after_fire)
						playlist.Remove(E)
				return E

		if(possible.len)
			for(var/datum/round_event_control/E in possible)
				if(!E.candidate_flag) continue
				var/list/candidcount = get_candidates_event(E.candidate_flag, E.candidate_afk_bracket)
				if(candidcount.len < E.candidates_needed)
					possible.Remove(E)

		possible = cycler_modifier(possible) //remove/add events based on the cycler's cycler_modifier() proc

		var/sum_of_weights = 0
		for(var/datum/round_event_control/E in possible)
			sum_of_weights += E.weight

		sum_of_weights = rand(0,sum_of_weights)	//reusing this variable. It now represents the 'weight' we want to select

		for(var/datum/round_event_control/E in possible)
			sum_of_weights -= E.weight

			if(sum_of_weights <= 0)				//we've hit our goal
				if(E.RunEvent(src) == PROCESS_KILL)//we couldn't run this event for some reason, set its max_occurrences to 0
					E.max_occurrences = 0
					continue
				else if(E in playlist)
					if(remove_after_fire)
						playlist.Remove(E)
				return E

		//no events were picked, reschedule quicker
		if(!delete_warning)
			schedule = world.time + rand(600,1800) //1 to 3 minutes
			delete_warning = 1
		else
			lifetime = 0

	proc/cycler_modifier(var/list/L)
		//default do nothing
		return L