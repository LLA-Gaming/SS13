/datum/round_event_control/hivebots
	name = "Hivebot Invasion"
	typepath = /datum/round_event/hivebots
	weight = 5
	max_occurrences = 1

/datum/round_event/hivebots
	announceWhen	= 5
	var/area/impact_area
	var/turf/impact_turf

/datum/round_event/hivebots/setup()
	impact_area = findEventArea()
	if(impact_area)
		impact_turf = pick(get_area_turfs(impact_area))

/datum/round_event/hivebots/kill()
	if(!impact_turf)
		control.occurrences--
	return ..()

/datum/round_event/hivebots/announce()
	if(impact_turf)
		priority_announce("Synthetic lifesigns detected in [impact_area.name]", "Unidentified Objects Located", 'sound/AI/aliens.ogg')


/datum/round_event/hivebots/start()
	if(impact_turf)
		new /obj/structure/hivebot_tele(impact_turf.loc)