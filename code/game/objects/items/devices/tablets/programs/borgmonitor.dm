/datum/program/borgmonitor
	name = "Robotics Monitor"
	app_id = "roboticmonitor"

	use_app() //Put all the HTML here
		dat = ""
		if(tablet.network())
			var/robots = 0
			for(var/mob/living/silicon/robot/R in mob_list)
				if(!istype(R))
					continue
				if(istype(usr, /mob/living/silicon/ai))
					if (R.connected_ai != usr)
						continue
				if(istype(usr, /mob/living/silicon/robot))
					if (R != usr)
						continue
				if(R.scrambledcodes)
					continue
				robots++
				var/area/location = get_area(R)
				dat += "<div class='statusDisplay'>[R.name] <br>"
				dat += " Location: [location] <br>"
				if(R.stat)
					dat += " Not Responding <br>"
				else if (!R.canmove)
					dat += " Locked Down <br>"
				else
					dat += " Operating Normally <br>"
				if (!R.canmove)
				else if(R.cell)
					dat += " Battery Installed ([R.cell.charge]/[R.cell.maxcharge]) <br>"
				else
					dat += " No Cell Installed <br>"
				if(R.module)
					dat += " Module Installed ([R.module.name]) <br>"
				else
					dat += " No Module Installed <br>"
				if(R.connected_ai)
					dat += " Slaved to [R.connected_ai.name] <br>"
				else
					dat += " Independent from AI <br>"
				dat += "</div>"

			if(!robots)
				dat += "No Cyborg Units detected within access parameters."
		else
			dat = "ERROR: No connection to the server"
