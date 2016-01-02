//Direction definitions
#define NORTHSOUTH 1
#define EASTWEST 4

//Add any pre-defined atmos pipe variants as desired. This is specifically to make mapping easier.

//4-way Manifold pre-sets
//No colorless needed, there is only one dir so just use the default direction.
//Color Pre-sets

/obj/machinery/atmospherics/pipe/fourway_manifold/supply
	name = "Supply Manifold"
	pipe_color = "blue"
	icon_state = "manifold4w-b"
	level = 2

/obj/machinery/atmospherics/pipe/fourway_manifold/supply/hidden
	invisibility = 101
	icon_state = "manifold4w-b-f"
	level = 1

/obj/machinery/atmospherics/pipe/fourway_manifold/waste
	name = "Waste Manifold"
	pipe_color = "red"
	icon_state = "manifold4w-r"
	level = 2

/obj/machinery/atmospherics/pipe/fourway_manifold/waste/hidden
	invisibility = 101
	icon_state = "manifold4w-r-f"
	level = 1

/obj/machinery/atmospherics/pipe/fourway_manifold/yellow
	pipe_color = "yellow"
	icon_state = "manifold4w-y"
	level = 2

/obj/machinery/atmospherics/pipe/fourway_manifold/yellow/hidden
	invisibility = 101
	icon_state = "manifold4w-y-f"
	level = 1

/obj/machinery/atmospherics/pipe/fourway_manifold/green
	pipe_color = "green"
	icon_state = "manifold4w-g"
	level = 2

/obj/machinery/atmospherics/pipe/fourway_manifold/green/hidden
	invisibility = 101
	icon_state = "manifold4w-g-f"
	level = 1

/obj/machinery/atmospherics/pipe/fourway_manifold/cyan
	pipe_color = "cyan"
	icon_state = "manifold4w-c"
	level = 2

/obj/machinery/atmospherics/pipe/fourway_manifold/cyan/hidden
	invisibility = 101
	icon_state = "manifold4w-c-f"
	level = 1


//Simple Pipe Pre-sets
/obj/machinery/atmospherics/pipe/simple/preset
	level = 2

//Colorless and boring

/obj/machinery/atmospherics/pipe/simple/preset/grey
	pipe_color = null
	icon_state = "intact"

/obj/machinery/atmospherics/pipe/simple/preset/grey/northsouth
	dir = NORTHSOUTH

/obj/machinery/atmospherics/pipe/simple/preset/grey/eastwest
	dir = EASTWEST

/obj/machinery/atmospherics/pipe/simple/preset/grey/northeast
	dir = NORTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/grey/northwest
	dir = NORTHWEST

/obj/machinery/atmospherics/pipe/simple/preset/grey/southeast
	dir = SOUTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/grey/southwest
	dir = SOUTHWEST

//Supply Loop
//Visible

/obj/machinery/atmospherics/pipe/simple/preset/supply
	pipe_color = "blue"
	icon_state = "intact-b"

/obj/machinery/atmospherics/pipe/simple/preset/supply/northsouth
	dir = NORTHSOUTH

/obj/machinery/atmospherics/pipe/simple/preset/supply/eastwest
	dir = EASTWEST

/obj/machinery/atmospherics/pipe/simple/preset/supply/northeast
	dir = NORTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/supply/northwest
	dir = NORTHWEST

/obj/machinery/atmospherics/pipe/simple/preset/supply/southeast
	dir = SOUTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/supply/southwest
	dir = SOUTHWEST

//Hidden
/obj/machinery/atmospherics/pipe/simple/preset/hidden
	level = 1

/obj/machinery/atmospherics/pipe/simple/preset/hidden/supply
	pipe_color = "blue"
	icon_state = "intact-b-f"

/obj/machinery/atmospherics/pipe/simple/preset/hidden/supply/northsouth
	dir = NORTHSOUTH

/obj/machinery/atmospherics/pipe/simple/preset/hidden/supply/eastwest
	dir = EASTWEST

/obj/machinery/atmospherics/pipe/simple/preset/hidden/supply/northeast
	dir = NORTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/hidden/supply/northwest
	dir = NORTHWEST

/obj/machinery/atmospherics/pipe/simple/preset/hidden/supply/southeast
	dir = SOUTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/hidden/supply/southwest
	dir = SOUTHWEST

//Waste Loop
//Visible

/obj/machinery/atmospherics/pipe/simple/preset/waste
	pipe_color = "red"
	icon_state = "intact-r"

/obj/machinery/atmospherics/pipe/simple/preset/waste/northsouth
	dir = NORTHSOUTH

/obj/machinery/atmospherics/pipe/simple/preset/waste/eastwest
	dir = EASTWEST

/obj/machinery/atmospherics/pipe/simple/preset/waste/northeast
	dir = NORTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/waste/northwest
	dir = NORTHWEST

/obj/machinery/atmospherics/pipe/simple/preset/waste/southeast
	dir = SOUTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/waste/southwest
	dir = SOUTHWEST

//Hidden
/obj/machinery/atmospherics/pipe/simple/preset/hidden
	level = 1

/obj/machinery/atmospherics/pipe/simple/preset/hidden/waste
	pipe_color = "red"
	icon_state = "intact-r-f"
	invisibility = 101

/obj/machinery/atmospherics/pipe/simple/preset/hidden/waste/northsouth
	dir = NORTHSOUTH

/obj/machinery/atmospherics/pipe/simple/preset/hidden/waste/eastwest
	dir = EASTWEST

/obj/machinery/atmospherics/pipe/simple/preset/hidden/waste/northeast
	dir = NORTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/hidden/waste/northwest
	dir = NORTHWEST

/obj/machinery/atmospherics/pipe/simple/preset/hidden/waste/southeast
	dir = SOUTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/hidden/waste/southwest
	dir = SOUTHWEST

//Other Misc. Colors as requested.

//Cyan
/obj/machinery/atmospherics/pipe/simple/preset/cyan
	pipe_color = "cyan"
	icon_state = "intact-c"

/obj/machinery/atmospherics/pipe/simple/preset/cyan/northsouth
	dir = NORTHSOUTH

/obj/machinery/atmospherics/pipe/simple/preset/cyan/eastwest
	dir = EASTWEST

/obj/machinery/atmospherics/pipe/simple/preset/cyan/northeast
	dir = NORTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/cyan/northwest
	dir = NORTHWEST

/obj/machinery/atmospherics/pipe/simple/preset/cyan/southeast
	dir = SOUTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/cyan/southwest
	dir = SOUTHWEST

//Yellow
/obj/machinery/atmospherics/pipe/simple/preset/yellow
	pipe_color = "yellow"
	icon_state = "intact-y"

/obj/machinery/atmospherics/pipe/simple/preset/yellow/northsouth
	dir = NORTHSOUTH

/obj/machinery/atmospherics/pipe/simple/preset/yellow/eastwest
	dir = EASTWEST

/obj/machinery/atmospherics/pipe/simple/preset/yellow/northeast
	dir = NORTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/yellow/northwest
	dir = NORTHWEST

/obj/machinery/atmospherics/pipe/simple/preset/yellow/southeast
	dir = SOUTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/yellow/southwest
	dir = SOUTHWEST

//Green
/obj/machinery/atmospherics/pipe/simple/preset/green
	pipe_color = "green"
	icon_state = "intact-g"

/obj/machinery/atmospherics/pipe/simple/preset/green/northsouth
	dir = NORTHSOUTH

/obj/machinery/atmospherics/pipe/simple/preset/green/eastwest
	dir = EASTWEST

/obj/machinery/atmospherics/pipe/simple/preset/green/northeast
	dir = NORTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/green/northwest
	dir = NORTHWEST

/obj/machinery/atmospherics/pipe/simple/preset/green/southeast
	dir = SOUTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/green/southwest
	dir = SOUTHWEST

//Purple
/obj/machinery/atmospherics/pipe/simple/preset/purple
	pipe_color = "purple"
	icon_state = "intact-p"

/obj/machinery/atmospherics/pipe/simple/preset/purple/northsouth
	dir = NORTHSOUTH

/obj/machinery/atmospherics/pipe/simple/preset/purple/eastwest
	dir = EASTWEST

/obj/machinery/atmospherics/pipe/simple/preset/purple/northeast
	dir = NORTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/purple/northwest
	dir = NORTHWEST

/obj/machinery/atmospherics/pipe/simple/preset/purple/southeast
	dir = SOUTHEAST

/obj/machinery/atmospherics/pipe/simple/preset/purple/southwest
	dir = SOUTHWEST


//Cleanup
#undef NORTHSOUTH
#undef EASTWEST
