/obj/item/weapon/powersuit_assembly/
	var/construction_time = 500
	var/list/construction_cost = list("metal"=20000,"glass"=5000)

/obj/item/weapon/powersuit_assembly/l_arm
	name = "power suit left arm"
	icon = 'icons/obj/powersuit_assembly.dmi'
	icon_state = "p-armor_l-arm"

/obj/item/weapon/powersuit_assembly/r_arm
	name = "power suit right arm"
	icon = 'icons/obj/powersuit_assembly.dmi'
	icon_state = "p-armor_r-arm"

/obj/item/weapon/powersuit_assembly/l_leg
	name = "power suit left leg"
	icon = 'icons/obj/powersuit_assembly.dmi'
	icon_state = "p-armor_l-leg"

/obj/item/weapon/powersuit_assembly/r_leg
	name = "power suit right leg"
	icon = 'icons/obj/powersuit_assembly.dmi'
	icon_state = "p-armor_r-leg"

/obj/item/weapon/powersuit_assembly/torso
	name = "power suit torso"
	icon = 'icons/obj/powersuit_assembly.dmi'
	icon_state = "p-armor_torso"

//stand
/obj/item/weapon/powersuit_assembly/stand
	name = "power suit assembly stand"
	desc = "used to build power suits"
	icon = 'icons/obj/powersuit_assembly.dmi'
	icon_state = "p-armor_stand"
	construction_cost = list("metal"=15000)

	var/wrench_me = 0

	var/torso = 0
	var/r_arm = 0
	var/l_arm = 0
	var/r_leg = 0
	var/l_leg = 0

	attackby(var/obj/item/I, mob/user as mob)
		if(!wrench_me)
			if(istype(I, /obj/item/weapon/powersuit_assembly/torso))
				if(torso) return
				user.remove_from_mob(I)
				overlays += image(I.icon, I.icon_state)
				qdel(I)
				playsound(get_turf(src), pick('sound/items/Screwdriver.ogg', 'sound/items/Screwdriver2.ogg'), 100, 0, 0)
				wrench_me = 1
				torso = 1
				return
			if(istype(I, /obj/item/weapon/powersuit_assembly/r_arm))
				if(r_arm) return
				user.remove_from_mob(I)
				overlays += image(I.icon, I.icon_state)
				qdel(I)
				playsound(get_turf(src), pick('sound/items/Screwdriver.ogg', 'sound/items/Screwdriver2.ogg'), 100, 0, 0)
				wrench_me = 1
				r_arm = 1
				return
			if(istype(I, /obj/item/weapon/powersuit_assembly/l_arm))
				if(l_arm) return
				user.remove_from_mob(I)
				overlays += image(I.icon, I.icon_state)
				qdel(I)
				playsound(get_turf(src), pick('sound/items/Screwdriver.ogg', 'sound/items/Screwdriver2.ogg'), 100, 0, 0)
				wrench_me = 1
				l_arm = 1
				return
			if(istype(I, /obj/item/weapon/powersuit_assembly/r_leg))
				if(r_leg) return
				user.remove_from_mob(I)
				overlays += image(I.icon, I.icon_state)
				qdel(I)
				playsound(get_turf(src), pick('sound/items/Screwdriver.ogg', 'sound/items/Screwdriver2.ogg'), 100, 0, 0)
				wrench_me = 1
				r_leg = 1
				return
			if(istype(I, /obj/item/weapon/powersuit_assembly/l_leg))
				if(l_leg) return
				user.remove_from_mob(I)
				overlays += image(I.icon, I.icon_state)
				qdel(I)
				playsound(get_turf(src), pick('sound/items/Screwdriver.ogg', 'sound/items/Screwdriver2.ogg'), 100, 0, 0)
				wrench_me = 1
				l_leg = 1
				return
		else
			if(istype(I, /obj/item/weapon/wrench))
				playsound(get_turf(src), 'sound/items/Ratchet.ogg', 100, 0, 0)
				wrench_me = 0
				if(torso && l_arm && r_arm && l_leg && r_leg)
					new /obj/item/clothing/suit/space/powersuit(get_turf(src))
					qdel(src)
				return