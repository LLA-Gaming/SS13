/datum/program/GPS
	name = "Global Positioning System"
	app_id = "gps"
	price = 10

	use_app()

		dat = "<h4>Global Positioning System</h4>"

		var/turf/cl = get_turf(tablet)
		if (cl)
			dat += "Current Orbital Location: <b>\[[cl.x],[cl.y]\]</b>"
		else
			dat += "ERROR: Unable to determine current location."