/mob/living/simple_animal/hostile/cosmic_bear
	name = "Cosmicam Ursus Mortis"
	desc = "Or, in English, that's the Cosmic Bear of Death"
	maxHealth = 1000
	health = 1000

	icon = 'icons/mob/deathbear.dmi'
	icon_state = "deathbear_idle"
	icon_living = "deathbear_idle"

	faction = "cosmicbear"
	universal_speak = 0
	voice_name = "Cosmic Bear of Death"
	voice_message = "snarls"

	see_invisible = SEE_INVISIBLE_MINIMUM
	see_in_dark = 10

	speed = 2
	environment_smash = 3
	melee_damage_lower = 60
	melee_damage_upper = 60
	attacktext = "smacks"
	a_intent = "harm"

	unsuitable_atoms_damage = 25

	status_flags = 0

	stop_automated_movement = 1

	//
	var/power_cooldown = 0
	var/adrenaline = 0

	New()
		..()
		bound_width = 3 * 32
		bound_height = 3 * 32

	Die()
		if(stat == DEAD)
			return
		..()
		visible_message("<span class='danger'>\the [src] lets out one final <b>ROAR!</b> before violently exploding!</span>")
		var/turf/turf_offset = get_step(get_turf(src),NORTHEAST)
		var/obj/item/clothing/head/bearpelt/B = new /obj/item/clothing/head/bearpelt(turf_offset)
		new /obj/effect/gibspawner/generic(turf_offset)
		for(var/i=0 , i<=8, i++)
			new /obj/item/weapon/reagent_containers/food/snacks/bearmeat(turf_offset)
		B.name = "Cosmic Bear Pelt"
		B.desc = "a bear pelt from a Cosmic Bear of Death"
		qdel(src)

	Adjacent(var/atom/neighbor)
		if(neighbor in bounds(1))
			return 1

	Process_Spacemove(var/check_drift = 0)
		return 1

	ClickOn(var/atom/A, params)
		if(world.time <= next_click)
			return
		next_click = world.time + 1

		if(client.buildmode) // comes after object.Click to allow buildmode gui objects to be clicked
			build_click(src, client.buildmode, params, A)
			return

		if(stat)
			return

		var/list/modifiers = params2list(params)
		if(modifiers["shift"] && modifiers["ctrl"])
			CtrlShiftClickOn(A)
			return
		if(modifiers["middle"])
			MiddleClickOn(A)
			return
		if(modifiers["shift"])
			ShiftClickOn(A)
			return
		if(modifiers["alt"]) // alt and alt-gr (rightalt)
			AltClickOn(A)
			return
		if(modifiers["ctrl"])
			CtrlClickOn(A)
			return

		if(world.time <= next_move)
			return

		face_atom(A)

		if(A in bounds(1))
			src.changeNext_move(16)
			bear_slap(A)

	face_atom(var/atom/A)
		if( buckled || stat != CONSCIOUS || !A || !x || !y || !A.x || !A.y ) return
		for(var/d in cardinal)
			if(get_turf(A) in GetDirectionalTurfs(d))
				dir = d
				return

	proc/cooldown()
		power_cooldown = 1
		spawn(300)
			power_cooldown = 0

	Bump(atom/A)
		if(A && adrenaline)
			if(istype(A,/mob/living))
				var/mob/living/M = A
				M.Weaken(1)
				return
			else
				bear_slap(A)

	verb/suicide()
		set hidden = 1

		if (stat == 2)
			src << "You're already dead!"
			return

		if (suiciding)
			src << "You're already committing suicide! Be patient!"
			return

		var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

		if(confirm == "Yes")
			health = 0

//powers
/mob/living/simple_animal/hostile/cosmic_bear/proc/bear_slap(var/atom/A)
	if(A == src)
		return
	if(istype(A, /obj/machinery) || istype(A, /obj/structure))
		visible_message("<span class='danger'>[src] smashes [A] apart!</span>")
		A.ex_act(1.0)
		playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
	if(istype(A,/mob/living))
		var/mob/living/target = A
		if(target.stat && istype(target,/mob/living/carbon))
			devour(target)
			return
		target.attack_animal(src)
		target.Weaken(1)
		for(var/i=0;7 > i; i++)
			step(target, src.dir)
			sleep(0.3)
	else
		UnarmedAttack(A)

/mob/living/simple_animal/hostile/cosmic_bear/verb/roar()
	set name = "Roar"
	set desc = "Scream really loud"
	set category = "Bear"

	if(stat == DEAD)
		return
	if(power_cooldown)
		src << "you need to wait at least 30 seconds before using powers again"
		return
	else
		src.visible_message("<font color='red' size='7'><b>ROAR!</b></font>")
		for(var/mob/living/M in oviewers(7,src))
			M.Weaken(3)
		cooldown()

/mob/living/simple_animal/hostile/cosmic_bear/verb/adrenaline()
	set name = "Adrenaline Rush"
	set desc = "Adrenaline Rush"
	set category = "Bear"
	if(power_cooldown)
		src << "you need to wait at least 30 seconds before using powers again"
		return
	if(!adrenaline || !power_cooldown)
		overlays += image('icons/mob/deathbear.dmi', "deathbear_eyes_adr")
		speed = -1
		adrenaline = 1
		src.visible_message("<span class='danger'>[src]'s eyes glow bright</span>")
		cooldown()
		spawn(50)
			overlays.Cut()
			adrenaline = 0
			speed = initial(speed)

/mob/living/simple_animal/hostile/cosmic_bear/proc/devour(var/mob/living/carbon/target)
	src.visible_message("<span class='danger'>[src] begins to devour [target]</span>")
	playsound(src, 'sound/effects/bear_eating.ogg', 100, 1)
	spawn(100)
		if(target in bounds(1))
			src.visible_message("<span class='danger'>[src] devours [target]</span>")
			if(ishuman(target) || ismonkey(target))
				var/mob/living/carbon/C_target = target
				var/obj/item/organ/brain/B = C_target.getorgan(/obj/item/organ/brain)
				if(B)
					B.loc = get_turf(C_target)
					B.transfer_identity(C_target)
					C_target.internal_organs -= B
			target.gib()
			health = maxHealth


//////Disables automatic control (this is a player only mob)
/mob/living/simple_animal/hostile/cosmic_bear/ListTargets()//Step 1, find out what we can see
	return

/mob/living/simple_animal/hostile/cosmic_bear/FindTarget()//Step 2, filter down possible targets to things we actually care about
	return

/mob/living/simple_animal/hostile/cosmic_bear/Found()//This is here as a potential override to pick a specific target if available
	return

/mob/living/simple_animal/hostile/cosmic_bear/PickTarget()//Step 3, pick amongst the possible, attackable targets
	return

/mob/living/simple_animal/hostile/cosmic_bear/CanAttack()//Can we actually attack a possible target?
	return

/mob/living/simple_animal/hostile/cosmic_bear/GiveTarget()//Step 4, give us our selected target
	return

/mob/living/simple_animal/hostile/cosmic_bear/MoveToTarget()//Step 5, handle movement between us and our target
	return

/mob/living/simple_animal/hostile/cosmic_bear/Goto()
	return

/mob/living/simple_animal/hostile/cosmic_bear/AttackTarget()
	return

/mob/living/simple_animal/hostile/cosmic_bear/AttackingTarget()
	return

/mob/living/simple_animal/hostile/cosmic_bear/Aggro()
	return

/mob/living/simple_animal/hostile/cosmic_bear/LoseAggro()
	return

/mob/living/simple_animal/hostile/cosmic_bear/LoseTarget()
	return

/mob/living/simple_animal/hostile/cosmic_bear/LostTarget()
	return

/mob/living/simple_animal/hostile/cosmic_bear/DestroySurroundings()
	return