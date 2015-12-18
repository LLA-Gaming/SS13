/obj/item/weapon/powersuit_attachment/armor/
	name = "standard armor"
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "rig-ancient"
	attachment_type = POWERSUIT_ARMOR
	armor_stats = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 100) //Same as armor vest (plus rad support)
	slowdown_stats = 1

/obj/item/weapon/powersuit_attachment/armor/security
	name = "security armor"
	slowdown_stats = 0

/obj/item/weapon/powersuit_attachment/armor/syndicate
	name = "syndicate armor"
	slowdown_stats = 0