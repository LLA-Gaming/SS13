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
										/obj/item/weapon/reagent_containers/food/snacks/baguette,
										/obj/item/weapon/reagent_containers/food/snacks/spagetti,
										/obj/item/weapon/reagent_containers/food/snacks/faggot,
										/obj/item/weapon/reagent_containers/food/snacks/donut,
										/obj/item/weapon/reagent_containers/food/snacks/grown/lemon,
										/obj/item/weapon/reagent_containers/food/snacks/grown/carrot,
										/obj/item/weapon/reagent_containers/food/snacks/grown/moonflower,
										/obj/item/clothing/head/hardhat/pumpkinhead,
										/obj/item/weapon/reagent_containers/food/snacks/grown/orange,
										/obj/item/weapon/reagent_containers/food/snacks/grown/potato,
										/obj/item/weapon/reagent_containers/food/drinks/soda_cans/dr_gibb,
										/obj/item/weapon/reagent_containers/food/drinks/soda_cans/thirteenloko,
										/obj/item/weapon/reagent_containers/food/drinks/soda_cans/tonic,
										/obj/item/weapon/reagent_containers/food/drinks/beer,
										/obj/item/weapon/reagent_containers/food/snacks/chocolateegg,
										/obj/item/weapon/reagent_containers/food/snacks/fortunecookie,
										/obj/item/weapon/reagent_containers/food/snacks/no_raisin,
										/obj/item/weapon/reagent_containers/food/snacks/grown/harebell,
										/obj/item/weapon/reagent_containers/food/snacks/grown/bluetomato,
										/obj/item/weapon/reagent_containers/food/snacks/grown/grass,
										/obj/item/weapon/reagent_containers/food/snacks/grown/watermelon,
										/obj/item/weapon/reagent_containers/food/snacks/grown/grapes,
										/obj/item/weapon/reagent_containers/food/snacks/grown/bloodtomato,
										/obj/item/weapon/reagent_containers/food/snacks/grown/bluespacetomato,
										/obj/item/weapon/reagent_containers/food/snacks/candy,
										/obj/item/weapon/reagent_containers/food/snacks/pie
										)
		var/goal = pick(possible_goals)
		var/atom/AM = new goal()
		task_name = "Services: [AM.name]"
		task_desc = "The Commander is seeking [AM.name]. Please produce this ASAP"
		goals.Add(goal)
		qdel(AM)
		..()