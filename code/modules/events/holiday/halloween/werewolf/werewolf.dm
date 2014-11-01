#define WEREWOLF_HUMAN_COOLDOWN 5
#define WEREWOLF_COOLDOWN 4

/mob/living/carbon/human/var/LastTransformation = 0

/mob/living/carbon/werewolf
	name = "Werewolf"
	real_name = "Werewolf"
	voice_name = "Werewolf"

	icon = 'icons/mob/human.dmi'
	icon_state = "werewolf"

	// Speaking
	voice_message = "snarls"
	say_message = "snarls"

	// Can't crawl through vents
	ventcrawler = 0

	//No icon updating
	update_icon = 1

	status_flags = CANPARALYSE

	// AI can't track us
	digitalcamo = 1

	var/has_fine_manipulation = 0
	// Werewolf specific variables

	var/lastTransformation = 0 // Last Transformation as world.time
	var/transformationCooldownMinimum = 3 // Minutes

	var/mob/living/carbon/human/humanForm = 0

	var/damage = 25

	var/message_sent = 0

	// Wolf to Human
	proc/Transform()
		humanForm.loc = get_turf(src)
		humanForm.client = src.client
		src.mind.transfer_to(humanForm)
		humanForm.LastTransformation = world.time
		invisibility = 101

		humanForm.canmove = 0
		canmove = 0

		var/atom/movable/overlay/animation = new /atom/movable/overlay( loc )
		animation.layer = MOB_LAYER + 1
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/human.dmi'
		animation.master = src
		flick("were2h", animation)
		sleep(14)
		qdel(animation)

		canmove = 1
		humanForm.canmove = 1

		humanForm.regenerate_icons()

		humanForm.toxloss = getToxLoss()
		humanForm.oxyloss = getOxyLoss()
		humanForm.heal_overall_damage(100, 100)
		humanForm.take_overall_damage(getBruteLoss(), getFireLoss())
		humanForm.updatehealth()

		qdel(src)

	// Human to Wolf
	proc/Initiate(var/mob/living/carbon/human/H)
		if(!istype(H))	return 0
		if(!H)	return 0
		if(!H.client)	return 0
		if(H.stat != 0)	return 0

		if(H.mind)
			H.mind.special_role = "Werewolf"

		for(var/obj/item/I in H)
			H.unEquip(I)

		invisibility = 101
		H.invisibility = 101

		H.canmove = 0
		canmove = 0

		var/atom/movable/overlay/animation = new /atom/movable/overlay( loc )
		animation.layer = MOB_LAYER + 1
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/human.dmi'
		animation.master = src
		flick("h2were", animation)
		sleep(14)
		qdel(animation)

		H.canmove = 1
		canmove = 1

		humanForm = H
		spawn(-1)
			humanForm.regenerate_icons()

		toxloss = humanForm.getToxLoss()
		bruteloss = humanForm.getBruteLoss()
		oxyloss = humanForm.getOxyLoss()
		fireloss = humanForm.getFireLoss()

		H.loc = 0

		src.client = H.client
		H.mind.transfer_to(src)

		invisibility = 0
		H.invisibility = 0



		return 1

	New()
		..()
		create_reagents(1000)

		lastTransformation = world.time
		sight |= SEE_MOBS

		internal_organs += new /obj/item/organ/appendix
		internal_organs += new /obj/item/organ/heart
		internal_organs += new /obj/item/organ/brain

		hud_used = new /datum/hud(src)

		spawn(100)
			if(!humanForm)
				message_admins("Werewolf created without human form variable. Deleting.")
				qdel(src)

	Life()
		set invisibility = 0
		set background = BACKGROUND_ENABLED

		..()

		if(stat != 2)
			breathe()

			handle_chemicals_in_body()

		var/datum/gas_mixture/environment
		if(loc)
			environment = loc.return_air()

		if(environment)
			handle_environment(environment)

		if(client)
			handle_regular_hud_updates()

		handle_regular_status_updates()
		update_canmove()

		if(stat == 0)
			if(world.time > lastTransformation + ((transformationCooldownMinimum * 60) * 10))
				if(!message_sent)
					src << "<div class='warning'>You feel the curse's power beginning to fade!</div>"
					message_sent = 1
				if(prob(5))
					Transform()

	UnarmedAttack(var/atom/A)
		if(!istype(A, /mob))
			A.attack_alien(src)
		else
			if(istype(A, /mob/living))
				HandleAttack(A)

		//Prying airlocks open.
		if(istype(A, /obj/machinery/door/airlock))
			var/obj/machinery/door/airlock/AL = A

			if(!AL.density)	return //already open

			src << "<div class='info'>You start to pry the [AL] open!</a>"
			if(do_after(src, 25, needhand = 0))
				if(AL.locked)
					src << "<div class='warning'>You fail to pry open the [AL].</div>"
					return
				AL.open()

	var/lastFling = 0
	var/flingCooldown = 10

	AltClickOn(var/atom/A)

		if(get_dist(A, src) > 1)	return

		if(world.time < lastFling + ((flingCooldown*10)))
			src << "<div class='warning'>You can't do that yet!</div>"
			return

		if(istype(A, /mob/living))
			var/flingDir = src.dir
			var/mob/living/L = A

			if(L == src)
				src << "<div class='warning'>You can't fling yourself!</div>"
				return

			var/turf/T = get_turf(src)
			T.visible_message("<div class='warning'>[src] flings [L].</div>")

			if(issilicon(L))
				var/datum/effect/effect/system/spark_spread/system = new()
				system.set_up(3, 0, get_turf(L))
				system.start()

			for(var/i = 0; i < 5; i++)
				step(L, flingDir, 0)
			L.Weaken(3)
			L.Stun(3)

		lastFling = world.time

	var/lastMiddleClick = 0
	var/middleClickCooldown = 5

	MiddleClickOn(var/atom/A)
		..()

		if(get_dist(A, src) > 1)	return

		if(world.time < lastMiddleClick + (middleClickCooldown*10))
			src << "<div class='warning'>You can't do that yet!</div>"
			return

		lastMiddleClick = world.time

		var/mob/living/M
		if(istype(A, /mob/living))
			M = A
		else return

		var/turf/T = get_turf(src)

		if(issilicon(M))
			T.visible_message("<div class='warning'>[src] pushes away [M].</div>")
			M.Stun(4)
			playsound(M, 'sound/weapons/bladeslice.ogg', 20, 0, 0, 0, 1)

			step(M, get_dir(src, M))

			var/datum/effect/effect/system/spark_spread/system = new()
			system.set_up(3, 0, get_turf(src))
			system.start()
			return

		M.Weaken(3)
		T.visible_message("<div class='warning'>[src] knocks down [M].</div>")
		src << "<div class='info'>You knock down [M]</div>"

	proc/HandleAttack(var/mob/living/M)
		if(M == src)
			src << "<div class='warning'>You can't attack yourself!</div>"
			return

		var/turf/T = get_turf(src)

		if(M.stat == 0)

			// Missing

			if(prob(5))
				src << "<div class='warning'>You miss [M]!</div>"
				playsound(src, 'sound/weapons/slashmiss.ogg', 20, 0, 0, 0, 1)
				return

/*
			// Stuns borgs & pushes them away

			if(issilicon(M))
				if(prob(40))
					T.visible_message("<div class='warning'>[src] pushes away [M].</div>")
					M.Stun(4)
					playsound(M, 'sound/weapons/bladeslice.ogg', 20, 0, 0, 0, 1)

					step(M, get_dir(src, M))

					var/datum/effect/effect/system/spark_spread/system = new()
					system.set_up(3, 0, get_turf(src))
					system.start()
					return
*/
			// Handle regular attack

			T.visible_message("<div class='warning'>[src] slashes [M]</div>")
			playsound(M, 'sound/weapons/bladeslice.ogg', 20, 0, 0, 0, 1)
			M.apply_damage(rand(round(damage / 2), damage))

			// Knocking down

			if(prob(40) && !issilicon(M))
				M.Weaken(3)
				T.visible_message("<div class='warning'>[src] knocks down [M].</div>")
				src << "<div class='info'>You knock down [M]</div>"

			add_logs(src, M, "slashed")

			if(prob(15))
				new /obj/effect/decal/cleanable/blood/splatter(get_turf(M))
		else
			if(issilicon(M))	return

			// Feeding on mobs

			src << "<div class='info'>You begin feeding on [M]</div>"
			T.visible_message("<div class='warning'>[src] begins feeding on [M].</div>")
			while(do_after(src, 25, needhand = 0))
				if(!M)	return
				if(M.stat == 1)
					if(health >= 100)
						health = maxHealth
						src << "<div class='info'>We're fully healed.</div>"
					heal_organ_damage(5, 5)
					M.take_organ_damage(5, 5)
					src << "<div class='info'>You feed from [M].</div>"
					T.visible_message("<div class='warning'>[src] fed from [M].</div>")

				/*
				// Devour instead, if they're already dead.

				else
					src << "<div class='info'>You devour [M].</div>"
					T.visible_message("<div class='warning'>[src] devoured [M].</div>")

					if(isalien(M))
						new /obj/effect/decal/remains/xeno(get_turf(M))
					else
						new /obj/effect/decal/remains/human(get_turf(M))
					qdel(M)
				*/

	Stat()
		..()
		statpanel("Status")
		stat(null, "Health: [health]")

	throw_mode_on()
		return

	throw_mode_off()
		return


	var/lastHowl = 0
	var/howlCooldown = 30

	verb/Howl()
		set category = "Werewolf"
		set name = "Howl"

		if(stat != 0)
			return

		if(world.time < lastHowl + ((howlCooldown*10)))
			src << "<div class='warning'>You can't do that yet!</div>"
			return

		var/turf/T = get_turf(src)
		T.visible_message("<div class='warning'><b>[src] howls!</b></div>")

		for(var/mob/living/L in range(4))
			if(L == src)	continue
			L.Weaken(3)
			L.Stun(3)
			if(issilicon(L))
				var/datum/effect/effect/system/spark_spread/system = new()
				system.set_up(3, 0, get_turf(L))
				system.start()

		lastHowl = world.time