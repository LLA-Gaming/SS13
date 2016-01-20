/datum/program/atmosscan
	name = "Atmospherics Scan"
	app_id = "atmosphericsscan"
	utility = 1
	drm = 1

	use_app()
		dat = "<h4>Atmospheric Readings</h4>"

		var/turf/T = get_turf(tablet.loc)
		if (isnull(T))
			dat += "Unable to obtain a reading.<br>"
		else
			var/datum/gas_mixture/environment = T.return_air()

			var/pressure = environment.return_pressure()
			var/total_moles = environment.total_moles()

			dat += "Air Pressure: [round(pressure,0.1)] kPa<br>"

			if (total_moles)
				var/o2_level = environment.gasses[OXYGEN]/total_moles
				var/n2_level = environment.gasses[NITROGEN]/total_moles
				var/co2_level = environment.gasses[CARBONDIOXIDE]/total_moles
				var/plasma_level = environment.gasses[PLASMA]/total_moles
				var/unknown_level =  1-(o2_level+n2_level+co2_level+plasma_level)
				dat += "Nitrogen: [round(n2_level*100)]%<br>"
				dat += "Oxygen: [round(o2_level*100)]%<br>"
				dat += "Carbon Dioxide: [round(co2_level*100)]%<br>"
				dat += "Plasma: [round(plasma_level*100)]%<br>"
				if(unknown_level > 0.01)
					dat += "OTHER: [round(unknown_level)]%<br>"
			dat += "Temperature: [round(environment.temperature-T0C)]&deg;C<br>"