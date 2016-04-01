/datum/program/cargobay
	name = "Cargo Bay Monitor"
	app_id = "cargocontrol"
	usesalerts = 1

	use_app()
		dat = "<h4>Cargo Bay Monitor</h4>"
		dat += {"Supply Points: [supply_shuttle.points]<BR>"}
		dat += "<BR><B>Supply shuttle</B><BR>"
		dat += "Location: [supply_shuttle.moving ? "Moving to station ([supply_shuttle.eta] Mins.)":supply_shuttle.at_station ? "Station":"Dock"]<BR>"
		dat += "Current approved orders: <BR><ol>"
		for(var/S in supply_shuttle.shoppinglist)
			var/datum/supply_order/SO = S
			dat += "<li>#[SO.ordernum] - [SO.object.name] approved by [SO.orderedby] [SO.comment ? "([SO.comment])":""]</li>"
		dat += "</ol>"

		dat += "Current requests: <BR><ol>"
		for(var/S in supply_shuttle.requestlist)
			var/datum/supply_order/SO = S
			dat += "<li>#[SO.ordernum] - [SO.object.name] requested by [SO.orderedby]</li>"
		dat += "</ol>"
		if(supply_shuttle.tasks.len)
			var/export_grade = "D"
			switch(supply_shuttle.task_cycler.task_level)
				if(1)
					export_grade = "D"
				if(2)
					export_grade = "C"
				if(3)
					export_grade = "B"
				else
					export_grade = "A"
			dat += "<hr>Export Grade: [export_grade]<br>"
			dat += "Current Tasks: <BR>"
			for(var/datum/round_event/task/T in supply_shuttle.tasks)
				dat += "<div class='statusDisplay'>"
				dat += "<b><u>[T.task_name]</b></u><br>"
				dat += "[T.task_desc]"
				if(T.requires_delivery)
					dat += "<br><br>NOTE: To ensure proper delivery, please ensure all exports are packaged properly in a crate"
				dat += "</div>"