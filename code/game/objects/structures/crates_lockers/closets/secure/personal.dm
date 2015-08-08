/obj/structure/closet/secure_closet/personal
	desc = "It's a secure locker for personnel. The first card swiped gains control."
	name = "personal closet"
	req_access = list(access_all_personal_lockers)
	var/registered_name = null

/obj/structure/closet/secure_closet/personal/New()
	..()
	if(prob(25))
		new /obj/item/weapon/storage/backpack/dufflebag(src)
	else if(prob(25))
		new /obj/item/weapon/storage/backpack(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_norm(src)
	new /obj/item/device/radio/headset( src )
	return


/obj/structure/closet/secure_closet/personal/patient
	name = "patient's closet"

/obj/structure/closet/secure_closet/personal/patient/New()
	..()
	contents.Cut()
	new /obj/item/clothing/under/color/white( src )
	new /obj/item/clothing/shoes/sneakers/white( src )
	return



/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"

/obj/structure/closet/secure_closet/personal/cabinet/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened

/obj/structure/closet/secure_closet/personal/cabinet/New()
	..()
	contents = list()
	new /obj/item/weapon/storage/backpack/satchel/withwallet( src )
	new /obj/item/device/radio/headset( src )
	return

/obj/structure/closet/secure_closet/personal/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W))
		var/obj/item/weapon/card/id/I = W.GetID()
		if(istype(I))
			if(src.broken)
				user << "\red It appears to be broken."
				return
			if(!I || !I.registered_name)	return
			if(src.allowed(user) || !src.registered_name || (istype(I) && (src.registered_name == I.registered_name)))
				//they can open all lockers, or nobody owns this, or they own this locker
				src.locked = !( src.locked )
				if(src.locked)	src.icon_state = src.icon_locked
				else	src.icon_state = src.icon_closed

				if(!src.registered_name)
					src.registered_name = I.registered_name
					src.desc = "Owned by [I.registered_name]."
			else
				user << "\red Access Denied"
		else
			..()
	else
		..()
	return

/obj/structure/closet/secure_closet/personal/togglelock(mob/user as mob)
	if(src.allowed(user))
		src.locked = !src.locked
		for(var/mob/O in viewers(user, 3))
			if((O.client && !( O.blinded )))
				O << "<span class='notice'>The locker has been [locked ? null : "un"]locked by [user].</span>"
		if(src.locked)
			src.icon_state = src.icon_locked
		else
			src.icon_state = src.icon_closed
		return
	else
		if (istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(!H.wear_id)
				user << "<span class='notice'>Access Denied</span>"
				return
			var/obj/item/weapon/card/id/I = H.wear_id.GetID()
			if(!I || !I.registered_name)
				user << "<span class='notice'>Access Denied</span>"
				return
			if (src.allowed(user) || istype(I) && (src.registered_name == I.registered_name))
				src.locked = !( src.locked )
				if(src.locked)	src.icon_state = src.icon_locked
				else	src.icon_state = src.icon_closed
				return
			else
				user << "<span class='notice'>Access Denied</span>"
				return
		user << "<span class='notice'>Access Denied</span>"