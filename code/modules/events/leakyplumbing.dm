/datum/round_event_control/leakyplumbing/
	name = "Leaky Plumbing"
	typepath = /datum/round_event/leakyplumbing/
	event_flags = EVENT_STANDARD
	max_occurrences = -1
	weight = 35
	earliest_start = 0

/datum/round_event/leakyplumbing/
	start_when = 0
	alert_when = 1200
	end_when = -1

	var/list/vents = list()
	var/obj/structure/toilet/chosen_toilet
	var/obj/item/trash/deadmouse/mouse
	var/interval = 2

	Setup()
		for(var/obj/machinery/atmospherics/unary/vent_scrubber/temp_vent in machines)
			if(temp_vent.loc.z == 1 && temp_vent.network)
				if(temp_vent.network.normal_members.len > 20)
					vents += temp_vent
		var/list/toilets = list()
		for(var/obj/structure/toilet/T in world)
			if(T.z != 1) continue
			toilets.Add(T)
		chosen_toilet = safepick(toilets)
		if(!vents.len || !chosen_toilet)
			return CancelSelf()

	Start()
		mouse = new(chosen_toilet)
		mouse.desc = "How did this get in here??"
		mouse.name = "dead toilet rat"
		if (!prevent_stories) EventStory("A rat crawled into one of the toilets causing a interference in the scrubbing system... somehow.")

	Tick()
		if(!chosen_toilet) AbruptEnd()
		if(!mouse) AbruptEnd()
		if(mouse.loc != chosen_toilet) AbruptEnd()
		if(active_for % interval == 0)
			var/obj/vent = safepick(vents)
			if(vent && vent.loc)
				var/datum/reagents/R = new/datum/reagents(50)
				R.my_atom = vent
				R.add_reagent("water", 50)

				var/datum/effect/effect/system/chem_smoke_spread/smoke = new
				smoke.set_up(R, rand(1, 2), 0, vent, 0, silent = 1)
				playsound(vent.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
				smoke.start()
				R.delete()	//GC the reagents

	End()
		for(var/mob/living/carbon/human/L in player_list)
			events.AddAwards("eventmedal_leakyplumbing",list("[L.key]"))

	Alert()
		send_alerts("Fluid buildup inside scrubber network detected. Please inspect all plumbing systems.")