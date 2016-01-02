/obj/machinery/atmospherics/pipe/fourway_manifold
	name = "4-way pipe manifold"
	desc = "A 4 way manifold composed of regular pipes."
	icon = 'icons/obj/atmospherics/pipe_manifold.dmi'
	icon_state = "manifold4w"

	dir = NORTH //Honestly this probably doesn't even matter
	initialize_directions = NORTH|SOUTH|EAST|WEST

	volume = 120 //Tweak as needed, all i had to go on for a good value was "more than the 3way manifold"

	level = 1
	layer = 2.4 //Below wires which use 2.44

	nodecount = 4 //Finally something that uses the whole list!

/obj/machinery/atmospherics/pipe/fourway_manifold/process()
	if(!parent)
		..()
	else
		. = PROCESS_KILL

/obj/machinery/atmospherics/pipe/fourway_manifold/update_icon()
	if(NODE_1 && NODE_2 && NODE_3 && NODE_4) //If all the nodes exist
		icon_state = "manifold4w"
	else
		//If not all nodes exist, determine bitflag values for connected and unconnected sides.
		var/connected = 0
		var/unconnected = 0
		for(NODE_LOOP)
			if(NODE_I)
				connected |= get_dir(src, NODE_I)
		// The unconnected sides will just be the opposite of the connected sides. I could probably also do this arithmetically due to begin 4-sided but meh.
		unconnected = (~connected)&(NORTH|SOUTH|EAST|WEST)

		if(!connected)
			qdel(src) // No single pipes allowed.
		icon_state = "manifold4w_[connected]_[unconnected]"

	// Set proper color
	color = pipe_color
	// If color exists, append 7D (if invisible) or FF if not invisible. If it does not exist, substitute the null color.
	color = "[color ? color : "#FFFFFF"][invisibility ? "7D" : "FF"]"

	return

/obj/machinery/atmospherics/pipe/fourway_manifold/hide(var/i)
	if(level == 1 && istype(loc, /turf/simulated))
		invisibility = i ? 101: 0
	update_icon()