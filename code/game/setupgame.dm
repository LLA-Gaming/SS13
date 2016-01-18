/proc/setup_game()

	makepowernets()

	if(!job_master)
		job_master = new /datum/controller/occupations()
		job_master.SetupOccupations()
		job_master.LoadJobs("config/jobs.txt")
		world << "\red \b Job setup complete"

	data_core = new /obj/effect/datacore()
	radio_controller = new /datum/controller/radio()
	paiController = new /datum/paiController()

	setup_objects()
	setupgenetics()
	setup_engineering()
	setup_mining()

	getHoliday()

	if(!mining_config)
		mining_config = new()

	if(!template_config)
		template_config = new()

	if(!template_controller)
		template_controller = new()

	if(!syndicate_code_phrase)		syndicate_code_phrase	= generate_code_phrase()
	if(!syndicate_code_response)	syndicate_code_response	= generate_code_phrase()

//setup game procs

/proc/setup_engineering()
	var/area/mainengine = locate(/area/engine/engineering)
	if(!config.random_engine)  //Enable this setup using the config option "randomize_engine_template"
		for(var/B in typesof(/area/engine/alternate))
			var/template = locate(B)
			for(var/C in template)
				qdel(C) // Cleaning up to reduce residual lag

	else
		world << "\red \b Randomizing world..."

		sleep(-1)
		var/area/engine/alternate/A
		var/list/alternates = (typesof(/area/engine/alternate) - /area/engine/alternate)
		if(alternates.len)
			A = locate(pick(alternates)) // Choose one of the alternates.
		else
			world << "\red \b No Alternates found, reverting to lame mode..."
			return

		for(var/E in mainengine)
			qdel(E) // Delete the default before we copy things over. Don't want to accidentally have any duplicate things now do we?

		A.move_contents_to(mainengine) // Move everything from the template

		for(var/turf/simulated/wall/wall in world)
			wall.relativewall() // Reconnect all walls moved

		for(var/obj/machinery/atmospherics/pipe/P in world)
			P.initialize()
			P.build_network() // Force re-connect all atmos pipes.
			for(var/I; I <= P.nodecount; I++)
				var/obj/machinery/atmospherics/pipe/M = P.node[I]
				M.initialize()
				M.build_network()


		for(var/B in typesof(/area/engine/alternate))
			var/template = locate(B)
			for(var/C in template)
				qdel(C) // Cleaning up to reduce residual lag

	//Prune any space turfs in the resulting engine
	var/list/spacetiles = list()
	var/area/AR = locate(/area/space)
	for(var/turf/space/S in mainengine)
		spacetiles +=S
	AR.contents.Add(spacetiles)

	//Move all SMES's in the engine into their special area
	var/list/batteries = list()
	AR = locate(/area/engine/engine_smes)
	for (var/obj/machinery/power/smes/M in mainengine)
		batteries += M.loc
	AR.contents.Add(batteries)

	//Move the pod tiles into their special area
	//This HAS to be the same size as the centcomm location. No whining.
	var/list/pods = list()
	AR = locate(/area/shuttle/escape_pod4/station)
	for (var/turf/simulated/shuttle/H in mainengine)
		pods += H
	AR.contents.Add(pods)

	makepowernets() // Reconnect the cables now that they've moved

	sleep(-1)

/proc/setup_objects()
	world << "\red \b Initializing objects..."
	sleep(-1)
	for(var/atom/movable/object in world)
		object.initialize()

	world << "\red \b Initializing pipe networks..."
	sleep(-1)
	for(var/obj/machinery/atmospherics/machine in world)
		machine.build_network()

	world << "\red \b Initializing atmos machinery..."
	sleep(-1)
	for(var/obj/machinery/atmospherics/unary/U in world)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()

	world << "\red \b Making a mess..."
	sleep(-1)
	for(var/turf/simulated/floor/F in world)
		F.MakeDirty()

	world << "\red \b Initializations complete."
	sleep(-1)

/proc/setup_mining()
	for(var/i=0, i<max_secret_rooms, i++)
		if(!possiblethemes.len)
			break
		make_mining_asteroid_secret()


/proc/setupgenetics()
//	if (prob(50))
//		BLOCKADD = rand(-300,300)
//	if (prob(75))
//		DIFFMUT = rand(0,20)

	var/list/avnums = new /list(DNA_STRUC_ENZYMES_BLOCKS)
	for(var/i=1, i<=DNA_STRUC_ENZYMES_BLOCKS, i++)
		avnums[i] = i

	HULKBLOCK = pick_n_take(avnums)
	TELEBLOCK = pick_n_take(avnums)

	FIREBLOCK = pick_n_take(avnums)
	XRAYBLOCK = pick_n_take(avnums)

	CLUMSYBLOCK = pick_n_take(avnums)
	STRANGEBLOCK = pick_n_take(avnums)
	DEAFBLOCK = pick_n_take(avnums)
	BLINDBLOCK = pick_n_take(avnums)
	NEARSIGHTEDBLOCK = pick_n_take(avnums)
	EPILEPSYBLOCK = pick_n_take(avnums)
	COUGHBLOCK = pick_n_take(avnums)
	TOURETTESBLOCK = pick_n_take(avnums)
	NERVOUSBLOCK = pick_n_take(avnums)
	RACEBLOCK = pick_n_take(avnums)

	bad_se_blocks = list(NEARSIGHTEDBLOCK,EPILEPSYBLOCK,STRANGEBLOCK,COUGHBLOCK,CLUMSYBLOCK,TOURETTESBLOCK,NERVOUSBLOCK,DEAFBLOCK,BLINDBLOCK)
	good_se_blocks = list(FIREBLOCK,XRAYBLOCK)
	op_se_blocks = list(HULKBLOCK,TELEBLOCK)

	NULLED_SE = repeat_string(DNA_STRUC_ENZYMES_BLOCKS, repeat_string(DNA_BLOCK_SIZE, "_"))
	NULLED_UI = repeat_string(DNA_UNI_IDENTITY_BLOCKS, repeat_string(DNA_BLOCK_SIZE, "_"))
	// HIDDEN MUTATIONS / SUPERPOWERS INITIALIZTION

/*
	for(var/x in typesof(/datum/mutations) - /datum/mutations)
		var/datum/mutations/mut = new x

		for(var/i = 1, i <= mut.required, i++)
			var/datum/mutationreq/require = new/datum/mutationreq
			require.block = rand(1, 13)
			require.subblock = rand(1, 3)

			// Create random requirement identification
			require.reqID = pick("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", \
							 "B", "C", "D", "E", "F")

			mut.requirements += require


		global_mutations += mut// add to global mutations list!
*/