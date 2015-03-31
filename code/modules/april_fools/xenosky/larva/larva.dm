/mob/living/carbon/alien/beepsky/larva
	name = "beepsky larva"
	real_name = "beepsky larva"
	icon_state = "larva0"
	pass_flags = PASSTABLE

	maxHealth = 25
	health = 25
	storedPlasma = 50
	max_plasma = 50

	var/amount_grown = 0
	var/max_grown = 200
	var/time_of_birth

//This is fine right now, if we're adding organ specific damage this needs to be updated
/mob/living/carbon/alien/beepsky/larva/New()
	create_reagents(100)
	if(name == "beepsky larva")
		name = "beepsky larva ([rand(1, 1000)])"
	real_name = name
	regenerate_icons()
	..()

//This is fine, works the same as a human
/mob/living/carbon/alien/beepsky/larva/Bump(atom/movable/AM as mob|obj, yes)
	if ((!( yes ) || now_pushing))
		return
	now_pushing = 1
	if(ismob(AM))
		var/mob/tmob = AM
		tmob.LAssailant = src

	now_pushing = 0
	..()
	if (!istype(AM, /atom/movable))
		return
	if (!( now_pushing ))
		now_pushing = 1
		if (!( AM.anchored ))
			var/t = get_dir(src, AM)
			step(AM, t)
		now_pushing = null


//This needs to be fixed
/mob/living/carbon/alien/beepsky/larva/Stat()
	..()
	stat(null, "Progress: [amount_grown]/[max_grown]")

/mob/living/carbon/alien/beepsky/larva/adjustToxLoss(amount)
	if(stat != DEAD)
		amount_grown = min(amount_grown + 1, max_grown)
	..(amount)


/mob/living/carbon/alien/beepsky/larva/ex_act(severity)
	..()

	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if (1.0)
			gib()
			return

		if (2.0)

			b_loss += 60

			f_loss += 60

			ear_damage += 30
			ear_deaf += 120

		if(3.0)
			b_loss += 30
			if (prob(50))
				Paralyse(1)
			ear_damage += 15
			ear_deaf += 60

	adjustBruteLoss(b_loss)
	adjustFireLoss(f_loss)

	updatehealth()



/mob/living/carbon/alien/beepsky/larva/blob_act()
	if (stat == 2)
		return
	var/shielded = 0

	var/damage = null
	if (stat != 2)
		damage = rand(10,30)

	if(shielded)
		damage /= 4

		//paralysis += 1

	show_message("\red The blob attacks you!")

	adjustFireLoss(damage)

	updatehealth()
	return


//can't equip anything
/mob/living/carbon/alien/beepsky/larva/attack_ui(slot_id)
	return

/mob/living/carbon/alien/beepsky/larva/attack_animal(mob/living/simple_animal/M as mob)
	//honking angel only
	if (M.quantum_locked)
		return
	if (istype(M, /mob/living/simple_animal/hostile/weeping_honk) && M.a_intent == "disarm")
		teletouch(M)
		return
	////////////////////
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		//M.do_attack_animation(src)
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[M]</B> [M.attacktext] [src]!", 1)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		adjustBruteLoss(damage)
		add_logs(M, src, "attacked", admin=0)
		updatehealth()


/mob/living/carbon/alien/beepsky/larva/attack_paw(mob/living/carbon/monkey/M as mob)
	if(!(istype(M, /mob/living/carbon/monkey)))	return//Fix for aliens receiving double messages when attacking other aliens.

	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return
	..()

	switch(M.a_intent)

		if ("help")
			help_shake_act(M)
		else
			//M.do_attack_animation(src)
			if (istype(wear_mask, /obj/item/clothing/mask/muzzle))
				return
			if (health > 0)
				playsound(loc, 'sound/weapons/bite.ogg', 50, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("<span class='danger'>[M.name] bites [src]!</span>"), 1)
				adjustBruteLoss(rand(1, 3))
				updatehealth()
	return


/mob/living/carbon/alien/beepsky/larva/attack_slime(mob/living/carbon/slime/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if(M.Victim) return // can't attack while eating!

	if (health > -100)
		//M.do_attack_animation(src)

		for(var/mob/O in viewers(src, null))
			if ((O.client && !( O.blinded )))
				O.show_message(text("\red <B>The [M.name] glomps []!</B>", src), 1)

		var/damage = rand(1, 3)

		if(M.is_adult)
			damage = rand(20, 40)
		else
			damage = rand(5, 35)

		adjustBruteLoss(damage)


		updatehealth()

	return

/mob/living/carbon/alien/beepsky/larva/attack_hand(mob/living/carbon/human/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return

	..()

	switch(M.a_intent)

		if ("help")
			help_shake_act(M)

		if ("grab")
			if (M == src || anchored)
				return
			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src )

			M.put_in_active_hand(G)

			G.synch()

			LAssailant = M

			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			for(var/mob/O in viewers(src, null))
				if ((O.client && !( O.blinded )))
					O.show_message(text("\red [] has grabbed [] passively!", M, src), 1)

		else
			//M.do_attack_animation(src)
			var/damage = rand(1, 9)
			if (prob(90))
				if (HULK in M.mutations)
					damage += 5
					spawn(0)
						Paralyse(1)
						step_away(src,M,15)
						sleep(3)
						step_away(src,M,15)
				playsound(loc, "punch", 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has kicked []!</B>", M, src), 1)
				if ((stat != DEAD) && (damage > 4.9))
					Weaken(rand(5,10))
					for(var/mob/O in viewers(M, null))
						if ((O.client && !( O.blinded )))
							O.show_message(text("\red <B>[] has weakened []!</B>", M, src), 1, "\red You hear someone fall.", 2)
				adjustBruteLoss(damage)
				updatehealth()
			else
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has attempted to kick []!</B>", M, src), 1)
	return

/mob/living/carbon/alien/beepsky/larva/attack_alien(mob/living/carbon/alien/beepsky/humanoid/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return

	..()

	switch(M.a_intent)

		if ("help")
			sleeping = max(0,sleeping-5)
			resting = 0
			AdjustParalysis(-3)
			AdjustStunned(-3)
			AdjustWeakened(-3)
			for(var/mob/O in viewers(src, null))
				if ((O.client && !( O.blinded )))
					O.show_message(text("\blue [M.name] nuzzles [] trying to wake it up!", src), 1)

		else
			if (health > 0)
				//M.do_attack_animation(src)
				playsound(loc, 'sound/effects/sparks1.ogg', 50, 1, -1)
				var/damage = rand(1, 3)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("<span class='danger'>[M.name] zaps []!</span>", src), 1)
				adjustBruteLoss(damage)
				updatehealth()
			else
				M << "\green <B>[name] is too injured for that.</B>"
	return

/mob/living/carbon/alien/beepsky/larva/restrained()
	return 0

/mob/living/carbon/alien/beepsky/larva/var/co2overloadtime = null
/mob/living/carbon/alien/beepsky/larva/var/temperature_resistance = T0C+75

// new damage icon system
// now constructs damage icon for each organ from mask * damage field


/mob/living/carbon/alien/beepsky/larva/show_inv(mob/user)
	return

/mob/living/carbon/alien/beepsky/larva/toggle_throw_mode()
	return

/* Commented out because it's duplicated in life.dm
/mob/living/carbon/alien/beepsky/larva/proc/grow() // Larvae can grow into full fledged Xenos if they survive long enough
	if(icon_state == "larva_l" && !canmove) // This is a shit death check. It is made of shit and death. Fix later.
		return
	else
		var/mob/living/carbon/alien/beepsky/humanoid/A = new(loc)
		A.key = key
		qdel(src) */
