/datum/round_event_control/zombies
	name = "Zombie Outbreak"
	typepath = /datum/round_event/zombies
	max_occurrences = 1
	rating = list(
				"Gameplay"	= 100,
				"Dangerous"	= 100
				)

/datum/round_event/zombies
	var/SpawnNum = 15
	announceWhen	= 15

/datum/round_event/zombies/announce()
	priority_announce("Confirmed outbreak of level 7 viral biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", 'sound/AI/outbreak7.ogg')

/datum/round_event/zombies/start()
	var/list/spawns = list()
	SpawnNum = rand(5,30)

	for(var/obj/effect/landmark/holiday/O in world)
		spawns += O
	if(!spawns.len)
		message_admins("Error: No spawns points exist. Aborting zombie spawn.",1)
		return

	for(var/i=0,i<SpawnNum,i++) // Loops to determine zombie numver

		var/mob/living/carbon/human/zombie/Z
		var/obj/effect/landmark/s
		s = pick(spawns)

		Z = new/mob/living/carbon/human/zombie(s.loc)
		var/datum/preferences/A = new()//Randomize appearance for the zombie.
		A.copy_to(Z)
		ready_dna(Z)

		Z.gender = pick(MALE, FEMALE)


		if(Z.gender == MALE)
			Z.real_name = text("[] []", pick(first_names_male), pick(last_names))
		else
			Z.real_name = text("[] []", pick(first_names_female), pick(last_names))
		ready_dna(Z)
		var/a = pick("Janitor", "Medical Doctor", "Assistant", "Atmospheric Technician", "Security Officer", "Botanist", "Cargo Technician")
		job_master.EquipRank(Z, a, 0)

/datum/round_event/zombies/declare_completion()
	var/zombie_count = 0
	for(var/mob/living/carbon/human/zombie/Z in world)
		if(Z.stat != DEAD)
			zombie_count++
	if(zombie_count)
		return "<b>Zombie Outbreak:</b> <font color='red'>The zombies now roam what is left of [station_name]</font>"
	else
		return "<b>Zombie Outbreak:</b> <font color='green'>The Z-virus was cleared from [station_name]</font>"