/*
Contains:
Borg Hypospray
Borg Shaker
Nothing to do with hydroponics in here. Sorry to dissapoint you.
*/

/*
Borg Hypospray
*/
/obj/item/weapon/reagent_containers/borghypo
	name = "cyborg hypospray"
	desc = "An advanced chemical synthesizer and injection system, designed for heavy-duty medical equipment."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "borghypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = null
	var/mode = 1
	var/charge_cost = 50
	var/charge_tick = 0
	var/recharge_time = 5 //Time it takes for shots to recharge (in seconds)

	var/list/datum/reagents/reagent_list = list()
	//var/list/reagent_ids = list("doctorsdelight", "inaprovaline", "spaceacillin")
	var/list/reagent_ids = list("dexalin", "kelotane", "bicaridine", "anti_toxin", "inaprovaline", "tricordrazine")
	var/list/modes = list() //Basically the inverse of reagent_ids. Instead of having numbers as "keys" and strings as values it has strings as keys and numbers as values.
								//Used as list for input() in shakers.


/obj/item/weapon/reagent_containers/borghypo/New()
	..()

	var/iteration = 1
	for(var/R in reagent_ids)
		add_reagent(R)
		modes[R] = iteration
		iteration++

	processing_objects.Add(src)


/obj/item/weapon/reagent_containers/borghypo/Destroy()
	processing_objects.Remove(src)
	..()


/obj/item/weapon/reagent_containers/borghypo/process() //Every [recharge_time] seconds, recharge some reagents for the cyborg
	charge_tick++
	if(charge_tick >= recharge_time)
		regenerate_reagents()
		charge_tick = 0

	//update_icon()
	return 1

// Purely for testing purposes I swear~
/*
/obj/item/weapon/reagent_containers/borghypo/verb/add_cyanide()
	set src in world
	add_reagent("cyanide")
*/


// Use this to add more chemicals for the borghypo to produce.
/obj/item/weapon/reagent_containers/borghypo/proc/add_reagent(var/reagent)
	reagent_ids |= reagent
	var/datum/reagents/RG = new(30)
	RG.my_atom = src
	reagent_list += RG

	var/datum/reagents/R = reagent_list[reagent_list.len]
	R.add_reagent(reagent, 30)

/obj/item/weapon/reagent_containers/borghypo/proc/regenerate_reagents()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		if(R && R.cell)
			var/datum/reagents/RG = reagent_list[mode]
			if(RG.total_volume < RG.maximum_volume) 	//Don't recharge reagents and drain power if the storage is full.
				R.cell.use(charge_cost) 					//Take power from borg...
				RG.add_reagent(reagent_ids[mode], 5)		//And fill hypo with reagent.

/obj/item/weapon/reagent_containers/borghypo/attack(mob/living/M as mob, mob/user as mob)
	var/datum/reagents/R = reagent_list[mode]
	if(!R.total_volume)
		user << "<span class='notice'>The injector is empty.</span>"
		return
	if (!( istype(M) ))
		return
	if (R.total_volume && M.can_inject(user, 1))
		M << "<span class='warning'>You feel a tiny prick!</span>"
		user << "<span class='notice'>You inject [M] with the injector.</span>"
		R.reaction(M, INGEST)
		if(M.reagents)
			var/trans = R.trans_to(M, amount_per_transfer_from_this)
			user << "<span class='notice'>[trans] unit\s injected.  [R.total_volume] unit\s remaining.</span>"
	return

/obj/item/weapon/reagent_containers/borghypo/attack_self(mob/user)
	mode++
	if(mode > reagent_list.len)
		mode = 1
	playsound(loc, 'sound/effects/pop.ogg', 50, 0)

	var/datum/reagent/R = chemical_reagents_list[reagent_ids[mode]]
	user << "<span class='notice'>[src] is now dispensing '[R.name]'.</span>"
	return

/obj/item/weapon/reagent_containers/borghypo/examine()
	..()
	DescribeContents()

/obj/item/weapon/reagent_containers/borghypo/proc/DescribeContents()
	var/empty = 1

	for(var/datum/reagents/RS in reagent_list)
		var/datum/reagent/R = locate() in RS.reagent_list
		if(R)
			usr << "<span class='notice'>It currently has [R.volume] unit\s of [R.name] stored.</span>"
			empty = 0

	if(empty)
		usr << "<span class='notice'>It is currently empty. Allow some time for the internal syntheszier to produce more.</span>"
/*
Borg Shaker
*/
/obj/item/weapon/reagent_containers/borghypo/borgshaker
	name = "cyborg shaker"
	desc = "An advanced drink synthesizer and mixer."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "shaker"
	possible_transfer_amounts = list(5,10,20)
	charge_cost = 20 //Lots of reagents all regenerating at once, so the charge cost is lower. They also regenerate faster.
	recharge_time = 3

	reagent_ids = list("orangejuice", "limejuice", "tomatojuice", "cola", "tonic", "sodawater", "ice", "cream", "beer", "whiskey", "vodka", "rum", "gin", "tequilla", "vermouth", "wine", "kahlua", "cognac", "ale")

/obj/item/weapon/reagent_containers/borghypo/borgshaker/attack(mob/M as mob, mob/user as mob)
	return //Can't inject stuff with a shaker, can we?

/obj/item/weapon/reagent_containers/borghypo/borgshaker/regenerate_reagents()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		if(R && R.cell)
			for(var/i in modes) //Lots of reagents in this one, so it's best to regenrate them all at once to keep it from being tedious.
				var/valueofi = modes[i]
				var/datum/reagents/RG = reagent_list[valueofi]
				if(RG.total_volume < RG.maximum_volume)
					R.cell.use(charge_cost)
					RG.add_reagent(reagent_ids[valueofi], 5)

/obj/item/weapon/reagent_containers/borghypo/borgshaker/attack_self(mob/user)
	mode = modes[input(user, "What reagent do you want to dispense?") as anything in reagent_ids]

	playsound(loc, 'sound/effects/pop.ogg', 50, 0)

	var/datum/reagent/R = chemical_reagents_list[reagent_ids[mode]]
	user << "<span class='notice'>[src] is now dispensing '[R.name]'.</span>"
	return

/obj/item/weapon/reagent_containers/borghypo/borgshaker/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return

	else if(target.is_open_container() && target.reagents)
		var/datum/reagents/R = reagent_list[mode]
		if(!R.total_volume)
			user << "<span class='notice'>[src] is currently out of this ingredient. Please allow some time for the synthesizer to produce more.</span>"
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			user << "<span class='notice'>[target] is full.</span>"
			return

		var/trans = R.trans_to(target, amount_per_transfer_from_this)
		user << "<span class='notice'>You transfer [trans] unit\s of the solution to [target].</span>"

/obj/item/weapon/reagent_containers/borghypo/borgshaker/DescribeContents()
	var/empty = 1

	var/datum/reagents/RS = reagent_list[mode]
	var/datum/reagent/R = locate() in RS.reagent_list
	if(R)
		usr << "<span class='notice'>It currently has [R.volume] unit\s of [R.name] stored.</span>"
		empty = 0

	if(empty)
		usr << "<span class='notice'>It is currently empty. Please allow some time for the synthesizer to produce more.</span>"