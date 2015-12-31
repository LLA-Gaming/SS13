obj/machinery/atmospherics/binary
	dir = SOUTH
	initialize_directions = SOUTH|NORTH
	use_power = 1
	nodecount = 2

	var/datum/gas_mixture/air1
	var/datum/gas_mixture/air2

	var/datum/pipe_network/network1
	var/datum/pipe_network/network2

	New()
		..()
		switch(dir)
			if(NORTH)
				initialize_directions = NORTH|SOUTH
			if(SOUTH)
				initialize_directions = NORTH|SOUTH
			if(EAST)
				initialize_directions = EAST|WEST
			if(WEST)
				initialize_directions = EAST|WEST
		air1 = new
		air2 = new

		air1.volume = 200
		air2.volume = 200

// Housekeeping and pipe network stuff below
	network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
		if(reference == NODE_1)
			network1 = new_network

		else if(reference == NODE_2)
			network2 = new_network

		if(new_network.normal_members.Find(src))
			return 0

		new_network.normal_members += src

		return null

	Destroy()
		loc = null

		if(NODE_1)
			var/obj/machinery/atmospherics/A = NODE_1
			A.disconnect(src)
			del(network1)
			NODE_1 = null
		if(NODE_2)
			var/obj/machinery/atmospherics/A = NODE_2
			A.disconnect(src)
			del(network2)
			NODE_2 = null

		..()

	initialize()
		src.disconnect(src)

		var/node2_connect = dir
		var/node1_connect = turn(dir, 180)

		for(var/obj/machinery/atmospherics/target in get_step(src,node1_connect))
			if(target.initialize_directions & get_dir(target,src))
				NODE_1 = target
				break

		for(var/obj/machinery/atmospherics/target in get_step(src,node2_connect))
			if(target.initialize_directions & get_dir(target,src))
				NODE_2 = target
				break

		update_icon()

	build_network()
		if(!network1 && NODE_1)
			network1 = new /datum/pipe_network()
			network1.normal_members += src
			network1.build_network(NODE_1, src)

		if(!network2 && NODE_2)
			network2 = new /datum/pipe_network()
			network2.normal_members += src
			network2.build_network(NODE_2, src)


	return_network(obj/machinery/atmospherics/reference)
		build_network()

		if(reference==NODE_1)
			return network1

		if(reference==NODE_2)
			return network2

		return null

	reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
		if(network1 == old_network)
			network1 = new_network
		if(network2 == old_network)
			network2 = new_network

		return 1

	return_network_air(datum/pipe_network/reference)
		var/list/results = list()

		if(network1 == reference)
			results += air1
		if(network2 == reference)
			results += air2

		return results

	disconnect(obj/machinery/atmospherics/reference)
		if(reference==NODE_1)
			del(network1)
			NODE_1 = null

		else if(reference==NODE_2)
			del(network2)
			NODE_2 = null

		return null