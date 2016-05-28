/datum/round_event_control/disease_outbreak
	name = "Disease Outbreak"
	typepath = /datum/round_event/disease_outbreak
	event_flags = EVENT_STANDARD
	max_occurrences = 1
	weight = 5

/datum/round_event/disease_outbreak
	alert_when	= 150
	end_when = -1
	var/list/possible_viruses = list(/datum/disease/dnaspread, /datum/disease/advance/flu, /datum/disease/advance/cold, /datum/disease/brainrot, /datum/disease/magnitis)
	var/virus_type
	var/zero = null
	var/case = null
	var/datum/disease/target

	SetTimers()
		alert_when = rand(150, 300)

	Alert()
		priority_announce("Confirmed outbreak of level 7 viral biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", 'sound/AI/outbreak7.ogg')

	Setup()
		//just a check to see if there is any valid candidates
		for(var/mob/living/carbon/human/H in living_mob_list)
			return
		//and if there isn't...
		CancelSelf()

	Start()
		if(!virus_type)
			virus_type = pick(possible_viruses)

		for(var/mob/living/carbon/human/H in shuffle(living_mob_list))
			var/turf/T = get_turf(H)
			if(!T)
				continue
			if(T.z != 1)
				continue
			if(!(H.dna))
				continue
			var/foundAlready = 0	// don't infect someone that already has the virus
			for(var/datum/disease/D in H.viruses)
				if(istype(D, virus_type))
					foundAlready = 1
					break
			if(H.stat == DEAD || foundAlready)
				continue

			var/datum/disease/D
			if(virus_type == /datum/disease/dnaspread)		//Dnaspread needs strain_data set to work.
				if(!H.dna || (H.sdisabilities & BLIND))	//A blindness disease would be the worst.
					continue
				D = new virus_type()
				var/datum/disease/dnaspread/DS = D
				DS.strain_data["name"] = H.real_name
				DS.strain_data["UI"] = H.dna.uni_identity
				DS.strain_data["SE"] = H.dna.struc_enzymes
			else
				D = new virus_type()
			D.carrier = 1
			D.holder = H
			D.affected_mob = H
			H.viruses += D
			zero = H.real_name
			case = D
			target = D
			if (!prevent_stories)
				if(zero && case)
					EventStory("During [zero]'s travels they managed to contract a serious case of [case].")
			break

	Tick()
		if(!target)
			AbruptEnd()

	End()
		if(!target)
			OnPass()

	OnFail()
		if (!prevent_stories)
			if(zero && case)
				EventStory("[zero] was never cured from the case of [case].")

	OnPass()
		if (!prevent_stories)
			if(zero && case)
				EventStory("[zero] was cured of their [case].")