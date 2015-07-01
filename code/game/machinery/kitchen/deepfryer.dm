/obj/machinery/deepfryer
	name = "deep fryer"
	desc = "Deep fried <i>everything</i>."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "fryer_off"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	var/on = FALSE	//Is it deep frying already?
	var/obj/item/frying = null	//What's being fried RIGHT NOW?

/obj/machinery/deepfryer/examine()
	..()
	if(frying)
		usr << "You can make out [frying] in the oil."

/obj/machinery/deepfryer/attackby(obj/item/I, mob/living/carbon/human/user)
	if(!anchored)
		if(istype(I, /obj/item/weapon/wrench))
			if(default_unfasten_wrench(user, I))
				power_change()
				return
		return
	if(on)
		user << "<span class='notice'>[src] is still active!</span>"
		return
	if(!istype(I, /obj/item/device/) && !istype(I, /obj/item/organ) && !istype(I, /obj/item/weapon) && !istype(I, /obj/item/weapon/reagent_containers/food/snacks/))
	// Is it a snack, organ, device, or weapon.. FRY IT UP!
		user << "<span class='warning'>Budget cuts won't let you put that in there.</span>"
		return
	if(istype(I, /obj/item/weapon/storage) || istype(I, /obj/item/weapon/card) || istype(I, /obj/item/weapon/twohanded) || istype(I, /obj/item/weapon/grab) || istype(I, /obj/item/device/tablet) || istype(I, /obj/item/weapon/melee/arm_blade) || istype(I, /obj/item/weapon/melee/energy/) || istype(I, /obj/item/weapon/gun/energy/) || istype(I, /obj/item/weapon/extinguisher/mini/nozzle) || istype(I, /obj/item/weapon/reagent_containers/spray/mister) || istype(I, /obj/item/weapon/pinpointer))
	// Block specific items
		user << "<span class='warning'>Budget cuts won't let you put that in there.</span>"
		return
	if(istype(I, /obj/item/weapon/wrench))
		if(default_unfasten_wrench(user, I))
			power_change()
			return
		return
	if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/deepfryholder))
		user << "<span class='userdanger'>You cannot doublefry.</span>"
		return
	else
		user << "<span class='notice'>You put [I] into [src].</span>"
		on = TRUE
		user.drop_item()
		frying = I
		frying.loc = src
		icon_state = "fryer_on"
		sleep(200)

		if(frying && frying.loc == src)
			var/obj/item/weapon/reagent_containers/food/snacks/deepfryholder/S = new(get_turf(src))
			if(istype(frying, /obj/item/weapon/reagent_containers/))
				var/obj/item/weapon/reagent_containers/food = frying
				food.reagents.trans_to(S, food.reagents.total_volume)
			S.color = "#FFAD33"
			S.icon = frying.icon
			S.overlays = I.overlays
			S.icon_state = frying.icon_state
			S.name = "deep fried [frying.name]"
			S.desc = I.desc
			S.w_class = I.w_class
			S.slot_flags = I.slot_flags
			qdel(frying)

		icon_state = "fryer_off"
		on = FALSE
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)


/obj/machinery/deepfryer/attack_hand(mob/user)
	if(on && frying)
		user << "<span class='notice'>You pull [frying] from [src]! It looks like you were just in time!</span>"
		user.put_in_hands(frying)
		frying = null
		return
	..()