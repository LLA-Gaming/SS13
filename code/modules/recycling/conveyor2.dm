//conveyor2 is pretty much like the original, except it supports corners, but not diverters.
//note that corner pieces transfer stuff clockwise when running forward, and anti-clockwise backwards.

var/list/conveyor_belts = list()

/obj/machinery/conveyor
	icon = 'icons/obj/recycling.dmi'
	icon_state = "conveyor0"
	name = "conveyor belt"
	desc = "A conveyor belt."
	anchored = 1
	var/operating = 0	// 1 if running forward, -1 if backwards, 0 if off
	var/operable = 1	// true if can operate (no broken segments in this belt run)
	var/forwards		// this is the default (forward) direction, set by the map dir
	var/backwards		// hopefully self-explanatory
	var/movedir			// the actual direction to move stuff in

	var/list/affecting	// the list of all items that will be moved this ptick
	var/id = ""			// the control ID	- must match controller ID
	var/verted = 1		// set to -1 to have the conveyour belt be inverted, so you can use the other corner icons

/obj/machinery/conveyor/centcom_auto
	id = "round_end_belt"


// Auto conveyour is always on unless unpowered

/obj/machinery/conveyor/auto/New(loc, newdir)
	..(loc, newdir)
	operating = 1
	setmove()

/obj/machinery/conveyor/auto/update()
	if(stat & BROKEN)
		icon_state = "conveyor-broken"
		operating = 0
		return
	else if(!operable)
		operating = 0
	else if(stat & NOPOWER)
		operating = 0
	else
		operating = 1
	icon_state = "conveyor[operating * verted]"

	// create a conveyor
/obj/machinery/conveyor/New(loc, newdir)
	..(loc)
	if(newdir)
		dir = newdir

	conveyor_belts += src

	UpdateDirections()

	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/conveyor(null)
	component_parts += new /obj/item/stack/cable_coil(null, 1)

/obj/machinery/conveyor/proc/UpdateDirections()
	switch(dir)
		if(NORTH)
			forwards = NORTH
			backwards = SOUTH
		if(SOUTH)
			forwards = SOUTH
			backwards = NORTH
		if(EAST)
			forwards = EAST
			backwards = WEST
		if(WEST)
			forwards = WEST
			backwards = EAST
		if(NORTHEAST)
			forwards = EAST
			backwards = SOUTH
		if(NORTHWEST)
			forwards = SOUTH
			backwards = WEST
		if(SOUTHEAST)
			forwards = NORTH
			backwards = EAST
		if(SOUTHWEST)
			forwards = WEST
			backwards = NORTH

	if(verted == -1)
		var/temp = forwards
		forwards = backwards
		backwards = temp

/obj/machinery/conveyor/examine()
	..()
	usr << "<span class='notice'>Its current ID is '[id ? id : "*NONE*"]'."
	usr << "<span class='notice'>Current direction: [dir2text(dir)]</span>"
	if(panel_open)
		usr << "<span class='notice'>The maintenance panel is open.</span>"

/obj/machinery/conveyor/proc/setmove()
	if(operating == 1)
		movedir = forwards
	else
		movedir = backwards
	update()

/obj/machinery/conveyor/proc/update()
	if(stat & BROKEN)
		icon_state = "conveyor-broken"
		operating = 0
		return
	if(!operable)
		operating = 0
	if(stat & NOPOWER)
		operating = 0
	icon_state = "conveyor[operating * verted]"

	// machine process
	// move items to the target location
/obj/machinery/conveyor/process()
	if(stat & (BROKEN | NOPOWER))
		return
	if(!operating)
		return
	if(panel_open)
		return 0

	use_power(100)

	affecting = loc.contents - src		// moved items will be all in loc
	spawn(1)	// slight delay to prevent infinite propagation due to map order	//TODO: please no spawn() in process(). It's a very bad idea
		var/items_moved = 0
		for(var/atom/movable/A in affecting)
			if(!A.anchored)
				if(A.loc == src.loc) // prevents the object from being affected if it's not currently here.
					step(A,movedir)
					items_moved++
			if(items_moved >= 10)
				break

// attack with item, place item on conveyor
/obj/machinery/conveyor/attackby(var/obj/item/I, mob/user)
	if(isrobot(user))	return //Carn: fix for borgs dropping their modules on conveyor belts

	if(istype(I, /obj/item/weapon/screwdriver))
		if(operating)
			return 0
		default_deconstruction_screwdriver(user, icon_state, icon_state, I)
		return 0

	if(istype(I, /obj/item/device/multitool))
		if(panel_open)
			if(verted == 1)
				verted = -1
			else
				verted = 1
			user << "<span class='notice'>\The [src] now moves in the opposite direction."

			UpdateDirections()
		else
			var/newid = input(user, "Please enter a new ID.", "Input") as text
			newid = trim(newid)
			newid = strip_html(newid)
			newid = sanitize(newid)
			id = newid
			user << "<span class='notice'>You set \the [src]'s ID to '[id]'."

			for(var/obj/machinery/conveyor_switch/conveyor_switch in conveyor_switches)
				conveyor_switch.UpdateConveyors()

		return 0

	if(istype(I, /obj/item/weapon/crowbar))
		if(panel_open)
			default_deconstruction_crowbar(I)
		else
			var/list/directions = list()
			for(var/_dir in (alldirs.Copy() - dir))
				directions[dir2text(_dir)] = _dir

			var/newdir_input = input(user, "Select a new direction", "Input") in directions + "Cancel"
			if(!newdir_input || newdir_input == "Cancel")
				return 0

			dir = directions[newdir_input]
			user << "<span class='notice'>You rotate \the [src] to [dir2text(dir)].</span>"

			UpdateDirections()
			setmove()
		return 0

	if(!user.drop_item())
		user << "<span class='notice'>\The [I] is stuck to your hand, you cannot place it on the conveyor!</span>"
		return
	if(I && I.loc)	I.loc = src.loc
	return

// attack with hand, move pulled object onto conveyor
/obj/machinery/conveyor/attack_hand(mob/user as mob)
	user.Move_Pulled(src)


// make the conveyor broken
// also propagate inoperability to any connected conveyor with the same ID
/obj/machinery/conveyor/proc/broken()
	stat |= BROKEN
	update()

	var/obj/machinery/conveyor/C = locate() in get_step(src, dir)
	if(C)
		C.set_operable(dir, id, 0)

	C = locate() in get_step(src, turn(dir,180))
	if(C)
		C.set_operable(turn(dir,180), id, 0)


//set the operable var if ID matches, propagating in the given direction

/obj/machinery/conveyor/proc/set_operable(stepdir, match_id, op)

	if(id != match_id)
		return
	operable = op

	update()
	var/obj/machinery/conveyor/C = locate() in get_step(src, stepdir)
	if(C)
		C.set_operable(stepdir, id, op)

/*
/obj/machinery/conveyor/verb/destroy()
	set src in view()
	src.broken()
*/

/obj/machinery/conveyor/power_change()
	..()
	update()

// the conveyor control switch
//
//

var/list/conveyor_switches = list()

/obj/machinery/conveyor_switch

	name = "conveyor switch"
	desc = "A conveyor control switch."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "switch-off"
	var/position = 0			// 0 off, -1 reverse, 1 forward
	var/last_pos = -1			// last direction setting
	var/operated = 1			// true if just operated

	var/id = "" 				// must match conveyor IDs to control them

	var/list/conveyors		// the list of converyors that are controlled by this switch
	anchored = 1

/obj/machinery/conveyor_switch/New()
	..()
	update()

	conveyor_switches += src

	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/conveyor_switch(null)
	component_parts += new /obj/item/stack/cable_coil(null, 1)

	spawn(5)		// allow map load
		UpdateConveyors()

// update the icon depending on the position

/obj/machinery/conveyor_switch/proc/update()
	if(position<0)
		icon_state = "switch-rev"
	else if(position>0)
		icon_state = "switch-fwd"
	else
		icon_state = "switch-off"

/obj/machinery/conveyor_switch/proc/UpdateConveyors()
	conveyors = list()
	for(var/obj/machinery/conveyor/C in conveyor_belts)
		if(C.id == id)
			conveyors += C

/obj/machinery/conveyor_switch/examine()
	..()
	usr << "<span class='notice'>Its current ID is '[id ? id : "*NONE*"]'."

// timed process
// if the switch changed, update the linked conveyors

/obj/machinery/conveyor_switch/process()
	if(!operated)
		return
	operated = 0

	for(var/obj/machinery/conveyor/C in conveyors)
		C.operating = position
		C.setmove()

// attack with hand, switch position
/obj/machinery/conveyor_switch/attack_hand(mob/user)
	if(position == 0)
		if(last_pos < 0)
			position = 1
			last_pos = 0
		else
			position = -1
			last_pos = 0
	else
		last_pos = position
		position = 0

	operated = 1
	update()

	// find any switches with same id as this one, and set their positions to match us
	for(var/obj/machinery/conveyor_switch/S in conveyor_switches)
		if(S.id == src.id)
			S.position = position
			S.update()

/obj/machinery/conveyor_switch/attackby(var/obj/item/I, var/mob/living/user)
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, I))
		return 0

	if(istype(I, /obj/item/weapon/crowbar))
		default_deconstruction_crowbar(I)
		return 0

	if(istype(I, /obj/item/device/multitool))
		var/newid = input(user, "Please enter a new ID.", "Input") as text
		newid = trim(newid)
		newid = strip_html(newid)
		newid = sanitize(newid)
		id = newid
		user << "<span class='notice'>You set \the [src]'s ID to '[id]'."
		UpdateConveyors()
		return 0

	return attack_hand(user)

/obj/machinery/conveyor_switch/oneway
	var/convdir = 1 //Set to 1 or -1 depending on which way you want the convayor to go. (In other words keep at 1 and set the proper dir on the belts.)
	desc = "A conveyor control switch. It appears to only go in one direction."

// attack with hand, switch position
/obj/machinery/conveyor_switch/oneway/attack_hand(mob/user)
	if(position == 0)
		position = convdir
	else
		position = 0

	operated = 1
	update()

	// find any switches with same id as this one, and set their positions to match us
	for(var/obj/machinery/conveyor_switch/S in conveyor_switches)
		if(S.id == src.id)
			S.position = position
			S.update()
