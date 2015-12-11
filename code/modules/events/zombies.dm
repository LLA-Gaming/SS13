/datum/round_event_control/zombies
	name = "Zombie Outbreak"
	typepath = /datum/round_event/zombies
	max_occurrences = 1
	weight = 5

/datum/round_event/zombies
	var/SpawnNum = 15
	announceWhen	= 15

/datum/round_event/zombies/announce()
	priority_announce("Confirmed outbreak of level 7 viral biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", 'sound/AI/outbreak7.ogg')

/datum/round_event/zombies/start()
	var/list/spawns = list()
	SpawnNum = rand(1,5)

	for(var/obj/effect/landmark/holiday/O in world)
		spawns += O
	if(!spawns.len)
		message_admins("Error: No spawns points exist. Aborting zombie spawn.",1)
		return

	for(var/i=0,i<SpawnNum,i++) // Loops to determine zombie numver

		var/mob/living/carbon/human/npc/zombie/Z
		var/obj/effect/landmark/s
		s = pick(spawns)

		Z = new/mob/living/carbon/human/npc/zombie(s.loc)
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