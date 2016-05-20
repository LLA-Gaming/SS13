/datum/round_event_control/electrical_storm
	name = "Electrical Storm"
	typepath = /datum/round_event/electrical_storm
	event_flags = EVENT_MAJOR
	max_occurrences = 1
	weight = 10
	accuracy = 80

/datum/round_event/electrical_storm
	var/lightsoutAmount	= 1
	var/lightsoutRange	= 25

	Alert()
		send_alerts("An electrical storm has been detected in your area, please repair potential electronic overloads.")


	Start()
		var/list/epicentreList = list()

		for(var/i=1, i <= lightsoutAmount, i++)
			var/list/possibleEpicentres = list()
			for(var/obj/effect/landmark/newEpicentre in landmarks_list)
				if(newEpicentre.name == "lightsout" && !(newEpicentre in epicentreList))
					possibleEpicentres += newEpicentre
			if(possibleEpicentres.len)
				epicentreList += pick(possibleEpicentres)
			else
				break

		if(!epicentreList.len)
			return

		for(var/obj/effect/landmark/epicentre in epicentreList)
			for(var/obj/machinery/power/apc/apc in range(epicentre,lightsoutRange))
				apc.overload_lighting()