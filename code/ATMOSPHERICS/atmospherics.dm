/*
Quick overview:

Pipes combine to form pipelines
Pipelines and other atmospheric objects combine to form pipe_networks
	Note: A single pipe_network represents a completely open space

Pipes -> Pipelines
Pipelines + Other Objects -> Pipe network

*/

obj/machinery/atmospherics
	anchored = 1
	idle_power_usage = 0
	active_power_usage = 0
	power_channel = ENVIRON
	var/nodealert = 0
	var/can_unwrench = 0
	var/list/node = list(1=null, 2=null, 3=null, 4=null)
	var/nodecount = 0



obj/machinery/atmospherics/var/initialize_directions = 0
obj/machinery/atmospherics/var/pipe_color

obj/machinery/atmospherics/process()
	if(gc_destroyed) //comments on /vg/ imply that GC'd pipes still process
		return PROCESS_KILL
	build_network()

obj/machinery/atmospherics/proc/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	// Check to see if should be added to network. Add self if so and adjust variables appropriately.
	// Note don't forget to have neighbors look as well!

	return null

obj/machinery/atmospherics/proc/build_network()
	// Called to build a network from this node

	return null

obj/machinery/atmospherics/proc/return_network(obj/machinery/atmospherics/reference)
	// Returns pipe_network associated with connection to reference
	// Notes: should create network if necessary
	// Should never return null

	return null

obj/machinery/atmospherics/proc/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	// Used when two pipe_networks are combining

obj/machinery/atmospherics/proc/return_network_air(datum/network/reference)
	// Return a list of gas_mixture(s) in the object
	//		associated with reference pipe_network for use in rebuilding the networks gases list
	// Is permitted to return null

obj/machinery/atmospherics/proc/disconnect(obj/machinery/atmospherics/reference)

obj/machinery/atmospherics/proc/normalize_dir()
	if(dir==3)
		dir = 1
	else if(dir==12)
		dir = 4

obj/machinery/atmospherics/update_icon()
	color = pipe_color
	return null

obj/machinery/atmospherics/proc/rename(var/newname, var/pipe)
	if(newname)
		src.name = newname
	else
		src.name = initial(src.name)
	if(pipe)
		//typecast because i just want this all in one damned place.
		var/obj/machinery/atmospherics/pipe/P = src
		//force parent to exist
		if(!P.parent)
			P.parent = new /datum/pipeline()
			P.parent.build_pipeline(src)
		if(P.parent.naming_pipe)
			return 0
		//if no name entered, reset.
		if(newname == "")
			P.parent.resetname()
		else
			P.parent.naming_pipe = P
		//build_pipeline propagates the new name.
		P.parent.build_pipeline(src)
	return 1



obj/machinery/atmospherics/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)

	if(istype(W, /obj/item/weapon/pen))
		var/newname = stripped_input(user,"Enter a name. Leave blank for default.","Rename",src.name) //Sanitize sanitize sanitize
		var/ispipe
		if (istype(src, /obj/machinery/atmospherics/pipe))
			ispipe = 1
		else
			ispipe = 0
		if(istype(src, /obj/machinery/atmospherics/unary/vent_pump) || istype(src, /obj/machinery/atmospherics/unary/vent_scrubber))
			user << "You cannot name this machine!"
			return 1
		//user << "You begin to rename the pipe.."
		//Flavo threatened to call the police if i committed the comment that used to be here.
		if(src.rename(newname, ispipe))
			user << "You rename the pipe to [newname]."
			log_game("[key_name(user)] has renamed the pipe at ([src.x],[src.y],[src.z]) to [newname].")
			return 1
		else
			user << "\red Someone is already naming this pipeline!" //Realistically? Chances of this are tiny
			return 1

	if(istype(W, /obj/item/weapon/pipe_painter))
		var/obj/item/weapon/pipe_painter/P = W
		src.pipe_color = P.colors[P.paint_color]
		update_icon()
		return 1

	if(can_unwrench && istype(W, /obj/item/weapon/wrench))
		var/turf/T = src.loc
		if (level==1 && isturf(T) && T.intact)
			user << "\red You must remove the plating first."
			return 1
		var/datum/gas_mixture/int_air = return_air()
		var/datum/gas_mixture/env_air = loc.return_air()
		if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
			user << "\red You cannot unwrench this [src], it is too exerted due to internal pressure."
			add_fingerprint(user)
			return 1
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		user << "\blue You begin to unfasten \the [src]..."
		add_fingerprint(user)
		if (do_after(user, 40))
			user.visible_message( \
				"[user] unfastens \the [src].", \
				"\blue You have unfastened \the [src].", \
				"You hear ratchet.")
			var/obj/item/pipe/newpipe = new(loc, make_from=src)
			transfer_fingerprints_to(newpipe)
			newpipe.pipe_color = src.pipe_color
			newpipe.color = src.color
			if(istype(src, /obj/machinery/atmospherics/pipe))
				for(var/obj/machinery/meter/meter in T)
					if(meter.target == src)
						new /obj/item/pipe_meter(T)
						qdel(meter)
			qdel(src)
	else
		return ..()
