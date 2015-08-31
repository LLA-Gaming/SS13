/datum/round_event_control/electrical_storm
	name = "Electrical Storm"
	typepath = /datum/round_event/electrical_storm
	phases_required = 0
	max_occurrences = 3
	rating = list(
				"Gameplay"	= 20,
				"Dangerous"	= 10
				)
/datum/round_event/electrical_storm
	var/lightsoutAmount	= 1
	var/lightsoutRange	= 25
	var/mode = "Lights out"

/datum/round_event/electrical_storm/setup()
	mode = pick("Lights out","Airlocks")

/datum/round_event/electrical_storm/announce()
	switch(mode)
		if("Lights out")
			priority_announce("An electrical storm has been detected in your area, please repair potential electronic overloads.", "Electrical Storm Alert")
		if("Airlocks")
			priority_announce("Abnormal activity in the station's airlock system, please repair potential airlock malfunctions", "Electrical Storm Alert")


/datum/round_event/electrical_storm/start()
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

	switch(mode)
		if("Lights out")
			for(var/obj/effect/landmark/epicentre in epicentreList)
				for(var/obj/machinery/power/apc/apc in range(epicentre,lightsoutRange))
					apc.overload_lighting()
		if("Airlocks")
			for(var/obj/effect/landmark/epicentre in epicentreList)
				for(var/obj/machinery/door/airlock/A in range(epicentre,lightsoutRange))
					if(prob(30))
						continue
					if(istype(A,/obj/machinery/door/airlock/external))
						continue
					else
						spawn(0)
							A.prison_open()
