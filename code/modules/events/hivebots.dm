/datum/round_event_control/hivebots
	name = "Hivebot Invasion"
	typepath = /datum/round_event/hivebots
	max_occurrences = 1
	weight = 5

/datum/round_event/hivebots
	announceWhen	= 5
	var/area/impact_area

/datum/round_event/hivebots/setup(loop=0)
	var/safety_loop = loop + 1
	if(safety_loop > 50)
		kill()
		end()
		return
	impact_area = findEventArea()
	if(!impact_area)
		setup(safety_loop)
	var/list/turf_test = get_area_turfs(impact_area)
	if(!turf_test.len)
		setup(safety_loop)

/datum/round_event/hivebots/kill()
	if(!impact_area)
		control.occurrences--
	return ..()

/datum/round_event/hivebots/announce()
	if(impact_area)
		priority_announce("Synthetic lifesigns detected in [impact_area.name]", "Unidentified Objects Located", 'sound/AI/aliens.ogg')


/datum/round_event/hivebots/start()
	var/turf/impact_turf = pick(get_area_turfs(impact_area))
	if(impact_turf)
		new /obj/structure/hivebot_tele(impact_turf.loc)