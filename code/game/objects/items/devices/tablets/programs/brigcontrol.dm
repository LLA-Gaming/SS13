/datum/program/brigcontrol
	name = "Brig Control"
	app_id = "brigcontrol"

	use_app()
		if(tablet.network())
			dat = "<h4>Brig Control</h4>"
			var/cellshutters = 1
			for(var/obj/machinery/door/poddoor/M in world)
				if(M.id == "Secure Gate")
					if(M.density)
						cellshutters = 1
					else
						cellshutters = 0
			dat += "Cell Shutters are: <i>[cellshutters ? "Closed" : "Opened"]</i>"
			dat += "<br>"
			var/briglockdown = 1
			for(var/obj/machinery/door/poddoor/M in world)
				if(M.id == "briggate")
					if(M.density)
						briglockdown = 1
					else
						briglockdown = 0
			dat += "Brig Lockdown is: <i>[briglockdown ? "Active" : "Inactive"]</i>"
			dat += "<br>"
			var/permalockdown = 1
			for(var/obj/machinery/door/poddoor/M in world)
				if(M.id == "Prison Gate")
					if(M.density)
						permalockdown = 1
					else
						permalockdown = 0
			dat += "Permabrig Lockdown is: <i>[permalockdown ? "Active" : "Inactive"]</i>"
			dat += "<br>"
			var/laborlock = 1
			for(var/obj/machinery/door/poddoor/M in world)
				if(M.id == "Labor")
					if(M.density)
						laborlock = 1
					else
						laborlock = 0
			dat += "Labor Lockdown is: <i>[laborlock ? "Active" : "Inactive"]</i>"
			dat += "<br>"
			var/datum/shuttle_manager/s = shuttles["laborcamp"]
			if(s.location == /area/shuttle/laborcamp/outpost)
				dat += "Labor Shuttle Location: Labor Camp<BR>"
			else
				dat += "Labor Shuttle Location:  Station<BR>"
			dat += "<h4>Cell Details</h4>"
			for(var/obj/machinery/brig_timer/cell in world)
				if(cell.timing)
					dat += "<div class='statusDisplay'>"
					dat += {"[cell.name]<br>"}
					var/second = round(cell.timeleft() % 60)
					var/minute = round((cell.timeleft() - second) / 60)
					dat += {"Time Left: [minute]:[second]<br>"}
					dat += {"Crime: [cell.detail]<br>"}
					dat += {"Prisoner: [cell.prisoner]<br>"}
					dat += "</div>"
		else
			dat = "ERROR: No connection to the server"

