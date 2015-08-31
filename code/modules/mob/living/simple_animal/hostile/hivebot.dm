/obj/item/projectile/hivebotbullet
	damage = 10
	damage_type = BRUTE

/mob/living/simple_animal/hostile/hivebot
	name = "hivebot"
	desc = "A small robot."
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "basic"
	icon_living = "basic"
	icon_dead = "basic"
	health = 15
	maxHealth = 15
	melee_damage_lower = 2
	melee_damage_upper = 3
	attacktext = "claws"
	projectilesound = 'sound/weapons/Gunshot.ogg'
	projectiletype = /obj/item/projectile/hivebotbullet
	faction = "hivebot"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple_animal/hostile/hivebot/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj,/obj/item/projectile/hivebotbullet))
		return
	else
		..()


/mob/living/simple_animal/hostile/hivebot/range
	name = "hivebot"
	desc = "A smallish robot, this one is armed!"
	ranged = 1
	retreat_distance = 5
	minimum_distance = 5

/mob/living/simple_animal/hostile/hivebot/rapid
	ranged = 1
	rapid = 1
	retreat_distance = 5
	minimum_distance = 5

/mob/living/simple_animal/hostile/hivebot/strong
	name = "strong hivebot"
	desc = "A robot, this one is armed and looks tough!"
	health = 80
	ranged = 1

/mob/living/simple_animal/hostile/hivebot/Die()
	..()
	visible_message("<b>[src]</b> blows apart!")
	new /obj/effect/decal/cleanable/robot_debris(src.loc)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return

/obj/structure/hivebot_tele
	name = "beacon"
	desc = "Some odd beacon thing."
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "def_radar-off"
	density = 1
	anchored = 1
	var/health = 200
	var/bot_type = "norm"
	var/bot_amt = 10
	var/spawn_delay = 600
	var/turn_on = 0
	var/auto_spawn = 1
	proc
		warpbots()


	New()
		..()
		var/datum/effect/effect/system/harmless_smoke_spread/smoke = new /datum/effect/effect/system/harmless_smoke_spread()
		smoke.set_up(5, 0, src.loc)
		smoke.start()
		visible_message("\red <B>The [src] warps in!</B>")
		playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)
		spawn(rand(10,600))
			warpbots()

	attackby(obj/item/W as obj, mob/user as mob)
		user.changeNext_move(8)
		switch(W.damtype)
			if("fire")
				src.health -= W.force * 1
			if("brute")
				src.health -= W.force * 0.75
			else
		if (src.health <= 0)
			visible_message("\red <B>The beacon is smashed apart!</B>")
			qdel(src)
		..()


	warpbots()
		icon_state = "def_radar"
		visible_message("\red The [src] turns on!")
		while(bot_amt > 0)
			bot_amt--
			bot_type = pick("norm","range","rapid")
			switch(bot_type)
				if("norm")
					new /mob/living/simple_animal/hostile/hivebot(get_turf(src))
				if("range")
					new /mob/living/simple_animal/hostile/hivebot/range(get_turf(src))
				if("rapid")
					new /mob/living/simple_animal/hostile/hivebot/rapid(get_turf(src))
		spawn(100)
			qdel(src)
		return