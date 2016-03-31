/datum/round_event_control/task/fresh_materials
	name = "Materials Needed"
	typepath = /datum/round_event/task/fresh_materials
	event_flags = EVENT_TASK | EVENT_HIDDEN
	weight = 5

	task_level = 1

/datum/round_event/task/fresh_materials
	Setup()
		var/list/possible_goals = list(/obj/item/stack/sheet/metal,
										/obj/item/stack/sheet/cardboard,
										/obj/item/stack/sheet/glass,
										/obj/item/stack/sheet/plasteel,
										/obj/item/stack/sheet/rglass,
										/obj/item/stack/sheet/mineral/plasma,
										/obj/item/stack/sheet/mineral/silver,
										/obj/item/stack/sheet/mineral/gold
										)
		var/goal = pick(possible_goals)
		var/atom/AM = new goal()
		task_name = "Material stocking: [AM.name]"
		task_desc = pick("Don't ask questions, we just need a sheet of [AM.name]")
		goals.Add(goal)
		qdel(AM)
		..()