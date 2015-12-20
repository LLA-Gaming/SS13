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
	var/armor_stats = list()
	var/slowdown_stats = 1
	var/fist_damage = 0

	var/obj/item/clothing/suit/space/powersuit/attached_to


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
	rating = 3

/obj/item/weapon/stock_parts/cell/fusion/extended
	name = "extended-capacity power core"
	maxcharge = 20000

/obj/item/weapon/stock_parts/cell/fusion/enhanced
	name = "enhanced power core"
	maxcharge = 30000