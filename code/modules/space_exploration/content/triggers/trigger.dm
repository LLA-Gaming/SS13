/obj/effect/trigger
	icon = 'icons/effects/space_exploration.dmi'
	icon_state = "trigger"
	invisibility = 100
	layer = 4.1

	var/_id
	var/trigger_type = TT_NORMAL
	var/turf/location

	New()
		..()
		triggers.Add(src)

	initialize()
		location = get_turf(src)

		var/obj/effect/trigger_modules/trigger_type/type_module = locate() in location
		if(type_module)
			trigger_type = type_module.trigger_type

	proc/Evaluate()
		var/obj/effect/trigger_modules/conditional/condition = locate() in location
		if(condition)
			return condition.Evaluate()

		return 0
