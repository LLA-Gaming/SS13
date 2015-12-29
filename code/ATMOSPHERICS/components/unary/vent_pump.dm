/obj/machinery/atmospherics/unary/vent_pump
	icon = 'icons/obj/atmospherics/vent_pump.dmi'
	icon_state = "off"

	name = "air vent"
	desc = "Has a valve and pump attached to it"
	use_power = 1

	can_unwrench = 1

	var/area/initial_loc
	level = 1
	var/area_uid
	var/id_tag = null

	var/on = 0
	var/pump_direction = 1 //0 = siphoning, 1 = releasing

	var/external_pressure_bound = ONE_ATMOSPHERE
	var/internal_pressure_bound = 0

	var/pressure_checks = 1
	//1: Do not pass external_pressure_bound
	//2: Do not pass internal_pressure_bound
	//3: Do not pass either

	var/welded = 0

	var/frequency = 1439
	var/datum/radio_frequency/radio_connection

	var/radio_filter_out
	var/radio_filter_in

	on
		on = 1
		icon_state = "out"

	siphon
		pump_direction = 0
		icon_state = "off"

		on
			on = 1
			icon_state = "in"

	New()
		..()
		initial_loc = get_area(loc)
		if (initial_loc.master)
			initial_loc = initial_loc.master
		area_uid = initial_loc.uid
		if (!id_tag)
			assign_uid()
			id_tag = num2text(uid)
		if(ticker && ticker.current_state == 3)//if the game is running
			src.initialize()
			src.broadcast_status()

	high_volume
		name = "large air vent"
		power_channel = EQUIP
		New()
			..()
			air_contents.volume = 1000

	update_icon()
		if(welded)
			icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]weld"
			return
		if(on && !(stat & (NOPOWER|BROKEN)))
			if(pump_direction)
				icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]out"
			else
				icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]in"
		else
			icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]off"
		color = pipe_color

		return

	process()
		..()
		if(stat & (NOPOWER|BROKEN))
			return
		if (!NODE_1)
			on = 0
		//broadcast_status() // from now air alarm/control computer should request update purposely --rastaf0
		if(!on)
			return 0

		if(welded)
			return 0

		var/datum/gas_mixture/environment = loc.return_air()
		var/environment_pressure = environment.return_pressure()

		if(pump_direction) //internal -> external
			var/pressure_delta = 10000

			if(pressure_checks&1)
				pressure_delta = min(pressure_delta, (external_pressure_bound - environment_pressure))
			if(pressure_checks&2)
				pressure_delta = min(pressure_delta, (air_contents.return_pressure() - internal_pressure_bound))

			if(pressure_delta > 0)
				if(air_contents.temperature > 0)
					var/transfer_moles = pressure_delta*environment.volume/(air_contents.temperature * R_IDEAL_GAS_EQUATION)

					var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)

					loc.assume_air(removed)
					air_update_turf()

					if(network)
						network.update = 1

		else //external -> internal
			var/pressure_delta = 10000
			if(pressure_checks&1)
				pressure_delta = min(pressure_delta, (environment_pressure - external_pressure_bound))
			if(pressure_checks&2)
				pressure_delta = min(pressure_delta, (internal_pressure_bound - air_contents.return_pressure()))

			if(pressure_delta > 0)
				if(environment.temperature > 0)
					var/transfer_moles = pressure_delta*air_contents.volume/(environment.temperature * R_IDEAL_GAS_EQUATION)

					var/datum/gas_mixture/removed = loc.remove_air(transfer_moles)
					if (isnull(removed)) //in space
						return

					air_contents.merge(removed)
					air_update_turf()

					if(network)
						network.update = 1

		return 1

	//Radio remote control

	proc
		set_frequency(new_frequency)
			radio_controller.remove_object(src, frequency)
			frequency = new_frequency
			if(frequency)
				radio_connection = radio_controller.add_object(src, frequency,radio_filter_in)

		broadcast_status()
			if(!radio_connection)
				return 0

			var/datum/signal/signal = new
			signal.transmission_method = 1 //radio signal
			signal.source = src

			signal.data = list(
				"area" = src.area_uid,
				"tag" = src.id_tag,
				"device" = "AVP",
				"power" = on,
				"direction" = pump_direction?("release"):("siphon"),
				"checks" = pressure_checks,
				"internal" = internal_pressure_bound,
				"external" = external_pressure_bound,
				"timestamp" = world.time,
				"sigtype" = "status"
			)

			if(!initial_loc.air_vent_names[id_tag])
				var/new_name = "\improper [initial_loc.name] vent pump #[initial_loc.air_vent_names.len+1]"
				initial_loc.air_vent_names[id_tag] = new_name
				src.name = new_name
			initial_loc.air_vent_info[id_tag] = signal.data

			radio_connection.post_signal(src, signal, radio_filter_out)

			return 1


	initialize()
		..()

		//some vents work his own spesial way
		radio_filter_in = frequency==1439?(RADIO_FROM_AIRALARM):null
		radio_filter_out = frequency==1439?(RADIO_TO_AIRALARM):null
		if(frequency)
			set_frequency(frequency)

	receive_signal(datum/signal/signal)
		if(stat & (NOPOWER|BROKEN))
			return
		//log_admin("DEBUG \[[world.timeofday]\]: /obj/machinery/atmospherics/unary/vent_pump/receive_signal([signal.debug_print()])")
		if(!signal.data["tag"] || (signal.data["tag"] != id_tag) || (signal.data["sigtype"]!="command"))
			return 0

		if("purge" in signal.data)
			pressure_checks &= ~1
			pump_direction = 0

		if("stabalize" in signal.data)
			pressure_checks |= 1
			pump_direction = 1

		if("power" in signal.data)
			on = text2num(signal.data["power"])

		if("power_toggle" in signal.data)
			on = !on

		if("checks" in signal.data)
			pressure_checks = text2num(signal.data["checks"])

		if("checks_toggle" in signal.data)
			pressure_checks = (pressure_checks?0:3)

		if("direction" in signal.data)
			pump_direction = text2num(signal.data["direction"])

		if("set_internal_pressure" in signal.data)
			internal_pressure_bound = Clamp(
				text2num(signal.data["set_internal_pressure"]),
				0,
				ONE_ATMOSPHERE*50
			)

		if("set_external_pressure" in signal.data)
			external_pressure_bound = Clamp(
				text2num(signal.data["set_external_pressure"]),
				0,
				ONE_ATMOSPHERE*50
			)

		if("adjust_internal_pressure" in signal.data)
			internal_pressure_bound = Clamp(
				internal_pressure_bound + text2num(signal.data["adjust_internal_pressure"]),
				0,
				ONE_ATMOSPHERE*50
			)

		if("adjust_external_pressure" in signal.data)
			external_pressure_bound = Clamp(
				external_pressure_bound + text2num(signal.data["adjust_external_pressure"]),
				0,
				ONE_ATMOSPHERE*50
			)

		if("init" in signal.data)
			name = signal.data["init"]
			return

		if("status" in signal.data)
			spawn(2)
				broadcast_status()
			return //do not update_icon

			//log_admin("DEBUG \[[world.timeofday]\]: vent_pump/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
		spawn(2)
			broadcast_status()
		update_icon()
		return

	hide(var/i) //to make the little pipe section invisible, the icon changes.
		if(welded)
			icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]weld"
			return
		if(on&&NODE_1)
			if(pump_direction)
				icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]out"
			else
				icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]in"
		else
			icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]off"
			on = 0
		return

	attackby(obj/item/W, mob/user)
		if (istype(W, /obj/item/weapon/wrench)&& !(stat & NOPOWER) && on)
			user << "\red You cannot unwrench this [src], turn it off first."
			return 1
		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if (WT.remove_fuel(0,user))
				user << "\blue Now welding the vent."
				if(do_after(user, 20))
					if(!src || !WT.isOn()) return
					playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
					if(!welded)
						user.visible_message("[user] welds the vent shut.", "You weld the vent shut.", "You hear welding.")
						welded = 1
						update_icon()
					else
						user.visible_message("[user] unwelds the vent.", "You unweld the vent.", "You hear welding.")
						welded = 0
						update_icon()
				else
					user << "\blue The welding tool needs to be on to start this task."
			else
				user << "\blue You need more welding fuel to complete this task."
				return 1
		else
			return ..()

	examine()
		set src in oview(1)
		..()
		if(welded)
			usr.send_text_to_tab("It seems welded shut.", "ic")
			usr << "It seems welded shut."

	power_change()
		if(powered(power_channel))
			stat &= ~NOPOWER
		else
			stat |= NOPOWER
		update_icon()

/obj/machinery/atmospherics/unary/vent_pump/Destroy()
	if(initial_loc)
		initial_loc.air_vent_info -= id_tag
		initial_loc.air_vent_names -= id_tag
	..()

/*
	Alt-click to ventcrawl
*/
/obj/machinery/atmospherics/unary/vent_pump/AltClick(var/mob/living/L)
	if(!L.ventcrawler || !isliving(L) || !Adjacent(L))
		return
	if(L.stat)
		L << "You must be conscious to do this!"
		return
	if(L.lying)
		L << "You can't vent crawl while you're stunned!"
		return
	if(welded)
		L << "That vent is welded shut."
		return

	if(!network || !network.normal_members.len)
		L << "This vent is not connected to anything."
		return

	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in network.normal_members)
		if(temp_vent.welded)
			continue
		if(temp_vent in loc)
			continue
		var/turf/T = get_turf(temp_vent)

		if(!T || T.z != loc.z)
			continue

		var/i = 1
		var/index = "[T.loc.name]\[[i]\]"
		while(index in vents)
			i++
			index = "[T.loc.name]\[[i]\]"
		vents[index] = temp_vent
	if(!vents.len)
		L << "<span class='warning'> There are no available vents to travel to, they could be welded. </span>"
		return

	var/obj/selection = input(L,"Select a destination.", "Duct System") as null|anything in sortAssoc(vents)
	if(!selection)	return

	if(!Adjacent(L))
		return
	if(iscarbon(L) && L.ventcrawler < 2) // lesser ventcrawlers can't bring items
		for(var/obj/item/carried_item in L.contents)
			if(!istype(carried_item, /obj/item/weapon/implant))//If it's not an implant
				L << "<span class='warning'> You can't be carrying items or have items equipped when vent crawling!</span>"
				return

	var/obj/machinery/atmospherics/unary/vent_pump/target_vent = vents[selection]
	if(!target_vent)
		return

	for(var/mob/O in viewers(L, null))
		O.show_message(text("<B>[L] scrambles into the ventillation ducts!</B>"), 1)

	for(var/mob/O in hearers(target_vent,null))
		O.show_message("You hear something squeezing through the ventilation ducts.",2)

	if(target_vent.welded)		//the vent can be welded while they scrolled through the list.
		target_vent = src
		L << "<span class='warning'> The vent you were heading to appears to be welded.</span>"
	L.loc = target_vent.loc
	var/area/new_area = get_area(L.loc)
	if(new_area)
		new_area.Entered(L)
