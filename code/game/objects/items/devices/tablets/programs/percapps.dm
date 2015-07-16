/datum/program/percblastdoors
	name = "Blast Door Status"
	app_id = "perc_blastdoors"
	drm = 1
	use_app()

		var/blastdoors = 1
		for(var/obj/machinery/door/poddoor/M in world)
			if(M.id == "prisonship")
				if(M.density)
					blastdoors = 1
				else
					blastdoors = 0
		dat = "<i>Blast doors are: [blastdoors ? "Closed" : "Opened"]</i>"

/datum/program/percimplants
	name = "Implant Status"
	app_id = "perc_implants"
	drm = 1
	use_app()

		var/penum = 1
		var/pcnum = 1
		dat = "<h3><font color=\"#232D45\"> Perseus Implant Tracker </font></h3><br>"
		for(var/obj/item/weapon/implant/enforcer/PE in world)
			var/turf/T = get_turf(PE)
			var/mob/M = PE.imp_in
			dat += "Implant <b>[penum]</b>: <br>"
			dat += "Area: <b>[get_area(T)]</b><br>"
			dat += "Coordinates: <b>(X: [T.x] Y: [T.y] Z: [T.z])</b><br>"
			dat += "Holder: <b>[ismob(M) ? M.name : "Error."]</b><br>"
			dat += "********************************<br>"
			penum++
		dat += "<b><i> Total Enforcer Implants: [penum - 1]</b><br>"
		dat += "<hr><br>"
		for(var/obj/item/weapon/implant/commander/PC in world)
			var/turf/T = get_turf(PC)
			var/mob/M = PC.imp_in
			dat += "Implant <b>[pcnum]</b>: <br>"
			dat += "Area: <b>[get_area(T)]</b><br>"
			dat += "Coordinates: <b>(X: [T.x] Y: [T.y] Z: [T.z])</b><br>"
			dat += "Holder: <b>[ismob(M) ? M.name : "Error."]</b><br>"
			dat += "********************************<br>"
			pcnum++
		dat += "<b><i> Total Commander Implants: [pcnum - 1]<br>"

/datum/program/percmissions
	name = "Missions"
	app_id = "perc_missions"
	drm = 1
	use_app()

		dat = "<br>"
		var/index = 1
		for(var/datum/perseus_mission/P in perseusMissions)
			dat += "<b>Mission #[index]</b>: [P.mission]<br>"
			dat += "<b>Creator:</b> [P.creatorName && !P.adminCreated ? P.creatorName : ""] [P.adminCreated ? "<b>(Centcom Official)</b>" : ""]<br>"
			dat += "<b>Status:</b>: "
			dat += "<a href='byond://?src=\ref[src];choice=perseus_mission;what=change_setting;mission=\ref[P]'>[P.status]</a><br>"
			dat += "<center>------------------------------</center><br>"
			index++
		if(!perseusMissions.len)
			dat = "<b>No Missions Found.</b>"

	Topic(href, href_list)
		if (!..()) return
		switch(href_list["choice"])//Now we switch based on choice.
			if("perseus_mission")
				if(href_list["what"] == "change_setting")
					var/toWhat = input("What do you want to change it to?", "Input") as anything in list("Pending", "Accepted", "Denied", "Successful", "Failed")
					var/datum/perseus_mission/P = locate(href_list["mission"])
					if(!P)	return
					P.status = toWhat
		use_app()
		tablet.attack_self(usr)



/datum/program/percshuttlelock
	name = "Shuttle Lock (Locked)"
	app_id = "perc_shuttlelock"
	drm = 1
	use_app()
		for(var/obj/machinery/computer/perseus_shuttle_computer/P in world)
			if(!P.perseus_type)
				P.locked = !P.locked
				if(P.locked)
					name = "Shuttle Lock (Locked)"
				else
					name = "Shuttle Lock (Unlocked)"