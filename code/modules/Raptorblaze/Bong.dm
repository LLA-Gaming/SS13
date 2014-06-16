
/obj/item/weapon/reagent_containers/spacebong
    name = "Space Bong"
    desc = "a filtration device/apparatus generally used for smoking perfectly legal herbal substances."
    icon = 'icons/obj/Spacebong.dmi'
    icon_state = "Spacebong_empty"
    w_class = 2.0
    amount_per_transfer_from_this = 0
    possible_transfer_amounts = list()
    volume = 60
    var/lit = 0 // Track if the bong is lit or not
    flags = OPENCONTAINER | NOREACT

/obj/item/weapon/reagent_containers/spacebong/proc/updatebong_icon()
	if(src.reagents.has_reagent("water",10))
		icon_state = "Spacebong_full"
	else
		icon_state = "Spacebong_empty"
	return


/obj/item/weapon/reagent_containers/spacebong/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)
	..()
	if(istype(O, /obj/item/weapon/reagent_containers/))
		if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown/))
			if((O.reagents.total_volume + src.reagents.total_volume) > src.volume)
				user << "<span class='notice'>The [src.name]'s bowl can't fit the [O.name]</span>"
				updatebong_icon()
				return
			O.reagents.trans_to(src, 60)
			user << "<span class='notice'>You add the [O.name] to the bowl.</span>"
			user.unEquip(O, 1)
			qdel(O)
			updatebong_icon()
			return
	else
		if(istype(O, /obj/item/weapon/lighter))
			var/obj/item/weapon/lighter/L = O
			if((L.lit == 1))
				lit = 1
				user << "<span class='notice'> ou light the bowl with the [L.name].</span>"
				updatebong_icon()
				return
			else
				user << "<span class='notice'>The [L.name] is not lit!</span>"
				updatebong_icon()
				return
		if(istype(O, /obj/item/weapon/match))
			var/obj/item/weapon/match/M = O
			if((M.lit == 1))
				lit = 1
				user << "<span class='notice'>You light the bowl with the [M.name].</span>"
				updatebong_icon()
				return
			else
				user << "<span class='notice'>The [M.name] is not lit!</span>"
				updatebong_icon()
				return
		if(istype(O, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = O
			if(WT.welding == 1)
				lit = 1
				src.reagents.add_reagent("fuel", 1)
				user << "<span class='notice'>You light the bowl with the [WT.name].</span>"
				updatebong_icon()
				return
			else
				user << "<span class ='notice'>The [WT.name] is not lit!</span>"
				return
		updatebong_icon()
		return

/obj/item/weapon/reagent_containers/spacebong/verb/empty_bong(mob/user) //clear contents
	set name = "Clean out the bong"
	set category = "Object"
	set src in oview(1)
	if(!usr.canmove || usr.stat || usr.restrained()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return
	src.reagents.clear_reagents()
	updatebong_icon()
	user << "<span class='notice'>You dump out the [src.name] onto the floor.</span>"
	return

/obj/item/weapon/reagent_containers/spacebong/afterattack(obj/target, mob/user, proximity)
	if(target.is_open_container())
		src.reagents.clear_reagents()
		user << "<span class='notice'>You clumsily splash the [src.name] contents onto the [target.name]. The [src.name] definitely wasn't designed for pouring.</span>"
		updatebong_icon()
		return
	else
		updatebong_icon()
		return

/obj/item/weapon/reagent_containers/spacebong/attack(mob/M, mob/user, proximity)
	if(!(M == user)) //Sorry, can't force someone to hit a bong, as lame as that makes them. This is meant for killing cool people.
		updatebong_icon()
		return
	if(src.reagents.total_volume == 0)
		user << "<span class='notice'>The [src.name] is empty!</span>"
		updatebong_icon()
		return
	if(src.lit == 1)
		if (src.reagents.has_reagent("water",1))
			src.reagents.trans_to(user, 10)
			user << "<span class='notice'>You take a rip off the [src.name].</span>"
			src.lit = 0
			updatebong_icon()
			return
		else
			user << "<span class='notice'>You take a harsh toke off the [src.name].</span>"
			src.reagents.trans_to(user,60)
			updatebong_icon()
			sleep(5)
			user << "<span class='notice'>You fall to the ground and begin to cough.</span>"
			user.Weaken(12)
			user.Stun(12)
			var/mob/living/U = user
			U.apply_effect(STUTTER,12)
			src.lit = 0
			return
	else
		user << "<span class='notice'>The [src.name] isn't lit!</span>"
		updatebong_icon()
		return





