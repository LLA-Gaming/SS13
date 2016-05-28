/datum/round_event_control/prison_break
	name = "Prison Break"
	typepath = /datum/round_event/prison_break
	event_flags = EVENT_STANDARD
	max_occurrences = 2

/datum/round_event/prison_break
	alert_when = 400
	end_when = 300
	var/list/area/prisonAreas = list()

	Setup()
		for(var/area/security/A in world)
			if(istype(A, /area/security/prison) || istype(A, /area/security/brig))
				prisonAreas += A

	Alert()
		priority_announce("Gr3y.T1d3 virus detected in [station_name()] imprisonment subroutines. Recommend station AI involvement.", "Security Alert")

	Start()
		if (!prevent_stories) EventStory("The brig was infected by the Gr3y.T1d3 virus.")
		for(var/area/A in prisonAreas)
			for(var/obj/machinery/light/L in area_contents(A))
				L.flicker(10)

	End()
		for(var/area/A in prisonAreas)
			for(var/obj/O in area_contents(A))
				if(istype(O,/obj/structure/closet/secure_closet/brig))
					var/obj/structure/closet/secure_closet/brig/temp = O
					temp.locked = 0
					temp.icon_state = temp.icon_closed
				else if(istype(O,/obj/machinery/door/airlock/security))
					var/obj/machinery/door/airlock/security/temp = O
					temp.emergency = 1
					temp.locked = 0
					temp.update_icon(0)
				else if(istype(O,/obj/machinery/door/airlock/glass_security))
					var/obj/machinery/door/airlock/glass_security/temp = O
					temp.emergency = 1
					temp.locked = 0
					temp.update_icon(0)
				else if(istype(O,/obj/machinery/brig_timer))
					var/obj/machinery/brig_timer/temp = O
					temp.releasetime = 1