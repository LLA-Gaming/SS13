/datum/program/theoriontrail
	name = "The Orion Trail"
	app_id = "oriontrail"
	price = 10
	var/engine = 0
	var/hull = 0
	var/electronics = 0
	var/food = 80
	var/fuel = 60
	var/turns = 4
	var/playing = 0
	var/gameover = 0
	var/alive = 4
	var/eventdat = null
	var/event = null
	var/list/settlers = list("Harry","Larry","Bob")
	var/list/events = list("Raiders"				= 3,
						   "Interstellar Flux"		= 1,
						   "Illness"				= 3,
						   "Breakdown"				= 2,
						   "Malfunction"			= 2,
						   "Collision"              = 1
						   )
	var/list/stops = list()
	var/list/stopblurbs = list()

/datum/program/theoriontrail/New()
	// Sets up the main trail
	stops = list("Pluto","Asteroid Belt","Proxima Centauri","Dead Space","Rigel Prime","Tau Ceti Beta","Black Hole","Space Outpost Beta-9","Orion Prime")
	stopblurbs = list(
		"Pluto, long since occupied with long-range sensors and scanners, stands ready to, and indeed continues to probe the far reaches of the galaxy.",
		"At the edge of the Sol system lies a treacherous asteroid belt. Many have been crushed by stray asteroids and misguided judgement.",
		"The nearest star system to Sol, in ages past it stood as a reminder of the boundaries of sub-light travel, now a low-population sanctuary for adventurers and traders.",
		"This region of space is particularly devoid of matter. Such low-density pockets are known to exist, but the vastness of it is astounding.",
		"Rigel Prime, the center of the Rigel system, burns hot, basking its planetary bodies in warmth and radiation.",
		"Tau Ceti Beta has recently become a waypoint for colonists headed towards Orion. There are many ships and makeshift stations in the vicinity.",
		"Sensors indicate that a black hole's gravitational field is affecting the region of space we were headed through. We could stay of course, but risk of being overcome by its gravity, or we could change course to go around, which will take longer.",
		"You have come into range of the first man-made structure in this region of space. It has been constructed not by travellers from Sol, but by colonists from Orion. It stands as a monument to the colonists' success.",
		"You have made it to Orion! Congratulations! Your crew is one of the few to start a new foothold for mankind!"
		)

/datum/program/theoriontrail/use_app()
	if(fuel <= 0 || food <=0 || settlers.len == 0)
		gameover = 1
		event = null
	if(gameover)
		dat = "<center><h1>Game Over</h1></center>"
		dat += "Like many before you, your crew never made it to Orion, lost to space... <br><b>Forever</b>."
		if(settlers.len == 0)
			dat += "<br>Your entire crew died, your ship joins the fleet of ghost-ships littering the galaxy."
		else
			if(food <= 0)
				dat += "<br>You ran out of food and starved."
			if(fuel <= 0)
				dat += "<br>You ran out of fuel, and drift, slowly, into a star."
		dat += "<br><P ALIGN=Right><a href='byond://?src=\ref[src];menu=1'>OK...</a></P>"
	else if(event)
		dat = eventdat
	else if(playing)
		var/title = stops[turns]
		var/subtext = stopblurbs[turns]
		dat = "<center><h1>[title]</h1></center>"
		dat += "[subtext]"
		dat += "<h3><b>Crew:</b></h3>"
		dat += english_list(settlers)
		dat += "<br><b>Food: </b>[food] | <b>Fuel: </b>[fuel]"
		dat += "<br><b>Engine Parts: </b>[engine] | <b>Hull Panels: </b>[hull] | <b>Electronics: </b>[electronics]<br>"
		if(turns == 7)
			dat += "<P ALIGN=Right><a href='byond://?src=\ref[src];pastblack=1'>Go Around</a> <a href='byond://?src=\ref[src];blackhole=1'>Continue</a></P>"
		else
			dat += "<P ALIGN=Right><a href='byond://?src=\ref[src];continue=1'>Continue</a></P>"
	else
		dat = "<center><h2>The Orion Trail</h2></center>"
		dat += "<br><center><h3>Experience the journey of your ancestors!</h3></center><br><br>"
		dat += "<center><b><a href='byond://?src=\ref[src];newgame=1'>New Game</a></b></center>"

/////////////////////////////////
//	Topic                      //
/////////////////////////////////
/datum/program/theoriontrail/Topic(href, href_list)
	if (!..()) return
	if (href_list["continue"]) //Continue your travels
		if(turns >= 9)
			win()
		else if(turns == 2)
			if(prob(30))
				event = "Collision"
				event()
				food -= alive*2
				fuel -= 5
				turns += 1
			else
				food -= alive*2
				fuel -= 5
				turns += 1
				if(prob(75))
					event = pickweight(events)
					event()
		else
			food -= alive*2
			fuel -= 5
			turns += 1
			if(prob(75))
				event = pickweight(events)
				event()
	else if(href_list["newgame"]) //Reset everything
		newgame()
	else if(href_list["menu"]) //back to the main menu
		playing = 0
		event = null
		gameover = 0
		food = 80
		fuel = 60
		settlers = list("Harry","Larry","Bob")
	else if(href_list["slow"]) //slow down
		food -= alive*2
		fuel -= 5
		event = null
	else if(href_list["pastblack"]) //slow down
		food -= (alive*2)*3
		fuel -= 15
		turns += 1
		event = null
	else if(href_list["useengine"]) //use parts
		engine -= 1
		event = null
	else if(href_list["useelec"]) //use parts
		electronics -= 1
		event = null
	else if(href_list["usehull"]) //use parts
		hull -= 1
		event = null
	else if(href_list["wait"]) //wait 3 days
		food -= (alive*2)*3
		event = null
	else if(href_list["keepspeed"]) //keep speed
		if(prob(75))
			event = "Breakdown"
			event()
		else
			event = null
	else if(href_list["blackhole"]) //keep speed past a black hole
		if(prob(75))
			event = "BlackHole"
			event()
		else
			event = null
			turns += 1
	else if(href_list["holedeath"])
		gameover = 1
		event = null
	else if(href_list["eventclose"]) //end an event
		event = null
	use_app()
	tablet.attack_self(usr)

/////////////////////////////////
//	Procs go below if needed   //
/////////////////////////////////
/datum/program/theoriontrail/proc/newgame()
	// Set names of settlers in crew
	settlers = list()
	var/choice = null
	for(var/i = 1; i <= 3; i++)
		if(prob(50))
			choice = pick(first_names_male)
		else
			choice = pick(first_names_female)
		settlers += choice
	settlers += "[usr]"
	// Re-set items to defaults
	engine = 1
	hull = 1
	electronics = 1
	food = 80
	fuel = 60
	alive = 4
	turns = 1
	event = null
	playing = 1
	gameover = 0

/datum/program/theoriontrail/proc/event()
	eventdat = "<center><h1>[event]</h1></center>"
	if(event == "Raiders")
		eventdat += "Raiders have come aboard your ship!"
		if(prob(50))
			var/sfood = rand(1,10)
			var/sfuel = rand(1,10)
			food -= sfood
			fuel -= sfuel
			eventdat += "<br>They have stolen [sfood] <b>Food</b> and [sfuel] <b>Fuel</b>."
		else if(prob(10))
			var/deadname = pick_n_take(settlers)
			eventdat += "<br>[deadname] tried to fight back but was killed."
			alive -= 1
		else
			eventdat += "<br>Fortunately you fended them off without any trouble."
		eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];eventclose=1'>Continue</a></P>"

	else if(event == "Interstellar Flux")
		eventdat += "This region of space is highly turbulent. <br>If we go slowly we may avoid more damage, but if we keep our speed we won't waste supplies."
		eventdat += "<br>What will you do?"
		eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];slow=1'>Slow Down</a> <a href='byond://?src=\ref[src];keepspeed=1'>Continue</a></P>"

	else if(event == "Illness")
		eventdat += "A deadly illness has been contracted!"
		var/deadname = pick_n_take(settlers)
		eventdat += "<br>[deadname] was killed by the disease."
		alive -= 1
		eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];eventclose=1'>Continue</a></P>"

	else if(event == "Breakdown")
		eventdat += "Oh no! The engine has broken down!"
		eventdat += "<br>You can repair it with an engine part, or you can make repairs for 3 days."
		if(engine >= 1)
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];useengine=1'>Use Part</a><a href='byond://?src=\ref[src];wait=1'>Wait</a></P>"
		else
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];wait=1'>Wait</a></P>"

	else if(event == "Malfunction")
		eventdat += "The ship's systems are malfunctioning!"
		eventdat += "<br>You can replace the broken electronics with spares, or you can spend 3 days troubleshooting the AI."
		if(electronics >= 1)
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];useelec=1'>Use Part</a><a href='byond://?src=\ref[src];wait=1'>Wait</a></P>"
		else
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];wait=1'>Wait</a></P>"

	else if(event == "Collision")
		eventdat += "Something hit us! Looks like there's some hull damage."
		if(prob(25))
			var/sfood = rand(5,15)
			var/sfuel = rand(5,15)
			food -= sfood
			fuel -= sfuel
			eventdat += "<br>[sfood] <b>Food</b> and [sfuel] <b>Fuel</b> was vented out into space."
		if(prob(10))
			var/deadname = pick_n_take(settlers)
			eventdat += "<br>[deadname] was killed by rapid depressurization."
			alive -= 1
		eventdat += "<br>You can repair the damage with hull plates, or you can spend the next 3 days welding scrap together."
		if(hull >= 1)
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];usehull=1'>Use Part</a><a href='byond://?src=\ref[src];wait=1'>Wait</a></P>"
		else
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];wait=1'>Wait</a></P>"

	else if(event == "BlackHole")
		eventdat += "You were swept away into the black hole."
		eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];holedeath=1'>Oh...</a></P>"

		settlers = list()


/datum/program/theoriontrail/proc/win()
	playing = 0
