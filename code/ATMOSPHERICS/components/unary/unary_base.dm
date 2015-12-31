/obj/machinery/atmospherics/unary
	dir = SOUTH
	initialize_directions = SOUTH
	layer = TURF_LAYER+0.1
	nodecount = 1

	var/datum/gas_mixture/air_contents

	var/datum/pipe_network/network

	New()
		..()
		initialize_directions = dir
		air_contents = new

		air_contents.volume = 200

// Housekeeping and pipe network stuff below
	network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
		if(reference == NODE_1)
			network = new_network

		if(new_network.normal_members.Find(src))
			return 0

		new_network.normal_members += src

		return null

	Destroy()
		if(NODE_1)
			var/obj/machinery/atmospherics/A = NODE_1
			A.disconnect(src)
			del(network)

		NODE_1 = null

		..()

	initialize(infiniteloop = 0)
		if(!infiniteloop)
			src.disconnect(src)

		var/node_connect = dir

		for(var/obj/machinery/atmospherics/target in get_step(src,node_connect))
			if(target.initialize_directions & get_dir(target,src))
				NODE_1 = target
				if(!infiniteloop)
					target.initialize(1)
				break
		build_network()

		update_icon()

	default_change_direction_wrench(mob/user, obj/item/weapon/wrench/W)
		if(..())
			initialize_directions = dir
			if(NODE_1)
				disconnect(NODE_1)
			initialize()
			. = 1

	build_network()
		if(!network && NODE_1)
			network = new /datum/pipe_network()
			network.normal_members += src
			network.build_network(NODE_1, src)


	return_network(obj/machinery/atmospherics/reference)
		build_network()

		if(reference==NODE_1)
			return network

		return null

	reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
		if(network == old_network)
			network = new_network

		return 1

	return_network_air(datum/pipe_network/reference)
		var/list/results = list()

		if(network == reference)
			results += air_contents

		return results

	disconnect(obj/machinery/atmospherics/reference)
		if(reference==NODE_1)
			NODE_1 = null
			reference.disconnect(src)
			del(network)

		return null