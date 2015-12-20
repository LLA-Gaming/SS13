/obj/item/weapon/powersuit_attachment/armor/
	name = "standard armor"
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "rig-ancient"
	attachment_type = POWERSUIT_ARMOR
	armor_stats = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 100, rad = 100) //Same as armor vest (plus bio/rad support)
	slowdown_stats = 1

/obj/item/weapon/powersuit_attachment/armor/security
	name = "security armor"
	slowdown_stats = 0
	armor = list(melee = 70, bullet = 70, laser = 25, energy = 15, bomb = 50, bio = 100, rad = 100)

/obj/item/weapon/powersuit_attachment/armor/syndicate
	name = "syndicate armor"
	slowdown_stats = 0
	armor_stats = list(melee = 15, bullet = 70, laser = 70, energy = 15, bomb = 50, bio = 100, rad = 100)

//non-armor armor
/obj/item/weapon/powersuit_attachment/armor/accelerator // I'm Accelerating
	name = "acceleration boots"
	slowdown_stats = 0
	armor_stats = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 100)
	slowdown_stats = -1
	cost = 10