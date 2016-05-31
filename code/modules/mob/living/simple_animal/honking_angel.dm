/mob/living/simple_animal/var/quantum_locked = 0

/mob/living/simple_animal/hostile/weeping_honk
	name = "Honking Angel"
	desc = "Don't blink."
	icon = 'icons/mob/honkingangel.dmi'
	icon_state = ""
	icon_living = "d1"
	icon_dead = "d6"
	health = 500
	maxHealth = 500
	melee_damage_lower = 5
	melee_damage_upper = 10
	attacktext = "claws"
	wander = 0
	density = 1
	a_intent = "disarm"
	//temp stuff
	heat_damage_per_tick = 0	//amount of damage applied if animal's body temperature is higher than maxbodytemp
	cold_damage_per_tick = 0	//same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp
	//atmos stuff
	unsuitable_atoms_damage = 0
	min_oxy = 0
	max_oxy = 0					//Leaving something at 0 means it's off - has no maximum
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
//	can_unbuckle = 1
	////////////
	speed = -1
	//see_in_dark = 100

	//var/quantum_locked = 0 //moved to simple animal
	var/honktimer = 0
	var/id = ""
	var/disrupting = 0
	var/helping = 0
	var/const/quantum_lock_loop_delay = 1

	New()
		..()
		spawn(quantum_lock_loop_delay)
			quantum_lock_loop()

	Life()
		..()
		if (health > 0)
			if (health >=1 && health <=100)
				melee_damage_lower = 1
				melee_damage_upper = 4
				speed = 3
			else if (health >=101 && health <=200)
				melee_damage_lower = 1
				melee_damage_upper = 7
				speed = 2
			else if (health >=201 && health <=300)
				melee_damage_lower = 5
				melee_damage_upper = 10
				speed = 1
			else if (health >=301 && health <=400)
				melee_damage_lower = 5
				melee_damage_upper = 13
				speed = 0
			else if (health >=401 && health <=500)
				melee_damage_lower = 5
				melee_damage_upper = 16
				speed = -1



		if(stat != DEAD)
			//sight |= (SEE_MOBS)
			//HP bleeding
			if (health > 0)
				health -= 1


		if (honktimer > 0)
			honktimer--

		if (quantum_locked)
			LoseTarget()

		/*
			for (var/obj/o in range(14, src))
				if (o.light_power == TRUE && prob(10))
					o.break_light()
					o.disable_light()

			for (var/mob/M in viewers(src))
				for (var/obj/o in M.contents)
					if (o.light_power == TRUE && prob(10))
						o.break_light()
						o.disable_light()
		*/


			if (istype(loc, /obj))
				if (istype(loc, /obj/structure/closet))
					loc:open()


	Move()
		if (quantum_locked)
			return

		if (honktimer == 0 && prob(5))
			playsound(src.loc, 'sound/items/bikehorn_dark.ogg', 30, 1)
			honktimer = 10

		..()

	AttackingTarget()
		if (quantum_locked)
			return

		..()

	attack_animal(mob/living/simple_animal/M as mob)
		if (quantum_locked)
			M << "There is no effect."
			return
		if (istype(src, /mob/living/simple_animal/hostile/weeping_honk))
			return
		..()

	bullet_act()
		if (quantum_locked)
			return

		..()

	attack_hand(mob/living/carbon/human/M as mob)
		if (quantum_locked)
			M << "There is no effect."
			return

		..()

	attack_alien(mob/living/carbon/alien/humanoid/M as mob)
		if (quantum_locked)
			M << "There is no effect."
			return

		..()

	attack_larva(mob/living/carbon/alien/larva/L as mob)
		if (quantum_locked)
			L << "There is no effect."
			return

		..()

	attack_slime(mob/living/carbon/slime/M as mob)
		if (quantum_locked)
			return

		..()

	attackby(var/obj/item/O as obj, var/mob/user as mob)
		if (quantum_locked)
			user << "There is no effect."
			return

		..()

	ex_act(severity)
		if (quantum_locked)
			return

	Bumped(AM as mob|obj)
		return

	DestroySurroundings()
		return

	say_verb(message as text)
		steal_voice(message)
		return

	me_verb(message as text)
		if (quantum_locked)
			src << "You are quantum locked."
			return

	proc/quantum_lock_loop() //Done seperate to master controller for quicker update times. Ideally event driven.
		quantum_locked = 0
		if(mob_viewing_angel())
			quantum_locked = 1

		update_quantum_lock_effects()
		spawn(quantum_lock_loop_delay)
			quantum_lock_loop()


	proc/mob_viewing_angel()
		if (!istype(loc, /turf))
			return 0
		var/turf/simulated/t = get_turf(src)

		if (t.get_lumcount() * 10 >= 0.50)
			for(var/mob/M in viewers(src))
				if (!istype(M, /mob/living) || M.stat == DEAD || M:blinded > 0)
					continue

				if (M.loc.x > src.loc.x && M.dir == WEST)
					return 1

				if (M.loc.x < src.loc.x && M.dir == EAST)
					return 1

				if (M.loc.y < src.loc.y && M.dir == NORTH)
					return 1

				if (M.loc.y > src.loc.y && M.dir == SOUTH)
					return 1

		return 0

	proc/update_quantum_lock_effects()
		if (quantum_locked)
		//	icon_state = "frozen"
			canmove = 0
			if (health >=1 && health <=100)
				icon_state = "frozen-d5"
			else if (health >=101 && health <=200)
				icon_state = "frozen-d4"
			else if (health >=201 && health <=300)
				icon_state = "frozen-d3"
			else if (health >=301 && health <=400)
				icon_state = "frozen-d2"
			else if (health >=401 && health <=500)
				icon_state = "frozen-d1"

		else
			//icon_state = ""
			if (health >=1 && health <=100)
				icon_state = "d5"
			else if (health >=101 && health <=200)
				icon_state = "d4"
			else if (health >=201 && health <=300)
				icon_state = "d3"
			else if (health >=301 && health <=400)
				icon_state = "d2"
			else if (health >=401 && health <=500)
				icon_state = "d1"
			//buckled = 0 //old way
			canmove = 1



//intent changing verbs
/mob/living/simple_animal/hostile/weeping_honk/verb/harm_intent()
	set name = "Harm Intent"
	set desc = "Change intent to harm."
	set category = "H.Angel"
	src.a_intent = "hurt"
	src << {"\red <b>Set intent to clawing.</b>"}
	return

/mob/living/simple_animal/hostile/weeping_honk/verb/grab_intent()
	set name = "Grab Intent"
	set desc = "Change intent to grab."
	set category = "H.Angel"
	src.a_intent = "grab"
	src << {"\green <b>Set intent to grabbing.</b>"}
	return

/mob/living/simple_animal/hostile/weeping_honk/verb/disarm_intent()
	set name = "Disarm Intent"
	set desc = "Change intent to disarm."
	set category = "H.Angel"
	src.a_intent = "disarm"
	src << {"\blue <b>Set intent to disarm.</b>"}
	return

///////////////////////////////////////////



/mob/living/simple_animal/hostile/weeping_honk/verb/hsay(msg as text)
	set name = "hsay"
	set desc = "Angel telepathic communication."
	set category = "H.Angel"

	if(msg)
		if(src.id == "") //assign a unique ID if you dont have one.
			var/list/hex = list("A","B","C","D","E","F","1","2","3","4","5","6","7","8","9")
			var/one = pick(hex)
			var/two = pick(hex)
			var/three = pick(hex)
			src.id = one+two+three
		for (var/mob/living/simple_animal/hostile/weeping_honk/S in player_list)
			if(health > 0)
				log_say("AngelSay: [key_name(src)] : [msg]")
				S << {"<font color='purple'> <b>Honking Angel([id])</b> thinks: "[msg]"</font>"}
	return



/mob/living/proc/teletouch(mob/living/simple_animal/M as mob)
//	if (M.a_intent == "disarm")
	//spark at start
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(4, 2, get_turf(src.loc))
	s.start()
	//if(s) world << "yay s exists"
	//logg attacks
	M.attack_log += text("\[[time_stamp()]\] <font color='red'>teleport attacked [src.name] ([src.ckey])</font>")
	src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was teleport attacked by [M.name] ([M.ckey])</font>")
	//announce it to people in view.
	for(var/mob/O in viewers(src, null))
		O.show_message("\red <B>[M]</B> touched [src] who disappeared instantly!", 1)
	//give some clonedamage/damage
	var/N = rand(1,15)
	//exceptions for things that done have cloneloss
	if (istype(src, /mob/living/simple_animal) || istype(src, /mob/living/carbon/slime) || istype(src, /mob/living/carbon/alien/larva))
		src.health -= N
	else if (istype(src, /mob/living/silicon/robot))
		src.health -= N
	else
		src.adjustCloneLoss(N)
	//convert to angel health
	M.health += N*5

	//teleporting stuff
	var/x = rand(20,world.maxx-20)
	var/y = rand(20,world.maxy-20)
	var/turf/T = locate(x, y, 1)
	while (istype(get_turf(T), /turf/space))
		x = rand(20,world.maxx-20)
		y = rand(20,world.maxy-20)
		T = locate(x, y, 1)
	if(T)	src.loc = T
	//sparks at destination
	s.set_up(4, 2, get_turf(T))
	s.start()
	return

///////////////////////


/mob/living/simple_animal/hostile/weeping_honk/verb/power_disrupt()
	set name = "Power Disruption"
	set desc = "Disrupt and drain power from the local area."
	set category = "H.Angel"
	//find current area
	var/area/A = get_area(src.loc)
	//A = A.loc
	if (!( istype(A, /area))) // If its not a area, stop!
		return
	if(!A.requires_power) // If it doesn't require power, stop!
		return
	if (istype(A, /area/space)) // If it is space, LOVE OF GOD PLEASE STOP!
		src << "\red <b>There is no power to disrupt in space.</b>"
		return
	//stop if you are already disrupting
	if(src.disrupting)
		src << "\red <b>Disruption is not ready yet.</b>"
		return
	else disrupting = 1
	src << "\green <b>Disrupting Power.</b>"

//	if (A == "Space")
//		return
//	if (!( istype(A, /area) ))
//		return

	//spacecheck

	//flicker lights
	for(var/obj/machinery/light/L in A)
		L.flicker(10)
		var/R = rand(1,3)
		if (R == 3)
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(4, 2, get_turf(L.loc))
			s.start()
/*
	//setup to fuck with flashlights/lamps/hardhats
	var/list/portable_lights = list()
	for (var/obj/o in A)
		if (o.light_power == TRUE)
			if (istype(o, /obj/machinery/light))
				break
			portable_lights += o

	for (var/mob/M in A)
		for (var/obj/o in M.contents)
			if (o.light_power == TRUE)
				if (istype(o, /obj/machinery/light))
					break
				portable_lights += o
*/

	//fuck with the APC
	var/obj/machinery/power/apc/O = A.get_apc()
//	world << "APC name: [O.name]"
//	world << "First APC equipt: [O.equipment]"

	if (O)
		//store the original values to restore at the end.
		var/s_equp = O.equipment
		var/s_envi = O.environ
		for(var/i = 0; i < 10; i++)
			if (O.equipment == 0 || O.equipment == 1)
				O.equipment = 2
			else O.equipment = 0
			if (O.environ == 0 || O.environ == 1)
				O.environ = 2
			else O.environ = 0
//			world << "[i] APC equipt: [O.equipment]"
			//steal some power
			var/N = rand(0,3)
			if (O.cell.charge > 0)
				O.cell.charge -= N
				src.health += N
			O.update()
			O.update_icon()
			//portable lights
			//portable_lights.toggle_emitting_light()
			sleep(rand(5, 15))
		O.equipment = s_equp
		O.environ = s_envi
		O.update()
		O.update_icon()
//		world << "Final APC equipt: [O.equipment]"
										// val 0=off, 1=off(auto) 2=on 3=on(auto)
										// on 0=off, 1=on, 2=autooff
		sleep(rand(5, 15))

	sleep(50)
	disrupting = 0
	return



//stealing voice
/mob/living/simple_animal/hostile/weeping_honk/verb/steal_voice(msg as text)
	set name = "Steal Voice"
	set desc = "Speak through the body of a dead person."
	set category = "H.Angel"

	var/mob/living/carbon/target = locate() in range(0)
	if (!src.quantum_locked)
		if(target.stat == DEAD)
			var/N = src.name
			src.name = target.name
			src.say(msg)
			sleep(3)
			src.name = N
			return
			//src << {"\red <b>[target.name]debug: this should work</b>"}
		else
			src << {"\red <b>The target must be dead. This target is not dead.</b>"}
			return
	else
		src << {"\red <b>You are currently Quantum Locked and cannot perform this task.</b>"}
		return
	src << {"\red <b>To speak out loud you must be standing on a compatible corpse who will speak for you. To speak telepathically to other Angels use 'hsay' instead of say.</b>"}
	return



//the dredded neck snap.
/mob/living/proc/necksnap(mob/living/simple_animal/M as mob)
	if (M.health >=101 && M.health <=500)
		M << "\blue <b>You cannot use this intent until you are below 20% health. </b>"
		M << "\blue <b>Defaulting to harm intent. </b>"
		M.a_intent = "hurt"
		return
	else if (src.stat == DEAD || src.health <= 0)
		M << "\red <b>Target is already dead or dying. </b>"
		return
	else
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[M]</B> grabs [src] by the head!", 1)
		src.canmove = 0
		M.canmove = 0
	//resolve
		sleep(15)
		//resist
			//couldnt tie in the resist code organically.
		//locked
		if (M.quantum_locked)
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <B>[M]</B> is frozen and loses its grip on [src]'s head.", 1)
			src.canmove = 1
			M.canmove = 1
			return
		//the kill
		else
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <B>[M]</B> violently twists [src] by the head!", 1)
			for(var/mob/O in hearers(src, null))
				O.show_message("SNAP!", 2)
			playsound(loc, 'sound/effects/neck_snap.ogg', 50, 1)
			var/damage = src.health + 1
			apply_damage(damage, BRUTE, "head")
			src.canmove = 1
			M.canmove = 1
			return
	return



/mob/living/simple_animal/hostile/weeping_honk/verb/nightvision()
	set name = "Nightvision"
	set desc = "toggle seeing darkness."
	set category = "H.Angel"
	if (src.see_invisible == 25)
		src.see_invisible = SEE_INVISIBLE_MINIMUM
		src.see_in_dark = 8
		src << {"\blue You can now see in the dark."}
	else
		src.see_invisible = SEE_INVISIBLE_LIVING
		src.see_in_dark = 8
		src << {"\blue You can now see normally."}
	return



/mob/living/simple_animal/hostile/weeping_honk/verb/angel_help()
	set name = "Help"
	set desc = "Basic instructions on how to play the Honking Angel"
	set category = "H.Angel"
	if(src.disrupting)
		src << "\red <b>Antispam!</b>"
		return
	disrupting = 1
	src << "\red <b>WELCOME TO THE HONKING ANGEL HELP!</b>"
	src << "\blue <b>About:</b>"
	src << "Honking Angels are an ancient species of statuesque humanoids. Not to be confused with their weeping cousins, though they do share some similarities. Angels are predatory by nature and feed off forms of energy be it radiation, electricity, or even stealing energy from living beings. It's worth it to note that angels are sadistic and very intellegent. They find great pleasure harrassing and causing their prey anguish before striking. Angels have evolved with a very special defensive ability. They will involuntarily quantum lock when they are under observation to protect themselves to ALMOST all forms of harm. They also possess a voracious appetite and can starve to death in the span of a single round. In fact if you are reading this you are actually on your way to starvation right now so there is no time to waste. "
	src << "\blue <b>Health and Starvation:</b>"
	src << "\red To reiterate, your health constantly and slowly drains. This is to represent the starvation from energy that will eventually lead to death. The healtier you are, the faster you will move and the stronger your brute claw attack will be. Your health percentage can be viewed from the 'Status' tab and it is also displayed by the condition of your icon. Darker and skinnier is lower than lighter color and a full figure. To restore your life force you will need to steal it from the power network or from the life force of living creatures."
	src << "\blue <b>Abilities: </b>"
	src << "\red Quantum Locking"
	src << "Involuntary defense response to being observed by a nearby creature. While locked Angels are immune to most forms of damage."
	src << "\red Claw Attack"
	src << "To use the claw attack use the Harm Intent verb under the H.Angel tab and click the creature you want to attack. The damage of this attack will decrease as the angel slips farther and farther into starvation."
	src << "\red Teleporting Touch Attack"
	src << "this method of attack is set in with the Disarm Intent verb under H.Angel tab. Click an adjacent creature to touch them teleporting them off to a random part of the station. This attack will drain some of their life force and heal your starvation (which is also your HP). The ammount healed depends on the amount of damage done to the creation and can vary."
	src << "\red Neck Snapping"
	src << "This particularly horrifying form of attack is not available at all times. To use it set the Grab Intent verb. It may only be used by angels in the final form of starvation when the clown mask is abandoned showing their true face. This attack is not recommended under most circumstances considering it will no restore any of your starvation. It's still pretty awesome though."
	src << "\red Steal Voice"
	src << "An angel cannot speak out loud with mortal creatures. If you want to communicate with non angelic creatures you will need to stand on a corpse and use the 'say' verb as normal to manipulate its body to articulate your thoughts. If there is more than one body under you, you will not get to chose which body speaks."
	src << "\red Telepathic Communication"
	src << "in the event that there are other Angels on board the station you can communicate with them telepathically using the 'hsay' verb the same way you would use 'say'"
	src << "\red Power Disruption"
	src << "This power allows you to steal power from the local area APC. It can be done anywhere in an area that has one. The lights and local machines will flicker on and off with power as you steal a small amount of the local power to feed your hunger. Use of this ability is critical for survival. This ability can restore some of your hunger and also provide and opportunity for escape if being observed."
	src << "\red Prying Doors Open with Hands"
	src << "Angels can pry unpowered doors open with their hands to open them. This can be used together with Power disruption to gain access to new areas. One thing to note though, you will only disrupt power in the area you are standing. A good way to determine if you will be able to pry a door is to right click it and check the area it is a part of. If it is not the same as the one you are in, you will need to find an alternative route."
	src << "\blue <b>Goals: </b>"
	src << "Honking Angels are in it for the hunt. They have come to the station to feed on it, and its inhabitants energy. Honking Angels may kill indiscriminately but it is not neccessarily withing their intrests to do so all of the time. Good luck and have fun. If you have any questions feel free to ask in ahelp."
	sleep(1200)
	disrupting = 0
	return

//Door code

	//honking angel claw doors open
/obj/machinery/door/airlock/attack_animal(mob/living/simple_animal/M as mob)
	if(istype(M, /mob/living/simple_animal/hostile/weeping_honk))
		if(arePowerSystemsOn() && !(stat & NOPOWER))
			M << "\blue The airlock's motors resist your efforts to force it."
			return
		else if(locked)
			M << "\blue The airlock's bolts prevent it from being forced."
			return
		else if( !welded && !operating )
			if(density)
				spawn(0)	open(1)
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <B>[M]</B> prys open the [src] airlock with its fingers!", 1)
			else
				// angels cant pry the door closed.
				return
		else return
	return

/obj/machinery/door/firedoor/attack_animal(mob/living/simple_animal/M as mob)
	if(istype(M, /mob/living/simple_animal/hostile/weeping_honk))
		if(blocked || operating)	return
		if(density)
			open()
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <B>[M]</B> prys open the [src] with its fingers!", 1)
			return
		else //angels cant pry it closed.
			return
	return
