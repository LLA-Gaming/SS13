/datum/program/honk
	name = "Honk Synthesizer"
	app_id = "honk"
	price = 20
	var/last_honk = null

	use_app()
		if ( !(last_honk && world.time < last_honk + 20) )
			playsound(tablet.loc, 'sound/items/bikehorn.ogg', 50, 1)
			last_honk = world.time