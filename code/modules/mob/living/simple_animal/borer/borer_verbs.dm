/mob/living/simple_animal/borer/proc/initialize_lists()
	detached += list(/mob/living/simple_animal/borer/proc/infest,
					 /mob/living/simple_animal/borer/proc/hide,
					 /mob/living/simple_animal/borer/proc/reproduce)

	attached += list(/mob/living/simple_animal/borer/proc/abandon_host,
					 /mob/living/simple_animal/borer/proc/secrete_chems,
					 /mob/living/simple_animal/borer/proc/adrenalin,
					 /mob/living/simple_animal/borer/proc/paralyze)

	chems += list("kelotane","bicaridine","hyronalin","imidazoline","ethylredoxrazine","anti_toxin")

	if(evil)
		detached += list(/mob/living/simple_animal/borer/proc/instill_fear)

		attached += list(/mob/living/simple_animal/borer/proc/assume_control)

		chems += list("impedrezene","lexorin","mindbreaker","toxin")

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
	for(var/mob/living/carbon/human/C in view(1,src))
		if(C.stat != 2 && src.Adjacent(C))
			choices += C

	var/mob/living/carbon/human/M = input(src,"Who do you wish to infest?") in null|choices

	if(!M || !src) return

	if(!(src.Adjacent(M))) return

	for(var/mob/living/simple_animal/borer/B in M.contents)
		src << "<span class='notice'>You cannot infest someone who is already infested.</span>"
		return

//	if(istype(M,/mob/living/carbon/human))
//		var/mob/living/carbon/human/H = M
//		if(M.ear_safety)
//			src << "<span class='notice'>You cannot get through that host's protective gear.</span>"
//			return

	ventcrawler = 0
	src << "<span class='notice'>You slither up [M] and begin probing at their ear canal...</span>"
	M << "<span class='notice'>You feel something slithering up your leg...</span>"

	if(!do_after(M,50) && !do_after(src,50))
		for(var/mob/living/simple_animal/borer/B in M.contents)
			src << "<span class='notice'>You stop probing at [M]'s ear canal as you realize that [M] has already been infested.</span>"
			ventcrawler = 2
			return
		src << "<span class='notice'>As [M] moves away, you are dislodged and fall to the ground.</span>"
		ventcrawler = 2
		return

	if(!M || !src) return

	if(src.stat)
		src << "<span class='notice'>You cannot infest a target in your current state.</span>"
		return

	if(M.stat == 2)
		src << "<span class='notice'>That is not an appropriate target.</span>"
		return

	if(M in view(1, src))
		src << "<span class='notice'>You wiggle into [M]'s ear.</span>"
		host = M
		attach()
		return

	else
		src << "<span class='notice'>They are no longer in range!</span>"
		return

/mob/living/simple_animal/borer/proc/attach()
		src.verbs -= detached
		src.verbs |= attached
		sleep(1) // verbs wouldnt update properly otherwise
		host.contents += src

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
	set name = "Lay Egg (200)"
	set desc = "Lay an egg to reproduce."

	if(chemicals < 200)
		src << "<span class='warning'>You do not have enough chemicals to reproduce.</span>"
		return

	if(locate(/obj/structure/borer_egg) in get_turf(src))
		src << "There's already an egg here."
		return

	if(chemicals >= 200)
		chemicals -= 200
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\green <B>The [src] has laid an egg!</B>"), 1)
		new /obj/structure/borer_egg(loc)
	return

/mob/living/simple_animal/borer/proc/instill_fear()
	set category = "Borer"
	set name = "Instill Fear (50)"
	set desc = "Instill fear in a target to make it easier for you to infest it."

	if(chemicals < 50)
		src << "<span class='warning'>You do not have enough chemicals to do this.</span>"
		return

	if(chemicals >= 50)
		var/list/choices = list()
		for(var/mob/living/carbon/human/C in view(7,src))
			if(C.stat != 2)
				choices += C

		var/mob/living/carbon/human/M = input(src,"Pick your target.") in null|choices

		if(!M || !src) return

		if(M)
			M << "<span class='warning'>Your muscles don't seem to listen to you.</span>"
			M.paralysis += 10
			chemicals -= 50
			return

// Available verbs when attached //

/mob/living/simple_animal/borer/proc/abandon_host()
	set category = "Borer"
	set name = "Abandon Host"
	set desc = "Slither out of your host."

	if(!host)
		src << "<span class='warning'>You are not inside a host body.</span>"
		return

	if(stat)
		src << "<span class='warning'>You cannot leave your host in your current state.</span>"
		return

	if(!src)
		return

	src << "<span class='info'>You begin disconnecting from [host]'s synapses and prodding at their internal ear canal.</span>"

	spawn(200)

		if((!host) || !src) return

		if(src.stat)
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

	if(chemicals < 75)
		src << "<span class='warning'>You do not have enough chemicals to do this.</span>"
		return

	if(chemicals >= 75)
		var/chem = input(src,"What do you want to secrete?") in null|chems
		host.reagents.add_reagent(chem, 5)
		chemicals -= 75

/mob/living/simple_animal/borer/proc/adrenalin()
	set category = "Borer"
	set name = "Adrenalin (150)"
	set desc = "Order your host's body to produce epinephrine, increasing its speed for a short time."

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

	if(chemicals < 125)
		src << "<span class='warning'>You do not have enough chemicals to do this.</span>"
		return

	if(chemicals >= 125)
		src << "<span class='info'>You secrete a paralyzing reactant into [host]'s body.</span>"
		host << "<span class='info'>Your muscles don't seem to listen to you.</span>"
		host.paralysis += 10
		chemicals -= 125
		return

/mob/living/simple_animal/borer/proc/assume_control()
	set category = "Borer"
	set name = "Assume Control"
	set desc = "Assume control over your host's body for a period of time."

	var/list/protected_roles = list("Wizard","Changeling","Cultist")
	var/mob/borer = src

	if(!host.key || !host.mind)
		src.verbs -= attached
		host.verbs |= /mob/living/simple_animal/borer/proc/release_control
		borer.mind.transfer_to(host)
		controlling = 1
		return

	if(host.mind.special_role in protected_roles)
		src << "<span class='warning'>Their mind is resisting you.</span>"
		return

	var/mob/dead/observer/ghost = host.ghostize(0)
	host.verbs |= /mob/living/simple_animal/borer/proc/release_control
	borer.mind.transfer_to(host)

	src.verbs -= attached
	ghost.mind.transfer_to(borer)
	borer.key = ghost.key

	controlling = 1

/mob/living/simple_animal/borer/proc/return_control()
	var/mob/borer = src

	if(!borer.key || !borer.mind)
		src.verbs |= attached
		host.verbs -= /mob/living/simple_animal/borer/proc/release_control
		host.mind.transfer_to(borer)
		controlling = 0
		return

	var/mob/dead/observer/ghost = host.ghostize(0)
	host.verbs -= /mob/living/simple_animal/borer/proc/release_control
	borer.mind.transfer_to(host)

	src.verbs |= attached
	ghost.mind.transfer_to(borer)
	borer.key = ghost.key

	controlling = 0

/mob/living/simple_animal/borer/proc/release_control()
	set category = "Borer"
	set name = "Release Control"
	set desc = "Release control over your host's body."

	for(var/mob/living/simple_animal/borer/B in src.contents)
		B.host << "<span class='info'>You release control over your host's body.</span>"
		B.return_control()
