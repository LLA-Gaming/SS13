/datum/round_event_control/EMP_wave
	name = "EMP Wave"
	typepath = /datum/round_event/EMP_wave
	event_flags = EVENT_CONSEQUENCE
	weight = 10

/datum/round_event/EMP_wave
	var/area/impact_area
	alert_when = 100

	Setup()
		impact_area = FindEventAreaNearPeople()
		if(!impact_area)
			CancelSelf()

	Alert()
		send_alerts("Electromagnetic overload detected in the powernet. Area effected: [impact_area.name].")

	Start()
		var/sound_played = 0
		for(var/obj/machinery/M in area_contents(impact_area))
			M.emp_act(rand(1,3))
			if(!sound_played)
				playsound(get_turf(M), 'sound/weapons/flash.ogg', 100, 1)
				sound_played = 1