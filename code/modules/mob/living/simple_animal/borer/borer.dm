/mob/living/simple_animal/borer
	name = "Cortical Borer"
	real_name = ""
	desc = "A small, quivering sluglike creature."
	icon = 'icons/mob/animal.dmi'
	icon_state = "brainslug"
	icon_living = "brainslug"
	icon_dead = "brainslug_dead"
	maxHealth = 5
	health = 5
	response_help  = "pokes"
	response_disarm = "prods"
	response_harm   = "stomps on"
	density = 0
	ventcrawler = 2
	max_co2 = 0
	max_tox = 0
	stop_automated_movement = 1
	pass_flags = PASSTABLE

	var/evil = 0
	var/chemicals = 50
	var/mob/living/carbon/human/host
	var/docile = 0
	var/controlling = 0
	var/list/detached = list()
	var/list/attached = list()
	var/list/chems = list()

/mob/living/simple_animal/borer/New()
	..()
	real_name = "[pick("Primary","Secondary","Tertiary","Quaternary")] [rand(1000,9999)]"
//	if(prob(5))
	evil = 1
	initialize_lists()
	verbs += detached


/mob/living/simple_animal/borer/Life()
	..()
	if(host)
		if(!ishuman(host) && !ismonkey(host))
			detach()
		if(!stat && !host.stat)
			src.sight = host.sight
			src.see_in_dark = host.see_in_dark
			src.see_invisible = host.see_invisible
			if(host.reagents.has_reagent("sugar"))
				if(!docile)
					src << "\blue You feel the soporific flow of sugar in your host's blood, lulling you into docility."
					docile = 1
			else
				if(docile)
					src << "\blue You shake off your lethargy as the sugar leaves your host's blood."
					docile = 0
//			if(!ismonkey(host))
			host.nutrition -= HUNGER_FACTOR
			if(chemicals < 200 && !controlling)
				chemicals++

		if(controlling)
			chemicals--
			if(docile || chemicals <= 0)
				host << "<span class='notice'>Your control over your host's body fades away.</span>"
				return_control()


/mob/living/simple_animal/borer/Stat()
	statpanel("Status")
	stat("Borer Information")
	stat(null) // this is to have empty lines in the panel for cleaner formatting.
	..()

	if (client.statpanel == "Status")
		stat("Chemicals", chemicals)

		if(host)
			stat(null)
			stat("Host Information")
			stat(null)
			stat("Health", "[host.health - host.getBloodLoss()]%")
			stat("Brute damage: [host.getBruteLoss()]")
			stat("Burn damage: [host.getFireLoss()]")
			stat("Toxin damage: [host.getToxLoss()]")
			stat(null)
			stat("Intent:", "[host.a_intent]")
			stat("Move Mode:", "[host.m_intent]")

			if(!ismonkey(host))
				if (host.internal)
					if (!host.internal.air_contents)
						qdel(host.internal)
					else
						stat(null)
						stat("Internal Atmosphere Info", host.internal.name)
						stat("Tank Pressure", host.internal.air_contents.return_pressure())
						stat("Distribution Pressure", host.internal.distribute_pressure)

				if ((istype(host.wear_suit, /obj/item/clothing/suit/space/space_ninja)&&host.wear_suit:s_initialized) || (istype(host.wear_suit, /obj/item/clothing/suit/space/powersuit)&&host.wear_suit:powered))
					stat(null)
					stat("Suit Energy Charge", round(host.wear_suit:cell:charge/100)) // This seems like a horrible way to do but ok
				if(istype(host.loc, /obj/pod))
					var/obj/pod/pod = host.loc
					if(pod.pilot == host)
						stat(null)
						stat("Pod Integrity: ", "[round((pod.health / pod.max_health) * 100)]%")
						if(pod.power_source)
							stat("Pod Charge: ", "[pod.power_source.charge]/[pod.power_source.maxcharge] ([pod.power_source.percent()]%)")
						var/obj/item/weapon/pod_attachment/sensor/sensor = pod.GetAttachmentOnHardpoint(16)
						if(sensor && istype(sensor, /obj/item/weapon/pod_attachment/sensor/gps))
							stat("Pod Position: ", "([pod.x], [pod.y], [pod.z])")
				if(ticker && ticker.mode && ticker.mode.name == "AI malfunction")
					if(ticker.mode:malf_mode_declared)
						stat("Station Override", "Time left: [max(ticker.mode:AI_win_timeleft/(ticker.mode:apcs/3), 0)]")
				if(emergency_shuttle)
					if(emergency_shuttle.online && emergency_shuttle.location < 2)
						var/timeleft = emergency_shuttle.timeleft()
						if (timeleft)
							stat("Emergency Shuttle","ETA-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")

