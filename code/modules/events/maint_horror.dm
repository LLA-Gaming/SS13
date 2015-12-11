/datum/round_event_control/maint_horror
	name = "Maintenance Horror"
	typepath = /datum/round_event/maint_horror
	max_occurrences = 3
	weight = 15


/datum/round_event/maint_horror/start(loop=0)
	var/list/allowed = list(/mob/living/simple_animal/hostile/eyehorror=15,
		/mob/living/simple_animal/hostile/bear=15,
		/mob/living/simple_animal/hostile/giant_spider/hunter=15,
		/mob/living/simple_animal/hostile/retaliate/bat=15,
		/mob/living/carbon/human/npc/clown=5
		)
	var/list/maintareas = list()
	for(var/area/maintenance/A in world)
		maintareas.Add(A)
	var/safety_loop = loop + 1
	if(safety_loop > 50)
		kill()
		end()
	var/impact_area = safepick(maintareas)
	if(!impact_area)
		setup(safety_loop)
	var/list/turf_test = get_area_turfs(impact_area)
	if(!turf_test.len)
		setup(safety_loop)

	var/turf/T = pick(get_area_turfs(impact_area))
	var/picked = pick(allowed)
	if(T && picked)
		new picked(T.loc)
