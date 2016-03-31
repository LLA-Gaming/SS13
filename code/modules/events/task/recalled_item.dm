/datum/round_event_control/task/recalled_item
	name = "Item Recalled"
	typepath = /datum/round_event/task/recalled_item
	event_flags = EVENT_TASK | EVENT_HIDDEN
	weight = 5

	task_level = 1

/datum/round_event/task/recalled_item
	Setup()
		var/list/possible_goals = list(/obj/item/clothing/gloves/yellow,
										//medical
										/obj/item/clothing/glasses/hud/health,
										/obj/item/weapon/scalpel,
										/obj/item/device/assembly/heartmonitor,
										/obj/item/weapon/gun/syringe,
										/obj/item/stack/medical/ointment,
										//science
										/obj/item/robot_parts,
										/obj/item/clothing/glasses/science,
										/obj/item/weapon/tank/plasma,
										/obj/item/slime_extract,
										/obj/item/weapon/firstaid_arm_assembly,
										//security
										/obj/item/clothing/glasses/hud/security,
										/obj/item/weapon/handcuffs,
										/obj/item/weapon/contraband/poster,
										/obj/item/device/flash,
										/obj/item/weapon/grenade/flashbang,
										//engineering
										/obj/item/clothing/head/cone,
										/obj/item/weapon/wirerod,
										/obj/item/weapon/tank/emergency_oxygen/engi,
										/obj/item/weapon/stock_parts/cell/high,
										/obj/item/weapon/storage/belt/utility,
										//service
										/obj/item/weapon/minihoe,
										/obj/item/weapon/mop,
										/obj/item/weapon/reagent_containers/food/drinks/flour,
										/obj/item/weapon/spacecash,
										/obj/item/weapon/dice,
										//other
										/obj/item/clothing/suit/labcoat/jacket,
										/obj/item/clothing/under/jeans,
										/obj/item/latexballon,
										/obj/item/weapon/shovel
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