/mob/living/simple_animal/borer/proc/initialize_lists()

	if(evil)
		detached |= list(/mob/living/simple_animal/borer/proc/instill_fear)

		attached |= list(/mob/living/simple_animal/borer/proc/assume_control)

		chems |= list("Impedrezene","Lexorin","Mindbreaker","Toxin")


	detached |= list(/mob/living/simple_animal/borer/proc/infest,
					 /mob/living/simple_animal/borer/proc/hide,
					 /mob/living/simple_animal/borer/proc/reproduce,
					 /mob/living/simple_animal/borer/proc/build_nest)

	attached |= list(/mob/living/simple_animal/borer/proc/abandon_host,
					 /mob/living/simple_animal/borer/proc/secrete_chems,
					 /mob/living/simple_animal/borer/proc/adrenalin,
					 /mob/living/simple_animal/borer/proc/paralyze,
					 /mob/living/simple_animal/borer/proc/suck)

	chems |= list("Kelotane","Bicaridine","Hyronalin","Imidazoline","Ethylredoxrazine","Anti-Toxin (Dylovene)","Cancel") // This uses the 'exact' chem name.

// Available verbs when detached //

/mob/living/simple_animal/borer/proc/infest()
	set category = "Borer"
	set name = "Infest"
	set desc = "Infest a suitable humanoid host."

	if(host)
		src << "<span class='notice'>You are already within a host.</span>"
		return

	if(stat)
		src << "<span class='notice'>You cannot infest a target in your current state.</span>"
		return

	var/list/choices = list()
	for(var/mob/living/carbon/C in view(1,src))
		if(C.stat != 2 && src.Adjacent(C) && ishuman(C) || ismonkey(C))
			choices += C

	var/mob/living/carbon/M = input(src,"Who do you wish to infest?") in null|choices
	var/mob/living/carbon/human/H

	if(ishuman(M))
		H = M

	if(!M || !src) return

	if(!(src.Adjacent(M))) return

	for(var/mob/living/simple_animal/borer/B in M.contents)
		src << "<span class='notice'>You cannot infest someone who is already infested.</span>"
		return
	if (ishuman(M) && istype(H.glasses, /obj/item/clothing/glasses/virtual) && H.glasses:is_in_use)
		src << "<span class='notice'>Their equipment prevents you from infesting them.</span>"
		return

//	if(istype(M,/mob/living/carbon/human))
//		var/mob/living/carbon/human/H = M
//		if(M.ear_safety)
//			src << "<span class='notice'>You cannot get through that host's protective gear.</span>"
//			return

	if(M.stat == 2)
		src << "<span class='notice'>That is not an appropriate target.</span>"
		return

	ventcrawler = 0
	src << "<span class='notice'>You slither up [M] and begin probing at their ear canal...</span>"
	M << "<span class='notice'>You feel something slithering up your leg...</span>"

	if(!do_after(M,attach_speed) && !do_after(src,attach_speed))
		ventcrawler = 2
		return

	if(M in view(1, src))
		if (ishuman(M) && istype(H.glasses, /obj/item/clothing/glasses/virtual) && H.glasses:is_in_use)
			src << "<span class='notice'>Their equipment prevents you from infesting them.</span>"
			return
		for(var/mob/living/simple_animal/borer/B in M.contents)
			src << "<span class='notice'>You stop probing at [M]'s ear canal as you realize that [M] has already been infested.</span>"
			ventcrawler = 2
			return
		src << "<span class='notice'>You wiggle into [M]'s ear.</span>"
		host = M
		attach()
		return

	if(!M || !src)
		ventcrawler = 2
		return

	if(src.stat)
		src << "<span class='notice'>You cannot infest a target in your current state.</span>"
		ventcrawler = 2
		return

	else
		src << "<span class='notice'>They are no longer in range!</span>"
		ventcrawler = 2
		return

/mob/living/simple_animal/borer/proc/attach()
	if(layer != MOB_LAYER)
		layer = MOB_LAYER
	src.verbs -= detached
	src.verbs |= attached
	sleep(1) // verbs wouldnt update properly otherwise
	host.contents += src
	var/list/borer = list()
	for(var/mob/living/simple_animal/borer/B in host.contents)
		borer += B
	if(borer.len != 1)
		src << "<span class='warning'>You were forced outside because [host]'s brain has already been infested.</span>"
		detach()

/mob/living/simple_animal/borer/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Borer"

	if(stat != CONSCIOUS)
		return

	if (layer != TURF_LAYER+0.2)
		layer = TURF_LAYER+0.2
		src << text("\green You are now hiding.")
		for(var/mob/O in oviewers(src, null))
			if ((O.client && !( O.blinded )))
				O << text("<B>[] scurries to the ground!</B>", src)
	else
		layer = MOB_LAYER
		src << text("\green You have stopped hiding.")
		for(var/mob/O in oviewers(src, null))
			if ((O.client && !( O.blinded )))
				O << text("[] slowly peaks up from the ground...", src)

/mob/living/simple_animal/borer/proc/reproduce()
	set category = "Borer"
	set name = "Lay Egg"
	set desc = "Lay an egg to reproduce."

	if(stat)
		src << "<span class='warning'>You can't do that in your current state.</span>"
		return

	if(!can_lay && world.time < egg_timer)
		src << "<span class='warning'>You have to wait [round((egg_timer - world.time) / 10)] seconds before you can lay an egg.</span>"
		return

	if(locate(/turf/space) in get_turf(src))
		src << "You can't lay an egg here."
		return

	if(locate(/obj/structure/borer_egg) in get_turf(src))
		src << "There's already an egg here."
		return

	if(can_lay)
		can_lay = 0
		egg_timer = world.time + 3000
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\green <B>The [src] has laid an egg!</B>"), 1)
		new /obj/structure/borer_egg(loc)
	return

/mob/living/simple_animal/borer/proc/build_nest()
	set category = "Borer"
	set name = "Build Nest (200)"
	set desc = "Build a nest that helps your eggs grow without plasma."

	if(stat)
		src << "<span class='warning'>You can't do that in your current state.</span>"
		return

	if(locate(/turf/space) in get_turf(src))
		src << "You can't build a nest here."
		return

	if(locate(/obj/structure/borer_nest) in get_turf(src))
		src << "There's already a nest here."
		return

	if(chemicals < 200)
		src << "<span class='warning'>You do not have enough chemicals to do this.</span>"
		return

	if(chemicals >= 200)
		chemicals -= 200
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\green <B>The [src] has built a nest!</B>"), 1)
		new /obj/structure/borer_nest(loc)
	return


/mob/living/simple_animal/borer/proc/instill_fear()
	set category = "Borer"
	set name = "Instill Fear (50)"
	set desc = "Instill fear in a target to make it easier for you to infest it."

	if(stat)
		src << "<span class='warning'>You can't do that in your current state.</span>"
		return

	if(chemicals < 50)
		src << "<span class='warning'>You do not have enough chemicals to do this.</span>"
		return

	if(chemicals >= 50)
		var/list/choices = list()
		for(var/mob/living/carbon/C in view(7,src))
			if(C.stat != 2 && ishuman(C) || ismonkey(C))
				choices += C

		var/mob/living/carbon/M = input(src,"Pick your target.") in null|choices

		if(!M || !src) return

		if(M)
			src << "<span class='notice'>You instill fear into your victim.</span>"
			M << "<span class='warning'>Your muscles don't seem to listen to you.</span>"
			M.weakened += 5
			chemicals -= 50
			return

// Available verbs when attached //

/mob/living/simple_animal/borer/proc/abandon_host()
	set category = "Borer"
	set name = "Abandon Host"
	set desc = "Slither out of your host."

	if(!host)
		src << "<span class='warning'>You are not inside a host body.</span>"
		detach()
		return

	if(stat || docile)
		src << "<span class='warning'>You cannot leave your host in your current state.</span>"
		return

	if(!src)
		return

	src << "<span class='info'>You begin disconnecting from [host]'s synapses and prodding at their internal ear canal.</span>"

	spawn(detach_speed)

		if((!host) || !src) return

		if(src.stat || src.docile)
			src << "<span class='warning'>You cannot abandon [host] in your current state.</span>"
			return

		if(host)
			src << "<span class='info'>You wiggle out of the ear of \the [loc] and plop to the ground.</span>"
		else
			src << "<span class='info'>You wiggle out of [host]'s ear and plop to the ground.</span>"

		detach()


/mob/living/simple_animal/borer/proc/detach()

	if(controlling)
		return_control()

	host.contents -= src
	src.loc = get_turf(host)
	host = null
	src.sight = initial(src.sight)
	src.see_in_dark = initial(src.see_in_dark)
	src.see_invisible = initial(src.see_invisible)
	reset_view(null)

	src.verbs -= attached
	src.verbs |= detached
	ventcrawler = 2

/mob/living/simple_animal/borer/proc/secrete_chems()
	set category = "Borer"
	set name = "Secrete Chemicals (75)"
	set desc = "Secrete chemicals into your host's bloodstream."

	if(host.stat == 2)
		src << "<span class='info'>That wouldn't have an effect on [host]'s body.</span>"
		return

	if(stat || docile)
		src << "<span class='warning'>You can't do that in your current state.</span>"
		return

	if(chemicals < 75)
		src << "<span class='warning'>You do not have enough chemicals to do this.</span>"
		return

	if(chemicals >= 75)
		var/chem = input(src,"What do you want to secrete?") in null|chems
		if(chem)
			if(chem == "Cancel") return
			if(chemicals < 75)
				src << "<span class='warning'>You do not have enough chemicals to do this.</span>"
				return
			chem = get_chem_id(chem)
			src << "<span class='info'>You secrete some of the chemical into [host]'s body.</span>"
			host.reagents.add_reagent(chem, 5)
			chemicals -= 75

/mob/living/simple_animal/borer/proc/adrenalin()
	set category = "Borer"
	set name = "Adrenalin (150)"
	set desc = "Order your host's body to produce epinephrine, increasing its speed for a short time."

	if(host.stat == 2)
		src << "<span class='info'>That wouldn't have an effect on [host]'s body.</span>"
		return

	if(stat || docile)
		src << "<span class='warning'>You can't do that in your current state.</span>"
		return

	if(chemicals < 150)
		src << "<span class='warning'>You do not have enough chemicals to do this.</span>"
		return

	if(chemicals >= 150)
		src << "<span class='info'>You order [host]'s body to produce epinephrine.</span>"
		host << "<span class='info'>You feel like you could run a marathon.</span>"
		host.reagents.add_reagent("hyperzine", 5)
		host.reagents.add_reagent("synaptizine", 5)
		chemicals -= 150

/mob/living/simple_animal/borer/proc/paralyze()
	set category = "Borer"
	set name = "Paralyze (125)"
	set desc = "Paralyze your host to prevent it from doing something stupid."

	if(host.stat == 2)
		src << "<span class='info'>That wouldn't have an effect on [host]'s body.</span>"
		return

	if(stat || docile)
		src << "<span class='warning'>You can't do that in your current state.</span>"
		return

	if(chemicals < 125)
		src << "<span class='warning'>You do not have enough chemicals to do this.</span>"
		return

	if(chemicals >= 125)
		src << "<span class='info'>You secrete a paralyzing reactant into [host]'s body.</span>"
		host << "<span class='warning'>Your muscles don't seem to listen to you.</span>"
		host.paralysis += 10
		chemicals -= 125
		return

/mob/living/simple_animal/borer/proc/suck()
	set category = "Borer"
	set name = "Rapid Suction"
	set desc = "Filter your host's bloodstream for nutriments to rapdily generate chemicals."

	if(!host)
		return

	if(stat || docile)
		src << "<span class='warning'>You can't do that in your current state.</span>"
		return

	if(host.stat == 2)
		src << "<span class='warning'>You attempt to filter nutriments, but the blood doesn't flow.</span>"
		return

	if(suction_cooldown)
		src << "<span class='warning'>You have to wait before you can use this ability again.</span>"
		return

	src << "<span class='notice'>You filter nutriments out of [host]'s bloodstream.</span>"
	suction_cooldown = 1
	for(var/i=0, i<5, i++)
		if(host)
			host.nutrition -= 15
			if(chemicals < maxChems-9)
				chemicals += 10
			else if(chemicals >= maxChems-9)
				chemicals = maxChems
				break
		sleep(20)
	sleep(1200)
	suction_cooldown = 0

/mob/living/simple_animal/borer/proc/assume_control()
	set category = "Borer"
	set name = "Assume Control"
	set desc = "Assume control over your host's body for a period of time."

	if(!host)
		return

	if(stat || docile)
		src << "<span class='warning'>You can't do that in your current state.</span>"
		return

	if(host.stat == 2)
		src << "<span class='notice'>You can't control a dead body.</span>"
		return

	var/list/protected_roles = list("Wizard","Changeling","Cultist")
	var/mob/borer = src

	if(!host.key || !host.mind)
		src << "<span class='notice'>You effortlessly take control over your host's body.</span>"
		src.verbs -= attached
		host.verbs |= /mob/living/simple_animal/borer/proc/release_control
		borer.mind.transfer_to(host)
		if(adv_control)
			adv_control_active = 1
		controlling = 1
		return

	if(host.mind.special_role in protected_roles)
		src << "<span class='warning'>Their mind is resisting you.</span>"
		return

	host << "<span class='warning'>Your mind fades away.</span>"
	src << "<span class='notice'>You take control over your host's body.</span>"
	host.verbs |= /mob/living/simple_animal/borer/proc/release_control
	src.verbs -= upgrade_verbs
	src.verbs -= attached

	mind_trade(host,src)

	controlling = 1

/mob/living/simple_animal/borer/proc/lesser_assume()
	set category = "Borer"
	set name = "Lesser Assume Control"
	set desc = "Assume control of a lesser mind for a period of time."

	if(!host)
		return

	if(stat || docile)
		src << "<span class='warning'>You can't do that in your current state.</span>"
		return

	if(host.stat == 2)
		src << "<span class='notice'>You can't control a dead body.</span>"
		return

	if(!ismonkey(host) || host.mind)
		src << "<span class='warning'>This mind is too advanced for you to control.</span>"
		return

	var/mob/borer = src

	src << "<span class='notice'>You take control over your host's body.</span>"
	src.verbs -= attached
	host.verbs |= /mob/living/simple_animal/borer/proc/release_control
	borer.mind.transfer_to(host)
	controlling = 1
	return

/mob/living/simple_animal/borer/proc/return_control()
	var/mob/borer = src

	if(!host)
		controlling = 0
		return

	if(!borer.key || !borer.mind)
		src.verbs |= upgrade_verbs
		src.verbs |= attached
		host.verbs -= /mob/living/simple_animal/borer/proc/release_control
		host.mind.transfer_to(borer)
		controlling = 0
		return

	host.verbs -= /mob/living/simple_animal/borer/proc/release_control
	src.verbs |= attached

	mind_trade(host,src)

	host << "<span class='notice'>You suddenly find yourself back in control.</span>"
	controlling = 0

/mob/living/simple_animal/borer/proc/release_control()
	set category = "Borer"
	set name = "Release Control"
	set desc = "Release control over your host's body."

	for(var/mob/living/simple_animal/borer/B in src.contents)
		B.host << "<span class='info'>You release control over your host's body.</span>"
		B.return_control()

// Upgrade Verbs //

/mob/living/simple_animal/borer/proc/heal()
	set category = "Borer"
	set name = "Regenerate"
	set desc = "Regenerate your body."
	var/cost = round((maxHealth-health)*5)

	if(stat || docile)
		src << "<span class='warning'>You can't do that in your current state.</span>"
		return

	if(health == maxHealth)
		src << "<span class='info'>Your body is already in perfect condition.</span>"
		return

	if(chemicals < cost)
		src << "<span class='warning'>You need [cost] chemicals to do this.</span>"
		return

	if(chemicals >= cost)
		src << "<span class='info'>You use [cost] chemicals to heal your body.</span>"
		health = maxHealth
		chemicals -= cost

/mob/living/simple_animal/borer/proc/telepathic()
	set category = "Borer"
	set name = "Telepathic Projection (25)"
	set desc = "Transmit some information to an individual."

	if(stat || docile)
		src << "<span class='warning'>You can't do that in your current state.</span>"
		return

	if(chemicals < 25)
		src << "<span class='warning'>You do not have enough chemicals to do this.</span>"
		return

	var/who
	if(host)
		who = host
	else
		who = src
	var/list/choices = list()
	for(var/mob/living/L in view(7,who))
		if(!L.mind) continue
		if(isborer(L)) continue
		if(host && host == L) continue
		if(universal_speak)
			if(L.stat != 2)
				choices += L
		else
			if(L.stat != 2 && ishuman(L) || ismonkey(L))
				choices += L

	var/mob/living/L = input(src,"Who do you wish to talk to?") in null|choices

	if(!L) return

	var/tele_message = copytext(sanitize(input(src, "What do you want to say?", "Enter here", null) as text|null),1,MAX_MESSAGE_LEN)

	if(!tele_message) return

	if(chemicals < 25)
		src << "<span class='warning'>You do not have enough chemicals to do this.</span>"
		return

	if(L in view(7,who))
		src << "<i><span class='name'>You speak to [L]:</span> <span class='message'>[tele_message]</span></i>"
		L << "<i><span class='name'>An unknown voice in your head says,</span> <span class='message'>[tele_message]</span></i>"
		chemicals -= 25

/mob/living/simple_animal/borer/proc/blood_clot()
	set category = "Borer"
	set name = "Coagulation Agent"
	set desc = "Secrete a blood clotting agent into your host's bloodstream."

	if(!host) return

	if(stat || docile)
		src << "<span class='warning'>You can't do that in your current state.</span>"
		return

	var/list/bleeding = host.get_damaged_organs(0,0,1)

	if(!bleeding.len)
		src << "Your host isn't bleeding."
		return

	blood_clotting = 1
	src << "You secrete a blood clotting agent into [host]'s bloodstream."