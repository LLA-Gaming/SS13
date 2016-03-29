/datum/round_event_control/task/recalled_item
	name = "Item Recalled"
	typepath = /datum/round_event/task/recalled_item
	event_flags = EVENT_TASK | EVENT_HIDDEN
	weight = 10

	task_level = 1

/datum/round_event/task/recalled_item
	Setup()
		var/list/possible_goals = list(/obj/item/clothing/gloves/fyellow,
										/obj/item/weapon/clipboard,
										/obj/item/weapon/bikehorn,
										/obj/item/weapon/soap,
										/obj/item/weapon/paper,
										/obj/item/weapon/bedsheet,
										/obj/item/weapon/caution,
										/obj/item/weapon/extinguisher,
										)
		var/goal = pick(possible_goals)
		var/atom/AM = new goal()
		task_name = "Item Recalled: [AM.name]"
		task_desc = pick("We are in a short supply of [AM.name] back here. We could use more",
						"The syndicate is holding one of the commanders hostage and is demanding [AM.name]. send us some",
						"Some of the [AM.name] that we shipped to your station MAY be infected with a dangerous contangion and we just need a sample to confirm")
		goals.Add(goal)
		qdel(AM)
		..()