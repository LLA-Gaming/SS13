/datum/round_event_control/blob
	name = "Blob"
	typepath = /datum/round_event/blob
	max_occurrences = 1
	phases_required = 5 //25 to 75 minutes
	rating = list(
				"Gameplay"	= 100,
				"Dangerous"	= 100
				)

/datum/round_event/blob
	announceWhen	= 12
	endWhen			= 120

	var/obj/effect/blob/core/Blob


/datum/round_event/blob/announce()
	priority_announce("Confirmed outbreak of level 5 biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", 'sound/AI/outbreak5.ogg')


/datum/round_event/blob/start()
	var/turf/T = pick(blobstart)
	if(!T)
		return kill()
	Blob = new /obj/effect/blob/core(T, 200)
	for(var/i = 1; i < rand(3, 6), i++)
		Blob.process()


/datum/round_event/blob/tick()
	if(!Blob)
		kill()
		return
	if(IsMultiple(activeFor, 3))
		Blob.process()

/datum/round_event/blob/declare_completion()
	var/core_count = 0
	for(var/obj/effect/blob/core/C in world)
		if(C.loc)
			core_count++
	if(core_count)
		return "<b>Blob:</b> <font color='red'>The blob was not destroyed</font>"
	else
		return "<b>Alien Infestation:</b> <font color='green'>The blob's core was destroyed</font>"