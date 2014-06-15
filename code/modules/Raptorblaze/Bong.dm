
/obj/item/weapon/reagent_containers/spacebong
    name = "Space Bong"
    desc = "a filtration device/apparatus generally used for smoking perfectly legal herbal substances."
    icon = 'icons/obj/items.dmi'
    icon_state = "spacebong_empty"
    w_class = 2.0
    amount_per_transfer_from_this = 0
    possible_transfer_amounts = list()
    volume = 60
    var/lit = 0 // Track if the bong is lit or not


/obj/item/weapon/reagent_containers/spacebong/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)
	..()
	if(istype(O, /obj/item/weapon/reagent_containers/))
		if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown/))
			O.reagents.trans_to(src, 60)
			user << "<span class='notice'>You add the [O.name] to the bowl.</span>"
			user.unEquip(O, 1)
			qdel(O)
			return
		else
			if(O.reagents.has_reagent("water", 10))
				O.reagents.trans_id_to(src, "water", 10)
				user << "<span class='notice'>You add the water to the chamber.</span>"
				return
	else
		if(istype(O, /obj/item/weapon/lighter))
			var/obj/item/weapon/lighter/L = O
			if((Z.lit == 1))
				lit = 1
				user << "<span class='notice'> You light the bowl with the [L.name].</span>"
				return
			else
				user << "<span class='notice'> The [L.name] is not lit!</span>"
				return
		if(istype(O, /obj/item/weapon/match))
			var/obj/item/weapon/match/M = O
			if((M.lit == 1))
				lit = 1
				user << "<span class='notice'> You light the bowl with the [M.name].</span>"
				return
			else
				user << "<span class='notice'> The [M.name] is not lit!</span>"
				return
		if(istype(O, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = O
			if(WT.welding == 1)
				lit = 1
				src.reagents.add_reagent("fuel", 1)
				user << "<span class='notice'> You light the bowl with the [WT.name].</span>"
				return
			else
				user << "<span class ='notice'> The [WT.name] is not lit!</span>"
		return

/obj/item/weapon/reagent_containers/spacebong/verb/empty_bong() //clear contents
	set name = "Clean out the bong"
	set category = "Object"
	set src in range(0)
	src.reagents.clear_reagents()
	// no idea why this is calling as a var
	// user << "<span class='notice'> You dump out the bong onto the floor.</span>"

	return




