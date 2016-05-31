/datum/round_event_control/spider_infestation
	name = "Spider Infestation"
	typepath = /datum/round_event/spider_infestation
	event_flags = EVENT_STANDARD
	max_occurrences = 1
	weight = 5

/datum/round_event/spider_infestation
	alert_when	= 400

	var/spawncount = 1

	SetTimers()
		alert_when = rand(alert_when, alert_when + 50)

	Setup()
		spawncount = rand(5, 8)

	Alert()
		priority_announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", 'sound/AI/aliens.ogg')

	Start()
		if (!prevent_stories) EventStory("Spiders started breeding aboard [station_name()].")
		var/list/vents = list()
		for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in world)
			if(temp_vent.loc.z == 1 && !temp_vent.welded && temp_vent.network)
				if(temp_vent.network.normal_members.len > 20)
					vents += temp_vent

		while((spawncount >= 1) && vents.len)
			var/obj/vent = pick(vents)
			var/obj/effect/spider/spiderling/S = new(vent.loc)
			if(prob(66))
				S.grow_as = /mob/living/simple_animal/hostile/giant_spider/nurse
			vents -= vent
			spawncount--