/datum/round_event/the_rift
	var/ready = 0
	var/failed = 1
	end_when = -1
	alert_when = -1
	start_when = -1
	var/nextwave_when = 0
	var/wave = 0

	var/list/hit_areas = list()
	var/list/mobs_holder = list()

	var/area/safe_zone
	var/area/alpha
	var/area/bravo
	var/area/charlie

	var/list/monsters = list(/mob/living/simple_animal/hostile/carp,
							/mob/living/simple_animal/hostile/creature,
							/mob/living/simple_animal/hostile/viscerator,
							/mob/living/simple_animal/hostile/asteroid/goliath,
							/mob/living/simple_animal/hostile/asteroid/basilisk,
							/mob/living/simple_animal/hostile/asteroid/hivelord,
							/mob/living/simple_animal/hostile/faithless,
							/mob/living/carbon/human/npc/syndicate_ranged_s
							)

	Setup()
		var/list/areas = ((the_station_areas - the_station_areas_safe) + the_station_areas_danger)
		for(var/i=0, i<=50, i++)
			var/area/A = locate(pick_n_take(areas))
			if(A && A.get_apc())
				if(!safe_zone)
					safe_zone = A
					continue
				if(!alpha)
					alpha = A
					hit_areas |= A.type
					continue
				if(!bravo)
					bravo = A
					hit_areas |= A.type
					continue
				if(!charlie)
					charlie = A
					hit_areas |= A.type
					continue
				break
		if(!safe_zone || !alpha || !bravo || !charlie)
			CancelSelf()
			return

	Start()
		if (!prevent_stories) EventStory("The crew hastily activated the artifact's signal code. Causing a rift in bluespace")
		var/turf/landing = safepick(FindImpactTurfs(alpha))
		new /obj/structure/xeno_rift(landing)
		landing = safepick(FindImpactTurfs(bravo))
		new /obj/structure/xeno_rift(landing)
		landing = safepick(FindImpactTurfs(charlie))
		new /obj/structure/xeno_rift(landing)
		//
		emergency_shuttle.incall(1)
		emergency_shuttle.prevent_recall = 1
		var/list/rip_areas = list()
		for(var/mob/living/L in player_list)
			L.flash_eyes(1, 1, 1)
			rip_areas |= get_area(L)
			L.playsound_local(get_turf(L), 'sound/effects/alert.ogg', 100, 1, 0.5)
		for(var/area/A in rip_areas)
			var/list/impact_turfs = FindImpactTurfs(A)
			if(impact_turfs.len)
				var/i= impact_turfs.len / 3
				for(var/turf/simulated/floor/F in shuffle(impact_turfs))
					if(i<=0) break
					F.break_tile_to_plating()
					i--
				var/obj/machinery/power/apc/APC = A.get_apc()
				if(APC)
					APC.overload_lighting()
					APC.opened = 1
					APC.locked = 0
					APC.update_icon()
				for(var/obj/structure/table/T in area_contents(A))
					if(prob(33))
						new T.parts( T.loc )
						qdel(T)
		//
		priority_announce("Unstable bluespace rifts have opened in [alpha], [bravo], and [charlie]. Attempt to disable them or remain safely in [safe_zone] until the shuttle arrives. ","Priority Emergency Alert", 'sound/AI/shuttlecalled.ogg')
		for(var/obj/structure/xeno_rift/R in world)
			R.spawn_monsters(monsters)
			R.spawn_monsters(monsters)

		var/datum/round_event_control/rift_bus/rift_bus = locate(/datum/round_event_control/rift_bus) in events.all_events
		if(rift_bus)
			rift_bus.rift_events_exist = 1
		set_security_level(SEC_LEVEL_RED)

	Tick()
		if(emergency_shuttle.location == -1) //shuttle docked at station, gameover
			failed = 1
			AbruptEnd()
		if(!ready)
			return
		else
			var/list/active_rifts = list()
			for(var/obj/structure/xeno_rift/R in world)
				if(!R.gc_destroyed)
					active_rifts.Add(R)
			if(!active_rifts.len)
				failed = 0
				AbruptEnd()
			if(world.time >= nextwave_when)
				nextwave_when = world.time + rand(300,1200)
				var/spawncount = rand(7,14)
				for(var/i=0, i<=spawncount, i++)
					var/area/A
					if(prob(50))
						A = FindEventAreaAwayFromPeople(hit_areas)
						if(A)
							hit_areas |= A.type
					else if (wave)
						A = FindEventAreaNearPeople(hit_areas)
						if(A)
							hit_areas |= A.type
					if(istype(A,safe_zone.type))
						A = FindEventAreaAwayFromPeople(hit_areas)
						if(A)
							hit_areas |= A.type
					if(!A)
						A = FindEventArea(hit_areas)
					if(A)
						var/turf/landing = safepick(FindImpactTurfs(A))
						var/tospawn = pick(monsters)
						var/mob/living/L = new tospawn(landing)
						var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
						s.set_up(4, 2, get_turf(L))
						s.start()
						mobs_holder.Add(L)
						L.faction = "rift"
				wave += 1

	End()
		if(failed)
			OnFail()
		else
			OnPass()

	OnFail()
		if (!prevent_stories) EventStory("The rift consumed [station_name()]")

	OnPass()
		emergency_shuttle.recall()
		emergency_shuttle.prevent_recall = 0
		for(var/datum/event_cycler/main/R in events.event_cyclers)
			R.frequency_lower = 1800
			R.frequency_lower = 4800
		priority_announce("We're not sure how... But you survived that crew. Enjoy the rest of your shift. We have included a complimentary gift on your next supply order","We're Sorry", 'sound/AI/shuttlerecalled.ogg')

		for(var/mob/living/L in mobs_holder)
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(4, 2, get_turf(L))
			s.start()
			qdel(L)

		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = supply_shuttle.ordernum
		O.object = new /datum/supply_packs/rift_rewards
		O.object.name = "loads of materials crate"
		O.orderedby = "Centcomm"
		O.perfect = 1
		supply_shuttle.shoppinglist += O

		message_admins("Rift complete, main cycler rotation is now paused. Post-game events are now active")
		if (!prevent_stories)
			EventStory("[station_name()] went through one of the biggest disasters of [year_integer+540]")
			EventStory("The crew managed to work together and survive to tell the tale of... <b>The Bluespace Rift</b>",1)
		for(var/mob/living/carbon/human/L in player_list)
			if(L.stat != DEAD)
				events.AddAwards("eventmedal_rift",list("[L.key]"))
