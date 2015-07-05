/datum/round_event_control/hivebots
	name = "Hivebot Invasion"
	typepath = /datum/round_event/hivebots
	weight = 5
	max_occurrences = 1

/datum/round_event/hivebots
	announceWhen	= 5
	var/area/impact_area

/datum/round_event/hivebots/setup()
	impact_area = findEventArea()

/datum/round_event/hivebots/announce()
	priority_announce("Synthetic lifesigns detected in [impact_area.name]", "Unidentified Objects Located", 'sound/AI/aliens.ogg')


/datum/round_event/hivebots/start()
	var/turf/T = pick(get_area_turfs(impact_area))
	if(T)
		new /obj/structure/hivebot_tele(T.loc)