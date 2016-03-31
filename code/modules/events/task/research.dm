/datum/round_event_control/task/research
	name = "Research"
	typepath = /datum/round_event/task/research
	event_flags = EVENT_TASK | EVENT_HIDDEN
	weight = 10

	task_level = 2

/datum/round_event/task/research
	var/list/possible_goals = list(/obj/item/weapon/stock_parts/matter_bin/super,
									/obj/item/weapon/stock_parts/manipulator/pico,
									/obj/item/weapon/gun/energy/stunrevolver,
									/obj/item/weapon/gun/syringe/rapidsyringe,
									/obj/item/weapon/grenade/chem_grenade/large,
									/obj/item/device/mmi/radio_enabled,
									/obj/item/device/gps,
									/obj/item/device/mass_spectrometer/adv,
									/obj/item/weapon/stock_parts/capacitor/adv,
									/obj/item/weapon/stock_parts/scanning_module/adv,
									/obj/item/weapon/stock_parts/cell/super,
									/obj/item/weapon/reagent_containers/glass/beaker/noreact,
									/obj/item/clothing/mask/gas/welding,
									/obj/item/weapon/pickaxe/drill)
	Setup()
		var/goal = pick(possible_goals)
		var/atom/AM = new goal()
		task_name = "Research: [AM.name]"
		task_desc = pick("Please research and develop the following item: [AM.name]")
		goals.Add(goal)
		qdel(AM)
		..()

//advanced
/datum/round_event_control/task/research/advanced
	name = "Advanced Research"
	typepath = /datum/round_event/task/research/advanced
	task_level = 4

/datum/round_event/task/research/advanced
	possible_goals = list(/obj/item/weapon/storage/backpack/holding,
							/obj/item/weapon/gun/energy/xray,
							/obj/item/weapon/gun/projectile/automatic,
							/obj/item/slime_extract/adamantine,
							/obj/item/bluespace_crystal/artificial,
							/obj/item/weapon/aiModule/core/full/tyrant,
							/obj/item/weapon/reagent_containers/glass/beaker/cryoxadone,
							/obj/item/weapon/gun/energy/gun/nuclear,
							/obj/item/mecha_parts/mecha_equipment/weapon/honker,
							/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack,
							/obj/item/weapon/slimepotion,
							/obj/item/weapon/slimepotion2,
							/obj/item/weapon/slimesteroid,
							/obj/item/weapon/slimesteroid2)

	cash_out()
		..()
		for(var/mob/living/carbon/human/L in player_list)
			if(L.stat != DEAD)
				events.AddAwards("eventmedal_taskmaster",list("[L.key]"))