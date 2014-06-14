
// Yes this is purely for fun (and learning!)
/obj/item/weapon/gun/bluespacelauncher
	name = "bluespace crystal launcher"
	desc = "so much potential!"
	icon = 'icons/obj/gun.dmi'
	icon_state = "riotgunblue"
	item_state = "riotgunblue"
	w_class = 4.0
	throw_speed = 2
	throw_range = 7
	force = 5.0
	var/list/grenades = new/list()
	var/max_grenades = 9
	m_amt = 2000

	examine()
		set src in view()
		..()
		if(!(usr in view(2)) && usr != loc)
			return
		usr << "[grenades] / [max_grenades] crystals."

	attackby(obj/item/I as obj, mob/user as mob)

		if((istype(I, /obj/item/bluespace_crystal)))
			if(grenades.len < max_grenades)
				user.drop_item()
				I.loc = src
				grenades += I
				user << "\blue You put the crystal in the crystal launcher."
				user << "\blue [grenades.len] / [max_grenades] Crystals."
			else
				usr << "\red The crystal launcher cannot hold more crystals."

	afterattack(obj/target, mob/user , flag)

		if (istype(target, /obj/item/weapon/storage/backpack ))
			return

		else if (locate (/obj/structure/table, src.loc))
			return

		else if(target == user)
			return

		if(grenades.len)
			spawn(0) fire_grenade(target,user)
		else
			usr << "\red The grenade launcher is empty."

	proc
		fire_grenade(atom/target, mob/user)
			for(var/mob/O in viewers(world.view, user))
				O.show_message(text("\red [] fired a crystal!", user), 1)
			user << "\red You fire the crystal launcher!"
			var/obj/item/weapon/grenade/chem_grenade/F = grenades[1] //Now with less copypasta!
			grenades -= F
			F.loc = user.loc
			F.throw_at(target, 30, 2)
			playsound(user.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)


