//Config stuff
#define SPECOPS_MOVETIME 240
#define SPECOPS_SHUTTLE_COOLDOWN 200

var/specops_shuttle_moving_to_station = 0
var/specops_shuttle_moving_to_centcom = 0
var/specops_shuttle_at_station = 0
var/specops_shuttle_can_send = 1
var/specops_shuttle_time = 0
var/specops_shuttle_timeleft = 0

/obj/machinery/computer/specops_station
	name = "specops shuttle terminal"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer_generic"
	req_access = list(access_cent_specops)
	var/area/curr_location
	var/moving = 0
	var/lastMove = 0
	var/temp = null


/obj/machinery/computer/specops_station/New()
	curr_location= locate(/area/shuttle/specops/centcom)


/obj/machinery/computer/specops_station/proc/specops_move_to(area/destination as area)
	if(moving)	return
	if(lastMove + SPECOPS_SHUTTLE_COOLDOWN > world.time)	return
	var/area/dest_location = locate(destination)
	if(curr_location == dest_location)	return

	moving = 1
	lastMove = world.time

	curr_location.move_contents_to(dest_location)
	curr_location = dest_location
	moving = 0
	return 1

/obj/machinery/computer/specops_station/attack_hand(mob/user as mob)
	if(!allowed(user))
		user << "\red Access Denied"
		return

	user.set_machine(src)

	var/dat = {"Location: [curr_location]<br>
	Ready to move[max(lastMove + SPECOPS_SHUTTLE_COOLDOWN - world.time, 0) ? " in [max(round((lastMove + SPECOPS_SHUTTLE_COOLDOWN - world.time) * 0.1), 0)] seconds" : ": now"]<br>
	<hr>
	<a href='?src=\ref[src];station=1'>Deploy to station (This will be instant, make sure you guys are all on the shuttle)</a><br>
	<a href='?src=\ref[user];mach_close=computer'>Close</a>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return


/obj/machinery/computer/specops_station/Topic(href, href_list)
	if(..())
		return

	var/mob/living/user = usr

	user.set_machine(src)

	if(href_list["station"])
		specops_move_to(/area/shuttle/specops/station)
	updateUsrDialog()
	return
