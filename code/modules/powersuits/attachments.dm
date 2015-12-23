//attachments
/obj/item/weapon/powersuit_attachment
	name = "powersuit attachment"
	desc = "An attachment for power suits"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "romos2"
	item_state = "syringe_kit"
	w_class = 4
	layer = 3.3
	var/display_name
	var/attachment_type
	var/cost = 0
	var/on = 0
	var/active_vision = 0
	var/armor_stats = list()
	var/unpowered_armor = list(melee = 30, bullet = 15, laser = 30,energy = 10, bomb = 10, bio = 50, rad = 50)
	var/slowdown_stats = 1
	var/fist_damage = 0
	var/armor_iconstate
	var/compatible
	var/requires_helmet = 0

	var/obj/item/clothing/suit/space/powersuit/attached_to

	var/construction_time = 500
	var/list/construction_cost = list("metal"=20000,"glass"=5000, "plasma" = 2000)


/obj/item/weapon/powersuit_attachment/proc/power_punch(var/mob/living/victim, var/mob/living/assaulter, var/obj/item/organ/limb/affecting, var/armor_block, var/a_intent)
	return

/obj/item/weapon/powersuit_attachment/proc/activate_module()
	return

//power cells
/obj/item/weapon/stock_parts/cell/fusion
	name = "standard-capacity power core"
	desc = "attachable to powersuits"
	origin_tech = "powerstorage=4"
	icon_state = "fusion_core"
	maxcharge = 10000
	g_amt = 60
	rating = 5
	construction_time = 500
	construction_cost = list("metal" = 400, "plasma" = 2000, "glass" = 70)

datum/design/power_core
	name = "Power Core"
	desc = "A power core that holds 10000 units of energy. for power suits"
	id = "power_core"
	req_tech = list("powerstorage" = 4, "materials" = 4)
	build_type = 2 | 16
	materials = list("$metal" = 400, "$plasma" = 2000, "$glass" = 70)
	build_path = /obj/item/weapon/stock_parts/cell/fusion
	category = "Power Suit Equipment"

/obj/item/weapon/stock_parts/cell/fusion/extended
	name = "extended-capacity power core"
	maxcharge = 20000

/obj/item/weapon/stock_parts/cell/fusion/enhanced
	name = "enhanced power core"
	maxcharge = 30000