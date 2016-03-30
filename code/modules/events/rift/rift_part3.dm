/datum/round_event/the_rift
	var/ready = 0
	var/failed = 1
	end_when = -1
	alert_when = -1
	start_when = -1
	var/nextwave_when = 0

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
					continue
				if(!bravo)
					bravo = A
					continue
				if(!charlie)
					charlie = A
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
		emergency_shuttle.settimeleft(7800)
		if(emergency_shuttle.direction == -1)
			emergency_shuttle.setdirection(1)
		emergency_shuttle.prevent_recall = 1
		emergency_shuttle.online = 1
		for(var/mob/living/L in player_list)
			L.flash_eyes(1, 1, 1)
			L.playsound_local(get_turf(L), 'sound/effects/alert.ogg', 100, 1, 0.5)
		//
		priority_announce("Unstable bluespace rifts have opened in [alpha], [bravo], and [charlie]. Attempt to disable them or remain safely in [safe_zone] until the shuttle arrives. ","Priority Emergency Alert", 'sound/AI/shuttlecalled.ogg')
		for(var/obj/structure/xeno_rift/R in world)
			R.spawn_monsters(monsters)
			R.spawn_monsters(monsters)

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
			if(world.time <= nextwave_when)
				events.spawn_orphan_event(/datum/round_event/minor_meteorwave/{sends_alerts=0})
				nextwave_when = world.time + rand(300,1200)
				var/spawncount = rand(7,14)
				for(var/i=0, i<=spawncount, i++)
					var/area/A = FindEventAreaAwayFromPeople()
					if(istype(A,safe_zone.type))
						continue
					var/turf/landing = safepick(FindImpactTurfs(A))
					var/tospawn = pick(monsters)
					var/mob/living/L = new tospawn(landing)
					L.faction = "rift"

	End()
		if(failed)
			OnFail()
		else
			OnPass()

	OnFail()
		if (!prevent_stories) EventStory("The rift consumed [station_name()]")

	OnPass()
		emergency_shuttle.recall()
		for(var/datum/event_cycler/rotation/R in events.event_cyclers)
			R.paused = 1
			R.hideme = 1
		//pauses all rotation event cyclers and sets up the end game cycler
		var/datum/event_cycler/endless/new_cycler = new /datum/event_cycler/endless/(6600, "Central", "Command")
		new_cycler.events_allowed = EVENT_MAJOR | EVENT_ENDGAME
		new_cycler.frequency_lower = 1800
		new_cycler.frequency_lower = 4800
		priority_announce("We're not sure how... But you survived that crew. Enjoy the rest of your shift. We have included a complimentary gift on your next supply order","We're Sorry", 'sound/AI/shuttlerecalled.ogg')

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
