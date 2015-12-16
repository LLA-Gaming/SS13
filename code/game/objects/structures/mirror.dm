//wip wip wup
/obj/structure/mirror
	name = "mirror"
	desc = "Mirror mirror on the wall, who's the most robust of them all?"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = 0
	anchored = 1
	var/shattered = 0


/obj/structure/mirror/attack_hand(mob/user as mob)
	if(shattered)	return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		var/userloc = H.loc

		//see code/modules/mob/new_player/preferences.dm at approx line 545 for comments!
		//this is largely copypasted from there.

		var/choice = input(user, "Hair Style or Color?", "Changing") as null|anything in list("Hair Style","Hair Color")

		switch(choice)
			if("Hair Style")
				var/s_choice = input(user, "Style", "Changing") as null|anything in list("Hair","Facial Hair")

				switch(s_choice)

					if("Hair")
						var/new_hair_style = input(user, "Select a hair style", "Grooming")  as null|anything in hair_styles_list
						if(userloc != H.loc) return	//no tele-grooming
						if(new_hair_style)
							H.hair_style = new_hair_style

					if("Facial Hair")
						var/new_facial_style = input(user, "Select a facial hair style", "Grooming")  as null|anything in facial_hair_styles_list
						if(userloc != H.loc) return	//no tele-grooming
						if(new_facial_style)
							H.facial_hair_style = new_facial_style

			if("Hair Color")
				var/c_choice = input(user, "Color", "Changing") as null|anything in list("Both","Hair Color","Facial Hair Color")

				switch(c_choice)

					if("Both")
						var/new_hair_color = input(user, "Select a hair colour:", "Grooming") as null|color
						if(userloc != H.loc) return	//no tele-grooming
						if(new_hair_color)
							H.hair_color = sanitize_hexcolor(new_hair_color)
							H.facial_hair_color = sanitize_hexcolor(new_hair_color)

					if("Hair Color")
						var/new_hair_color = input(user, "Select a hair colour:", "Grooming") as null|color
						if(userloc != H.loc) return	//no tele-grooming
						if(new_hair_color)
							H.hair_color = sanitize_hexcolor(new_hair_color)

					if("Facial Hair Color")
						var/new_facial_hair_color = input(user, "Select a facial hair colour:", "Grooming") as null|color
						if(userloc != H.loc) return	//no tele-grooming
						if(new_facial_hair_color)
							H.facial_hair_color = sanitize_hexcolor(new_facial_hair_color)

		H.update_hair()


/obj/structure/mirror/proc/shatter()
	if(shattered)	return
	shattered = 1
	icon_state = "mirror_broke"
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"


/obj/structure/mirror/bullet_act(var/obj/item/projectile/Proj)
	if(prob(Proj.damage * 2))
		if((Proj.damage_type == BRUTE || Proj.damage_type == BURN))
			if(!shattered)
				shatter()
			else
				playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
	..()


/obj/structure/mirror/attackby(obj/item/I as obj, mob/user as mob)
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return

	if(prob(I.force * 2))
		visible_message("<span class='warning'>[user] smashes [src] with [I]!</span>")
		shatter()
	else
		visible_message("<span class='warning'>[user] hits [src] with [I]!</span>")
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 70, 1)


/obj/structure/mirror/attack_alien(mob/living/user as mob)
	if(islarva(user)) return
	user.do_attack_animation(src, 1)
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return
	user.visible_message("<span class='danger'>[user] smashes [src]!</span>")
	shatter()


/obj/structure/mirror/attack_animal(mob/living/user as mob)
	if(!isanimal(user)) return
	user.do_attack_animation(src, 1)
	var/mob/living/simple_animal/M = user
	if(M.melee_damage_upper <= 0) return
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return
	user.visible_message("<span class='danger'>[user] smashes [src]!</span>")
	shatter()


/obj/structure/mirror/attack_slime(mob/living/user as mob)
	user.do_attack_animation(src, 1)
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return
	user.visible_message("<span class='danger'>[user] smashes [src]!</span>")
	shatter()