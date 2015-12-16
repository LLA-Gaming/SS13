/mob/living/carbon/monkey
	name = "monkey"
	voice_name = "monkey"
	voice_message = "chimpers"
	say_message = "chimpers"
	icon = 'icons/mob/monkey.dmi'
	icon_state = "monkey1"
	gender = NEUTER
	pass_flags = PASSTABLE
	update_icon = 0		///no need to call regenerate_icon
	ventcrawler = 1

/mob/living/carbon/monkey/thedon
	name = "The Don"
	voice_name = "monkey"
	voice_message = "chimpers"
	say_message = "chimpers"
	icon = 'icons/mob/monkey.dmi'
	icon_state = "thedon1"
	gender = NEUTER
	pass_flags = PASSTABLE
	update_icon = 0		///no need to call regenerate_icon
	ventcrawler = 1

/mob/living/carbon/monkey/New()
	create_reagents(1000)
	verbs += /mob/living/proc/mob_sleep
	verbs += /mob/living/proc/lay_down

	internal_organs += new /obj/item/organ/appendix
	internal_organs += new /obj/item/organ/heart
	internal_organs += new /obj/item/organ/brain

	if(name == "monkey")
		name = text("monkey ([rand(1, 1000)])")
	real_name = name
	gender = pick(MALE, FEMALE)

	..()

/mob/living/carbon/monkey/movement_delay()
	var/tally = 0
	if(reagents)
		if(reagents.has_reagent("hyperzine")) return -1

		if(reagents.has_reagent("nuka_cola")) return -1

	var/health_deficiency = (100 - health)
	if(health_deficiency >= 45) tally += (health_deficiency / 25)

	if (bodytemperature < 283.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75
	return tally+config.monkey_delay

/mob/living/carbon/monkey/Bump(atom/movable/AM as mob|obj, yes)
	if ((!( yes ) || now_pushing))
		return
	now_pushing = 1
	if(ismob(AM))
		var/mob/tmob = AM
		if(!(tmob.status_flags & CANPUSH))
			now_pushing = 0
			return

		tmob.LAssailant = src
	now_pushing = 0
	..()
	if (!istype(AM, /atom/movable))
		return
	if (!( now_pushing ))
		now_pushing = 1
		if (!( AM.anchored ))
			var/t = get_dir(src, AM)
			if (istype(AM, /obj/structure/window))
				if(AM:ini_dir == NORTHWEST || AM:ini_dir == NORTHEAST || AM:ini_dir == SOUTHWEST || AM:ini_dir == SOUTHEAST)
					for(var/obj/structure/window/win in get_step(AM,t))
						now_pushing = 0
						return
			step(AM, t)
		now_pushing = null


/mob/living/carbon/monkey/attack_paw(mob/living/M as mob)
	..()

	if (M.a_intent == "help")
		help_shake_act(M)
	else
		if ((M.a_intent == "harm" && !( istype(wear_mask, /obj/item/clothing/mask/muzzle) )))
			M.do_attack_animation(src, 1)
			if ((prob(75) && health > 0))
				playsound(loc, 'sound/weapons/bite.ogg', 50, 1, -1)
				for(var/mob/O in viewers(src, null))
					O.show_message("<span class='danger'>[M.name] bites [name]!</span>", 1)
				var/damage = rand(1, 5)
				adjustBruteLoss(damage)
				health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
				for(var/datum/disease/D in M.viruses)
					if(istype(D, /datum/disease/jungle_fever))
						contract_disease(D,1,0)
			else
				for(var/mob/O in viewers(src, null))
					O.show_message("<span class='danger'>[M.name] has attempted to bite [name]!</span>", 1)
	return

/mob/living/carbon/monkey/attack_hand(mob/living/carbon/human/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return

	if(..())	//To allow surgery to return properly.
		return

	if (M.a_intent == "help")
		help_shake_act(M)

	else
		if (M.a_intent == "harm")
			M.do_attack_animation(src, 1)
			if (prob(75))
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("<span class='danger'>[] has punched [name]!</span>", M), 1)

				playsound(loc, "punch", 25, 1, -1)
				var/damage = rand(5, 10)
				if (prob(40))
					damage = rand(10, 15)
					if ( (paralysis < 5)  && (health > 0) )
						Paralyse(rand(10, 15))
						spawn( 0 )
							for(var/mob/O in viewers(src, null))
								if ((O.client && !( O.blinded )))
									O.show_message(text("<span class='danger'>[] has knocked out [name]!</span>", M), 1)
							return
				adjustBruteLoss(damage)
				updatehealth()
			else
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("<span class='danger'>[] has attempted to punch [name]!</span>", M), 1)
		else
			if (M.a_intent == "grab")
				if (M == src || anchored)
					return

				var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src )

				M.put_in_active_hand(G)

				G.synch()

				LAssailant = M

				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				for(var/mob/O in viewers(src, null))
					O.show_message(text("\red [] has grabbed [name] passively!", M), 1)
			else
				if (!( paralysis ))
					if (prob(25))
						Paralyse(2)
						playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
						for(var/mob/O in viewers(src, null))
							if ((O.client && !( O.blinded )))
								O.show_message(text("<span class='danger'>[] has pushed down [name]!</span>", M), 1)
					else
						if(drop_item())
							playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
							for(var/mob/O in viewers(src, null))
								if ((O.client && !( O.blinded )))
									O.show_message(text("<span class='danger'>[] has disarmed [name]!</span>", M), 1)
	return

/mob/living/carbon/monkey/attack_alien(mob/living/carbon/alien/humanoid/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return

	switch(M.a_intent)
		if ("help")
			for(var/mob/O in viewers(src, null))
				if ((O.client && !( O.blinded )))
					O.show_message(text("\blue [M] caresses [src] with its scythe like arm."), 1)

		if ("harm")
			M.do_attack_animation(src, 1)
			if ((prob(95) && health > 0))
				playsound(loc, 'sound/weapons/slice.ogg', 25, 1, -1)
				var/damage = rand(15, 30)
				if (damage >= 25)
					damage = rand(20, 40)
					if (paralysis < 15)
						Paralyse(rand(10, 15))
					for(var/mob/O in viewers(src, null))
						if ((O.client && !( O.blinded )))
							O.show_message(text("<span class='danger'>[] has wounded [name]!</span>", M), 1)
				else
					for(var/mob/O in viewers(src, null))
						if ((O.client && !( O.blinded )))
							O.show_message(text("<span class='danger'>[] has slashed [name]!</span>", M), 1)
				adjustBruteLoss(damage)
				updatehealth()
			else
				playsound(loc, 'sound/weapons/slashmiss.ogg', 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("<span class='danger'>[] has attempted to lunge at [name]!</span>", M), 1)

		if ("grab")
			if (M == src || anchored)
				return
			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src )

			M.put_in_active_hand(G)

			G.synch()

			LAssailant = M

			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			for(var/mob/O in viewers(src, null))
				O.show_message(text("\red [] has grabbed [name] passively!", M), 1)

		if ("disarm")
			playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
			var/damage = 5
			if(prob(95))
				Weaken(10)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("<span class='danger'>[] has tackled down [name]!</span>", M), 1)
			else
				if(drop_item())
					for(var/mob/O in viewers(src, null))
						if ((O.client && !( O.blinded )))
							O.show_message(text("<span class='danger'>[] has disarmed [name]!</span>", M), 1)
			adjustBruteLoss(damage)
			updatehealth()
	return

/mob/living/carbon/monkey/attack_animal(mob/living/simple_animal/M as mob)
	//honking angel only
	if (M.quantum_locked)
		return
	if (istype(M, /mob/living/simple_animal/hostile/weeping_honk) && M.a_intent == "disarm")
		teletouch(M)
		return
	if (istype(M, /mob/living/simple_animal/hostile/weeping_honk) && M.a_intent == "grab")
		necksnap(M)
		return
	////////////////////
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 50, 1, 1)
		for(var/mob/O in viewers(src, null))
			O.show_message("<span class='danger'>[M] [M.attacktext] [src]!</span>", 1)
		add_logs(M, src, "attacked", admin=0)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		adjustBruteLoss(damage)
		updatehealth()


/mob/living/carbon/monkey/attack_slime(mob/living/carbon/slime/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if(M.Victim) return // can't attack while eating!

	if (health > -100)

		for(var/mob/O in viewers(src, null))
			if ((O.client && !( O.blinded )))
				O.show_message(text("<span class='danger'>The [M.name] glomps []!</span>", src), 1)

		var/damage = rand(1, 3)

		if(M.is_adult)
			damage = rand(20, 40)
		else
			damage = rand(5, 35)

		adjustBruteLoss(damage)

		if(M.powerlevel > 0)
			var/stunprob = 10
			var/power = M.powerlevel + rand(0,3)

			switch(M.powerlevel)
				if(1 to 2) stunprob = 20
				if(3 to 4) stunprob = 30
				if(5 to 6) stunprob = 40
				if(7 to 8) stunprob = 60
				if(9) 	   stunprob = 70
				if(10) 	   stunprob = 95

			if(prob(stunprob))
				M.powerlevel -= 3
				if(M.powerlevel < 0)
					M.powerlevel = 0

				visible_message("<span class='danger'>[M] shocked [src]!</span>", "<span class='userdanger'>[M] shocked [src]!</span>")

				Weaken(power)
				if (stuttering < power)
					stuttering = power
				Stun(power)

				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()

				if (prob(stunprob) && M.powerlevel >= 8)
					adjustFireLoss(M.powerlevel * rand(6,10))


		updatehealth()

	return

/mob/living/carbon/monkey/Stat()
	..()
	statpanel("Status")
	stat(null, text("Intent: []", a_intent))
	stat(null, text("Move Mode: []", m_intent))
	if(client && mind)
		if (client.statpanel == "Status")
			if(mind.changeling)
				stat("Chemical Storage", "[mind.changeling.chem_charges]/[mind.changeling.chem_storage]")
				stat("Absorbed DNA", mind.changeling.absorbedcount)
	return


/mob/living/carbon/monkey/verb/removeinternal()
	set name = "Remove Internals"
	set category = "IC"
	internal = null
	return

/mob/living/carbon/monkey/var/co2overloadtime = null
/mob/living/carbon/monkey/var/temperature_resistance = T0C+75

/mob/living/carbon/monkey/ex_act(severity)
	..()
	switch(severity)
		if(1.0)
			gib()
			return
		if(2.0)
			adjustBruteLoss(60)
			adjustFireLoss(60)
		if(3.0)
			adjustBruteLoss(30)
			if (prob(50))
				Paralyse(10)
	return

/mob/living/carbon/monkey/blob_act()
	if (stat != 2)
		adjustFireLoss(60)
		health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
	if (prob(50))
		Paralyse(10)
	if (stat == DEAD && client)
		gib()
		return
	if (stat == DEAD && !client)
		gibs(loc, viruses)
		qdel(src)
		return


/mob/living/carbon/monkey/IsAdvancedToolUser()//Unless its monkey mode monkeys cant use advanced tools
	return 0

/mob/living/carbon/monkey/canBeHandcuffed()
	return 1

//Baby monkey
/obj/item/baby_monkey
	icon = 'icons/mob/baby_monkey.dmi'
	layer = MOB_LAYER
	name = "Little Don"

	attack_hand(user)
		user << "<span class = 'notice'> you pet [src]"