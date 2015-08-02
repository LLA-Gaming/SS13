/datum/round_event_control/spooky
	name = "2 SPOOKY!"
	holidayID = "Halloween"
	typepath = /datum/round_event/spooky
	weight = -1							//forces it to be called, regardless of weight
	max_occurrences = 1
	earliest_start = 0

/datum/round_event/spooky/
	var/minWerewolfAmt = 1
	var/maxWerewolfAmt = 4
	var/werewolfMinPlayers = 20

	proc/PickWerewolves()

		if(!(clients.len >= werewolfMinPlayers))
			log_game("Not enough players for werewolf, aborting.")
			return

		var/scale = round(length(clients) / 8)
		var/amount = max(1, scale > maxWerewolfAmt ? maxWerewolfAmt : scale)
		var/picked = 0

		for(var/client/C in shuffle(clients))
			if(!istype(C.mob, /mob/living/carbon/human))	continue
			var/mob/living/carbon/human/H = C.mob
			if(!H.mind)	return
			if(picked >= amount)	break

			if(!(C.prefs.be_special & 1))
				continue

			if(C.mob.job in list("Perseus Security Enforcer", "Perseus Security Commander"))	continue

			if(H.mind.special_role == "Werewolf")	continue

			H.mind.special_role = "Werewolf"
			H.mind.store_memory("<B><font size=3 color=red>You are the Werewolf.</font></B>")
			H << "<B><font size=3 color=red>You are the Werewolf.</font></B>"
			H << {"<font size=2 color=red>As a werewolf, you will sporadically transform between your human form and werewolf form. <br><b>Be aware of this at all times!</b></font>"}
			picked++

	start()
		PickWerewolves()

	/*
		for(var/mob/living/carbon/human/H in mob_list)
			if(H.dna)
				hardset_dna(H, null, null, null, "skeleton")
	*/

		for(var/mob/living/simple_animal/corgi/Ian/Ian in mob_list)
			Ian.place_on_head(new /obj/item/weapon/bedsheet(Ian))

		/*
		* Make Lights flicker & break
		*/

		for(var/obj/machinery/light/L in world)
			if(L.z != 1)	continue
			if(prob(15))
				L.broken()
			else
				L.flicker()
				spawn(150)
					if(prob(50))
						L.broken()

		/*
		* Reduce apc cell charge to 30% (10% chance)
		*/

		for(var/obj/machinery/power/apc/A in world)
			if(A.z != 1)	continue
			if(prob(10))
				A.cell.charge = A.cell.maxcharge * 0.30 //set the apc power to 30%

		/*
		* Tcoms blackout for 30 seconds
		*/

		for(var/obj/machinery/telecomms/T in telecomms_list)
			if(T.z != 1)	continue
			if(!(T.stat & EMPED))
				T.stat |= EMPED
				spawn(300)
					T.stat &= ~EMPED

		/*
		* Iterate through all the humans.
		*/

		for(var/mob/living/carbon/human/H in mob_list)
			//Give people a little room in their stomach so they can eat lots of candy.
			H.nutrition -= 125

			// Award medal for participating in halloween events.
			// @MEDAL
			//if(H.client)
			//	H.client.AwardMedal("halloween2014")

			//Give people candy bags
			var/obj/item/weapon/storage/hallooween/B = new(get_turf(H))
			H.put_in_any_hand_if_possible(B)

			//Give people a costume box (contains random costume)
			var/obj/item/weapon/storage/box/costume_box/cbox = new(get_turf(H))
			if(H.back)
				if(istype(H.back, /obj/item/weapon/storage))
					var/obj/item/weapon/storage/S = H.back
					if(S.can_be_inserted(cbox, 1))
						S.handle_item_insertion(cbox, 1)

		// Decided to leave it up to randomness for when they transform.
		/*	// Turn picked werewolves into werewolves
			if(H.mind)
				if(H.mind.special_role == "Werewolf")
					var/mob/living/carbon/werewolf/wolf = new /mob/living/carbon/werewolf(get_turf(H))
					wolf.Initiate(H)
		*/

		/*
		* Spawn Cauldrons
		*/

		//list of coordinates where the candy cauldrons spawn
		//I realise this is hacky, but I didn't want to put halloween-specific landmarks on the map.
//		var/list/coords = list(list(122, 99, 1), 		//Science
//								list(92, 103, 1),		//Medbay
//								list(102, 134, 1),		//Bridge
//								list(70, 138, 1),		//Cargo
//								list(108, 165, 1),		//Security
//								list(159, 137, 1),		//Engineering
//							//	list(122, 149, 1),		//Civilian 1
//							//	list(132, 126, 1),		//Civilian 2
//							//	list(82, 126, 1),		//Civilian 3
//							//	list(67, 134, 1),		//Civilian 4
//								list(128, 149, 1)		//Civilian 5 - Crew Quarters
//							)
//
//		//use coordinates above to place the cauldrons.
//		for(var/list/coord in coords)
//			new /obj/structure/candy_cauldron(get_turf(locate(coord[1], coord[2], coord[3])))
// Ok so... i commented out the cauldrons spawning as we switched maps and the coordinates for there spawn points have not been made, re-make these coords or make landmarks before uncommenting. per don zombie. ~Flavo


	announce()
		priority_announce(pick("RATTLE ME BONES!","THE RIDE NEVER ENDS!", "A SKELETON POPS OUT!", "SPOOKY SCARY SKELETONS!", "CREWMEMBERS BEWARE, YOU'RE IN FOR A SCARE!") , "THE CALL IS COMING FROM INSIDE THE HOUSE")

		// Play some sp00ky songs.
		var/song = pick(list('sound/ambience/scaryskeletons.ogg', 'sound/ambience/thisishalloween.ogg'))
		for(var/client/C in clients)
			if(C.prefs.toggles & SOUND_MIDI)
				C << sound(song, repeat = 0, wait = 0, volume = 50, channel = 1)
