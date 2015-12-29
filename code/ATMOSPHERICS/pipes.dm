obj/machinery/atmospherics/pipe
	var/datum/gas_mixture/air_temporary //used when reconstructing a pipeline that broke
	var/datum/pipeline/parent

	var/volume = 0
	force = 20

	layer = 2.4 //under wires with their 2.44
	use_power = 0

	can_unwrench = 1

	var/alert_pressure = 80*ONE_ATMOSPHERE
		//minimum pressure before check_pressure(...) should be called

	proc/pipeline_expansion()
		if (node.len)
			return node
		else
			return null

	proc/check_pressure(pressure)
		//Return 1 if parent should continue checking other pipes
		//Return null if parent should stop checking other pipes. Recall: del(src) will by default return null

		return 1

	return_air()
		if(!parent)
			parent = new /datum/pipeline()
			parent.build_pipeline(src)

		return parent.air

	build_network()
		if(!parent)
			parent = new /datum/pipeline()
			parent.build_pipeline(src)

		return parent.return_network()

	network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
		if(!parent)
			parent = new /datum/pipeline()
			parent.build_pipeline(src)

		return parent.network_expand(new_network, reference)

	return_network(obj/machinery/atmospherics/reference)
		if(!parent)
			parent = new /datum/pipeline()
			parent.build_pipeline(src)

		return parent.return_network(reference)

	Destroy()
		del(parent)

		if(air_temporary)
			loc.assume_air(air_temporary)
			del(air_temporary)

		for(NODE_LOOP)
			if(!NODE_I) continue
			var/obj/machinery/atmospherics/pipe/P = NODE_I
			P.disconnect(src)

		..()

	disconnect(obj/machinery/atmospherics/reference)
		for (NODE_LOOP)
			if(reference == NODE_I)
				if(istype(NODE_I, /obj/machinery/atmospherics/pipe))
					del(parent)
					NODE_I = null
		update_icon()
		return null

	initialize()
		normalize_dir()
		var/list/node_dir = list(1=null,2=null,3=null,4=null)
		for (var/direction in cardinal)
			if(direction&initialize_directions)
				for(var/I=1; I <= nodecount; I++)
					if(!node_dir[I])
						node_dir[I] = direction
						break
		for(NODE_LOOP)
			for(var/obj/machinery/atmospherics/target in get_step(src,node_dir[I]))
				if(target.initialize_directions & get_dir(target, src))
					node[I] = target
					break
		var/turf/T = src.loc
		if(T)
			hide(T.intact)
		update_icon()

	simple
		icon = 'icons/obj/pipes.dmi'
		icon_state = "intact-f"

		name = "pipe"
		desc = "A one meter section of regular pipe"

		volume = 70

		dir = SOUTH
		initialize_directions = SOUTH|NORTH
		nodecount = 2
		/*
		var/obj/machinery/atmospherics/node1
		var/obj/machinery/atmospherics/node2
		*/



		var/minimum_temperature_difference = 300
		var/thermal_conductivity = 0 //WALL_HEAT_TRANSFER_COEFFICIENT No

		var/maximum_pressure = 70*ONE_ATMOSPHERE
		var/fatigue_pressure = 55*ONE_ATMOSPHERE
		alert_pressure = 55*ONE_ATMOSPHERE


		level = 1

		New()
			..()
			switch(dir)
				if(SOUTH || NORTH)
					initialize_directions = SOUTH|NORTH
				if(EAST || WEST)
					initialize_directions = EAST|WEST
				if(NORTHEAST)
					initialize_directions = NORTH|EAST
				if(NORTHWEST)
					initialize_directions = NORTH|WEST
				if(SOUTHEAST)
					initialize_directions = SOUTH|EAST
				if(SOUTHWEST)
					initialize_directions = SOUTH|WEST


		hide(var/i)
			if(level == 1 && istype(loc, /turf/simulated))
				invisibility = i ? 101 : 0
			update_icon()

		process()
			if(!parent) //This should cut back on the overhead calling build_network thousands of times per cycle
				..()
			else
				. = PROCESS_KILL

			/*if(!node1)
				parent.mingle_with_turf(loc, volume)
				if(!nodealert)
					//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
					nodealert = 1

			else if(!node2)
				parent.mingle_with_turf(loc, volume)
				if(!nodealert)
					//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
					nodealert = 1
			else if (nodealert)
				nodealert = 0


			else if(parent)
				var/environment_temperature = 0

				if(istype(loc, /turf/simulated/))
					if(loc:blocks_air)
						environment_temperature = loc:temperature
					else
						var/datum/gas_mixture/environment = loc.return_air()
						environment_temperature = environment.temperature

				else
					environment_temperature = loc:temperature

				var/datum/gas_mixture/pipe_air = return_air()

				if(abs(environment_temperature-pipe_air.temperature) > minimum_temperature_difference)
					parent.temperature_interact(loc, volume, thermal_conductivity)
			*/  //Screw you heat lag

		check_pressure(pressure)
			var/datum/gas_mixture/environment = loc.return_air()

			var/pressure_difference = pressure - environment.return_pressure()

			if(pressure_difference > maximum_pressure)
				burst()

			else if(pressure_difference > fatigue_pressure)
				//TODO: leak to turf, doing pfshhhhh
				if(prob(5))
					burst()

			else return 1

		proc/burst()
			src.visible_message("\red \bold [src] bursts!");
			playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
			var/datum/effect/effect/system/harmless_smoke_spread/smoke = new
			smoke.set_up(1,0, src.loc, 0)
			smoke.start()
			qdel(src)
/*
		proc/normalize_dir()
			if(dir==3)
				dir = 1
			else if(dir==12)
				dir = 4
*/
/*
		Destroy()
			if(node[1])
				node[1].disconnect(src)
			if(node[2])
				node[2].disconnect(src)

			..()

		pipeline_expansion()
			return node
*/
		update_icon()
			if(NODE_1&&NODE_2)
				icon_state = "intact[invisibility ? "-f" : "" ]"
			else
				if(!NODE_1&&!NODE_2)
					qdel(src) //TODO: silent deleting looks weird
				var/have_node1 = NODE_1?1:0
				var/have_node2 = NODE_2?1:0
				icon_state = "exposed[have_node1][have_node2][invisibility ? "-f" : "" ]"
			color = pipe_color

/*
		initialize()
			normalize_dir()
			var/node1_dir
			var/node2_dir

			for(var/direction in cardinal)
				if(direction&initialize_directions)
					if (!node1_dir)
						node1_dir = direction
					else if (!node2_dir)
						node2_dir = direction

			for(var/obj/machinery/atmospherics/target in get_step(src,node1_dir))
				if(target.initialize_directions & get_dir(target,src))
					node[1] = target
					break
			for(var/obj/machinery/atmospherics/target in get_step(src,node2_dir))
				if(target.initialize_directions & get_dir(target,src))
					node[2] = target
					break


			var/turf/T = src.loc			// hide if turf is not intact
			if(T)
				hide(T.intact)
			update_icon()
			//update_icon()
			*/
/*
		disconnect(obj/machinery/atmospherics/reference)
			for (var/I = 1; I <= nodecount; I++)
				if(reference == node[I])
					if(istype(node[I], /obj/machinery/atmospherics/pipe))
						del(parent)
					node[I] = null
			update_icon()
			return null
*/
	simple/scrubbers
		name="Scrubbers pipe"
		pipe_color="red"
		icon_state = ""

	simple/supply
		name="Air supply pipe"
		pipe_color="blue"
		icon_state = ""

	simple/supplymain
		name="Main air supply pipe"
		pipe_color="purple"
		icon_state = ""

	simple/general
		name="Pipe"
		pipe_color=""
		icon_state = ""

	simple/scrubbers/visible
		level = 2
		icon_state = "intact-r"

	simple/scrubbers/hidden
		level = 1
		icon_state = "intact-r-f"

	simple/supply/visible
		level = 2
		icon_state = "intact-b"

	simple/supply/hidden
		level = 1
		icon_state = "intact-b-f"

	simple/supplymain/visible
		level = 2
		icon_state = "intact-p"

	simple/supplymain/hidden
		level = 1
		icon_state = "intact-p-f"

	simple/general/visible
		level = 2
		icon_state = "intact"

	simple/general/hidden
		level = 1
		icon_state = "intact-f"

	simple/yellow
		name="Pipe"
		pipe_color="yellow"
		icon_state = ""

	simple/yellow/visible
		level = 2
		icon_state = "intact-y"

	simple/yellow/hidden
		level = 1
		icon_state = "intact-y-f"



	simple/insulated
		icon = 'icons/obj/atmospherics/red_pipe.dmi'
		icon_state = "intact"

		minimum_temperature_difference = 10000
		thermal_conductivity = 0
		maximum_pressure = 1000*ONE_ATMOSPHERE
		fatigue_pressure = 900*ONE_ATMOSPHERE
		alert_pressure = 900*ONE_ATMOSPHERE

		level = 2


	tank
		icon = 'icons/obj/atmospherics/pipe_tank.dmi'
		icon_state = "intact"

		name = "pressure tank"
		desc = "A large vessel containing pressurized gas."

		volume = 10000 //in liters, 1 meters by 1 meters by 2 meters

		dir = SOUTH
		initialize_directions = SOUTH
		density = 1

		can_unwrench = 0

		nodecount = 1

		New()
			initialize_directions = dir
			..()

		process()
			if(!parent)
				..()
			else
				. = PROCESS_KILL
/*			if(!node1)
				parent.mingle_with_turf(loc, 200)
				if(!nodealert)
					//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
					nodealert = 1
			else if (nodealert)
				nodealert = 0
*/
		carbon_dioxide
			name = "pressure tank (Carbon Dioxide)"

			New()
				air_temporary = new
				air_temporary.volume = volume
				air_temporary.temperature = T20C

				air_temporary.carbon_dioxide = (25*ONE_ATMOSPHERE)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

				..()

		toxins
			icon = 'icons/obj/atmospherics/orange_pipe_tank.dmi'
			name = "pressure tank (Plasma)"

			New()
				air_temporary = new
				air_temporary.volume = volume
				air_temporary.temperature = T20C

				air_temporary.toxins = (25*ONE_ATMOSPHERE)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

				..()

		oxygen_agent_b
			icon = 'icons/obj/atmospherics/red_orange_pipe_tank.dmi'
			name = "pressure tank (Oxygen + Plasma)"

			New()
				air_temporary = new
				air_temporary.volume = volume
				air_temporary.temperature = T0C

				var/datum/gas/oxygen_agent_b/trace_gas = new
				trace_gas.moles = (25*ONE_ATMOSPHERE)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

				air_temporary.trace_gases += trace_gas

				..()

		oxygen
			icon = 'icons/obj/atmospherics/blue_pipe_tank.dmi'
			name = "pressure tank (Oxygen)"

			New()
				air_temporary = new
				air_temporary.volume = volume
				air_temporary.temperature = T20C

				air_temporary.oxygen = (25*ONE_ATMOSPHERE)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

				..()

		nitrogen
			icon = 'icons/obj/atmospherics/red_pipe_tank.dmi'
			name = "pressure tank (Nitrogen)"

			New()
				air_temporary = new
				air_temporary.volume = volume
				air_temporary.temperature = T20C

				air_temporary.nitrogen = (25*ONE_ATMOSPHERE)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

				..()

		air
			icon = 'icons/obj/atmospherics/red_pipe_tank.dmi'
			name = "pressure tank (Air)"

			New()
				air_temporary = new
				air_temporary.volume = volume
				air_temporary.temperature = T20C

				air_temporary.oxygen = (25*ONE_ATMOSPHERE*O2STANDARD)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)
				air_temporary.nitrogen = (25*ONE_ATMOSPHERE*N2STANDARD)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

				..()
/*
		Destroy()
			if(node1)
				node1.disconnect(src)

			..()
*/
/*
		pipeline_expansion()
			return list(node)
*/
		update_icon()
			if(NODE_1)
				icon_state = "intact"

				dir = get_dir(src, NODE_1)

			else
				icon_state = "exposed"
			color = pipe_color
/*
		initialize()

			var/connect_direction = dir

			for(var/obj/machinery/atmospherics/target in get_step(src,connect_direction))
				if(target.initialize_directions & get_dir(target,src))
					node1 = target
					break

			update_icon()

		disconnect(obj/machinery/atmospherics/reference)
			if(reference == node1)
				if(istype(node1, /obj/machinery/atmospherics/pipe))
					del(parent)
				node1 = null

			update_icon()

			return null
*/
		attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
			if (istype(W, /obj/item/device/analyzer) && get_dist(user, src) <= 1)
				atmosanalyzer_scan(parent.air, user)

	vent
		icon = 'icons/obj/atmospherics/pipe_vent.dmi'
		icon_state = "intact"

		name = "vent"
		desc = "A large air vent"

		level = 1

		volume = 250

		dir = SOUTH
		initialize_directions = SOUTH

		can_unwrench = 0

		var/build_killswitch = 1

		var/obj/machinery/atmospherics/node1
		New()
			initialize_directions = dir
			..()

		process()
			if(!parent)
				if(build_killswitch <= 0)
					. = PROCESS_KILL
				else
					build_killswitch--
				..()
				return
			else
				parent.mingle_with_turf(loc, 250)
/*
			if(!node1)
				if(!nodealert)
					//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
					nodealert = 1
			else if (nodealert)
				nodealert = 0
*/
		Destroy()
			if(node1)
				node1.disconnect(src)

			..()

		pipeline_expansion()
			return list(node1)

		update_icon()
			if(node1)
				icon_state = "intact"

				dir = get_dir(src, node1)

			else
				icon_state = "exposed"
			color = pipe_color

		initialize()
			var/connect_direction = dir

			for(var/obj/machinery/atmospherics/target in get_step(src,connect_direction))
				if(target.initialize_directions & get_dir(target,src))
					node1 = target
					break

			update_icon()

		disconnect(obj/machinery/atmospherics/reference)
			if(reference == node1)
				if(istype(node1, /obj/machinery/atmospherics/pipe))
					del(parent)
				node1 = null

			update_icon()

			return null

		hide(var/i) //to make the little pipe section invisible, the icon changes.
			if(node1)
				icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]intact"
				dir = get_dir(src, node1)
			else
				icon_state = "exposed"

	manifold
		icon = 'icons/obj/atmospherics/pipe_manifold.dmi'
		icon_state = "manifold-f"

		name = "pipe manifold"
		desc = "A manifold composed of regular pipes"

		volume = 105

		dir = SOUTH
		initialize_directions = EAST|NORTH|WEST
		nodecount = 3

		level = 1
		layer = 2.4 //under wires with their 2.44

		New()
			switch(dir)
				if(NORTH)
					initialize_directions = EAST|SOUTH|WEST
				if(SOUTH)
					initialize_directions = WEST|NORTH|EAST
				if(EAST)
					initialize_directions = SOUTH|WEST|NORTH
				if(WEST)
					initialize_directions = NORTH|EAST|SOUTH

			..()



		hide(var/i)
			if(level == 1 && istype(loc, /turf/simulated))
				invisibility = i ? 101 : 0
			update_icon()
/*
		pipeline_expansion()
			return list(node1, node2, node3)
*/
		process()
			if(!parent)
				..()
			else
				. = PROCESS_KILL
/*
			if(!node1)
				parent.mingle_with_turf(loc, 70)
				if(!nodealert)
					//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
					nodealert = 1
			else if(!node2)
				parent.mingle_with_turf(loc, 70)
				if(!nodealert)
					//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
					nodealert = 1
			else if(!node3)
				parent.mingle_with_turf(loc, 70)
				if(!nodealert)
					//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
					nodealert = 1
			else if (nodealert)
				nodealert = 0
*/
/*
		Destroy()
			if(node1)
				node1.disconnect(src)
			if(node2)
				node2.disconnect(src)
			if(node3)
				node3.disconnect(src)

			..()
*/
/*
		disconnect(obj/machinery/atmospherics/reference)
			if(reference == node1)
				if(istype(node1, /obj/machinery/atmospherics/pipe))
					del(parent)
				node1 = null

			if(reference == node2)
				if(istype(node2, /obj/machinery/atmospherics/pipe))
					del(parent)
				node2 = null

			if(reference == node3)
				if(istype(node3, /obj/machinery/atmospherics/pipe))
					del(parent)
				node3 = null

			update_icon()

			..()
*/

		update_icon()
			if(NODE_1 && NODE_2 && NODE_3)
				icon_state = "manifold[invisibility ? "-f" : ""]"

			else
				var/connected = 0
				var/unconnected = 0
				var/connect_directions = (NORTH|SOUTH|EAST|WEST)&(~dir)

				for(NODE_LOOP)
					if(NODE_I)
						connected |= get_dir(src, NODE_I)
				/*
				if(node1)
					connected |= get_dir(src, NODE_1)
				if(node2)
					connected |= get_dir(src, node2)
				if(node3)
					connected |= get_dir(src, node3)
				*/

				unconnected = (~connected)&(connect_directions)

				icon_state = "manifold_[connected]_[unconnected]"

				if(!connected)
					qdel(src)
			color = pipe_color
			return
/*
		initialize()
			var/connect_directions = (NORTH|SOUTH|EAST|WEST)&(~dir)

			for(var/direction in cardinal)
				if(direction&connect_directions)
					for(var/obj/machinery/atmospherics/target in get_step(src,direction))
						if(target.initialize_directions & get_dir(target,src))
							node1 = target
							connect_directions &= ~direction
							break
					if (node1)
						break


			for(var/direction in cardinal)
				if(direction&connect_directions)
					for(var/obj/machinery/atmospherics/target in get_step(src,direction))
						if(target.initialize_directions & get_dir(target,src))
							node2 = target
							connect_directions &= ~direction
							break
					if (node2)
						break


			for(var/direction in cardinal)
				if(direction&connect_directions)
					for(var/obj/machinery/atmospherics/target in get_step(src,direction))
						if(target.initialize_directions & get_dir(target,src))
							node3 = target
							connect_directions &= ~direction
							break
					if (node3)
						break

			var/turf/T = src.loc			// hide if turf is not intact
			if(T)
				hide(T.intact)
			//update_icon()
			update_icon()
*/
	manifold/scrubbers
		name="Scrubbers pipe"
		pipe_color="red"
		icon_state = ""

	manifold/supply
		name="Air supply pipe"
		pipe_color="blue"
		icon_state = ""

	manifold/supplymain
		name="Main air supply pipe"
		pipe_color="purple"
		icon_state = ""

	manifold/general
		name="Air supply pipe"
		pipe_color="gray"
		icon_state = ""

	manifold/yellow
		name="Air supply pipe"
		pipe_color="yellow"
		icon_state = ""

	manifold/scrubbers/visible
		level = 2
		icon_state = "manifold-r"

	manifold/scrubbers/hidden
		level = 1
		icon_state = "manifold-r-f"

	manifold/supply/visible
		level = 2
		icon_state = "manifold-b"

	manifold/supply/hidden
		level = 1
		icon_state = "manifold-b-f"

	manifold/supplymain/visible
		level = 2
		icon_state = "manifold-p"

	manifold/supplymain/hidden
		level = 1
		icon_state = "manifold-p-f"

	manifold/general/visible
		level = 2
		icon_state = "manifold"

	manifold/general/hidden
		level = 1
		icon_state = "manifold-f"

	manifold/yellow/visible
		level = 2
		icon_state = "manifold-y"

	manifold/yellow/hidden
		level = 1
		icon_state = "manifold-y-f"

obj/machinery/atmospherics/pipe/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if (istype(W, /obj/item/device/analyzer) && get_dist(user, src) <= 1)
		atmosanalyzer_scan(parent.air, user)
	else
		return ..()
