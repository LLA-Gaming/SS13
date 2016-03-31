/obj/machinery/atmospherics/portables_connector
	icon = 'icons/obj/atmospherics/portables_connector.dmi'
	icon_state = "intact"

	name = "connector port"
	desc = "For connecting portables devices related to atmospherics control."

	dir = SOUTH
	initialize_directions = SOUTH
	nodecount = 1

	can_unwrench = 1

	var/obj/machinery/portable_atmospherics/connected_device

	var/datum/pipe_network/network

	var/on = 0
	use_power = 0
	level = 0


	New()
		initialize_directions = dir
		..()

	update_icon()
		if(node[1])
			icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]intact"
			dir = get_dir(src, node[1])
		else
			icon_state = "exposed"
		color = pipe_color

		return

	hide(var/i) //to make the little pipe section invisible, the icon changes.
		if(node[1])
			icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]intact"
			dir = get_dir(src, node[1])
		else
			icon_state = "exposed"

	process()
		..()
		if(!on)
			return
		if(!connected_device)
			on = 0
			return
		if(network)
			network.update = 1
		return 1

// Housekeeping and pipe network stuff below
	network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
		if(reference == node[1])
			network = new_network

		if(new_network.normal_members.Find(src))
			return 0

		new_network.normal_members += src

		return null

	Destroy()
		if(connected_device)
			connected_device.disconnect()

		if(node[1])
			var/obj/machinery/atmospherics/A = node[1]
			A.disconnect(src)
			qdel(network)

		node = null

		..()

	initialize()
		src.disconnect(src)

		var/node_connect = dir

		for(var/obj/machinery/atmospherics/target in get_step(src,node_connect))
			if(target.initialize_directions & get_dir(target,src))
				node[1] = target
				break

		update_icon()

	build_network()
		if(!network && NODE_1)
			network = new /datum/pipe_network()
			network.normal_members += src
			network.build_network(NODE_1, src)


	return_network(obj/machinery/atmospherics/reference)
		build_network()

		if(reference==node[1])
			return network

		if(reference==connected_device)
			return network

		return null

	reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
		if(network == old_network)
			network = new_network

		return 1

	return_network_air(datum/pipe_network/reference)
		var/list/results = list()

		if(connected_device)
			results += connected_device.air_contents

		return results

	disconnect(obj/machinery/atmospherics/reference)
		if(node)
			if(reference==node[1])
				qdel(network)
				node[1] = null

		return null


	attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
		if (!istype(W, /obj/item/weapon/wrench))
			return ..()
		if (connected_device)
			user << "\red You cannot unwrench this [src], dettach [connected_device] first."
			return 1
		return ..()