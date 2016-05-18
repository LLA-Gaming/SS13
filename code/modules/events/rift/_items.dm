/obj/item/weapon/disk/rift_data
	name = "mysterious lost data disk"
	desc = "Who knows what this might be."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk0"
	item_state = "card-id"
	w_class = 1.0
	New()
		..()
		icon_state = "datadisk[pick(0,1,2)]"

/datum/supply_packs/xeno_artifact
	name = "Xeno Artifact"
	containername = "xeno artifact"
	contains = list(/obj/structure/xeno_artifact,/obj/item/weapon/paper/xeno_artifact_instructions)
	containertype = /obj/structure/closet/crate/
	notavailable = 1

/datum/supply_packs/rift_rewards
	name = "Loads of materials"
	containername = "loads of materials"
	contains = list(/obj/item/stack/sheet/mineral/gold{amount=50},
					/obj/item/stack/sheet/mineral/silver{amount=50},
					/obj/item/stack/sheet/mineral/diamond{amount=50},
					/obj/item/stack/sheet/mineral/uranium{amount=50},
					/obj/item/stack/sheet/metal{amount=50},
					/obj/item/stack/sheet/glass{amount=50},
					/obj/item/stack/sheet/mineral/plasma{amount=50},
					/obj/item/stack/sheet/mineral/clown{amount=50}
					)
	containertype = /obj/structure/closet/crate/
	notavailable = 1

/obj/item/weapon/paper/xeno_artifact_instructions
	name = "IMPORTANT: XENO ARTIFACT INSTRUCTIONS"
	info = {"<h3><span style="text-decoration: underline;">Instructions</span></h3>
<p>1) Mount the artifact onto reinforced flooring with a wrench</p>
<p>2) Pulse the artifact with a multi-tool. it will glow slightly for a second</p>
<p>3) Count to 10 and pulse the artifact again. If done correctly, the artifact will glow. if not, repeat until it glows.</p>
<p>4) Once glowing, apply another pulse to the artifact and count an additional 10 seconds, repeat twice until the artifact emits a signal</p>
<p>5) Stand by for next evaluation. in the meantime, please store the artifact somewhere secure</p>
<p></p>
<p><strong><span style="color: #ff0000;">WARNING: Safety is not guaranteed and failing to follow instructions may result in injury or death. Please ensure supervision before starting. Nanotrasen is not responsible for damages caused by failure</span></strong></p>"}


/obj/structure/xeno_rift
	name = "rift"
	desc = "do not make direct eye contact"
	icon = 'icons/obj/biomass.dmi'
	icon_state = "rift"
	unacidable = 1
	anchored = 1
	var/obj/item/device/assembly/signaler/rift/signal

	New()
		..()
		set_light(4)
		signal = new(src)
		signal.code = rand(1,100)
		signal.frequency = rand(1200, 1599)
		if(IsMultiple(signal.frequency, 2))//signaller frequencies are always uneven!
			signal.frequency++
		signal.rift = src
		var/area/A = get_area(src)
		if(A)
			var/list/impact_turfs = FindImpactTurfs(A)
			if(impact_turfs.len)
				var/i= impact_turfs.len / 3
				for(var/turf/simulated/floor/F in shuffle(impact_turfs))
					if(i<=0) break
					F.break_tile_to_plating()
					i--
				var/obj/machinery/power/apc/APC = A.get_apc()
				if(APC)
					APC.set_broken()
					APC.update_icon()
				for(var/obj/structure/table/T in area_contents(A))
					if(prob(33))
						new T.parts( T.loc )
						qdel(T)

	attackby(obj/item/I as obj, mob/user as mob)
		if(istype(I, /obj/item/device/analyzer))
			user << "<span class='notice'>Analyzing... encrypted frequency [signal.code]:[format_frequency(signal.frequency)].</span>"

	proc/spawn_monsters(var/list/monsters)
		var/turf/landing = safepick(FindImpactTurfs(get_area(src)))
		var/tospawn = pick(monsters)
		var/mob/living/L = new tospawn(landing)
		L.faction = "rift"
		var/datum/round_event/the_rift/event = locate(/datum/round_event/the_rift) in events.active_events
		if(event)
			event.mobs_holder.Add(L)



/obj/item/device/assembly/signaler/rift
	name = "rift singaller"
	icon_state = "anomaly core"
	item_state = "electronic"
	var/obj/structure/xeno_rift/rift


/obj/item/device/assembly/signaler/rift/receive_signal(datum/signal/signal)
	if(istype(loc,/obj/structure/xeno_artifact))
		if(!loc:pulsed || !loc:emitted)
			return
	if(rift)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(4, 2, get_turf(rift))
		s.start()
		qdel(rift)
		return
	else
		var/datum/round_event/the_rift/event = locate(/datum/round_event/the_rift) in events.active_events
		if(event && !event.ready)
			event.ready = 1
			event.alert_when = world.time + 150
			event.start_when = world.time + 10


/obj/item/device/assembly/signaler/rift/attack_self()
	return

/obj/structure/xeno_artifact
	name = "mysterious xeno artifact"
	desc = "a host to unimaginable power"
	icon = 'icons/obj/biomass.dmi'
	icon_state = ""
	density = 1
	var/clicks = 0
	var/next_clicktime = 0
	var/last_clicktime = 0
	var/pulsed = 0
	var/emitted = 0
	var/power = 0
	var/obj/item/device/assembly/signaler/rift/Signal = null

	New()
		..()
		Signal = new(src)
		Signal.code = rand(1,100)

		Signal.frequency = rand(1200, 1599)
		if(IsMultiple(Signal.frequency, 2))//signaller frequencies are always uneven!
			Signal.frequency++

	bullet_act(var/obj/item/projectile/Proj)
		if(emitted)
			return
		var/datum/round_event/xeno_artifact_testing/event = locate(/datum/round_event/xeno_artifact_testing) in events.active_events
		if(istype(Proj,/obj/item/projectile/beam/emitter))
			if(pulsed && event && event.ready)
				power += 10
				if(power >= 100)
					emitted = 1
					event.passed = 1
					event.AbruptEnd()
					src.visible_message("<span class ='danger'>[src] activates its true power!</span>")
					return

			else
				src.visible_message("<span class ='danger'>[src] explodes!</span>")
				if(event)
					event.passed = 0
					event.AbruptEnd()
				explosion(src, 3, 7, 14, 7)
				return


	attackby(obj/item/I as obj, mob/user as mob)
		if(istype(I, /obj/item/device/analyzer))
			var/datum/round_event/the_rift/event = locate(/datum/round_event/the_rift) in events.active_events
			if(!event && pulsed && emitted) //bussing a rift
				var/datum/round_event_control/rift_bus/rift_bus = locate(/datum/round_event_control/rift_bus) in events.all_events
				if(rift_bus && !rift_bus.rift_events_exist)
					event = events.spawn_orphan_event(/datum/round_event/the_rift)
			if(event && pulsed && emitted)
				user << "<span class='notice'>Analyzing... encrypted frequency [Signal.code]:[format_frequency(Signal.frequency)].</span>"

		if(istype(I, /obj/item/weapon/wrench))
			var/turf/T = loc
			if(istype(T,/turf/simulated/floor/engine))
				if(anchored)
					anchored = 0
					playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
					user.show_message("you remove [src]'s bolts to the floor")
					return user.changeNext_move(8)
				else
					anchored = 1
					playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
					user.show_message("you secure [src] to the floor")
					return user.changeNext_move(8)
			else
				user.show_message("[src] needs to be secured over reinforced flooring")
				return user.changeNext_move(8)
			if(!anchored)
				user.show_message("[src] needs to be anchored down")
				return user.changeNext_move(8)
			return user.changeNext_move(8)
		else
			if(istype(I, /obj/item/device/multitool))
				//part 1
				var/datum/round_event/xeno_artifact_research/event = locate(/datum/round_event/xeno_artifact_research) in events.active_events
				if(!event) //bussing a rift
					var/datum/round_event_control/rift_bus/rift_bus = locate(/datum/round_event_control/rift_bus) in events.all_events
					if(rift_bus && !rift_bus.rift_events_exist)
						event = events.spawn_orphan_event(/datum/round_event/xeno_artifact_research)
				switch(clicks)
					if(0) //first pulse, start
						next_clicktime = world.time + 100
						last_clicktime = world.time
						clicks++
						user.visible_message("[src] begins to glow!")
						playsound(src.loc, 'sound/effects/EMPulse.ogg', 100, 1)
					if(1) //1st pulse, end
						if(world.time >= next_clicktime - 20 && world.time <= next_clicktime + 20)
							clicks++
							user.visible_message("[src] stops glowing!")
							playsound(src.loc, 'sound/effects/EMPulse.ogg', 100, 1)
						else
							clicks--
							user.visible_message("[src] rings out ominously!")
							playsound(src.loc, 'sound/effects/screech.ogg', 100, 1)
							return user.changeNext_move(8)
						return user.changeNext_move(8)
					if(2) //2nd pulse, start
						next_clicktime = world.time + 100
						last_clicktime = world.time
						clicks++
						user.visible_message("[src] begins to shake!")
						playsound(src.loc, 'sound/effects/EMPulse.ogg', 100, 1)
					if(3) //2nd pulse, end
						if(world.time > next_clicktime + 20)//late
							clicks--
							user.visible_message("[src] rings out ominously!")
							playsound(src.loc, 'sound/effects/screech.ogg', 100, 1)
							return user.changeNext_move(8)
						if(world.time >= next_clicktime - 20 && world.time <= next_clicktime + 20)
							clicks++
							user.visible_message("[src] stops shaking!")
							playsound(src.loc, 'sound/effects/EMPulse.ogg', 100, 1)
							return user.changeNext_move(8)
						if(event)
							event.passed = 0
							event.AbruptEnd()
						user.visible_message("<span class ='danger'>[src] explodes!</span>")
						message_admins("[key_name(user)] caused [src] to explode with [round(next_clicktime - world.time) / 10] second(s) to spare")
						log_game("[key_name(user)] caused [src] to explode with [round(next_clicktime - world.time) / 10] second(s) to spare")
						explosion(src, 3, 7, 14,7)
						return user.changeNext_move(8)
					if(4) //3rd pulse, start
						next_clicktime = world.time + 100
						last_clicktime = world.time
						clicks++
						user.visible_message("[src] begins to radiate!")
						playsound(src.loc, 'sound/effects/EMPulse.ogg', 100, 1)
					if(5) //3rd pulse, end
						if(world.time > next_clicktime + 20)//late
							clicks--
							user.visible_message("[src] rings out ominously!")
							playsound(src.loc, 'sound/effects/screech.ogg', 100, 1)
							return user.changeNext_move(8)
						if(world.time >= next_clicktime - 20 && world.time <= next_clicktime + 20)
							clicks++
							user.visible_message("[src] emits a mysterious signal and stops radiating")
							playsound(src.loc, 'sound/effects/EMPulse.ogg', 100, 1)
							pulsed = 1
							if(event)
								event.passed = 1
								event.AbruptEnd()
							return user.changeNext_move(8)
						if(event)
							event.passed = 0
							event.AbruptEnd()
						user.visible_message("<span class ='danger'>[src] explodes!</span>")
						message_admins("[key_name(user)] caused [src] to explode with [round(next_clicktime - world.time) / 10] second(s) to spare")
						log_game("[key_name(user)] caused [src] to explode with [round(next_clicktime - world.time) / 10] second(s) to spare")
						explosion(src, 3, 7, 14,7)
						return user.changeNext_move(8)
					else
						user.show_message("[src] does not respond to the pulse")
				return
		..()