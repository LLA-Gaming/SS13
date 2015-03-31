//Alium nests. Essentially beds with an unbuckle delay that only aliums can buckle mobs to.

/obj/structure/stool/bed/nest/beepsky
	name = "beepsky nest"
	desc = "It's a gruesome pile of thick, metallic resin shaped like a nest."
	icon = 'icons/mob/alien_b.dmi'
	icon_state = "nest"

/obj/structure/stool/bed/nest/beepsky/unbuckle_other(mob/user as mob)
	buckled_mob.visible_message(\
		"<span class='notice'>[user.name] breaks [buckled_mob.name] free from the nest!</span>",\
		"[user.name] breaks you free from the nest.",\
		"You hear clanking...")
	buckled_mob.pixel_y = 0
	unbuckle()

/obj/structure/stool/bed/nest/beepsky/unbuckle_myself(mob/user as mob)
	buckled_mob.visible_message(\
		"<span class='warning'>[buckled_mob.name] struggles to break free of the nest...</span>",\
		"<span class='warning'>You struggle to break free from the nest...</span>",\
		"You hear clanking...")
	spawn(600)
		if(user && buckled_mob && user.buckled == src)
			buckled_mob.pixel_y = 0
			unbuckle()

/obj/structure/stool/bed/nest/beepsky/buckle_mob(mob/M as mob, mob/user as mob)
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || usr.stat || M.buckled || istype(user, /mob/living/silicon/pai) )
		return

	if(istype(M,/mob/living/carbon/alien))
		return
	if(!istype(user,/mob/living/carbon/alien/beepsky/humanoid))
		return

	unbuckle()

	if(M == usr)
		return
	else
		M.visible_message(\
			"<span class='notice'>[user.name] snaps [M.name] into the cuffs of [src]!</span>",\
			"<span class='warning'>[user.name] cuffs you to [src]!</span>",\
			"<span class='notice'>You hear clanking...</span>")
	M.buckled = src
	M.loc = src.loc
	M.dir = src.dir
	M.update_canmove()
	M.pixel_y = 0
	src.buckled_mob = M
	src.add_fingerprint(user)
	return

/obj/structure/stool/bed/nest/beepsky/attackby(obj/item/weapon/W as obj, mob/user as mob)
	var/aforce = W.force
	health = max(0, health - aforce)
	playsound(loc, 'sound/weapons/smash.ogg', 100, 1)
	for(var/mob/M in viewers(src, 7))
		M.show_message("<span class='warning'>[user] hits [src] with [W]!</span>", 1)
	healthcheck()


