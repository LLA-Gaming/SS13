#define MINING_BOT_IDLE		1
#define MINING_BOT_MINING	2

#define MINING_MODE_NEAREST	4
#define MINING_MODE_TUNNEL	8

/obj/machinery/bot/mining_bot
	name = "mining bot"
	icon_state = "mining_drone"
	health = 25
	density = 1
	locked = 0

	var/mode = MINING_BOT_IDLE
	var/mining_mode = MINING_MODE_NEAREST
	var/mining_direction = NORTH
	var/list/path = list()
	var/turf/target = 0
	var/turf/last_location = 0
	var/obj/item/weapon/stock_parts/cell/power_source
	var/operation_cost = 50

	// Tunnels
	var/tunnel_width = 2
	var/tunnel_reverse = 0
	var/turf/tunnel_origin = 0

	// Nearest
	var/check_range = 1

	New()
		..()
		botcard = new(src)
		botcard.access = list(access_mining, access_mining_office, access_mining_station)
		power_source = new /obj/item/weapon/stock_parts/cell/high(src)

	explode()
		var/turf/T = get_turf(src)
		T.visible_message("<span class='warning'><b>\The [src] blows apart!</b></span>")

		var/datum/effect/effect/system/spark_spread/sparks = new()
		sparks.set_up(5, 0, T)
		sparks.start()

		new /obj/effect/decal/cleanable/oil(T)

		qdel(src)

	proc/Bitflag2Display(var/bf)
		switch(bf)
			if(MINING_BOT_IDLE)
				return "Idle"
			if(MINING_BOT_MINING)
				return "Mining"
			if(MINING_MODE_NEAREST)
				return "Nearest"
			if(MINING_MODE_TUNNEL)
				return "Tunnel"

	proc/Display2Bitflag(var/display)
		switch(display)
			if("Idle")
				return MINING_BOT_IDLE
			if("Mining")
				return MINING_BOT_MINING
			if("Nearest")
				return MINING_MODE_NEAREST
			if("Tunnel")
				return MINING_MODE_TUNNEL

	attack_hand(var/mob/living/user)
		if(open)
			if(power_source)
				power_source.loc = get_turf(src)
				user.put_in_any_hand_if_possible(power_source)
				user << "<span class='info'>You take out the [power_source] out of \the [src].</span>"
				power_source = 0
				return 0

		interact(user)
		..()

	attackby(var/obj/item/I, var/mob/living/user)
		if(open && !power_source)
			if(istype(I, /obj/item/weapon/stock_parts/cell))
				user.unEquip(I)
				I.loc = src
				power_source = I
				user << "<span class='info'>You place the [I] into \the [src].</span>"
				return 0
		..()

	interact(var/mob/living/user)
		var/dat
		if(power_source)
			dat += "Charge: [power_source.charge]/[power_source.maxcharge] ([power_source.percent()]%)<br>"
		dat += "Current Status: <a href='?src=\ref[src];action=toggle_power'>[on ? "On" : "Off"]</a><br>"
		dat += "Current Mode: <a href='?src=\ref[src];action=change_mode'>[Bitflag2Display(mode)]</a><br>"
		if(mode == MINING_BOT_MINING)
			dat += "Mining Mode: <a href='?src=\ref[src];action=change_mining_mode'>[Bitflag2Display(mining_mode)]</a>"
			switch(mining_mode)
				if(MINING_MODE_TUNNEL)
					dat += "<br>Tunnel Width: <a href='?src=\ref[src];action=change_tunnel_width'>[tunnel_width]</a>"

		var/datum/browser/popup = new(user, "mining_bot_hud", "Mining Bot v1", 220, 180)
		popup.set_content(dat)
		popup.open()

	Topic(href, href_list)
		if(..())
			return
		usr.set_machine(src)

		if(!href_list["action"])
			return 0

		switch(href_list["action"])
			if("toggle_power")
				on = !on
				usr << "<span class='info'>You turn the [src] [on ? "on" : "off"].</span>"
			if("change_mode")
				var/selected_mode = input("Select mode", "Input") in list("Mining", "Idle", "Cancel")
				if(!selected_mode || selected_mode == "Cancel")
					return 0

				usr << "<span class='info'>You change \the [src]'s mode to [selected_mode].</span>"

				var/bitflag = Display2Bitflag(selected_mode)

				mode = bitflag

			if("change_mining_mode")
				var/selected_mode = input("Select mode", "Input") in list("Nearest", "Tunnel", "Cancel")
				if(!selected_mode || selected_mode == "Cancel")
					return 0

				usr << "<span class='info'>You change \the [src]'s mining mode to [selected_mode].</span>"

				var/bitflag = Display2Bitflag(selected_mode)

				mining_mode = bitflag

			if("change_tunnel_width")
				var/new_width = input("Enter a new width from 1 to 5.", "Input") as num
				new_width = Clamp(new_width, 1, 5)
				tunnel_width = new_width
				usr << "<span class='info'>You set \the [src]'s tunneling width to [tunnel_width].</span>"

		interact(usr)

	proc/CalculatePath(var/turf/avoid = 0)
		var/list/turfs = AStar(get_turf(src), target, /turf/proc/CardinalTurfsWithAccessAndMinerals, /turf/proc/Distance_cardinal, 0, 120, id=botcard, exclude=avoid)
		if(turfs)
			turfs -= get_turf(src)
		return turfs

	process()
		set background = BACKGROUND_ENABLED

		if(!power_source)
			return 0

		if(!on)
			return 0

		if(mode == MINING_BOT_MINING)
			if(!power_source.use(operation_cost))
				return 0

		if(target)
			if(!path || !length(path) || path[1] == get_turf(src))
				path = CalculatePath()

		if((get_dist(get_turf(src), target) <= 1) && istype(target, /turf/simulated/mineral))
			var/turf/simulated/mineral/M = target
			M.gets_drilled()
			return 0

		else if(path && length(path))
			last_location = get_turf(src)
			if(!Move(path[1]))
				var/turf/blocking = path[1]
				if(istype(blocking, /turf/simulated/mineral))
					var/turf/simulated/mineral/M = blocking
					M.gets_drilled()
			return 0

		switch(mode)
			if(MINING_BOT_IDLE)
				if(path && length(path))
					path = list()
				if(target)
					target = 0
				return 0

			if(MINING_BOT_MINING)
				switch(mining_mode)
					if(MINING_MODE_NEAREST)
						var/turf/simulated/mineral/mineral = locate() in range(check_range, src)
						if(!mineral)
							if(check_range >= 7)
								var/list/directions = cardinal
								if(last_location)
									directions -= get_dir(get_turf(src), last_location)

								step(src, pick(directions))
							else
								check_range++
						else
							target = mineral
							check_range = 1

					if(MINING_MODE_TUNNEL)
						if(!tunnel_origin)
							tunnel_origin = get_turf(src)

						var/turf/current_turf = get_turf(src)
						var/x_diff = abs(tunnel_origin.x - current_turf.x)
						var/add_x = 1

						if(x_diff == 0)
							tunnel_reverse = 0
						else if(x_diff == (tunnel_width - 1))
							tunnel_reverse = 1

						if(tunnel_reverse)
							add_x = -1

						if(x_diff == (tunnel_width - 1) && last_location && (last_location.x != (tunnel_origin.x + (tunnel_width - 1))))
							target = locate(tunnel_origin.x, current_turf.y + 1, tunnel_origin.z)
						else if(x_diff == 0 && last_location && (last_location.x != tunnel_origin.x))
							target = locate(tunnel_origin.x, current_turf.y + 1, tunnel_origin.z)
						else
							target = locate(current_turf.x + add_x, current_turf.y, current_turf.z)

/turf/proc/CardinalTurfsWithAccessAndMinerals(var/obj/item/weapon/card/id/ID)
	var/list/L = list()

	for(var/d in cardinal)
		var/turf/simulated/T = get_step(src, d)
		if(istype(T) && (!T.density || istype(T, /turf/simulated/mineral)))
			if(!LinkBlockedWithAccess(src, T, ID))
				L.Add(T)
	return L
