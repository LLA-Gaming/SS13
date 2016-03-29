/datum/round_event_control/task/services
	name = "Services needed"
	typepath = /datum/round_event/task/services
	event_flags = EVENT_TASK | EVENT_HIDDEN
	weight = 10

	task_level = 2

/datum/round_event/task/services
	Setup()
		var/list/possible_goals = list(/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiavulgaris,
										/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiadeus,
										/obj/item/weapon/reagent_containers/food/snacks/grown/tobacco,
										/obj/item/weapon/reagent_containers/food/snacks/grown/cocoapod,
										/obj/item/weapon/reagent_containers/food/snacks/grown/poppy,
										/obj/item/weapon/reagent_containers/food/snacks/sliceable/store/chocolatecake,
										/obj/item/weapon/reagent_containers/food/snacks/sausage,
										/obj/item/weapon/reagent_containers/food/snacks/waffles,
										/obj/item/weapon/reagent_containers/food/snacks/badrecipe,
										/obj/item/weapon/reagent_containers/food/snacks/baguette
										)
		var/goal = pick(possible_goals)
		var/atom/AM = new goal()
		task_name = "Services: [AM.name]"
		task_desc = "The Commander is seeking [AM.name]. Please produce this ASAP"
		goals.Add(goal)
		qdel(AM)
		..()