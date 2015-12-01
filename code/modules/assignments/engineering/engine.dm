/datum/assignment/engine_setup
	name = "Singularity Engine"
	details = "Setup the Singularity Engine"
	dept = list("Engineering")
	heads = list("Chief Engineer")
	repeat = 1
	tier_needed = 0
	var/area/SMES_room = null
	var/area/PA_room = null
	var/obj/machinery/particle_accelerator/control_box/control_box
	var/list/SMESs = list()

	pre_setup()
		todo.Add("Assemble the Particle Accelerator")
		todo.Add("Fill the Radiation Collectors with Full Plasma Tanks")
		todo.Add("Configure the SMES battery arrays")
		todo.Add("Activate the four containment emitters")
		todo.Add("Activate the Singularity Containment Field")
		todo.Add("Lock the emitters and Radiation Collectors")
		todo.Add("Activate the Particle Accelerator to form the singularity")
		todo.Add("Reduce the Particle Accelerator to 0 power to maintain the singularity once sufficient size has been reached.")
		return 1

	setup()
		SMES_room = locate(/area/engine/engine_smes) in world
		if(SMES_room)
			for(var/obj/machinery/power/smes/SMES in SMES_room)
				SMESs.Add(SMES)
		for(var/obj/machinery/particle_accelerator/control_box/C in machines)
			if(C.z != 1)
				continue
			control_box = C
		if(SMESs.len && control_box)
			return 1
		return 0

	tick()
		..()
		if(IsMultiple(activeFor,10))
			check_complete()

	check_complete()
		var/i = 0
		if(!control_box)
			fail()
			return
		if(!SMESs.len)
			fail()
			return
		for(var/obj/machinery/power/smes/SMES in SMESs)
			if(SMES.input_available >= 400000) // this should be a good enough number, its twice as higher then the max output
				i++
			if(i >= SMESs.len && control_box.active && control_box.strength == 0)
				complete()
				return
			continue
		return

	complete()
		..()
		for(var/datum/assignment/engine_setup/E in assignments.available)
			tier_up()
			qdel(E)
			assignments.update_assignments()