/datum/round_event_control/radiation_storm
	name = "Radiation Storm"
	typepath = /datum/round_event/radiation_storm
	event_flags = EVENT_CONSEQUENCE
	max_occurrences = -1
	weight = 15
	accuracy = 50

/datum/round_event/radiation_storm
	var/list/protected_areas = list(/area/maintenance, /area/turret_protected/ai_upload, /area/turret_protected/ai_upload_foyer, /area/turret_protected/ai)

	SetTimers()
		start_when = rand(200,500)
		end_when = start_when + 300

	Alert()
		priority_announce("High levels of radiation detected near the station. Maintenance is best shielded from radiation.", "Anomaly Alert", 'sound/AI/radiation.ogg')
		//sound not longer matches the text, but an audible warning is probably good

	Start()
		if (!prevent_stories) EventStory("Radiation waves filled the air at [station_name()].")
		for(var/mob/living/carbon/C in living_mob_list)
			var/turf/T = get_turf(C)
			if(!T)			continue
			if(T.z != 1)	continue

			var/skip = 0
			for(var/a in protected_areas)
				if(istype(T.loc, a))
					skip = 1
					continue

			if(skip)	continue

			if(locate(/obj/machinery/power/apc) in T)	//damn you maint APCs!!
				continue

			if(istype(C, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = C
				events.AddAwards("eventmedal_radiation",list("[H.key]"))
				H.apply_effect((rand(15, 75)), IRRADIATE, 0)
				if(prob(5))
					H.apply_effect((rand(90, 150)), IRRADIATE, 0)
				if(prob(25))
					if(prob(75))
						randmutb(H)
						domutcheck(H, null, 1)
					else
						randmutg(H)
						domutcheck(H, null, 1)

			else if(istype(C, /mob/living/carbon/monkey))
				var/mob/living/carbon/monkey/M = C
				M.apply_effect((rand(15, 75)), IRRADIATE, 0)


	End()
		priority_announce("The radiation threat has passed. Please return to your workplaces.", "Anomaly Alert")