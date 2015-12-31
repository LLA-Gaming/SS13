obj/machinery/atmospherics/valve
	icon = 'icons/obj/atmospherics/valve.dmi'
	icon_state = "valve0"

	name = "manual valve"
	desc = "A pipe valve"

	dir = SOUTH
	initialize_directions = SOUTH|NORTH

	can_unwrench = 1

	nodecount = 2

	var/open = 0
	var/openDuringInit = 0

	var/datum/pipe_network/network_node1
	var/datum/pipe_network/network_node2

	open
		open = 1
		icon_state = "valve1"

	update_icon(animation)
		if(animation)
			flick("valve[src.open][!src.open]",src)
		else
			icon_state = "valve[open]"
		color = pipe_color

	New()
		..()
		switch(dir)
			if(NORTH || SOUTH)
				initialize_directions = NORTH|SOUTH
			if(EAST || WEST)
				initialize_directions = EAST|WEST

	network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)


		if(reference == node[1])
			network_node1 = new_network
			if(open)
				network_node2 = new_network
		else if(reference == node[2])
			network_node2 = new_network
			if(open)
				network_node1 = new_network

		if(new_network.normal_members.Find(src))
			return 0

		new_network.normal_members += src

		if(open)
			if(reference == node[1])
				if(node[2])
					var/obj/machinery/atmospherics/A =  node[2]
					return A.network_expand(new_network, src)
			else if(reference == node[2])
				if(node[1])
					var/obj/machinery/atmospherics/A =  node[1]
					return A.network_expand(new_network, src)

		return null

	Destroy()
		for(NODE_LOOP)
			if(NODE_I)
				var/obj/machinery/atmospherics/A = NODE_I
				A.disconnect(src)
				if(I == 1)
					del(network_node1)
				if(I == 2)
					del(network_node2)
				NODE_I = null

		..()

	proc/open()

		if(open) return 0

		open = 1
		update_icon()

		if(network_node1&&network_node2)
			network_node1.merge(network_node2)
			network_node2 = network_node1

		if(network_node1)
			network_node1.update = 1
		else if(network_node2)
			network_node2.update = 1

		return 1

	proc/close()

		if(!open)
			return 0

		open = 0
		update_icon()

		if(network_node1)
			del(network_node1)
		if(network_node2)
			del(network_node2)

		build_network()

		return 1

	attack_ai(mob/user as mob)
		return

	attack_paw(mob/user as mob)
		return attack_hand(user)

	attack_hand(mob/user as mob)
		src.add_fingerprint(usr)
		update_icon(1)
		sleep(10)
		if (src.open)
			src.close()
		else
			src.open()

	process()
		..()
		. = PROCESS_KILL



		return

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

		build_network()

		if(openDuringInit)
			close()
			open()
			openDuringInit = 0

	build_network()

		if(!network_node1 && node[1])
			network_node1 = new /datum/pipe_network()
			network_node1.normal_members += src
			network_node1.build_network(node[1], src)

		if(!network_node2 && node[2])
			network_node2 = new /datum/pipe_network()
			network_node2.normal_members += src
			network_node2.build_network(node[2], src)


	return_network(obj/machinery/atmospherics/reference)
		build_network()

		if(reference==node[1])
			return network_node1

		if(reference==node[2])
			return network_node2

		return null

	reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
		if(network_node1 == old_network)
			network_node1 = new_network
		if(network_node2 == old_network)
			network_node2 = new_network

		return 1

	return_network_air(datum/network/reference)
		return null

	disconnect(obj/machinery/atmospherics/reference)
		if(reference==node[1])
			del(network_node1)
			node[1] = null

		else if(reference==node[2])
			del(network_node2)
			node[2] = null

		return null

	digital		// can be controlled by AI
		name = "digital valve"
		desc = "A digitally controlled valve."
		icon = 'icons/obj/atmospherics/digital_valve.dmi'

		attack_ai(mob/user as mob)
			return src.attack_hand(user)

		attack_hand(mob/user as mob)
			if(!src.allowed(user))
				user << "\red Access denied."
				return
			..()

		//Radio remote control

		proc
			set_frequency(new_frequency)
				radio_controller.remove_object(src, frequency)
				frequency = new_frequency
				if(frequency)
					radio_connection = radio_controller.add_object(src, frequency, RADIO_ATMOSIA)

		var/frequency = 0
		var/id = null
		var/datum/radio_frequency/radio_connection

		initialize()
			..()
			if(frequency)
				set_frequency(frequency)

		receive_signal(datum/signal/signal)
			if(!signal.data["tag"] || (signal.data["tag"] != id))
				return 0

			switch(signal.data["command"])
				if("valve_open")
					if(!open)
						open()

				if("valve_close")
					if(open)
						close()

				if("valve_toggle")
					if(open)
						close()
					else
						open()
