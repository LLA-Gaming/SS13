/obj/item/device/thinktronic_parts/program/general/GPS
	name = "Global Positioning System"


	use_app() //Put all the HTML here

		dat = "<h4>Global Positioning System</h4>"

		var/turf/cl = get_turf(src)
		if (cl)
			dat += "Current Orbital Location: <b>\[[cl.x],[cl.y]\]</b>"
		else
			dat += "ERROR: Unable to determine current location."