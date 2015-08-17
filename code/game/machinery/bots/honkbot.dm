/obj/machinery/bot/honk
	name = "Honk Pal"
	desc = "HONK"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "honk"
	layer = 5.0
	density = 0
	anchored = 0
	health = 50
	maxhealth = 50
	req_access =list(access_theatre)
	var/movement = 1
	var/talk = 1
	var/list/puns = list("Two cannibals are eating a clown, one says to the other \"does this taste funny to you?\"","I'd tell you a chemistry joke but I know I wouldn't get a reaction.","I wasn't originally going to get a brain transplant, but then I changed my mind.","Did you hear about the guy who got hit in the head with a can of sun kist? He was lucky it was a soft drink.","The chef backed up into the meat grinder and got a little behind in his work.","The other day I held an airlock open for a clown. I thought it was a nice jester.","Einstein developed a theory about space, and it was about time too.","never knew the price of a space pod was so astronomical!","Felt a little dim when I forgot about the replacement lightbulbs","Perseus' stun knife technology is really cutting edge.")
	var/turns_per_move = 3
	var/turns_since_move = 0

	New()
		..()

	turn_on()
		. = ..()
		src.updateUsrDialog()

	turn_off()
		..()
		src.updateUsrDialog()

	attack_hand(mob/user as mob)
		. = ..()
		if(.)
			return
		usr.set_machine(src)
		interact(user)

	interact(mob/user as mob)
		var/dat
		dat += hack(user)
		dat += text({"
	<TT><B>HONK BOT v2.2</B></TT><BR><BR>
	Status: []<BR>"},"<A href='?src=\ref[src];power=1'>[src.on ? "On" : "Off"]</A>")
		honk()

		user << browse("<HEAD><TITLE>Companion Bot v2.2 controls</TITLE></HEAD>[dat]", "window=autofriend")
		onclose(user, "autosec")
		return

	Topic(href, href_list)
		if(..())
			return
		usr.set_machine(src)
		if((href_list["power"]) && (src.allowed(usr)))
			if (src.on)
				turn_off()
			else
				turn_on()
			return

	proc/honk()
		if(on)
			playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/tablet))
			if(src.allowed(user) && !open)
				src.locked = !src.locked
				user << "Controls are now [src.locked ? "locked." : "unlocked."]"
			else
				if(open)
					user << "\red Please close the access panel before locking it."
				else
					user << "\red Access denied."
		else
			..()
			if(!istype(W, /obj/item/weapon/screwdriver) && !istype(W, /obj/item/weapon/weldingtool) && (W.force))
				honk()

	explode()
		src.on = 0
		visible_message("<span class='userdanger'>[src] blows apart!</span>", 1)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		qdel(src)
		return

	process()
		set background = BACKGROUND_ENABLED

		if(!src.on)
			return

		//movement
		if(isturf(src.loc))
			turns_since_move++
			if(turns_since_move >= turns_per_move)
				if(!(pulledby) && (src.on))
					Move(get_step(src,pick(cardinal)))
					turns_since_move = 0

		if(prob(5))
			honk()
			speak(pick(puns))



/obj/item/weapon/storage/fancy/crayons/attackby(obj/item/weapon/S as obj, mob/user as mob)

	if ((!istype(S, /obj/item/weapon/bikehorn)))
		..()
		return

	if(src.contents.len >= 1)
		user << "<span class='notice'>You need to empty [src] out first.</span>"
		return

	var/obj/item/weapon/honk_assembly/A = new /obj/item/weapon/honk_assembly

	user.put_in_hands(A)
	user << "<span class='notice'>You attach the bikehorn to [src]</span>"
	user.unEquip(src, 1)
	qdel(S)
	qdel(src)

/obj/item/weapon/honk_assembly/
	name = "honk pal assembly"
	desc = "honk"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "honk_proxy0"
	var/buildstep = 0

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		..()
		switch(buildstep)
			if(0)
				if (istype(W, /obj/item/clothing/mask/gas/clown_hat))
					buildstep++
					user << "<span class='notice'>You add the [W] to [src]</span>"
					icon_state = "honk_proxy[buildstep]"
					name = "metalbox/screen assembly"
					qdel(W)
			if(1)
				if (istype(W, /obj/item/weapon/grown/bananapeel/))
					buildstep++
					user << "<span class='notice'>You add the [W] to [src]</span>"
					icon_state = "honk_proxy[buildstep]"
					qdel(W)
			if(2)
				if (istype(W, /obj/item/robot_parts/l_arm) || (istype(W, /obj/item/robot_parts/r_arm)))
					buildstep++
					user << "<span class='notice'>You add the [W] to [src]</span>"
					qdel(W)
					var/obj/machinery/bot/honk/C = new /obj/machinery/bot/honk
					C.loc = src.loc
					qdel(src)