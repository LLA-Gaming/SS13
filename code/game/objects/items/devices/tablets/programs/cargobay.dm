/datum/program/cargobay
	name = "Cargo Bay Monitor"
	app_id = "cargocontrol"

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