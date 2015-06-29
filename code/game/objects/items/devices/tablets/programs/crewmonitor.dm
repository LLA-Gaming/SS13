/datum/program/crewmonitor
	name = "Medical Monitor"
	app_id = "crewmonitor"

	use_app()
		if(tablet.network())
			//Medbay Monitor
			dat = "<h3><center>Medbay Monitor</center></h3><BR><div class='statusDisplay'>"
			for(var/obj/machinery/clonepod/M in world)
				if(M.z == 1)
					if(M.occupant)
						dat += "Clone Pod is: In Use<br>"
					if(!M.occupant)
						dat += "Clone Pod is: Vacant<br>"
			for(var/obj/machinery/atmospherics/unary/cryo_cell/M in world)
				if(M.z == 1)
					if(M.occupant)
						if(istype(M.occupant, /mob/living/carbon))
							var/mob/living/carbon/H = M.occupant
							var/life_status = "[H.stat > 1 ? "<span class='bad'>Deceased</span>" : "<span class='good'>Living</span>"]"
							var/dam1 = round(H.getOxyLoss(),1)
							var/dam2 = round(H.getToxLoss(),1)
							var/dam3 = round(H.getFireLoss(),1)
							var/dam4 = round(H.getBruteLoss(),1)
							var/damage_report = "(<font color='blue'>[dam1]</font>/<font color='green'>[dam2]</font>/<font color='orange'>[dam3]</font>/<font color='red'>[dam4]</font>)"
							dat += "Cryo Cell is: In Use - [H.name] - [life_status] - [damage_report]<br>"
					if(!M.occupant)
						dat += "Cryo Cell is: Vacant<br>"
			for(var/obj/machinery/sleeper/M in world)
				if(M.z == 1)
					if(M.occupant)
						if(istype(M.occupant, /mob/living/carbon))
							var/mob/living/carbon/H = M.occupant
							var/life_status = "[H.stat > 1 ? "<span class='bad'>Deceased</span>" : "<span class='good'>Living</span>"]"
							var/dam1 = round(H.getOxyLoss(),1)
							var/dam2 = round(H.getToxLoss(),1)
							var/dam3 = round(H.getFireLoss(),1)
							var/dam4 = round(H.getBruteLoss(),1)
							var/damage_report = "(<font color='blue'>[dam1]</font>/<font color='green'>[dam2]</font>/<font color='orange'>[dam3]</font>/<font color='red'>[dam4]</font>)"
							dat += "Sleeper is: In Use - [H.name] - [life_status] - [damage_report]<br>"
					if(!M.occupant)
						dat += "Sleeper is: Vacant<br>"
			dat += "</div>"
			//Crew monitor lite
			dat += "<hr>"
			dat += "Locating all critical/deceased crew members on the crew monitoring console"
			dat += "<table width='100%'><tr><td width='40%'><h3>Name</h3></td><td width='30%'><h3>Vitals</h3></td><td width='30%'><h3>Position</h3></td></tr>"
			var/list/logs = list()
			var/list/tracked = crewscan()
			for(var/mob/living/carbon/human/H in tracked)
				var/log = ""
				var/turf/pos = get_turf(H)
				if(istype(H.w_uniform, /obj/item/clothing/under))
					var/obj/item/clothing/under/U = H.w_uniform
					if(pos && pos.z == 1 && U.sensor_mode && H.stat)
						var/obj/item/ID = null
						if(H.wear_id)
							ID = H.wear_id.GetID()


						var/life_status = "[H.stat > 1 ? "<span class='bad'>Deceased</span>" : "<span class='good'>Living</span>"]"

						if(ID)
							log += "<tr><td width='40%'>[ID.name]</td>"
						else
							log += "<tr><td width='40%'>Unknown</td>"

						var/damage_report
						if(U.sensor_mode > 1)
							var/dam1 = round(H.getOxyLoss(),1)
							var/dam2 = round(H.getToxLoss(),1)
							var/dam3 = round(H.getFireLoss(),1)
							var/dam4 = round(H.getBruteLoss(),1)
							damage_report = "(<font color='blue'>[dam1]</font>/<font color='green'>[dam2]</font>/<font color='orange'>[dam3]</font>/<font color='red'>[dam4]</font>)"

						switch(U.sensor_mode)
							if(1)
								log += "<td width='30%'>[life_status]</td><td width='30%'>Not Available</td></tr>"
							if(2)
								log += "<td width='30%'>[life_status] [damage_report]</td><td width='30%'>Not Available</td></tr>"
							if(3)
								var/area/player_area = get_area(H)
								log += "<td width='30%'>[life_status] [damage_report]</td><td width='30%'>[format_text(player_area.name)]</td></tr>"
				logs += log
			logs = sortList(logs)
			for(var/log in logs)
				dat += log
			dat += "</table>"
		else
			dat = "ERROR: Cannot connect to the network"