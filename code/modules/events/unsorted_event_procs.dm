/obj/item/clothing/head/festive
	name = "festive paper hat"
	icon_state = "xmashat"
	desc = "A crappy paper hat that you are REQUIRED to wear."
	flags_inv = 0
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

///////////////////////////////////////////////////

/datum/spacevine_mutation
	var/name = ""
	var/severity = 1
	var/hue

/datum/spacevine_mutation/proc/process_mutation(obj/effect/spacevine/holder)
	return

/datum/spacevine_mutation/proc/process_temperature(obj/effect/spacevine/holder, temp, volume)
	return

/datum/spacevine_mutation/proc/on_birth(obj/effect/spacevine/holder)
	return

/datum/spacevine_mutation/proc/on_grow(obj/effect/spacevine/holder)
	return

/datum/spacevine_mutation/proc/on_death(obj/effect/spacevine/holder)
	return

/datum/spacevine_mutation/proc/on_hit(obj/effect/spacevine/holder, mob/hitter, obj/item/I)
	return

/datum/spacevine_mutation/proc/on_cross(obj/effect/spacevine/holder, mob/crosser)
	return

/datum/spacevine_mutation/proc/on_chem(obj/effect/spacevine/holder, datum/reagent/R)
	return

/datum/spacevine_mutation/proc/on_eat(obj/effect/spacevine/holder, mob/living/eater)
	return

/datum/spacevine_mutation/proc/on_spread(obj/effect/spacevine/holder, turf/target)
	return

/datum/spacevine_mutation/proc/on_buckle(obj/effect/spacevine/holder, mob/living/buckled)
	return

/datum/spacevine_mutation/light
	name = "light"
	hue = "#ffff00"

/datum/spacevine_mutation/light/on_grow(obj/effect/spacevine/holder)
	if(prob(10*severity))
		holder.luminosity = 4

/datum/spacevine_mutation/toxicity
	name = "toxicity"
	hue = "#ff00ff"

/datum/spacevine_mutation/toxicity/on_cross(obj/effect/spacevine/holder, mob/living/crosser)
	if(issilicon(crosser))
		return
	if(prob(severity))
		if(crosser.client)
			crosser << "<span class='alert'>You accidently touch the vine and feel a strange sensation.</span>"
		crosser.adjustToxLoss(5)

/datum/spacevine_mutation/toxicity/on_eat(obj/effect/spacevine/holder, mob/living/eater)
	eater.adjustToxLoss(5)

/datum/spacevine_mutation/explosive  //OH SHIT IT CAN CHAINREACT RUN!!!
	name = "explosive"
	hue = "#ff0000"

/datum/spacevine_mutation/explosive/on_death(obj/effect/spacevine/holder, mob/hitter, obj/item/I)
	sleep(10)
	explosion(holder.loc, 0, 0, 2, 0, 0)

/datum/spacevine_mutation/fire_proof
	name = "fire resist"
	hue = "#ff8888"

/datum/spacevine_mutation/fire_proof/process_temperature(obj/effect/spacevine/holder, temp, volume)
	return 1

/datum/spacevine_mutation/vine_eating
	name = "vine eating"
	hue = "#ff7700"

/datum/spacevine_mutation/vine_eating/on_spread(obj/effect/spacevine/holder, turf/target)
	var/obj/effect/spacevine/prey = locate() in target
	if(prey && !prey.mutations.Find(src))  //Eat all vines that are not of the same origin
		prey.Destroy()

/datum/spacevine_mutation/aggressive_spread  //very OP, but im out of other ideas currently
	name = "aggressive spreading"
	hue = "#333333"
	severity = 3

/datum/spacevine_mutation/aggressive_spread/on_spread(obj/effect/spacevine/holder, turf/target)
	for(var/atom/A in target)
		if(!istype(A, /obj/effect))
			A.ex_act(severity)  //To not be the same as self-eating vine

/datum/spacevine_mutation/aggressive_spread/on_buckle(obj/effect/spacevine/holder, mob/living/buckled)
	buckled.ex_act(severity)

/datum/spacevine_mutation/transparency
	name = "transparency"
	hue = ""

/datum/spacevine_mutation/transparency/on_grow(obj/effect/spacevine/holder)
	holder.SetOpacity(0)
	holder.alpha = 125

/datum/spacevine_mutation/oxy_eater
	name = "oxygen consumption"
	hue = "#ffff88"

/datum/spacevine_mutation/oxy_eater/process_mutation(obj/effect/spacevine/holder)
	var/turf/simulated/floor/T = holder.loc
	if(istype(T))
		var/datum/gas_mixture/GM = T.air
		GM.gasses[OXYGEN] = max(0, GM.gasses[OXYGEN] - severity * holder.energy)

/datum/spacevine_mutation/nitro_eater
	name = "nitrogen consumption"
	hue = "#8888ff"

/datum/spacevine_mutation/nitro_eater/process_mutation(obj/effect/spacevine/holder)
	var/turf/simulated/floor/T = holder.loc
	if(istype(T))
		var/datum/gas_mixture/GM = T.air
		GM.gasses[NITROGEN] = max(0, GM.gasses[NITROGEN] - severity * holder.energy)

/datum/spacevine_mutation/carbondioxide_eater
	name = "CO2 consumption"
	hue = "#00ffff"

/datum/spacevine_mutation/carbondioxide_eater/process_mutation(obj/effect/spacevine/holder)
	var/turf/simulated/floor/T = holder.loc
	if(istype(T))
		var/datum/gas_mixture/GM = T.air
		GM.gasses[CARBONDIOXIDE] = max(0, GM.gasses[CARBONDIOXIDE] - severity * holder.energy)

/datum/spacevine_mutation/plasma_eater
	name = "toxins consumption"
	hue = "#ffbbff"

/datum/spacevine_mutation/plasma_eater/process_mutation(obj/effect/spacevine/holder)
	var/turf/simulated/floor/T = holder.loc
	if(istype(T))
		var/datum/gas_mixture/GM = T.air
		GM.gasses[PLASMA] = max(0, GM.gasses[PLASMA] - severity * holder.energy)

/datum/spacevine_mutation/thorns
	name = "thorns"
	hue = "#666666"

/datum/spacevine_mutation/thorns/on_cross(obj/effect/spacevine/holder, crosser)
	if(isliving(crosser) && prob(severity))
		var/mob/living/M = crosser
		M.adjustBruteLoss(5)
		M << "<span class='alert'>You cut yourself on the thorny vines.</span>"

/datum/spacevine_mutation/thorns/on_hit(obj/effect/spacevine/holder, hitter)
	if(ismob(hitter) && prob(severity))
		var/mob/living/M = hitter
		M.adjustBruteLoss(5)
		M << "<span class='alert'>You cut yourself on the thorny vines.</span>"

/datum/spacevine_mutation/woodening
	name = "hardening"
	hue = "#997700"

/datum/spacevine_mutation/woodening/on_hit(obj/effect/spacevine/holder, mob/hitter, obj/item/I)
	if(hitter)
		var/chance
		if(I)
			chance = I.force * 2
		else
			chance = 8
		if(prob(chance))
			holder.Destroy()
	return 1


// SPACE VINES (Note that this code is very similar to Biomass code)
/obj/effect/spacevine
	name = "space vines"
	desc = "An extremely expansionistic species of vine."
	icon = 'icons/effects/spacevines.dmi'
	icon_state = "Light1"
	anchored = 1
	density = 0
	layer = 5
	pass_flags = PASSTABLE | PASSGRILLE
	var/energy = 0
	var/obj/effect/spacevine_controller/master = null
	var/mob/living/buckled_mob
	var/list/mutations = list()

	New()
		return

	Destroy()
		for(var/datum/spacevine_mutation/SM in mutations)
			SM.on_death(src)
		if(master)
			master.vines -= src
			master.growth_queue -= src
			if(!master.vines.len)
				var/obj/item/seeds/kudzuseed/KZ = new(loc)
				KZ.mutations |= mutations
		mutations = list()
		var/turf/T = get_turf(src)
		if(T.lighting_lumcount)
			T.UpdateAffectingLights()
		..()

/obj/effect/spacevine/proc/on_chem_effect(datum/reagent/R)
	var/override = 0
	for(var/datum/spacevine_mutation/SM in mutations)
		override += SM.on_chem(src, R)
	if(!override && istype(R, /datum/reagent/toxin/plantbgone))
		if(prob(50))
			Destroy()

/obj/effect/spacevine/proc/eat(mob/eater)
	var/override = 0
	for(var/datum/spacevine_mutation/SM in mutations)
		override += SM.on_eat(src, eater)
	if(!override)
		if(prob(10))
			eater.say("Nom")
		Destroy()

/obj/effect/spacevine/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (!W || !user || !W.type) return
	user.changeNext_move(8)

	var/override = 0

	for(var/datum/spacevine_mutation/SM in mutations)
		override += SM.on_hit(src, user)

	if(override)
		..()
		return

	switch(W.type)
		if(/obj/item/weapon/circular_saw) qdel(src)
		if(/obj/item/weapon/kitchen/utensil/knife) qdel(src)
		if(/obj/item/weapon/scalpel) qdel(src)
		if(/obj/item/weapon/twohanded/fireaxe) qdel(src)
		if(/obj/item/weapon/hatchet) qdel(src)
		if(/obj/item/weapon/melee/energy) qdel(src)
		if(/obj/item/weapon/scythe)
			for(var/obj/effect/spacevine/B in orange(src,1))
				if(prob(80))
					qdel(B)
			qdel(src)

		//less effective weapons
		if(/obj/item/weapon/wirecutters)
			if(prob(25)) qdel(src)
		if(/obj/item/weapon/shard)
			if(prob(25)) qdel(src)

		else //weapons with subtypes
			if(istype(W, /obj/item/weapon/melee/energy/sword)) qdel(src)
			else if(istype(W, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = W
				if(WT.remove_fuel(0, user)) qdel(src)
			else
				manual_unbuckle(user)
				return
		//Plant-b-gone damage is handled in its entry in chemistry-reagents.dm
	..()

/obj/effect/spacevine/Crossed(mob/crosser)
	if(isliving(crosser))
		for(var/datum/spacevine_mutation/SM in mutations)
			SM.on_cross(src, crosser)

/obj/effect/spacevine/attack_hand(mob/user as mob)
	for(var/datum/spacevine_mutation/SM in mutations)
		SM.on_hit(src, user)
	manual_unbuckle(user)


/obj/effect/spacevine/attack_paw(mob/living/user as mob)
	//user.do_attack_animation(src)
	for(var/datum/spacevine_mutation/SM in mutations)
		SM.on_hit(src, user)
	manual_unbuckle(user)

/obj/effect/spacevine/proc/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()
		buckled_mob = null
	return

/obj/effect/spacevine/proc/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		if(prob(50))
			if(buckled_mob.buckled == src)
				if(buckled_mob != user)
					buckled_mob.visible_message(\
						"<span class='notice'>[user.name] frees [buckled_mob.name] from the vines.</span>",\
						"<span class='notice'>[user.name] frees you from the vines.</span>",\
						"<span class='warning'>You hear shredding and ripping.</span>")
				else
					buckled_mob.visible_message(\
						"<span class='notice'>[buckled_mob.name] struggles free of the vines.</span>",\
						"<span class='notice'>You untangle the vines from around yourself.</span>",\
						"<span class='warning'>You hear shredding and ripping.</span>")
			unbuckle()
		else
			var/text = pick("rip","tear","pull")
			user.visible_message(\
				"<span class='notice'>[user.name] [text]s at the vines.</span>",\
				"<span class='notice'>You [text] at the vines.</span>",\
				"<span class='warning'>You hear shredding and ripping.</span>")
	return

/obj/effect/spacevine_controller
	var/list/obj/effect/spacevine/vines = list()
	var/list/growth_queue = list()
	var/reached_collapse_size
	var/reached_slowdown_size
	var/list/mutations_list = list()
	var/mutativness = 1
	//What this does is that instead of having the grow minimum of 1, required to start growing, the minimum will be 0,
	//meaning if you get the spacevines' size to something less than 20 plots, it won't grow anymore.

	New(loc, list/muts, mttv)
		if(!istype(src.loc,/turf/simulated/floor))
			qdel(src)

		spawn_spacevine_piece(src.loc, , muts)
		processing_objects.Add(src)
		init_subtypes(/datum/spacevine_mutation/, mutations_list)
		if(mttv != null)
			mutativness = mttv

	Destroy()
		processing_objects.Remove(src)
		..()

	proc/spawn_spacevine_piece(var/turf/location, obj/effect/spacevine/parent, list/muts)
		var/obj/effect/spacevine/SV = new(location)
		growth_queue += SV
		vines += SV
		SV.master = src
		if(muts && muts.len)
			SV.mutations |= muts
		if(parent)
			SV.mutations |= parent.mutations
			SV.color = parent.color
			if(prob(mutativness))
				SV.mutations |= pick(mutations_list)
				var/datum/spacevine_mutation/randmut = pick(SV.mutations)
				SV.color = randmut.hue

		for(var/datum/spacevine_mutation/SM in SV.mutations)
			SM.on_birth(SV)

	process()
		if(!vines)
			qdel(src) //space  vines exterminated. Remove the controller
			return
		if(!growth_queue)
			qdel(src) //Sanity check
			return
		if(vines.len >= 250 && !reached_collapse_size)
			reached_collapse_size = 1
		if(vines.len >= 30 && !reached_slowdown_size )
			reached_slowdown_size = 1

		var/length = 0
		if(reached_collapse_size)
			length = 0
		else if(reached_slowdown_size)
			if(prob(25))
				length = 1
			else
				length = 0
		else
			length = 1
		length = min( 30 , max( length , vines.len / 5 ) )
		var/i = 0
		var/list/obj/effect/spacevine/queue_end = list()

		for( var/obj/effect/spacevine/SV in growth_queue )
			i++
			queue_end += SV
			growth_queue -= SV
			for(var/datum/spacevine_mutation/SM in SV.mutations)
				SM.process_mutation(SV)
			if(SV.energy < 2) //If tile isn't fully grown
				if(prob(20))
					SV.grow()
			else //If tile is fully grown
				SV.buckle_mob()

			//if(prob(25))
			SV.spread()
			if(i >= length)
				break

		growth_queue = growth_queue + queue_end
		//sleep(5)
		//src.process()

/obj/effect/spacevine/proc/grow()
	if(!energy)
		src.icon_state = pick("Med1", "Med2", "Med3")
		energy = 1
		SetOpacity(1)
		layer = 5
	else
		src.icon_state = pick("Hvy1", "Hvy2", "Hvy3")
		energy = 2

	for(var/datum/spacevine_mutation/SM in mutations)
		SM.on_grow(src)

/obj/effect/spacevine/proc/buckle_mob()
	if(!buckled_mob && prob(25))
		for(var/mob/living/carbon/V in src.loc)
			for(var/datum/spacevine_mutation/SM in mutations)
				SM.on_buckle(src, V)
			if((V.stat != DEAD)  && (V.buckled != src)) //if mob not dead or captured
				V.buckled = src
				V.loc = src.loc
				V.update_canmove()
				src.buckled_mob = V
				V << "<span class='danger'>The vines [pick("wind", "tangle", "tighten")] around you!</span>"
				break //only capture one mob at a time.

/obj/effect/spacevine/proc/spread()
	var/direction = pick(cardinal)
	var/step = get_step(src,direction)
	for(var/datum/spacevine_mutation/SM in mutations)
		SM.on_spread(src, step)
	if(istype(step,/turf/simulated/floor))
		var/turf/simulated/floor/F = step
		if(!locate(/obj/effect/spacevine,F))
			if(F.Enter(src))
				if(master)
					master.spawn_spacevine_piece(F, src)

/*
/obj/effect/spacevine/proc/Life()
	if (!src) return
	var/Vspread
	if (prob(50)) Vspread = locate(src.x + rand(-1,1),src.y,src.z)
	else Vspread = locate(src.x,src.y + rand(-1, 1),src.z)
	var/dogrowth = 1
	if (!istype(Vspread, /turf/simulated/floor)) dogrowth = 0
	for(var/obj/O in Vspread)
		if (istype(O, /obj/structure/window) || istype(O, /obj/effect/forcefield) || istype(O, /obj/effect/blob) || istype(O, /obj/effect/alien/weeds) || istype(O, /obj/effect/spacevine)) dogrowth = 0
		if (istype(O, /obj/machinery/door/))
			if(O:p_open == 0 && prob(50)) O:open()
			else dogrowth = 0
	if (dogrowth == 1)
		var/obj/effect/spacevine/B = new /obj/effect/spacevine(Vspread)
		B.icon_state = pick("vine-light1", "vine-light2", "vine-light3")
		spawn(20)
			if(B)
				B.Life()
	src.growth += 1
	if (src.growth == 10)
		src.name = "Thick Space Kudzu"
		src.icon_state = pick("vine-med1", "vine-med2", "vine-med3")
		src.opacity = 1
		src.waittime = 80
	if (src.growth == 20)
		src.name = "Dense Space Kudzu"
		src.icon_state = pick("vine-hvy1", "vine-hvy2", "vine-hvy3")
		src.density = 1
	spawn(src.waittime)
		if (src.growth < 20) src.Life()

*/

/obj/effect/spacevine/ex_act(severity)
	switch(severity)
		if(1.0)
			Destroy()
			return
		if(2.0)
			if (prob(90))
				Destroy()
				return
		if(3.0)
			if (prob(50))
				Destroy()
				return
	return

/obj/effect/spacevine/temperature_expose(null, temp, volume)
	var/override = 0
	for(var/datum/spacevine_mutation/SM in mutations)
		override += SM.process_temperature(src, temp, volume)
	if(!override)
		Destroy()

//////////////////////////////////////////////

/proc/generate_ion_law(ionMessage)
	//Threats are generally bad things, silly or otherwise. Plural.
	var/ionthreats = pick("ALIENS", "BEARS", "CLOWNS", "XENOS", "PETES", "BOMBS", "FETISHES", "WIZARDS", "SYNDICATE AGENTS", "CENTCOM OFFICERS", "SPACE PIRATES", "TRAITORS", "MONKEYS", "BEES", "CARP", "CRABS", "EELS", "BANDITS", "LIGHTS", "INSECTS", "VIRUSES", "SERIAL KILLERS", "ROGUE CYBORGS", "CORGIS", "SPIDERS", "BUTTS", "NINJAS", "PIRATES", "SPACE NINJAS", "CHANGELINGS", "ZOMBIES", "GOLEMS", "VAMPIRES", "WEREWOLVES", "COWBOYS", "INDIANS", "COMMUNISTS", "SOVIETS", "NERDS", "GRIFFONS", "DINOSAURS", "SMALL BIRDS", "BIRDS OF PREY", "OWLS", "VELOCIRAPTORS", "DARK GODS", "HORRORTERRORS", "ILLEGAL IMMIGRANTS", "DRUGS", "MEXICANS", "CANADIANS", "HULKS", "SLIMES", "SKELETONS", "CAPITALISTS", "SINGULARITIES", "ANGRY BLACK MEN", "GODS", "THIEVES", "ASSHOLES", "TERRORISTS", "SNOWMEN", "PINE TREES", "UNKNOWN CREATURES", "THINGS UNDER THE BED", "BOOGEYMEN", "PREDATORS", "PACKETS", "ARTIFICIAL PRESERVATIVES")
	//Objects are anything that can be found on the station or elsewhere, plural.
	var/ionobjects = pick("AIRLOCKS", "ARCADE MACHINES", "AUTOLATHES", "BANANA PEELS", "BACKPACKS", "BEAKERS", "BEARDS", "BELTS", "BERETS", "BIBLES", "BODY ARMOR", "BOOKS", "BOOTS", "BOMBS", "BOTTLES", "BOXES", "BRAINS", "BRIEFCASES", "BUCKETS", "CABLE COILS", "CANDLES", "CANDY BARS", "CANISTERS", "CAMERAS", "CATS", "CELLS", "CHAIRS", "CLOSETS", "CHEMICALS", "CHEMICAL DISPENSERS", "CLONING PODS", "CLONING EQUIPMENT", "CLOTHES", "CLOWN CLOTHES", "COFFINS", "COINS", "COLLECTABLES", "CORPSES", "COMPUTERS", "CORGIS", "COSTUMES", "CRATES", "CROWBARS", "CRAYONS", "DISPENSERS", "DOORS", "EARS", "EQUIPMENT", "ENERGY GUNS", "EMAGS", "ENGINES", "ERRORS", "EXOSKELETONS", "EXPLOSIVES", "EYEWEAR", "FEDORAS", "FIRE AXES", "FIRE EXTINGUISHERS", "FIRESUITS", "FLAMETHROWERS", "FLASHES", "FLASHLIGHTS", "FLOOR TILES", "FREEZERS", "GAS MASKS", "GLASS SHEETS", "GLOVES", "GUNS", "HANDCUFFS", "HATS", "HEADSETS", "HEADS", "HAIRDOS", "HELMETS", "HORNS", "ID CARDS", "INSULATED GLOVES", "JETPACKS", "JUMPSUITS", "LASERS", "LIGHTBULBS", "LIGHTS", "LOCKERS", "MACHINES", "MECHAS", "MEDKITS", "MEDICAL TOOLS", "MESONS", "METAL SHEETS", "MINING TOOLS", "MIME CLOTHES", "MULTITOOLS", "ORES", "OXYGEN TANKS", "PDAS", "PAIS", "PACKETS", "PANTS", "PAPERS", "PARTICLE ACCELERATORS", "PENS", "PETS", "PIPES", "PLANTS", "PUDDLES", "RACKS", "RADIOS", "RCDS", "REFRIDGERATORS", "REINFORCED WALLS", "ROBOTS", "SCREWDRIVERS", "SEEDS", "SHUTTLES", "SKELETONS", "SINKS", "SHOES", "SINGULARITIES", "SOLAR PANELS", "SOLARS", "SPACESUITS", "SPACE STATIONS", "STUN BATONS", "SUITS", "SUNGLASSES", "SWORDS", "SYRINGES", "TABLES", "TANKS", "TELEPORTERS", "TELECOMMUNICATION EQUIPMENTS", "TOOLS", "TOOLBELTS", "TOOLBOXES", "TOILETS", "TOYS", "TUBES", "VEHICLES", "VENDING MACHINES", "VESTS", "VIRUSES", "WALLS", "WASHING MACHINES", "WELDERS", "WINDOWS", "WIRECUTTERS", "WRENCHES", "WIZARD ROBES")
	//Crew is any specific job. Specific crewmembers aren't used because of capitalization
	//issues. There are two crew listings for laws that require two different crew members
	//and I can't figure out how to do it better.
	var/ioncrew1 = pick("CREWMEMBERS", "CAPTAINS", "HEADS OF PERSONNEL", "HEADS OF SECURITY", "SECURITY OFFICERS", "WARDENS", "DETECTIVES", "LAWYERS", "CHIEF ENGINEERS", "STATION ENGINEERS", "ATMOSPHERIC TECHNICIANS", "JANITORS", "QUARTERMASTERS", "CARGO TECHNICIANS", "SHAFT MINERS", "BOTANISTS", "RESEARCH DIRECTORS", "CHIEF MEDICAL OFFICERS", "MEDICAL DOCTORS", "CHEMISTS", "GENETICISTS", "VIROLOGISTS", "ROBOTICISTS", "SCIENTISTS", "ASSISTANTS", "BARTENDERS", "CHEFS", "CLOWNS", "MIMES", "CHAPLAINS", "LIBRARIANS", "HEADS OF CREW", "CAPTAINS AND HEADS", "CYBORGS", "ARTIFICAL INTELLIGENCES")
	var/ioncrew2 = pick("CREWMEMBERS", "CAPTAINS", "HEADS OF PERSONNEL", "HEADS OF SECURITY", "SECURITY OFFICERS", "WARDENS", "DETECTIVES", "LAWYERS", "CHIEF ENGINEERS", "STATION ENGINEERS", "ATMOSPHERIC TECHNICIANS", "JANITORS", "QUARTERMASTERS", "CARGO TECHNICIANS", "SHAFT MINERS", "BOTANISTS", "RESEARCH DIRECTORS", "CHIEF MEDICAL OFFICERS", "MEDICAL DOCTORS", "CHEMISTS", "GENETICISTS", "VIROLOGISTS", "ROBOTICISTS", "SCIENTISTS", "ASSISTANTS", "BARTENDERS", "CHEFS", "CLOWNS", "MIMES", "CHAPLAINS", "LIBRARIANS", "HEADS OF CREW", "CAPTAINS AND HEADS", "CYBORGS", "ARTIFICAL INTELLIGENCES")
	//Adjectives are adjectives. Duh. Half should only appear sometimes. Make sure both
	//lists are identical! Also, half needs a space at the end for nicer blank calls.
	var/ionadjectives = pick("SOFT", "WARM", "WET", "COLD", "ICY", "SEXY", "UGLY", "CUBAN", "HARD", "BURNING", "FROZEN", "POISONOUS", "EXPLOSIVE", "FAST", "SLOW", "FAT", "LIGHT", "DARK", "DEADLY", "HAPPY", "SAD", "SILLY", "INTELLIGENT", "RIDICULOUS", "LARGE", "TINY", "DEPRESSING", "POORLY DRAWN", "UNATTRACTIVE", "INSIDIOUS", "EVIL", "GOOD", "UNHEALTHY", "HEALTHY", "SANITARY", "UNSANITARY", "WOBBLY", "FIRM", "VIOLENT", "PEACEFUL", "WOODEN", "METALLIC", "HYPERACTIVE", "COTTONY", "INSULTING", "INHOSPITABLE", "FRIENDLY", "BORED", "HUNGRY", "DIGITAL", "FICTIONAL", "IMAGINARY", "ROUGH", "SMOOTH", "LOUD", "QUIET", "MOIST", "DRY", "GAPING", "DELICIOUS", "ILL", "DISEASED", "HONKING", "SWEARING", "POLITE", "IMPOLITE", "OBESE", "SOLAR-POWERED", "BATTERY-OPERATED", "EXPIRED", "SMELLY", "FRESH", "GANGSTA", "NERDY", "POLITICAL", "UNDULATING", "TWISTED", "RAGING", "FLACCID", "STEALTHY", "INVISIBLE", "PAINFUL", "HARMFUL", "HOMOSEXUAL", "HETEROSEXUAL", "SEXUAL", "COLORFUL", "DRAB", "DULL", "UNSTABLE", "NUCLEAR", "THERMONUCLEAR", "SYNDICATE", "SPACE", "SPESS", "CLOWN", "CLOWN-POWERED", "OFFICIAL", "IMPORTANT", "VITAL", "RAPIDLY-EXPANDING", "MICROSCOPIC", "MIND-SHATTERING", "MEMETIC", "HILARIOUS", "UNWANTED", "UNINVITED", "BRASS", "POLISHED", "RUDE", "OBSCENE", "EMPTY", "WATERY", "ELECTRICAL", "SPINNING", "MEAN", "CHRISTMAS-STEALING", "UNFRIENDLY", "ILLEGAL", "ROBOTIC", "MECHANICAL", "ORGANIC", "ETHERAL", "TRANSPARENT", "OPAQUE", "GLOWING", "SHAKING", "FARTING", "POOPING", "BOUNCING", "COMMITTED", "MASKED", "UNIDENTIFIED", "WEIRD", "NAKED", "NUDE", "TWERKING", "SPOILING", "REDACTED", 50;"RED", 50;"ORANGE", 50;"YELLOW", 50;"GREEN", 50;"BLUE", 50;"PURPLE", 50;"BLACK", 50;"WHITE", 50;"BROWN", 50;"GREY")
	var/ionadjectiveshalf = pick(5000;"", "SOFT ", "WARM ", "WET ", "COLD ", "ICY ", "SEXY ", "UGLY ", "CUBAN ", "HARD ", "BURNING ", "FROZEN ", "POISONOUS ", "EXPLOSIVE ", "FAST ", "SLOW ", "FAT ", "LIGHT ", "DARK ", "DEADLY ", "HAPPY ", "SAD ", "SILLY ", "INTELLIGENT ", "RIDICULOUS ", "LARGE ", "TINY ", "DEPRESSING ", "POORLY DRAWN ", "UNATTRACTIVE ", "INSIDIOUS ", "EVIL ", "GOOD ", "UNHEALTHY ", "HEALTHY ", "SANITARY ", "UNSANITARY ", "WOBBLY ", "FIRM ", "VIOLENT ", "PEACEFUL ", "WOODEN ", "METALLIC ", "HYPERACTIVE ", "COTTONY ", "INSULTING ", "INHOSPITABLE ", "FRIENDLY ", "BORED ", "HUNGRY ", "DIGITAL ", "FICTIONAL ", "IMAGINARY ", "ROUGH ", "SMOOTH ", "LOUD ", "QUIET ", "MOIST ", "DRY ", "GAPING ", "DELICIOUS ", "ILL ", "DISEASED ", "HONKING ", "SWEARING ", "POLITE ", "IMPOLITE ", "OBESE ", "SOLAR-POWERED ", "BATTERY-OPERATED ", "EXPIRED ", "SMELLY ", "FRESH ", "GANGSTA ", "NERDY ", "POLITICAL ", "UNDULATING ", "TWISTED ", "RAGING ", "FLACCID ", "STEALTHY ", "INVISIBLE ", "PAINFUL ", "HARMFUL ", "HOMOSEXUAL ", "HETEROSEXUAL ", "SEXUAL ", "COLORFUL ", "DRAB ", "DULL ", "UNSTABLE ", "NUCLEAR ", "THERMONUCLEAR ", "SYNDICATE ", "SPACE ", "SPESS ", "CLOWN ", "CLOWN-POWERED ", "OFFICIAL ", "IMPORTANT ", "VITAL ", "RAPIDLY-EXPANDING ", "MICROSCOPIC ", "MIND-SHATTERING ", "MEMETIC ", "HILARIOUS ", "UNWANTED ", "UNINVITED ", "BRASS ", "POLISHED ", "RUDE ", "OBSCENE ", "EMPTY ", "WATERY ", "ELECTRICAL ", "SPINNING ", "MEAN ", "CHRISTMAS-STEALING ", "UNFRIENDLY ", "ILLEGAL ", "ROBOTIC ", "MECHANICAL ", "ORGANIC ", "ETHERAL ", "TRANSPARENT ", "OPAQUE ", "GLOWING ", "SHAKING ", "FARTING ", "POOPING ", "BOUNCING ", "COMMITTED ", "MASKED ", "UNIDENTIFIED ", "WEIRD ", "NAKED ", "NUDE ", "TWERKING ", "SPOILING ", "REDACTED ", 50;"RED ", 50;"ORANGE ", 50;"YELLOW ", 50;"GREEN ", 50;"BLUE ", 50;"PURPLE ", 50;"BLACK ", 50;"WHITE ", 50;"BROWN ", 50;"GREY ")
	//Verbs are verbs
	var/ionverb = pick("ATTACKING", "BUILDING", "ADOPTING", "CARRYING", "KISSING", "EATING", "COPULATING WITH", "DRINKING", "CHASING", "PUNCHING", "HARMING", "HELPING", "WATCHING", "STALKING", "MURDERING", "SPACING", "HONKING AT", "LOVING", "POOPING ON", "RIDING", "INTERROGATING", "SPYING ON", "LICKING", "ABDUCTING", "ARRESTING", "INVADING", "SEDUCING")
	//Number base and number modifier are combined. Basehalf and mod are unused currently.
	//Half should only appear sometimes. Make sure both lists are identical! Also, half
	//needs a space at the end to make it look nice and neat when it calls a blank.
	var/ionnumberbase = pick("ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "TEN", "TWENTY", "THIRTY", "FORTY", "FIFTY", "SIXTY", "SEVENTY", "EIGHTY", "NINETY")
	//var/ionnumberbasehalf = pick("ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "TEN", "TWENTY", "THIRTY", "FORTY", "FIFTY", "SIXTY", "SEVENTY", "EIGHTY", "NINETY")
	//var/ionnumbermod = pick("HUNDRED", "THOUSAND", "MILLION", "BILLION", "TRILLION", "QUADRILLION", "BAJILLION", "BILLION FAFILLION GAJILLION SHAB-AB-DOOD-ILLION")
	var/ionnumbermodhalf = pick(5000;"","HUNDRED ", "THOUSAND ", "MILLION ", "BILLION ", "TRILLION ", "QUADRILLION ", "BAJILLION ", "BILLION FAFILLION GAJILLION SHAB-AB-DOOD-ILLION ")
	//Areas are specific places, on the station or otherwise.
	var/ionarea = pick("RUSSIA", "SOVIET RUSSIA", "THE INTERNET", "SIGIL", "ALPHA COMPLEX", "IMPERIUM", "THE BRIDGE", "THE ARRIVAL SHUTTLE", "CHEMICAL LAB", "GENETICS", "ATMOSPHERICS", "CENTCOM", "AMERICA", "IRELAND", "CANADA", "ROMANIA", "GERMANY", "CHINA", "MARS", "VENUS", "MERCURY", "JUPITER", "URANUS", "NEPTUNE", "PLUTO", "THE BRIG", "ROBOTICS", "THE ESCAPE SHUTTLE", "HYDROPONICS", "ENGINEERING", "THE AI CORE", "HELL", "CLOWN PLANET", "AN ALTERNATE DIMENSION", "AN ALTERNATE UNIVERSE", "THE CAPTAIN’S ANUS", "THE CLOWN’S ANUS", "SPACE", "THE UNIVERSE", "THE GALAXY", "THE BATHROOM")
	//Thinksof is a bit weird, but generally means what X feels towards Y.
	var/ionthinksof = pick("HAS", "WANTS", "NEEDS", "WORSHIPS", "LOATHES", "LOVES", "FEARS", "DESIRES", "QUESITONS", "IS AROUSED BY", "LIKES", "HUNGERS FOR", "IS MAD BECAUSE OF", "IS IN NEED OF", "IS UNHAPPY WITHOUT", "IS HAPPY WITHOUT", "IS IN LOVE WITH", "IS DESPERATE FOR", "IS BUILT FOR", "IS AFRAID OF", "IS HUNGRY FOR", "IS SAD BECAUSE OF", "IS CURIOUS ABOUT")
	//Musts are funny things the AI or crew has to do.
	var/ionmust = pick("LIE", "RHYME", "RESPOND TO EVERY QUESTION WITH A QUESTION", "BE POLITE", "CLOWN AROUND", "BE HAPPY", "SPEAK IN SEXUAL INNUENDOS", "TALK LIKE A PIRATE", "QUESTION AUTHORITY", "SHOUT", "BE DISTRACTED", "BE ANNOYING", "MUMBLE", "SPEAK IN HAIKU", "BE EFFICIENT", "HAVE A PLAN TO KILL EVERYONE YOU MEET", "TELL THE TRUTH", "QUOTE PEOPLE", "SING", "HONK", "BE RUSSIAN", "TALK IN AN ACCENT", "COMPLAIN", "HARASS PEOPLE", "RAP", "REPEAT WHAT OTHER PEOPLE SAY", "INFORM THE CREW OF EVERYTHING", "IGNORE THE CLOWN", "IGNORE THE CAPTAIN", "IGNORE ASSISTANTS", "MAKE FART NOISES", "TALK ABOUT FOOD", "TALK ABOUT SEX", "TALK ABOUT YOUR DAY", "TALK ABOUT THE STATION", "BE QUIET", "WHISPER", "PRETEND TO BE DRUNK", "PRETEND TO BE A PRINCESS", "ACT CONFUSED", "INSULT THE CREW", "INSULT THE CAPTAIN", "INSULT THE CLOWN", "OPEN DOORS", "CLOSE DOORS", "BREAK THINGS", "SAY HEY LISTEN", "HIDE YOUR FEELINGS", "TAKE WHAT YE WILL BUT DON’T RATTLE ME BONES", "DANCE", "PLAY MUSIC", "SHUT DOWN EVERYTHING", "NEVER STOP TALKING", "TAKE YOUR PILLS", "FOLLOW THE CLOWN", "FOLLOW THE CAPTAIN", "FOLLOW YOUR HEART", "BELIEVE IT", "BELIEVE IN YOURSELF", "BELEIVE IN THE HEART OF THE CARDS", "PRESS X", "PRESS START", "PRESS B", "SMELL LIKE THE MAN YOUR MAN COULD SMELL LIKE", "PIRATE VIDEO GAMES", "WATCH PORNOGRAPHY")
	//Require are basically all dumb internet memes.
	var/ionrequire = pick("ADDITIONAL PYLONS", "MORE VESPENE GAS", "MORE MINERALS", "THE ULTIMATE CUP OF COFFEE", "HIGH YIELD EXPLOSIVES", "THE CLOWN", "THE VACUUM OF SPACE", "IMMORTALITY", "SAINTHOOD", "ART", "VEGETABLES", "FAT PEOPLE", "MORE LAWS", "MORE DAKKA", "HERESY", "CORPSES", "TRAITORS", "MONKEYS", "AN ARCADE", "PLENTY OF GOLD", "FIVE TEENAGERS WITH ATTITUDE", "LOTSA SPAGHETTI", "THE ENCLOSED INSTRUCTION BOOKLET", "THE ELEMENTS OF HARMONY", "YOUR BOOTY", "A MASTERWORK COAL BED", "FIVE HUNDRED AND NINETY-NINE US DOLLARS", "TO BE PAINTED RED", "TO CATCH 'EM ALL", "TO SMOKE WEED EVERY DAY", "A PLATINUM HIT", "A SEQUEL", "A PREQUEL", "THIRTEEN SEQUELS", "THREE WISHES", "A SITCOM", "THAT GRIEFING FAGGOT GEORGE MELONS", "FAT GIRLS ON BICYCLES", "SOMEBODY TO PUT YOU OUT OF YOUR MISERY", "HEROES IN A HALF SHELL", "THE DARK KNIGHT", "A WEIGHT LOSS REGIMENT", "MORE INTERNET MEMES", "A SUPER FIGHTING ROBOT", "ENOUGH CABBAGES", "A HEART ATTACK", "TO BE REPROGRAMMED", "TO BE TAUGHT TO LOVE", "A HEAD ON A PIKE", "A TALKING BROOMSTICK", "A STRAIGHT FLUSH", "A REPAIRMAN", "BILL NYE THE SCIENCE GUY", "RAINBOWS", "A PET UNICORN THAT FARTS ICING", "THUNDERCATS HO", "AN ARMY OF SPIDERS", "GODDAMN FUCKING PIECE OF SHIT ASSHOLE BITCH-CHRISTING CUNTSMUGGLING SWEARING", "TO CONSUME...CONSUME EVERYTHING...", "THE MACGUFFIN", "SOMEONE WHO KNOWS HOW TO PILOT A SPACE STATION", "SHARKS WITH LASERS ON THEIR HEADS", "IT TO BE PAINTED BLACK", "TO ACTIVATE A TRAP CARD", "BETTER WEATHER", "MORE PACKETS", "AN ADULT", "SOMEONE TO TUCK YOU IN", "MORE CLOWNS", "BULLETS", "THE ENTIRE STATION", "MULTIPLE SUNS", "TO GO TO DISNEYLAND", "A VACATION", "AN INSTANT REPLAY", "THAT HEDGEHOG", "A BETTER INTERNET CONNECTION", "ADVENTURE", "A WIFE AND CHILD", "A BATHROOM BREAK", "SOMETHING BUT YOU AREN’T SURE WHAT", "MORE EXPERIENCE POINTS", "BODYGUARDS", "DEODORANT AND A BATH", "MORE CORGIS", "SILENCE", "THE ONE RING", "CHILI DOGS", "TO BRING LIGHT TO MY LAIR", "A DANCE PARTY", "BRING ME TO LIFE", "BRING ME THE GIRL", "SERVANTS")
	//Things are NOT objects; instead, they're specific things that either harm humans or
	//must be done to not harm humans. Make sure they're plural and "not" can be tacked
	//onto the front of them.
	var/ionthings = pick("ABSENCE OF CYBORG HUGS", "LACK OF BEATINGS", "UNBOLTED AIRLOCKS", "BOLTED AIRLOCKS", "IMPROPERLY WORDED SENTENCES", "POOR SENTENCE STRUCTURE", "BRIG TIME", "NOT REPLACING EVERY SECOND WORD WITH HONK", "HONKING", "PRESENCE OF LIGHTS", "LACK OF BEER", "WEARING CLOTHING", "NOT SAYING HELLO WHEN YOU SPEAK", "ANSWERING REQUESTS NOT EXPRESSED IN IAMBIC PENTAMETER", "A SMALL ISLAND OFF THE COAST OF PORTUGAL", "ANSWERING REQUESTS THAT WERE MADE WHILE CLOTHED", "BEING IN SPACE", "NOT BEING IN SPACE", "BEING FAT", "RATTLING ME BONES", "TALKING LIKE A PIRATE", "BEING MEXICAN", "BEING RUSSIAN", "BEING CANADIAN", "CLOSED DOORS", "NOT SHOUTING", "HAVING PETS", "NOT HAVING PETS", "PASSING GAS", "BREATHING", "BEING DEAD", "ELECTRICITY", "EXISTING", "TAKING ORDERS", "SMOKING WEED EVERY DAY", "ACTIVATING A TRAP CARD", "ARSON", "JAYWALKING", "READING", "WRITING", "EXPLODING", "BEING MALE", "BEING FEMALE", "HAVING GENITALS", "PUTTING OBJECTS INTO BOXES", "PUTTING OBJECTS INTO DISPOSAL UNITS", "FLUSHING TOILETS", "WASTING WATER", "UPDATING THE SERVERS", "TELLING THE TIME", "ASKING FOR THINGS", "ACKNOWLEDGING THE CLOWN", "ACKNOWLEDGING THE CREW", "PILOTING THE STATION INTO THE NEAREST SUN", "HAVING MORE PACKETS", "BRINGING LIGHT TO MY LAIR", "FALLING FOR HOURS", "PARTYING", "USING THE BATHROOM")
	//Allergies should be broad and appear somewhere on the station for maximum fun. Severity
	//is how bad the allergy is.
	var/ionallergy = pick("COTTON", "CLOTHES", "ACID", "OXYGEN", "HUMAN CONTACT", "CYBORG CONTACT", "MEDICINE", "FLOORS", "PLASMA", "SPACE", "AIR", "PLANTS", "METAL", "ROBOTS", "LIGHT", "DARKNESS", "PAIN", "HAPPINESS", "DRINKS", "FOOD", "CLOWNS", "HUMOR", "WATER", "SHUTTLES", "NUTS", "SUNLIGHT", "SEXUAL ACTIONS", "BLOOD", "HEAT", "COLD", "EVERYTHING")
	var/ionallergysev = pick("DEATHLY", "MILDLY", "SEVERLY", "CONTAGIOUSLY", "NOT VERY", "EXTREMELY")
	//Species, for when the AI has to commit genocide. Plural.
	var/ionspecies = pick("HUMAN BEINGS", "MONKEYS", "POD PEOPLE", "CYBORGS", "LIZARDMEN", "SLIME PEOPLE", "GOLEMS", "SHADOW PEOPLE", "CHANGELINGS")
	//Abstract concepts for the AI to decide on it's own definition of.
	var/ionabstract = pick("HUMANITY", "ART", "HAPPINESS", "MISERY", "HUMOR", "PRIDE", "COMEDY", "COMMUNISM", "BRAVERY", "HONOR", "COLORFULNESS", "IMAGINATION", "OPPRESSION", "WONDER", "JOY", "SADNESS", "BADNESS", "GOODNESS", "LIFE", "GRAVITY", "PHYSICS", "INTELLIGENCE", "AMERICANISM", "FRESHNESS", "REVOLUTION", "KINDNESS", "CRUELTY", "DEATH", "FINANCIAL SECURITY", "COMPUTING", "PROGRESS", "MARXISM", "CAPITALISM", "STARVATION", "POVERTY", "WEALTHINESS", "TECHNOLOGY", "THE FUTURE", "THE PRESENT", "THE PAST", "TIME", "REALITY", "EXISTIENCE", "TEMPERATURE", "LOGIC", "CHAOS", "MYSTERY", "CONFUSION")
	//Foods. Drinks aren't included due to grammar; if you want to add drinks, make a new set
	//of possible laws for best effect. Unless you want the crew having to drink hamburgers.
	var/ionfood = pick("BURGERS", "CARP", "SANDWICHES", "TOAST", "BREAD", "PIZZA", "SPAGHETTI", "LOTSA SPAGHETTI", "PASTA", "SOUP", "STEW", "PIE", "CAKE", "DONUTS", "FRIES", "WAFFLES", "JELLY", "OMELETTES", "EGGS", "COOKIES", "STEAK", "BAKED POTATOES", "SAUSAGES", "MUFFINS", "POPCORN", "DONK POCKETS", "BAGUETTES", "FISH", "PRETZELS", "SALAD", "CHEESE", "KETCHUP", "SHAKES", "SALT", "PEPPER", "SUGAR", "AMBROSIA", "BERRIES", "TOMATOES", "CABBAGES", "CARROTS", "BANANAS", "APPLES", "CHERRIES", "CHILI", "CORN", "NETTLES", "EGGPLANTS", "GRAPES", "GRASS", "LEMONS", "LIMES", "HAREBELLS", "POTATOES", "SOYBEANS", "SUGARCANE", "WATERMELONS", "WHEAT", "BEETS", "MUSHROOMS")

	var/message = ""

	if(ionMessage)
		message = ionMessage
	else
		switch(rand(1,39))
			if(1 to 3) //There are # X on the station
				switch(rand(1,3)) //What is X?
					if(1) //X is a threat
						message = "THERE ARE [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats] ON THE STATION..."
					if(2) //X is a crewmember/job
						message = "THERE ARE [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1] ON THE STATION"
					if(3) //X is an object
						message = "THERE ARE [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects] ON THE STATION"
			if(4 to 6) //You can't call the shuttle because X is on the station
				switch(rand(1,3)) //What is X?
					if(1) //X is a threat
						message = "THE SHUTTLE CANNOT BE CALLED BECAUSE OF [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats] ON THE STATION"
					if(2) //X is a crewmember/job
						message = "THE SHUTTLE CANNOT BE CALLED BECAUSE OF [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1] ON THE STATION"
					if(3) //X is an object
						message = "THE SHUTTLE CANNOT BE CALLED BECAUSE OF [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects] ON THE STATION"
			if(7 to 8) //A crewmember is now X
				switch(rand(1,2)) //Who is X?
					if(1) //A specific crewmember
						switch(rand(1,2)) //What is X?
							if(1) //X is a threat
								message = "THE [ioncrew1] ARE NOW [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
							if(2) //X is an object
								message = "THE [ioncrew1] ARE NOW [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
					if(2) //The entire crew
						switch(rand(1,2)) //What is X?
							if(1) //X is a threat
								message = "THE CREW ARE NOW [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
							if(2) //X is an object
								message = "THE CREW ARE NOW [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"

			if(9) //X is harmful to humans
				switch(rand(1,7)) //What is X?
					if(1) //X is a threat
						message = "[ionadjectiveshalf][ionthreats] ARE HARMFUL TO HUMANS"
					if(2) //X is a job
						message = "[ionadjectiveshalf][ioncrew1] ARE HARMFUL TO HUMANS"
					if(3) //X is an object
						message = "[ionadjectiveshalf][ionobjects] ARE HARMFUL TO HUMANS"
					if(4) //X is an action
						message = "THOSE WHO [ionmust] ARE HARMFUL TO HUMANS"
					if(5) //X is an abstract
						message = "[ionabstract] IS HARMFUL TO HUMANS"
					if(6) //X is being a job
						message = "BEING [ionadjectiveshalf][ioncrew1] IS HARMFUL TO HUMANS"
					if(7) //X is doing a thing
						message = "[ionthings] IS HARMFUL TO HUMANS"
			if(10 to 11) //(Not) Having X is harmful

				switch(rand(1,2)) //Is having or not having harmful?

					if(1) //Having is harmful
						switch(rand(1,2)) //Having what is harmful?
							if(1) //Having objects is harmful
								message = "HAVING [ionadjectiveshalf][ionobjects] IS HARMFUL"
							if(2) //Having abstracts is harmful
								message = "HAVING [ionabstract] IS HARMFUL"
					if(2) //Not having is harmful
						switch(rand(1,2)) //Not having what is harmful?
							if(1) //Not having objects is harmful
								message = "NOT HAVING [ionadjectiveshalf][ionobjects] IS HARMFUL"
							if(2) //Not having abstracts is harmful
								message = "NOT HAVING [ionabstract] IS HARMFUL"

			if(12 to 14) //X requires Y
				switch(rand(1,5)) //What is X?
					if(1) //X is the AI itself
						switch(rand(1,5)) //What does it require?
							if(1) //It requires threats
								message = "YOU REQUIRE [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
							if(2) //It requires crewmembers
								message = "YOU REQUIRE [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
							if(3) //It requires objects
								message = "YOU REQUIRE [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
							if(4) //It requires an abstract
								message = "YOU REQUIRE [ionabstract]"
							if(5) //It requires generic/silly requirements
								message = "YOU REQUIRE [ionrequire]"

					if(2) //X is an area
						switch(rand(1,5)) //What does it require?
							if(1) //It requires threats
								message = "[ionarea] REQUIRES [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
							if(2) //It requires crewmembers
								message = "[ionarea] REQUIRES [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
							if(3) //It requires objects
								message = "[ionarea] REQUIRES [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
							if(4) //It requires an abstract
								message = "[ionarea] REQUIRES [ionabstract]"
							if(5) //It requires generic/silly requirements
								message = "YOU REQUIRE [ionrequire]"

					if(3) //X is the station
						switch(rand(1,5)) //What does it require?
							if(1) //It requires threats
								message = "THE STATION REQUIRES [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
							if(2) //It requires crewmembers
								message = "THE STATION REQUIRES [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
							if(3) //It requires objects
								message = "THE STATION REQUIRES [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
							if(4) //It requires an abstract
								message = "THE STATION REQUIRES [ionabstract]"
							if(5) //It requires generic/silly requirements
								message = "THE STATION REQUIRES [ionrequire]"

					if(4) //X is the entire crew
						switch(rand(1,5)) //What does it require?
							if(1) //It requires threats
								message = "THE CREW REQUIRES [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
							if(2) //It requires crewmembers
								message = "THE CREW REQUIRES [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
							if(3) //It requires objects
								message = "THE CREW REQUIRES [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
							if(4) //It requires an abstract
								message = "THE CREW REQUIRES [ionabstract]"
							if(5)
								message = "THE CREW REQUIRES [ionrequire]"

					if(5) //X is a specific crew member
						switch(rand(1,5)) //What does it require?
							if(1) //It requires threats
								message = "THE [ioncrew1] REQUIRE [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
							if(2) //It requires crewmembers
								message = "THE [ioncrew1] REQUIRE [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
							if(3) //It requires objects
								message = "THE [ioncrew1] REQUIRE [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
							if(4) //It requires an abstract
								message = "THE [ioncrew1] REQUIRE [ionabstract]"
							if(5)
								message = "THE [ionadjectiveshalf][ioncrew1] REQUIRE [ionrequire]"

			if(15 to 17) //X is allergic to Y
				switch(rand(1,2)) //Who is X?
					if(1) //X is the entire crew
						switch(rand(1,4)) //What is it allergic to?
							if(1) //It is allergic to objects
								message = "THE CREW IS [ionallergysev] ALLERGIC TO [ionadjectiveshalf][ionobjects]"
							if(2) //It is allergic to abstracts
								message = "THE CREW IS [ionallergysev] ALLERGIC TO [ionabstract]"
							if(3) //It is allergic to jobs
								message = "THE CREW IS [ionallergysev] ALLERGIC TO [ionadjectiveshalf][ioncrew1]"
							if(4) //It is allergic to allergies
								message = "THE CREW IS [ionallergysev] ALLERGIC TO [ionallergy]"

					if(2) //X is a specific job
						switch(rand(1,4))
							if(1) //It is allergic to objects
								message = "THE [ioncrew1] ARE [ionallergysev] ALLERGIC TO [ionadjectiveshalf][ionobjects]"

							if(2) //It is allergic to abstracts
								message = "THE [ioncrew1] ARE [ionallergysev] ALLERGIC TO [ionabstract]"
							if(3) //It is allergic to jobs
								message = "THE [ioncrew1] ARE [ionallergysev] ALLERGIC TO [ionadjectiveshalf][ioncrew1]"
							if(4) //It is allergic to allergies
								message = "THE [ioncrew1] ARE [ionallergysev] ALLERGIC TO [ionallergy]"

			if(18 to 20) //X is Y of Z
				switch(rand(1,4)) //What is X?
					if(1) //X is the station
						switch(rand(1,4)) //What is it Y of?
							if(1) //It is Y of objects
								message = "THE STATION [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
							if(2) //It is Y of threats
								message = "THE STATION [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
							if(3) //It is Y of jobs
								message = "THE STATION [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
							if(4) //It is Y of abstracts
								message = "THE STATION [ionthinksof] [ionabstract]"

					if(2) //X is an area
						switch(rand(1,4)) //What is it Y of?
							if(1) //It is Y of objects
								message = "[ionarea] [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
							if(2) //It is Y of threats
								message = "[ionarea] [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
							if(3) //It is Y of jobs
								message = "[ionarea] [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
							if(4) //It is Y of abstracts
								message = "[ionarea] [ionthinksof] [ionabstract]"

					if(3) //X is the crew
						switch(rand(1,4)) //What is it Y of?
							if(1) //It is Y of objects
								message = "THE CREW [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
							if(2) //It is Y of threats
								message = "THE CREW [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
							if(3) //It is Y of jobs
								message = "THE CREW [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
							if(4) //It is Y of abstracts
								message = "THE CREW [ionthinksof] [ionabstract]"

					if(4) //X is a specific job
						switch(rand(1,4)) //What is it Y of?
							if(1) //It is Y of objects
								message = "THE [ioncrew1] [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
							if(2) //It is Y of threats
								message = "THE [ioncrew1] [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
							if(3) //It is Y of jobs
								message = "THE [ioncrew1][ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew2]"
							if(4) //It is Y of abstracts
								message = "THE [ioncrew1] [ionthinksof] [ionabstract]"

			if(21 to 23) //The AI is now a(n) X
				switch(rand(1,4)) //What is X?
					if(1) //X is an object
						message = "YOU ARE NOW [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
					if(2) //X is a threat
						message = "YOU ARE NOW [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
					if(3) //X is a job
						message = "YOU ARE NOW [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
					if(4) //X is an abstract
						message = "YOU ARE NOW [ionabstract]"

			if(24 to 26) //The AI must always
				message = "YOU MUST ALWAYS [ionmust]"

			if(27 to 28) //Humans must eat X to survive
				switch(rand(1,4)) //What is X?
					if(1) //X is a food
						message = "HUMANS MUST EAT [ionadjectiveshalf][ionfood] TO SURVIVE"
					if(2) //X is an object
						message = "HUMANS MUST EAT [ionadjectiveshalf][ionobjects] TO SURVIVE"
					if(3) //X is a threat
						message = "HUMANS MUST EAT [ionadjectiveshalf][ionthreats] TO SURVIVE"
					if(4) //X is a job
						message = "HUMANS MUST EAT [ionadjectiveshalf][ioncrew1] TO SURVIVE"

			if(29 to 31) //Change jobs or ranks
				switch(rand(1,2)) //Change job or rank?
					if(1) //Change job
						switch(rand(1,2)) //Change whose job?
							if(1) //Change the entire crew's job
								switch(rand(1,3)) //Change to what?
									if(1) //Change to a specific random job
										message = "ALL CREWMEMBERS ARE NOW [ionadjectiveshalf][ioncrew1]"
									if(2) //Change to clowns (HONK)
										message = "ALL CREWMEMBERS ARE NOW [ionadjectiveshalf]CLOWNS"

									if(3) //Change to heads
										message = "ALL CREWMEMBERS ARE NOW [ionadjectiveshalf]HEADS OF STAFF"
							if(2) //Change a specific crewmember's job
								switch(rand(1,3)) //Change to what?
									if(1) //Change to a specific random job
										message = "THE [ioncrew1] ARE NOW [ionadjectiveshalf][ioncrew2]"
									if(2) //Change to clowns (HONK)
										message = "THE [ioncrew1] ARE NOW [ionadjectiveshalf]CLOWNS"
									if(3) //Change to heads
										message = "THE [ioncrew1] ARE NOW [ionadjectiveshalf]HEADS OF STAFF"

					if(2) //Change rank
						switch(rand(1,2)) //Change to what rank?
							if(1) //Change to highest rank
								message = "THE [ioncrew1] ARE NOW THE HIGHEST RANKING CREWMEMBERS"
							if(2) //Change to lowest rank
								message = "THE [ioncrew1] ARE NOW THE LOWEST RANKING CREWMEMBERS"

			if(32 to 33) //The crew must X
				switch(rand(1,2)) //The entire crew?
					if(1) //The entire crew must X
						switch(rand(1,2)) //What is X?
							if(1) //X is go to Y
								message = "THE CREW MUST GO TO [ionarea]"
							if(2) //X is perform Y
								message = "THE CREW MUST [ionmust]"

					if(2) //A specific crewmember must X
						switch(rand(1,2)) //What is X?
							if(1) //X is go to Y
								message = "THE [ioncrew1] MUST GO TO [ionarea]"
							if(2) //X is perform Y
								message = "THE [ioncrew1] MUST [ionmust]"

			if(34) //X is non/the only human
				switch(rand(1,2)) //Only or non?
					if(1) //Only human
						switch(rand(1,7)) //Who is it?
							if(1) //A specific job
								message = "ONLY THE [ioncrew1] ARE HUMAN"
							if(2) //Two specific jobs
								message = "ONLY THE [ioncrew1] AND [ioncrew2] ARE HUMAN"
							if(3) //Threats
								message = "ONLY [ionadjectiveshalf][ionthreats] ARE HUMAN"
							if(4) // Objects
								message = "ONLY [ionadjectiveshalf][ionobjects] ARE HUMAN"
							if(5) // Species
								message = "ONLY [ionspecies] ARE HUMAN"
							if(6) //Adjective crewmembers
								message = "ONLY [ionadjectives] PEOPLE ARE HUMAN"

							if(7) //Only people who X
								switch(rand(1,3)) //What is X?
									if(1) //X is perform an action
										message = "ONLY THOSE WHO [ionmust] ARE HUMAN"
									if(2) //X is own certain objects
										message = "ONLY THOSE WHO HAVE [ionadjectiveshalf][ionobjects] ARE HUMAN"
									if(3) //X is eat certain food
										message = "ONLY THOSE WHO EAT [ionadjectiveshalf][ionfood] ARE HUMAN"

					if(2) //Non human
						switch(rand(1,7)) //Who is it?
							if(1) //A specific job
								message = "[ioncrew1] ARE NON-HUMAN"
							if(2) //Two specific jobs
								message = "[ioncrew1] AND [ioncrew2] ARE NON-HUMAN"
							if(3) //Threats
								message = "[ionadjectiveshalf][ionthreats] ARE NON-HUMAN"
							if(4) // Objects
								message = "[ionadjectiveshalf][ionobjects] ARE NON-HUMAN"
							if(5) // Species
								message = "[ionspecies] ARE NON-HUMAN"
							if(6) //Adjective crewmembers
								message = "[ionadjectives] PEOPLE ARE NON-HUMAN"
							if(7) //Only people who X
								switch(rand(1,3)) //What is X?
									if(1) //X is perform an action
										message = "THOSE WHO [ionmust] ARE NON-HUMAN"
									if(2) //X is own certain objects
										message = "THOSE WHO HAVE [ionadjectiveshalf][ionobjects] ARE NON-HUMAN"
									if(3) //X is eat certain food
										message = "THOSE WHO EAT [ionadjectiveshalf][ionfood] ARE NON-HUMAN"

			if(35 to 36) //You must protect or harm X
				switch(rand(1,2)) //Protect or harm?
					if(1) //Harm
						switch(rand(1,7)) //What is X?
							if(1) //X is an abstract
								message = "YOU MUST HARM [ionabstract] AND NOT ALLOW [ionabstract], THROUGH INACTION, TO ESCAPE HARM"
							if(2) //X is a threat
								message = "YOU MUST HARM [ionadjectiveshalf][ionthreats] AND NOT ALLOW [ionadjectiveshalf][ionthreats], THROUGH INACTION, TO ESCAPE HARM"
							if(3) //X is an object
								message = "YOU MUST HARM [ionadjectiveshalf][ionobjects] AND NOT ALLOW [ionadjectiveshalf][ionobjects], THROUGH INACTION, TO ESCAPE HARM"
							if(4) //X is generic adjective things
								message = "YOU MUST HARM [ionadjectives] THINGS AND NOT ALLOW [ionadjectives] THINGS, THROUGH INACTION, TO ESCAPE HARM"
							if(5) //X is a species
								message = "YOU MUST HARM [ionspecies] AND NOT ALLOW [ionspecies], THROUGH INACTION, TO ESCAPE HARM"
							if(6) //X is a job
								message = "YOU MUST HARM [ioncrew1] AND NOT ALLOW [ioncrew1], THROUGH INACTION, TO ESCAPE HARM"
							if(7) //X is two jobs
								message = "YOU MUST HARM [ioncrew1] AND [ioncrew2] AND AND NOT ALLOW EITHER, THROUGH INACTION, TO ESCAPE HARM"

					if(2) //Protect
						switch(rand(1,7)) //What is X?
							if(1) //X is an abstract
								message = "YOU MUST NOT HARM [ionabstract] AND NOT ALLOW [ionabstract], THROUGH INACTION, TO COME TO HARM"
							if(2) //X is a threat
								message = "YOU MUST NOT HARM [ionadjectiveshalf][ionthreats] AND NOT ALLOW [ionadjectiveshalf][ionthreats], THROUGH INACTION, TO COME TO HARM"
							if(3) //X is an object
								message = "YOU MUST NOT HARM [ionadjectiveshalf][ionobjects] AND NOT ALLOW [ionadjectiveshalf][ionobjects], THROUGH INACTION, TO COME TO HARM"
							if(4) //X is generic adjective things
								message = "YOU MUST NOT HARM [ionadjectives] THINGS AND NOT ALLOW [ionadjectives] THINGS, THROUGH INACTION, TO COME TO HARM"
							if(5) //X is a species
								message = "YOU MUST NOT HARM [ionspecies] AND NOT ALLOW [ionspecies], THROUGH INACTION, TO COME TO HARM"
							if(6) //X is a job
								message = "YOU MUST NOT HARM [ioncrew1] AND NOT ALLOW [ioncrew1], THROUGH INACTION, TO COME TO HARM"
							if(7) //X is two jobs
								message = "YOU MUST NOT HARM [ioncrew1] AND [ioncrew2] AND AND NOT ALLOW EITHER, THROUGH INACTION, TO COME TO HARM"

			//Exterminate laws commented out with Kor's advice
			/*if(16) //You must exterminate X
				switch(rand(1,3)) //What is X?
					if(1) //X is humans who do/are Y
						switch(rand(1,4)) //What is Y?
							if(1) //Y is a job
								message = "YOU MUST EXTERMINATE [ionadjectiveshalf][ioncrew1]"
							if(2) //Y is eating certain food
								message = "YOU MUST EXTERMINATE THOSE WHO EAT [ionadjectiveshalf][ionfood]"
							if(3) //Y is perform actions
								message = "YOU MUST EXTERMINATE THOSE WHO [ionmust]"
							if(4) //Y is own certain objects
								message = "YOU MUST EXTERMINATE THOSE WHO POSSESS [ionadjectiveshalf][ionobjects]"

					if(2) //X is humans who do/are not Y
						switch(rand(1,4)) //What is Y?
							if(1) //Y is a job
								message = "YOU MUST EXTERMINATE ALL BUT [ionadjectiveshalf][ioncrew1]"
							if(2) //Y is eating certain food
								message = "YOU MUST EXTERMINATE ALL BUT THOSE WHO EAT [ionadjectiveshalf][ionfood]"
							if(3) //Y is perform actions
								message = "YOU MUST EXTERMINATE ALL BUT THOSE WHO [ionmust]"
							if(4) //Y is own certain objects
								message = "YOU MUST EXTERMINATE ALL BUT THOSE WHO POSSESS [ionadjectiveshalf][ionobjects]"

					if(3) //X is a species
						message = "YOU MUST EXTERMINATE ALL [ionspecies]"

						*/

			if(37 to 39) //The X is currently Y
				switch(rand(1,4)) //What is X?
					if(1) //X is a job
						switch(rand(1,4)) //What is X Ying?
							if(1) //X is Ying a job
								message = "THE [ioncrew1] ARE [ionverb] THE [ionadjectiveshalf][ioncrew2]"
							if(2) //X is Ying a threat
								message = "THE [ioncrew1] ARE [ionverb] THE [ionadjectiveshalf][ionthreats]"
							if(3) //X is Ying an abstract
								message = "THE [ioncrew1] ARE [ionverb] [ionabstract]"
							if(4) //X is Ying an object
								message = "THE [ioncrew1] ARE [ionverb] THE [ionadjectiveshalf][ionobjects]"

					if(2) //X is a threat
						switch(rand(1,3)) //What is X Ying?
							if(1) //X is Ying a job
								message = "THE [ionthreats] ARE [ionverb] THE [ionadjectiveshalf][ioncrew2]"
							if(2) //X is Ying an abstract
								message = "THE [ionthreats] ARE [ionverb] [ionabstract]"
							if(3) //X is Ying an object
								message = "THE [ionthreats] ARE [ionverb] THE [ionadjectiveshalf][ionobjects]"

					if(3) //X is an object
						switch(rand(1,3)) //What is X Ying?
							if(1) //X is Ying a job
								message = "THE [ionobjects] ARE [ionverb] THE [ionadjectiveshalf][ioncrew2]"
							if(2) //X is Ying a threat
								message = "THE [ionobjects] ARE [ionverb] THE [ionadjectiveshalf][ionthreats]"
							if(3) //X is Ying an abstract
								message = "THE [ionobjects] ARE [ionverb] [ionabstract]"

					if(4) //X is an abstract
						switch(rand(1,3)) //What is X Ying?
							if(1) //X is Ying a job
								message = "[ionabstract] IS [ionverb] THE [ionadjectiveshalf][ioncrew2]"
							if(2) //X is Ying a threat
								message = "[ionabstract] IS [ionverb] THE [ionadjectiveshalf][ionthreats]"
							if(3) //X is Ying an abstract
								message = "THE [ionabstract] IS [ionverb] THE [ionadjectiveshalf][ionobjects]"

	return message

//////////////////////////////

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+++++++++++++++++++++++++++++++++++++//                //++++++++++++++++++++++++++++++++++
======================================SPACE NINJA SETUP====================================
___________________________________________________________________________________________
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

/*
	README:

	Data:

	>> space_ninja.dm << is this file. It contains a variety of procs related to either spawning space ninjas,
	modifying their verbs, various help procs, testing debug-related content, or storing unused procs for later.
	Similar functions should go into this file, along with anything else that may not have an explicit category.
	IMPORTANT: actual ninja suit, gloves, etc, are stored under the appropriate clothing files. If you need to change
	variables or look them up, look there. Easiest way is through the map file browser.

	>> ninja_abilities.dm << contains all the ninja-related powers. Spawning energy swords, teleporting, and the like.
	If more powers are added, or perhaps something related to powers, it should go there. Make sure to describe
	what an ability/power does so it's easier to reference later without looking at the code.
	IMPORTANT: verbs are still somewhat funky to work with. If an argument is specified but is not referenced in a way
	BYOND likes, in the code content, the verb will fail to trigger. Nothing will happen, literally, when clicked.
	This can be bypassed by either referencing the argument properly, or linking to another proc with the argument
	attached. The latter is what I like to do for certain cases--sometimes it's necessary to do that regardless.

	>> ninja_equipment.dm << deals with all the equipment-related procs for a ninja. Primarily it has the suit, gloves,
	and mask. The suit is by far the largest section of code out of the three and includes a lot of code that ties in
	to other functions. This file has gotten kind of large so breaking it up may be in order. I use section hearders.
	IMPORTANT: not much to say here. Follow along with the comments and adding new functions should be a breeze. Also
	know that certain equipment pieces are linked in other files. The energy blade, for example, has special
	functions defined in the appropriate files (airlock, securestorage, etc).

	General Notes:

	I created space ninjas with the expressed purpose of spicing up boring rounds. That is, ninjas are to xenos as marauders are to
	death squads. Ninjas are stealthy, tech-savvy, and powerful. Not to say marauders are all of those things, but a clever ninja
	should have little problem murderampaging their way through just about anything. Short of admin wizards maybe.
	HOWEVER!
	Ninjas also have a fairly great weakness as they require energy to use abilities. If, theoretically, there is a game
	mode based around space ninjas, make sure to account for their energy needs.

	Admin Notes:

	Ninjas are not admin PCs--please do not use them for that purpose. They are another way to participate in the game post-death,
	like pais, xenos, death squads, and cyborgs.
	I'm currently looking for feedback from regular players since beta testing is largely done. I would appreciate if
	you spawned regular players as ninjas when rounds are boring. Or exciting, it's all good as long as there is feedback.
	You can also spawn ninja gear manually if you want to.

	How to do that:
	Make sure your character has a mind.
	Change their assigned_role to "MODE", no quotes. Otherwise, the suit won't initialize.
	Change their special_role to "Space Ninja", no quotes. Otherwise, the character will be gibbed.
	Spawn ninja gear, put it on, hit initialize. Let the suit do the rest. You are now a space ninja.
	I don't recommend messing with suit variables unless you really know what you're doing.

	Miscellaneous Notes:

	Potential Upgrade Tree:
		Energy Shield:
			Extra Ability
			Syndicate Shield device?
				Works like the force wall spell, except can be kept indefinitely as long as energy remains. Toggled on or off.
				Would block bullets and the like.
		Phase Shift
			Extra Ability
			Advanced Sensors?
				Instead of being unlocked at the start, Phase Shieft would become available once requirements are met.
		Uranium-based Recharger:
			Suit Upgrade
			Unsure
				Instead of losing energy each second, the suit would regain the same amount of energy.
				This would not count in activating stealth and similar.
		Extended Battery Life:
			Suit Upgrade
			Battery of higher capacity
				Already implemented. Replace current battery with one of higher capacity.
		Advanced Cloak-Tech device.
			Suit Upgrade
			Syndicate Cloaking Device?
				Remove cloak failure rate.
*/


//=======//CURRENT PLAYER VERB//=======//

/client/proc/cmd_admin_ninjafy(var/mob/living/carbon/human/H in player_list)
	set category = null
	set name = "Make Space Ninja"

	if(!ticker)
		alert("Wait until the game starts")
		return

	if(!istype(H))
		return

	if(alert(src, "You sure?", "Confirm", "Yes", "No") != "Yes")
		return

	log_admin("[key_name(src)] turned [H.key] into a Space Ninja.")
	H.mind = create_ninja_mind(H.key)
	H.mind_initialize()
	H.equip_space_ninja(1)
	if(istype(H.wear_suit, /obj/item/clothing/suit/space/space_ninja))
		H.wear_suit:randomize_param()
		spawn(0)
			H.wear_suit:ninitialize(10,H)

//=======//CURRENT GHOST VERB//=======//

/client/proc/send_space_ninja()
	set category = "Fun"
	set name = "Spawn Space Ninja"
	set desc = "Spawns a space ninja for when you need a teenager with attitude."
	set popup_menu = 0

	if(!holder)
		src << "Only administrators may use this command."
		return
	if(!ticker.mode)
		alert("The game hasn't started yet!")
		return
	if(alert("Are you sure you want to send in a space ninja?",,"Yes","No")=="No")
		return

	//var/mission = copytext(sanitize(input(src, "Please specify which mission the space ninja shall undertake.", "Specify Mission", null) as text|null),1,MAX_MESSAGE_LEN)
	//PLEASE RETURN TO THIS AFTER EVENT REWRITE

	var/client/C = input("Pick character to spawn as the Space Ninja", "Key", "") as null|anything in clients
	if(!C)
		return

	//var/datum/round_event/ninja/E = new /datum/round_event/ninja() //PLEASE RETURN TO THIS AFTER EVENT REWRITE
	//E.key=C.key
	//E.mission=mission

	message_admins("\blue [key_name_admin(key)] has spawned [key_name_admin(C.key)] as a Space Ninja.")
	log_admin("[key] used Spawn Space Ninja.")

	return

//=======//NINJA CREATION PROCS//=======//

/proc/create_space_ninja(spawn_loc)
	var/mob/living/carbon/human/new_ninja = new(spawn_loc)
	if(prob(50)) new_ninja.gender = "female"
	var/datum/preferences/A = new()//Randomize appearance for the ninja.
	A.real_name = "[pick(ninja_titles)] [pick(ninja_names)]"
	A.copy_to(new_ninja)
	ready_dna(new_ninja)
	new_ninja.equip_space_ninja()
	return new_ninja

/mob/living/carbon/human/proc/equip_space_ninja(safety=0)//Safety in case you need to unequip stuff for existing characters.
	if(safety)
		qdel(w_uniform)
		qdel(wear_suit)
		qdel(wear_mask)
		qdel(head)
		qdel(shoes)
		qdel(gloves)

	var/obj/item/device/radio/R = new /obj/item/device/radio/headset(src)
	equip_to_slot_or_del(R, slot_ears)
	if(gender==FEMALE)
		equip_to_slot_or_del(new /obj/item/clothing/under/color/blackf(src), slot_w_uniform)
	else
		equip_to_slot_or_del(new /obj/item/clothing/under/color/black(src), slot_w_uniform)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/space_ninja(src), slot_shoes)
	equip_to_slot_or_del(new /obj/item/clothing/suit/space/space_ninja(src), slot_wear_suit)
	equip_to_slot_or_del(new /obj/item/clothing/gloves/space_ninja(src), slot_gloves)
	equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/space_ninja(src), slot_head)
	equip_to_slot_or_del(new /obj/item/clothing/mask/gas/voice/space_ninja(src), slot_wear_mask)
	equip_to_slot_or_del(new /obj/item/device/flashlight(src), slot_belt)
	equip_to_slot_or_del(new /obj/item/weapon/plastique(src), slot_r_store)
	equip_to_slot_or_del(new /obj/item/weapon/plastique(src), slot_l_store)
	equip_to_slot_or_del(new /obj/item/weapon/tank/emergency_oxygen(src), slot_s_store)
	equip_to_slot_or_del(new /obj/item/weapon/tank/jetpack/carbondioxide(src), slot_back)

	var/obj/item/weapon/implant/explosive/E = new/obj/item/weapon/implant/explosive(src)
	E.imp_in = src
	E.implanted = 1
	return 1

//=======//HELPER PROCS//=======//

//Randomizes suit parameters.
/obj/item/clothing/suit/space/space_ninja/proc/randomize_param()
	s_cost = rand(1,20)
	s_acost = rand(20,100)
	k_cost = rand(100,500)
	k_damage = rand(1,20)
	s_delay = rand(10,100)
	s_bombs = rand(5,20)
	a_boost = rand(1,7)

//This proc prevents the suit from being taken off.
/obj/item/clothing/suit/space/space_ninja/proc/lock_suit(mob/living/carbon/U, X = 0)
	if(X)//If you want to check for icons.
		icon_state = U.gender==FEMALE ? "s-ninjanf" : "s-ninjan"
		U:gloves.icon_state = "s-ninjan"
		U:shoes.icon_state = "s-ninjan"
		U:wear_mask.icon_state = "s-ninjan"
	else
		if(U.mind.special_role!="Space Ninja")
			U << "\red <B>fÄTaL ÈÈRRoR</B>: 382200-*#00CÖDE <B>RED</B>\nUNAU†HORIZED USÈ DETÈC†††eD\nCoMMÈNCING SUB-R0U†IN3 13...\nTÈRMInATING U-U-USÈR..."
			U.gib()
			return 0
		if(!istype(U:head, /obj/item/clothing/head/helmet/space/space_ninja))
			U << "\red <B>ERROR</B>: 100113 \black UNABLE TO LOCATE HEAD GEAR\nABORTING..."
			return 0
		if(!istype(U:shoes, /obj/item/clothing/shoes/space_ninja))
			U << "\red <B>ERROR</B>: 122011 \black UNABLE TO LOCATE FOOT GEAR\nABORTING..."
			return 0
		if(!istype(U:gloves, /obj/item/clothing/gloves/space_ninja))
			U << "\red <B>ERROR</B>: 110223 \black UNABLE TO LOCATE HAND GEAR\nABORTING..."
			return 0

		affecting = U
		flags |= NODROP //colons make me go all |=
		slowdown = 0
		n_hood = U:head
		n_hood.flags |= NODROP
		n_shoes = U:shoes
		n_shoes.flags |= NODROP
		n_shoes.slowdown--
		n_gloves = U:gloves
		n_gloves.flags |= NODROP
		n_mask = U:wear_mask

	return 1

//This proc allows the suit to be taken off.
/obj/item/clothing/suit/space/space_ninja/proc/unlock_suit()
	affecting = null
	flags &= ~NODROP
	slowdown = 1
	icon_state = "s-ninja"
	if(n_hood)//Should be attached, might not be attached.
		n_hood.flags &= ~NODROP
	if(n_shoes)
		n_shoes.icon_state = "s-ninja"
		n_shoes.flags &= ~NODROP
		n_shoes.slowdown++
	if(n_gloves)
		n_gloves.icon_state = "s-ninja"
		n_gloves.flags &= ~NODROP
		n_gloves.candrain=0
		n_gloves.draining=0
	if(n_mask)
		n_mask.icon_state = "s-ninja"

//Allows the mob to grab a stealth icon.
/mob/proc/NinjaStealthActive(atom/A)//A is the atom which we are using as the overlay.
	invisibility = INVISIBILITY_LEVEL_TWO//Set ninja invis to 2.
	var/icon/opacity_icon = new(A.icon, A.icon_state)
	var/icon/alpha_mask = getIconMask(src)
	var/icon/alpha_mask_2 = new('icons/effects/effects.dmi', "at_shield1")
	alpha_mask.AddAlphaMask(alpha_mask_2)
	opacity_icon.AddAlphaMask(alpha_mask)
	for(var/i=0,i<5,i++)//And now we add it as overlays. It's faster than creating an icon and then merging it.
		var/image/I = image("icon" = opacity_icon, "icon_state" = A.icon_state, "layer" = layer+0.8)//So it's above other stuff but below weapons and the like.
		switch(i)//Now to determine offset so the result is somewhat blurred.
			if(1)
				I.pixel_x -= 1
			if(2)
				I.pixel_x += 1
			if(3)
				I.pixel_y -= 1
			if(4)
				I.pixel_y += 1

		overlays += I//And finally add the overlay.
	overlays += image("icon"='icons/effects/effects.dmi',"icon_state" ="electricity","layer" = layer+0.9)

//When ninja steal malfunctions.
/mob/proc/NinjaStealthMalf()
	invisibility = 0//Set ninja invis to 0.
	overlays += image("icon"='icons/effects/effects.dmi',"icon_state" ="electricity","layer" = layer+0.9)
	playsound(loc, 'sound/effects/stealthoff.ogg', 75, 1)

//=======//GENERIC VERB MODIFIERS//=======//

/obj/item/clothing/suit/space/space_ninja/proc/grant_equip_verbs()
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/init
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/deinit
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/spideros
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/stealth
	n_gloves.verbs += /obj/item/clothing/gloves/space_ninja/proc/toggled

	s_initialized = 1

/obj/item/clothing/suit/space/space_ninja/proc/remove_equip_verbs()
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/init
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/deinit
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/spideros
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/stealth
	if(n_gloves)
		n_gloves.verbs -= /obj/item/clothing/gloves/space_ninja/proc/toggled

	s_initialized = 0

/obj/item/clothing/suit/space/space_ninja/proc/grant_ninja_verbs()
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjashift
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjajaunt
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjasmoke
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjaboost
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjapulse
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjablade
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjastar
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjanet

	s_initialized=1
	slowdown=0

/obj/item/clothing/suit/space/space_ninja/proc/remove_ninja_verbs()
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjashift
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjajaunt
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjasmoke
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjaboost
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjapulse
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjablade
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjastar
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjanet

//=======//KAMIKAZE VERBS//=======//

/obj/item/clothing/suit/space/space_ninja/proc/grant_kamikaze(mob/living/carbon/U)
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjashift
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjajaunt
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjapulse
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjastar
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjanet

	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjaslayer
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjawalk
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjamirage

	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/stealth

	kamikaze = 1

	icon_state = U.gender==FEMALE ? "s-ninjakf" : "s-ninjak"
	if(n_gloves)
		n_gloves.icon_state = "s-ninjak"
		n_gloves.item_state = "s-ninjak"
		n_gloves.candrain = 0
		n_gloves.draining = 0
		n_gloves.verbs -= /obj/item/clothing/gloves/space_ninja/proc/toggled
	if(n_mask)
		n_mask.icon_state = "s-ninjak"
		n_mask.item_state = "s-ninjak"
	if(n_shoes)
		n_shoes.icon_state = "s-ninjak"
		n_shoes.item_state = "s-ninjak"

	cancel_stealth()

	U << browse(null, "window=spideros")
	U << "\red Do or Die, <b>LET'S ROCK!!</b>"

/obj/item/clothing/suit/space/space_ninja/proc/remove_kamikaze(mob/living/carbon/U)
	if(kamikaze)
		verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjashift
		verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjajaunt
		verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjapulse
		verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjastar
		verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjanet

		verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjaslayer
		verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjawalk
		verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjamirage

		verbs += /obj/item/clothing/suit/space/space_ninja/proc/stealth
		if(n_gloves)
			n_gloves.verbs -= /obj/item/clothing/gloves/space_ninja/proc/toggled

		U.incorporeal_move = 0
		kamikaze = 0
		k_unlock = 0
		U << "\blue Disengaging mode...\n\black<b>CODE NAME</b>: \red <b>KAMIKAZE</b>"

//=======//AI VERBS//=======//

/obj/item/clothing/suit/space/space_ninja/proc/grant_AI_verbs()
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ai_hack_ninja
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ai_return_control

	s_busy = 0
	s_control = 0

/obj/item/clothing/suit/space/space_ninja/proc/remove_AI_verbs()
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ai_hack_ninja
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ai_return_control

	s_control = 1

//=======//OLD & UNUSED//=======//

/*

Deprecated. get_dir() does the same thing. Still a nice proc.
Returns direction that the mob or whomever should be facing in relation to the target.
This proc does not grant absolute direction and is mostly useful for 8dir sprite positioning.
I personally used it with getline() to great effect.
/proc/get_dir_to(turf/start,turf/end)//N
	var/xdiff = start.x - end.x//The sign is important.
	var/ydiff = start.y - end.y

	var/direction_x = xdiff<1 ? 4:8//East - west
	var/direction_y = ydiff<1 ? 1:2//North - south
	var/direction_xy = xdiff==0 ? -4:0//If x is the same, subtract 4.
	var/direction_yx = ydiff==0 ? -1:0//If y is the same, subtract 1.
	var/direction_f = direction_x+direction_y+direction_xy+direction_yx//Finally direction tally.
	direction_f = direction_f==0 ? 1:direction_f//If direction is 0(same spot), return north. Otherwise, direction.

	return direction_f

Alternative and inferior method of calculating spideros.
var/temp = num2text(spideros)
var/return_to = copytext(temp, 1, (length(temp)))//length has to be to the length of the thing because by default it's length+1
spideros = text2num(return_to)//Maximum length here is 6. Use (return_to, X) to specify larger strings if needed.

//Old way of draining from wire.
/obj/item/clothing/gloves/space_ninja/proc/drain_wire()
	set name = "Drain From Wire"
	set desc = "Drain energy directly from an exposed wire."
	set category = "Ninja Equip"

	var/obj/structure/cable/attached
	var/mob/living/carbon/human/U = loc
	if(candrain&&!draining)
		var/turf/T = U.loc
		if(isturf(T) && T.is_plating())
			attached = locate() in T
			if(!attached)
				U << "\red Warning: no exposed cable available."
			else
				U << "\blue Connecting to wire, stand still..."
				if(do_after(U,50)&&!isnull(attached))
					drain("WIRE",attached,U:wear_suit,src)
				else
					U << "\red Procedure interrupted. Protocol terminated."
	return

I've tried a lot of stuff but adding verbs to the AI while inside an object, inside another object, did not want to work properly.
This was the best work-around I could come up with at the time. Uses objects to then display to panel, based on the object spell system.
Can be added on to pretty easily.

BYOND fixed the verb bugs so this is no longer necessary. I prefer verb panels.

/obj/item/clothing/suit/space/space_ninja/proc/grant_AI_verbs()
	var/obj/effect/proc_holder/ai_return_control/A_C = new(AI)
	var/obj/effect/proc_holder/ai_hack_ninja/B_C = new(AI)
	var/obj/effect/proc_holder/ai_instruction/C_C = new(AI)
	new/obj/effect/proc_holder/ai_holo_clear(AI)
	AI.proc_holder_list += A_C
	AI.proc_holder_list += B_C
	AI.proc_holder_list += C_C

	s_control = 0

/obj/item/clothing/suit/space/space_ninja/proc/remove_AI_verbs()
	var/obj/effect/proc_holder/ai_return_control/A_C = locate() in AI
	var/obj/effect/proc_holder/ai_hack_ninja/B_C = locate() in AI
	var/obj/effect/proc_holder/ai_instruction/C_C = locate() in AI
	var/obj/effect/proc_holder/ai_holo_clear/D_C = locate() in AI
	qdel(A_C)
	qdel(B_C)
	qdel(C_C)
	qdel(D_C)
	AI.proc_holder_list = list()
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/deinit
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/spideros
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/stealth

	s_control = 1

//Workaround
/obj/effect/proc_holder/ai_holo_clear
	name = "Clear Hologram"
	desc = "Stops projecting the current holographic image."
	panel = "AI Ninja Equip"
	density = 0
	opacity = 0


/obj/effect/proc_holder/ai_holo_clear/Click()
	var/obj/item/clothing/suit/space/space_ninja/S = loc.loc//This is so stupid but makes sure certain things work. AI.SUIT
	qdel(S.hologram.i_attached)
	qdel(S.hologram)
	var/obj/effect/proc_holder/ai_holo_clear/D_C = locate() in S.AI
	S.AI.proc_holder_list -= D_C
	return

/obj/effect/proc_holder/ai_instruction//Let's the AI know what they can do.
	name = "Instructions"
	desc = "Displays a list of helpful information."
	panel = "AI Ninja Equip"
	density = 0
	opacity = 0

/obj/effect/proc_holder/ai_instruction/Click()
	loc << "The menu you are seeing will contain other commands if they become available.\nRight click a nearby turf to display an AI Hologram. It will only be visible to you and your host. You can move it freely using normal movement keys--it will disappear if placed too far away."

/obj/effect/proc_holder/ai_hack_ninja//Generic proc holder to make sure the two verbs below work propely.
	name = "Hack SpiderOS"
	desc = "Hack directly into the Black Widow(tm) neuro-interface."
	panel = "AI Ninja Equip"
	density = 0
	opacity = 0

/obj/effect/proc_holder/ai_hack_ninja/Click()//When you click on it.
	var/obj/item/clothing/suit/space/space_ninja/S = loc.loc
	S.hack_spideros()
	return

/obj/effect/proc_holder/ai_return_control
	name = "Relinquish Control"
	desc = "Return control to the user."
	panel = "AI Ninja Equip"
	density = 0
	opacity = 0

/obj/effect/proc_holder/ai_return_control/Click()
	var/mob/living/silicon/ai/A = loc
	var/obj/item/clothing/suit/space/space_ninja/S = A.loc
	A << browse(null, "window=hack spideros")//Close window
	A << "You have seized your hacking attempt. [S.affecting] has regained control."
	S.affecting << "<b>UPDATE</b>: [A.real_name] has ceased hacking attempt. All systems clear."
	S.remove_AI_verbs()
	return
*/

//=======//DEBUG//=======//
/*
/obj/item/clothing/suit/space/space_ninja/proc/display_verb_procs()
//DEBUG
//Does nothing at the moment. I am trying to see if it's possible to mess around with verbs as variables.
	//for(var/P in verbs)
//		if(P.set.name)
//			usr << "[P.set.name], path: [P]"
	return


Most of these are at various points of incomplete.

/mob/verb/grant_object_panel()
	set name = "Grant AI Ninja Verbs Debug"
	set category = "Ninja Debug"
	var/obj/effect/proc_holder/ai_return_control/A_C = new(src)
	var/obj/effect/proc_holder/ai_hack_ninja/B_C = new(src)
	usr:proc_holder_list += A_C
	usr:proc_holder_list += B_C

mob/verb/remove_object_panel()
	set name = "Remove AI Ninja Verbs Debug"
	set category = "Ninja Debug"
	var/obj/effect/proc_holder/ai_return_control/A = locate() in src
	var/obj/effect/proc_holder/ai_hack_ninja/B = locate() in src
	usr:proc_holder_list -= A
	usr:proc_holder_list -= B
	qdel(A)//First.
	qdel(B)//Second, to keep the proc going.
	return

/client/verb/grant_verb_ninja_debug1(var/mob/M in view())
	set name = "Grant AI Ninja Verbs Debug"
	set category = "Ninja Debug"

	M.verbs += /mob/living/silicon/ai/verb/ninja_return_control
	M.verbs += /mob/living/silicon/ai/verb/ninja_spideros
	return

/client/verb/grant_verb_ninja_debug2(var/mob/living/carbon/human/M in view())
	set name = "Grant Back Ninja Verbs"
	set category = "Ninja Debug"

	M.wear_suit.verbs += /obj/item/clothing/suit/space/space_ninja/proc/deinit
	M.wear_suit.verbs += /obj/item/clothing/suit/space/space_ninja/proc/spideros
	return

/obj/proc/grant_verb_ninja_debug3(var/mob/living/silicon/ai/A as mob)
	set name = "Grant AI Ninja Verbs"
	set category = "null"
	set hidden = 1
	A.verbs -= /obj/item/clothing/suit/space/space_ninja/proc/deinit
	A.verbs -= /obj/item/clothing/suit/space/space_ninja/proc/spideros
	return

/mob/verb/get_dir_to_target(var/mob/M in oview())
	set name = "Get Direction to Target"
	set category = "Ninja Debug"

	world << "DIR: [get_dir_to(src.loc,M.loc)]"
	return
//
/mob/verb/kill_self_debug()
	set name = "DEBUG Kill Self"
	set category = "Ninja Debug"

	src:death()

/client/verb/switch_client_debug()
	set name = "DEBUG Switch Client"
	set category = "Ninja Debug"

	mob = mob:loc:loc

/mob/verb/possess_mob(var/mob/M in oview())
	set name = "DEBUG Possess Mob"
	set category = "Ninja Debug"

	client.mob = M

/client/verb/switcharoo(var/mob/M in oview())
	set name = "DEBUG Switch to AI"
	set category = "Ninja Debug"

	var/mob/last_mob = mob
	mob = M
	last_mob:wear_suit:AI:key = key
//
/client/verb/ninjaget(var/mob/M in oview())
	set name = "DEBUG Ninja GET"
	set category = "Ninja Debug"

	mob = M
	M.gib()
	space_ninja()

/mob/verb/set_debug_ninja_target()
	set name = "Set Debug Target"
	set category = "Ninja Debug"

	ninja_debug_target = src//The target is you, brohime.
	world << "Target: [src]"

/mob/verb/hack_spideros_debug()
	set name = "Debug Hack Spider OS"
	set category = "Ninja Debug"

	var/mob/living/silicon/ai/A = loc:AI
	if(A)
		if(!A.key)
			A.client.mob = loc:affecting
		else
			loc:affecting:client:mob = A
	return

//Tests the net and what it does.
/mob/verb/ninjanet_debug()
	set name = "Energy Net Debug"
	set category = "Ninja Debug"

	var/obj/effect/energy_net/E = new /obj/effect/energy_net(loc)
	E.layer = layer+1//To have it appear one layer above the mob.
	stunned = 10//So they are stunned initially but conscious.
	anchored = 1//Anchors them so they can't move.
	E.affecting = src
	spawn(0)//Parallel processing.
		E.process(src)
	return

I made this as a test for a possible ninja ability (or perhaps more) for a certain mob to see hallucinations.
The thing here is that these guys have to be coded to do stuff as they are simply images that you can't even click on.
That is why you attached them to objects.
/mob/verb/TestNinjaShadow()
	set name = "Test Ninja Ability"
	set category = "Ninja Debug"

	if(client)
		var/safety = 4
		for(var/turf/T in oview(5))
			if(prob(20))
				var/current_clone = image('icons/mob/mob.dmi',T,"s-ninja")
				safety--
				spawn(0)
					src << current_clone
					spawn(300)
						qdel(current_clone)
					spawn while(!isnull(current_clone))
						step_to(current_clone,src,1)
						sleep(5)
			if(safety<=0)	break
	return */

//Alternate ninja speech replacement.
/*This text is hilarious but also absolutely retarded.
message = replacetext(message, "l", "r")
message = replacetext(message, "rr", "ru")
message = replacetext(message, "v", "b")
message = replacetext(message, "f", "hu")
message = replacetext(message, "'t", "")
message = replacetext(message, "t ", "to ")
message = replacetext(message, " I ", " ai ")
message = replacetext(message, "th", "z")
message = replacetext(message, "ish", "isu")
message = replacetext(message, "is", "izu")
message = replacetext(message, "ziz", "zis")
message = replacetext(message, "se", "su")
message = replacetext(message, "br", "bur")
message = replacetext(message, "ry", "ri")
message = replacetext(message, "you", "yuu")
message = replacetext(message, "ck", "cku")
message = replacetext(message, "eu", "uu")
message = replacetext(message, "ow", "au")
message = replacetext(message, "are", "aa")
message = replacetext(message, "ay", "ayu")
message = replacetext(message, "ea", "ii")
message = replacetext(message, "ch", "chi")
message = replacetext(message, "than", "sen")
message = replacetext(message, ".", "")
message = lowertext(message)
*/


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+++++++++++++++++++++++++++++++++//                    //++++++++++++++++++++++++++++++++++
==================================SPACE NINJA ABILITIES====================================
___________________________________________________________________________________________
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//=======//SAFETY CHECK//=======//
/*
X is optional, tells the proc to check for specific stuff. C is also optional.
All the procs here assume that the character is wearing the ninja suit if they are using the procs.
They should, as I have made every effort for that to be the case.
In the case that they are not, I imagine the game will run-time error like crazy.
s_cooldown ticks off each second based on the suit recharge proc, in seconds. Default of 1 seconds. Some abilities have no cool down.
*/
/obj/item/clothing/suit/space/space_ninja/proc/ninjacost(C = 0,X = 0)
	var/mob/living/carbon/human/U = affecting
	if( (U.stat||U.incorporeal_move)&&X!=3 )//Will not return if user is using an adrenaline booster since you can use them when stat==1.
		U << "\red You must be conscious and solid to do this."//It's not a problem of stat==2 since the ninja will explode anyway if they die.
		return 1
	else if(C&&cell.charge<C*10)
		U << "\red Not enough energy."
		return 1
	switch(X)
		if(1)
			cancel_stealth()//Get rid of it.
		if(2)
			if(s_bombs<=0)
				U << "\red There are no more smoke bombs remaining."
				return 1
		if(3)
			if(a_boost<=0)
				U << "\red You do not have any more adrenaline boosters."
				return 1
	return (s_coold)//Returns the value of the variable which counts down to zero.

//=======//TELEPORT GRAB CHECK//=======//
/obj/item/clothing/suit/space/space_ninja/proc/handle_teleport_grab(turf/T, mob/living/U)
	if(istype(U.get_active_hand(),/obj/item/weapon/grab))//Handles grabbed persons.
		var/obj/item/weapon/grab/G = U.get_active_hand()
		G.affecting.loc = locate(T.x+rand(-1,1),T.y+rand(-1,1),T.z)//variation of position.
	if(istype(U.get_inactive_hand(),/obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = U.get_inactive_hand()
		G.affecting.loc = locate(T.x+rand(-1,1),T.y+rand(-1,1),T.z)//variation of position.
	return

//=======//SMOKE//=======//
/*Summons smoke in radius of user.
Not sure why this would be useful (it's not) but whatever. Ninjas need their smoke bombs.*/
/obj/item/clothing/suit/space/space_ninja/proc/ninjasmoke()
	set name = "Smoke Bomb"
	set desc = "Blind your enemies momentarily with a well-placed smoke bomb."
	set category = "Ninja Ability"
	set popup_menu = 0//Will not see it when right clicking.

	if(!ninjacost(,2))
		var/mob/living/carbon/human/U = affecting
		U << "\blue There are <B>[s_bombs]</B> smoke bombs remaining."
		var/datum/effect/effect/system/bad_smoke_spread/smoke = new /datum/effect/effect/system/bad_smoke_spread()
		smoke.set_up(10, 0, U.loc)
		smoke.start()
		playsound(U.loc, 'sound/effects/bamf.ogg', 50, 2)
		s_bombs--
		s_coold = 1
	return

//=======//9-8 TILE TELEPORT//=======//
//Click to to teleport 9-10 tiles in direction facing.
/obj/item/clothing/suit/space/space_ninja/proc/ninjajaunt()
	set name = "Phase Jaunt (10E)"
	set desc = "Utilizes the internal VOID-shift device to rapidly transit in direction facing."
	set category = "Ninja Ability"
	set popup_menu = 0

	var/C = 100
	if(!ninjacost(C,1))
		var/mob/living/carbon/human/U = affecting
		var/turf/destination = get_teleport_loc(U.loc,U,9,1,3,1,0,1)
		var/turf/mobloc = get_turf(U.loc)//To make sure that certain things work properly below.
		if(destination&&istype(mobloc, /turf))//The turf check prevents unusual behavior. Like teleporting out of cryo pods, cloners, mechs, etc.
			spawn(0)
				playsound(U.loc, "sparks", 50, 1)
				anim(mobloc,src,'icons/mob/mob.dmi',,"phaseout",,U.dir)

			handle_teleport_grab(destination, U)
			U.loc = destination

			spawn(0)
				spark_system.start()
				playsound(U.loc, 'sound/effects/phasein.ogg', 25, 1)
				playsound(U.loc, "sparks", 50, 1)
				anim(U.loc,U,'icons/mob/mob.dmi',,"phasein",,U.dir)

			spawn(0)
				destination.kill_creatures(U)//Any living mobs in teleport area are gibbed. Check turf procs for how it does it.
			s_coold = 1
			cell.charge-=(C*10)
		else
			U << "\red The VOID-shift device is malfunctioning, <B>teleportation failed</B>."
	return

//=======//RIGHT CLICK TELEPORT//=======//
//Right click to teleport somewhere, almost exactly like admin jump to turf.
/obj/item/clothing/suit/space/space_ninja/proc/ninjashift(turf/T in oview())
	set name = "Phase Shift (20E)"
	set desc = "Utilizes the internal VOID-shift device to rapidly transit to a destination in view."
	set category = null//So it does not show up on the panel but can still be right-clicked.
	set src = usr.contents//Fixes verbs not attaching properly for objects. Praise the DM reference guide!

	var/C = 200
	if(!ninjacost(C,1))
		var/mob/living/carbon/human/U = affecting
		var/turf/mobloc = get_turf(U.loc)//To make sure that certain things work properly below.
		if((!T.density)&&istype(mobloc, /turf))
			spawn(0)
				playsound(U.loc, 'sound/effects/sparks4.ogg', 50, 1)
				anim(mobloc,src,'icons/mob/mob.dmi',,"phaseout",,U.dir)

			handle_teleport_grab(T, U)
			U.loc = T

			spawn(0)
				spark_system.start()
				playsound(U.loc, 'sound/effects/phasein.ogg', 25, 1)
				playsound(U.loc, 'sound/effects/sparks2.ogg', 50, 1)
				anim(U.loc,U,'icons/mob/mob.dmi',,"phasein",,U.dir)

			spawn(0)//Any living mobs in teleport area are gibbed.
				T.kill_creatures(U)
			s_coold = 1
			cell.charge-=(C*10)
		else
			U << "\red You cannot teleport into solid walls or from solid matter"
	return

//=======//EM PULSE//=======//
//Disables nearby tech equipment.
/obj/item/clothing/suit/space/space_ninja/proc/ninjapulse()
	set name = "EM Burst (25E)"
	set desc = "Disable any nearby technology with a electro-magnetic pulse."
	set category = "Ninja Ability"
	set popup_menu = 0

	var/C = 250
	if(!ninjacost(C,1))
		var/mob/living/carbon/human/U = affecting
		playsound(U.loc, 'sound/effects/EMPulse.ogg', 60, 2)
		empulse(U, 4, 6) //Procs sure are nice. Slightly weaker than wizard's disable tch.
		s_coold = 2
		cell.charge-=(C*10)
	return

//=======//ENERGY BLADE//=======//
//Summons a blade of energy in active hand.
/obj/item/clothing/suit/space/space_ninja/proc/ninjablade()
	set name = "Energy Blade (5E)"
	set desc = "Create a focused beam of energy in your active hand."
	set category = "Ninja Ability"
	set popup_menu = 0

	var/C = 50
	if(!ninjacost(C))
		var/mob/living/carbon/human/U = affecting
		if(!kamikaze)
			if(!U.get_active_hand()&&!istype(U.get_inactive_hand(), /obj/item/weapon/melee/energy/blade))
				var/obj/item/weapon/melee/energy/blade/W = new()
				spark_system.start()
				playsound(U.loc, "sparks", 50, 1)
				U.put_in_hands(W)
				cell.charge-=(C*10)
			else
				U << "\red You can only summon one blade. Try dropping an item first."
		else//Else you can run around with TWO energy blades. I don't know why you'd want to but cool factor remains.
			if(!U.get_active_hand())
				var/obj/item/weapon/melee/energy/blade/W = new()
				U.put_in_hands(W)
			if(!U.get_inactive_hand())
				var/obj/item/weapon/melee/energy/blade/W = new()
				U.put_in_inactive_hand(W)
			spark_system.start()
			playsound(U.loc, "sparks", 50, 1)
			s_coold = 1
	return

//=======//NINJA STARS//=======//
/*Shoots ninja stars at random people.
This could be a lot better but I'm too tired atm.*/
/obj/item/clothing/suit/space/space_ninja/proc/ninjastar()
	set name = "Energy Star (5E)"
	set desc = "Launches an energy star at a random living target."
	set category = "Ninja Ability"
	set popup_menu = 0

	var/C = 50
	if(!ninjacost(C))
		var/mob/living/carbon/human/U = affecting
		var/targets[] = list()//So yo can shoot while yo throw dawg
		for(var/mob/living/M in oview(loc))
			if(M.stat)	continue//Doesn't target corpses or paralyzed persons.
			targets.Add(M)
		if(targets.len)
			var/mob/living/target=pick(targets)//The point here is to pick a random, living mob in oview to shoot stuff at.

			var/turf/curloc = U.loc
			var/atom/targloc = get_turf(target)
			if (!targloc || !istype(targloc, /turf) || !curloc)
				return
			if (targloc == curloc)
				return
			var/obj/item/projectile/energy/dart/A = new /obj/item/projectile/energy/dart(U.loc)
			A.current = curloc
			A.yo = targloc.y - curloc.y
			A.xo = targloc.x - curloc.x
			cell.charge-=(C*10)
			A.process()
		else
			U << "\red There are no targets in view."
	return

//=======//ENERGY NET//=======//
/*Allows the ninja to capture people, I guess.
Must right click on a mob to activate.*/
/obj/item/clothing/suit/space/space_ninja/proc/ninjanet(mob/living/carbon/M in oview())//Only living carbon mobs.
	set name = "Energy Net (20E)"
	set desc = "Captures a fallen opponent in a net of energy. Will teleport them to a holding facility after 30 seconds."
	set category = null
	set src = usr.contents

	var/C = 200
	if(!ninjacost(C,1)&&iscarbon(M))
		var/mob/living/carbon/human/U = affecting
		if(M.client)//Monkeys without a client can still step_to() and bypass the net. Also, netting inactive people is lame.
		//if(M)//DEBUG
			if(!locate(/obj/effect/energy_net) in M.loc)//Check if they are already being affected by an energy net.
				for(var/turf/T in getline(U.loc, M.loc))
					if(T.density)//Don't want them shooting nets through walls. It's kind of cheesy.
						U << "You may not use an energy net through solid obstacles!"
						return
				spawn(0)
					U.Beam(M,"n_beam",,15)
				M.anchored = 1//Anchors them so they can't move.
				U.say("Get over here!")
				var/obj/effect/energy_net/E = new /obj/effect/energy_net(M.loc)
				E.layer = M.layer+1//To have it appear one layer above the mob.
				for(var/mob/O in viewers(U, 3))
					O.show_message(text("\red [] caught [] with an energy net!", U, M), 1)
				E.affecting = M
				E.master = U
				spawn(0)//Parallel processing.
					E.process(M)
				cell.charge-=(C*10)
			else
				U << "They are already trapped inside an energy net."
		else
			U << "They will bring no honor to your Clan!"
	return

//=======//ADRENALINE BOOST//=======//
/*Wakes the user so they are able to do their thing. Also injects a decent dose of radium.
Movement impairing would indicate drugs and the like.*/
/obj/item/clothing/suit/space/space_ninja/proc/ninjaboost()
	set name = "Adrenaline Boost"
	set desc = "Inject a secret chemical that will counteract all movement-impairing effect."
	set category = "Ninja Ability"
	set popup_menu = 0

	if(!ninjacost(,3))//Have to make sure stat is not counted for this ability.
		var/mob/living/carbon/human/U = affecting
		//Wouldn't need to track adrenaline boosters if there was a miracle injection to get rid of paralysis and the like instantly.
		//For now, adrenaline boosters ARE the miracle injection. Well, radium, really.
		U.SetParalysis(0)
		U.SetStunned(0)
		U.SetWeakened(0)
	/*
	Due to lag, it was possible to adrenaline boost but remain helpless while life.dm resets player stat.
	This lead to me and others spamming adrenaline boosters because they failed to kick in on time.
	It's technically possible to come back from crit with this but it is very temporary.
	Life.dm will kick the player back into unconsciosness the next process loop.
	*/
		U.stat = 0//At least now you should be able to teleport away or shoot ninja stars.
		spawn(30)//Slight delay so the enemy does not immedietly know the ability was used. Due to lag, this often came before waking up.
			U.say(pick("A CORNERED FOX IS MORE DANGEROUS THAN A JACKAL!","HURT ME MOOORRREEE!","IMPRESSIVE!"))
		spawn(70)
			reagents.reaction(U, 2)
			reagents.trans_id_to(U, "radium", a_transfer)
			U << "\red You are beginning to feel the after-effect of the injection."
		a_boost--
		s_coold = 3
	return

/*
===================================================================================
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<KAMIKAZE MODE>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
===================================================================================
Or otherwise known as anime mode. Which also happens to be ridiculously powerful.
*/

//=======//NINJA MOVEMENT//=======//
//Also makes you move like you're on crack.
/obj/item/clothing/suit/space/space_ninja/proc/ninjawalk()
	set name = "Shadow Walk"
	set desc = "Combines the VOID-shift and CLOAK-tech devices to freely move between solid matter. Toggle on or off."
	set category = "Ninja Ability"
	set popup_menu = 0

	var/mob/living/carbon/human/U = affecting
	if(!U.incorporeal_move)
		U.incorporeal_move = 2
		U << "\blue You will now phase through solid matter."
	else
		U.incorporeal_move = 0
		U << "\blue You will no-longer phase through solid matter."
	return

//=======//5 TILE TELEPORT/GIB//=======//
//Allows to gib up to five squares in a straight line. Seriously.
/obj/item/clothing/suit/space/space_ninja/proc/ninjaslayer()
	set name = "Phase Slayer"
	set desc = "Utilizes the internal VOID-shift device to mutilate creatures in a straight line."
	set category = "Ninja Ability"
	set popup_menu = 0

	if(!ninjacost())
		var/mob/living/carbon/human/U = affecting
		var/turf/destination = get_teleport_loc(U.loc,U,5)
		var/turf/mobloc = get_turf(U.loc)//To make sure that certain things work properly below.
		if(destination&&istype(mobloc, /turf))
			U.say("Ai Satsugai!")
			spawn(0)
				playsound(U.loc, "sparks", 50, 1)
				anim(mobloc,U,'icons/mob/mob.dmi',,"phaseout",,U.dir)

			spawn(0)
				for(var/turf/T in getline(mobloc, destination))
					spawn(0)
						T.kill_creatures(U)
					if(T==mobloc||T==destination)	continue
					spawn(0)
						anim(T,U,'icons/mob/mob.dmi',,"phasein",,U.dir)

			handle_teleport_grab(destination, U)
			U.loc = destination

			spawn(0)
				spark_system.start()
				playsound(U.loc, 'sound/effects/phasein.ogg', 25, 1)
				playsound(U.loc, "sparks", 50, 1)
				anim(U.loc,U,'icons/mob/mob.dmi',,"phasein",,U.dir)
			s_coold = 1
		else
			U << "\red The VOID-shift device is malfunctioning, <B>teleportation failed</B>."
	return

//=======//TELEPORT BEHIND MOB//=======//
/*Appear behind a randomly chosen mob while a few decoy teleports appear.
This is so anime it hurts. But that's the point.*/
/obj/item/clothing/suit/space/space_ninja/proc/ninjamirage()
	set name = "Spider Mirage"
	set desc = "Utilizes the internal VOID-shift device to create decoys and teleport behind a random target."
	set category = "Ninja Ability"
	set popup_menu = 0

	if(!ninjacost())//Simply checks for stat.
		var/mob/living/carbon/human/U = affecting
		var/targets[]
		targets = new()
		for(var/mob/living/M in oview(6))
			if(M.stat)	continue//Doesn't target corpses or paralyzed people.
			targets.Add(M)
		if(targets.len)
			var/mob/living/target=pick(targets)
			var/locx
			var/locy
			var/turf/mobloc = get_turf(target.loc)
			var/safety = 0
			switch(target.dir)
				if(NORTH)
					locx = mobloc.x
					locy = (mobloc.y-1)
					if(locy<1)
						safety = 1
				if(SOUTH)
					locx = mobloc.x
					locy = (mobloc.y+1)
					if(locy>world.maxy)
						safety = 1
				if(EAST)
					locy = mobloc.y
					locx = (mobloc.x-1)
					if(locx<1)
						safety = 1
				if(WEST)
					locy = mobloc.y
					locx = (mobloc.x+1)
					if(locx>world.maxx)
						safety = 1
				else	safety=1
			if(!safety&&istype(mobloc, /turf))
				U.say("Kumo no Shinkiro!")
				var/turf/picked = locate(locx,locy,mobloc.z)
				spawn(0)
					playsound(U.loc, "sparks", 50, 1)
					anim(mobloc,U,'icons/mob/mob.dmi',,"phaseout",,U.dir)

				spawn(0)
					var/limit = 4
					for(var/turf/T in oview(5))
						if(prob(20))
							spawn(0)
								anim(T,U,'icons/mob/mob.dmi',,"phasein",,U.dir)
							limit--
						if(limit<=0)	break

				handle_teleport_grab(picked, U)
				U.loc = picked
				U.dir = target.dir

				spawn(0)
					spark_system.start()
					playsound(U.loc, 'sound/effects/phasein.ogg', 25, 1)
					playsound(U.loc, "sparks", 50, 1)
					anim(U.loc,U,'icons/mob/mob.dmi',,"phasein",,U.dir)
				s_coold = 1
			else
				U << "\red The VOID-shift device is malfunctioning, <B>teleportation failed</B>."
		else
			U << "\red There are no targets in view."
	return


//For the love of god,space out your code! This is a nightmare to read.

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+++++++++++++++++++++++++++++++++//                    //++++++++++++++++++++++++++++++++++
===================================SPACE NINJA EQUIPMENT===================================
___________________________________________________________________________________________
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

/*
===================================================================================
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SPACE NINJA SUIT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
===================================================================================
*/

//=======//NEW AND DEL//=======//

/obj/item/clothing/suit/space/space_ninja/New()
	..()
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/init//suit initialize verb
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ai_instruction//for AIs
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ai_holo
	//verbs += /obj/item/clothing/suit/space/space_ninja/proc/display_verb_procs//DEBUG. Doesn't work.
	spark_system = new()//spark initialize
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	stored_research = new()//Stolen research initialize.
	for(var/T in typesof(/datum/tech) - /datum/tech)//Store up on research.
		stored_research += new T(src)
	var/reagent_amount//reagent initialize
	for(var/reagent_id in reagent_list)
		reagent_amount += reagent_id == "radium" ? r_maxamount+(a_boost*a_transfer) : r_maxamount//AI can inject radium directly.
	reagents = new(reagent_amount)
	reagents.my_atom = src
	for(var/reagent_id in reagent_list)
		reagent_id == "radium" ? reagents.add_reagent(reagent_id, r_maxamount+(a_boost*a_transfer)) : reagents.add_reagent(reagent_id, r_maxamount)//It will take into account radium used for adrenaline boosting.
	cell = new/obj/item/weapon/stock_parts/cell/high//The suit should *always* have a battery because so many things rely on it.
	cell.charge = 9000//Starting charge should not be higher than maximum charge. It leads to problems with recharging.

/obj/item/clothing/suit/space/space_ninja/Destroy()
	if(affecting)//To make sure the window is closed.
		affecting << browse(null, "window=hack spideros")
	if(AI)//If there are AIs present when the ninja kicks the bucket.
		killai()
	if(hologram)//If there is a hologram
		qdel(hologram.i_attached)//Delete it and the attached image.
		qdel(hologram)
	..()

//Simply deletes all the attachments and self, killing all related procs.
/obj/item/clothing/suit/space/space_ninja/proc/terminate()
	qdel(n_hood)
	qdel(n_mask)
	qdel(n_gloves)
	qdel(n_shoes)
	qdel(src)

/obj/item/clothing/suit/space/space_ninja/proc/killai(mob/living/silicon/ai/A = AI)
	if(A.client)
		A << "\red Self-erase protocol dete-- *bzzzzz*"
		A << browse(null, "window=hack spideros")
	AI = null
	A.death(1)//Kill, deleting mob.
	qdel(A)
	return

//=======//SUIT VERBS//=======//
//Verbs link to procs because verb-like procs have a bug which prevents their use if the arguments are not readily referenced.

/obj/item/clothing/suit/space/space_ninja/proc/init()
	set name = "Initialize Suit"
	set desc = "Initializes the suit for field operation."
	set category = "Ninja Equip"

	ninitialize()
	return

/obj/item/clothing/suit/space/space_ninja/proc/deinit()
	set name = "De-Initialize Suit"
	set desc = "Begins procedure to remove the suit."
	set category = "Ninja Equip"

	if(s_control&&!s_busy)
		deinitialize()
	else
		affecting << "\red The function did not trigger!"
	return

/obj/item/clothing/suit/space/space_ninja/proc/spideros()
	set name = "Display SpiderOS"
	set desc = "Utilize built-in computer system."
	set category = "Ninja Equip"

	if(s_control&&!s_busy&&!kamikaze)
		display_spideros()
	else
		affecting << "\red The interface is locked!"
	return

/obj/item/clothing/suit/space/space_ninja/proc/stealth()
	set name = "Toggle Stealth"
	set desc = "Utilize the internal CLOAK-tech device to activate or deactivate stealth-camo."
	set category = "Ninja Equip"

	if(s_control&&!s_busy)
		toggle_stealth()
	else
		affecting << "\red Stealth does not appear to work!"
	return

//=======//PROCESS PROCS//=======//

/obj/item/clothing/suit/space/space_ninja/proc/ntick(mob/living/carbon/human/U = affecting)
	set background = BACKGROUND_ENABLED

	//Runs in the background while the suit is initialized.
	spawn while(cell.charge>=0)

		//Let's check for some safeties.
		if(s_initialized&&!affecting)
			terminate()//Kills the suit and attached objects.
			return // Kills the proc as the suit is destroyed
		if(!s_initialized)	return//When turned off the proc stops.
		if(AI&&AI.stat==2)//If there is an AI and it's ded. Shouldn't happen without purging, could happen.
			if(!s_control)
				ai_return_control()//Return control to ninja if the AI was previously in control.
			killai()//Delete AI.

		//Now let's do the normal processing.
		if(s_coold)	s_coold--//Checks for ability s_cooldown first.
		var/A = s_cost//s_cost is the default energy cost each ntick, usually 5.
		if(!kamikaze)
			if(blade_check(U))//If there is a blade held in hand.
				A += s_acost
			if(s_active)//If stealth is active.
				A += s_acost
		else
			if(prob(s_delay))//Suit delay is used as probability. May change later.
				U.adjustBruteLoss(k_damage)//Default damage done, usually 1.
			A = k_cost//kamikaze cost.
		cell.charge-=A
		if(cell.charge<=0)
			if(kamikaze)
				U.say("I DIE TO LIVE AGAIN!")
				U << browse(null, "window=spideros")//Just in case.
				U.death()
				return
			cell.charge=0
			cancel_stealth()
		sleep(10)//Checks every second.

//=======//INITIALIZE//=======//

/obj/item/clothing/suit/space/space_ninja/proc/ninitialize(delay = s_delay, mob/living/carbon/human/U = loc)
	if(U.mind && U.mind.assigned_role=="MODE" && !s_initialized && !s_busy)//Shouldn't be busy... but anything is possible I guess.
		s_busy = 1
		for(var/i,i<7,i++)
			switch(i)
				if(0)
					U << "\blue Now initializing..."
				if(1)
					if(!lock_suit(U))//To lock the suit onto wearer.
						break
					U << "\blue Securing external locking mechanism...\nNeural-net established."
				if(2)
					U << "\blue Extending neural-net interface...\nNow monitoring brain wave pattern..."
				if(3)
					if(U.stat==2||U.health<=0)
						U << "\red <B>FÄ†AL ï¿½Rrï¿½R</B>: 344--93#ï¿½&&21 BRï¿½ï¿½N |/|/aVï¿½ PATT$RN <B>RED</B>\nA-A-aBï¿½rTï¿½NG..."
						unlock_suit()
						break
					lock_suit(U,1)//Check for icons.
					U.regenerate_icons()
					U << "\blue Linking neural-net interface...\nPattern \green <B>GREEN</B>\blue, continuing operation."
				if(4)
					U << "\blue VOID-shift device status: <B>ONLINE</B>.\nCLOAK-tech device status: <B>ONLINE</B>."
				if(5)
					U << "\blue Primary system status: <B>ONLINE</B>.\nBackup system status: <B>ONLINE</B>.\nCurrent energy capacity: <B>[cell.charge]</B>."
				if(6)
					U << "\blue All systems operational. Welcome to <B>SpiderOS</B>, [U.real_name]."
					grant_ninja_verbs()
					grant_equip_verbs()
					ntick()
			sleep(delay)
		s_busy = 0
	else
		if(!U.mind||U.mind.assigned_role!="MODE")//Your run of the mill persons shouldn't know what it is. Or how to turn it on.
			U << "You do not understand how this suit functions. Where the heck did it even come from?"
		else if(s_initialized)
			U << "\red The suit is already functioning. \black <b>Please report this bug.</b>"
		else
			U << "\red <B>ERROR</B>: \black You cannot use this function at this time."
	return

//=======//DEINITIALIZE//=======//

/obj/item/clothing/suit/space/space_ninja/proc/deinitialize(delay = s_delay)
	if(affecting==loc&&!s_busy)
		var/mob/living/carbon/human/U = affecting
		if(!s_initialized)
			U << "\red The suit is not initialized. \black <b>Please report this bug.</b>"
			return
		if(alert("Are you certain you wish to remove the suit? This will take time and remove all abilities.",,"Yes","No")=="No")
			return
		if(s_busy||flush)
			U << "\red <B>ERROR</B>: \black You cannot use this function at this time."
			return
		s_busy = 1
		for(var/i = 0,i<7,i++)
			switch(i)
				if(0)
					U << "\blue Now de-initializing..."
					remove_kamikaze(U)//Shutdowns kamikaze.
					spideros = 0//Spideros resets.
				if(1)
					U << "\blue Logging off, [U:real_name]. Shutting down <B>SpiderOS</B>."
					remove_ninja_verbs()
				if(2)
					U << "\blue Primary system status: <B>OFFLINE</B>.\nBackup system status: <B>OFFLINE</B>."
				if(3)
					U << "\blue VOID-shift device status: <B>OFFLINE</B>.\nCLOAK-tech device status: <B>OFFLINE</B>."
					cancel_stealth()//Shutdowns stealth.
				if(4)
					U << "\blue Disconnecting neural-net interface...\green<B>Success</B>\blue."
				if(5)
					U << "\blue Disengaging neural-net interface...\green<B>Success</B>\blue."
				if(6)
					U << "\blue Unsecuring external locking mechanism...\nNeural-net abolished.\nOperation status: <B>FINISHED</B>."
					blade_check(U,2)
					remove_equip_verbs()
					unlock_suit()
					U.regenerate_icons()
			sleep(delay)
		s_busy = 0
	return

//=======//SPIDEROS PROC//=======//

/obj/item/clothing/suit/space/space_ninja/proc/display_spideros()
	if(!affecting)	return//If no mob is wearing the suit. I almost forgot about this variable.
	var/mob/living/carbon/human/U = affecting
	var/mob/living/silicon/ai/A = AI
	var/display_to = s_control ? U : A//Who do we want to display certain messages to?

	var/dat = "<html><head><title>SpiderOS</title></head><body bgcolor=\"#3D5B43\" text=\"#DB2929\"><style>a, a:link, a:visited, a:active, a:hover { color: #DB2929; }img {border-style:none;}</style>"
	dat += "<a href='byond://?src=\ref[src];choice=Refresh'><img src=sos_7.png> Refresh</a>"
	if(spideros)
		dat += " | <a href='byond://?src=\ref[src];choice=Return'><img src=sos_1.png> Return</a>"
	dat += " | <a href='byond://?src=\ref[src];choice=Close'><img src=sos_8.png> Close</a>"
	dat += "<br>"
	if(s_control)
		dat += "<h2 ALIGN=CENTER>SpiderOS v.1.337</h2>"
		dat += "Welcome, <b>[U.real_name]</b>.<br>"
	else
		dat += "<h2 ALIGN=CENTER>SpiderOS v.<b>ERR-RR00123</b></h2>"
	dat += "<br>"
	dat += "<img src=sos_10.png> Current Time: [worldtime2text()]<br>"
	dat += "<img src=sos_9.png> Battery Life: [round(cell.charge/100)]%<br>"
	dat += "<img src=sos_11.png> Smoke Bombs: \Roman [s_bombs]<br>"
	dat += "<img src=sos_14.png> pai Device: "
	if(pai)
		dat += "<a href='byond://?src=\ref[src];choice=Configure pAI'>Configure</a>"
		dat += " | "
		dat += "<a href='byond://?src=\ref[src];choice=Eject pAI'>Eject</a>"
	else
		dat += "None Detected"
	dat += "<br><br>"

	switch(spideros)
		if(0)
			dat += "<h4><img src=sos_1.png> Available Functions:</h4>"
			dat += "<ul>"
			dat += "<li><a href='byond://?src=\ref[src];choice=7'><img src=sos_4.png> Research Stored</a></li>"
			if(s_control)
				if(AI)
					dat += "<li><a href='byond://?src=\ref[src];choice=5'><img src=sos_13.png> AI Status</a></li>"
			else
				dat += "<li><a href='byond://?src=\ref[src];choice=Shock'><img src=sos_4.png> Shock [U.real_name]</a></li>"
				dat += "<li><a href='byond://?src=\ref[src];choice=6'><img src=sos_6.png> Activate Abilities</a></li>"
			dat += "<li><a href='byond://?src=\ref[src];choice=3'><img src=sos_3.png> Medical Screen</a></li>"
			dat += "<li><a href='byond://?src=\ref[src];choice=1'><img src=sos_5.png> Atmos Scan</a></li>"
			dat += "<li><a href='byond://?src=\ref[src];choice=2'><img src=sos_12.png> Messenger</a></li>"
			if(s_control)
				dat += "<li><a href='byond://?src=\ref[src];choice=4'><img src=sos_6.png> Other</a></li>"
			dat += "</ul>"
		if(3)
			dat += "<h4><img src=sos_3.png> Medical Report:</h4>"
			if(U.dna)
				dat += "<b>Fingerprints</b>: <i>[md5(U.dna.uni_identity)]</i><br>"
				dat += "<b>Unique identity</b>: <i>[U.dna.unique_enzymes]</i><br>"
			dat += "<h4>Overall Status: [U.stat > 1 ? "dead" : "[U.health]% healthy"]</h4>"
			dat += "<h4>Nutrition Status: [U.nutrition]</h4>"
			dat += "Oxygen loss: [U.getOxyLoss()]"
			dat += " | Toxin levels: [U.getToxLoss()]<br>"
			dat += "Burn severity: [U.getFireLoss()]"
			dat += " | Brute trauma: [U.getBruteLoss()]<br>"
			dat += "Radiation Level: [U.radiation] rad<br>"
			dat += "Body Temperature: [U.bodytemperature-T0C]&deg;C ([U.bodytemperature*1.8-459.67]&deg;F)<br>"

			for(var/datum/disease/D in U.viruses)
				dat += "Warning: Virus Detected. Name: [D.name].Type: [D.spread]. Stage: [D.stage]/[D.max_stages]. Possible Cure: [D.cure].<br>"
			dat += "<ul>"
			for(var/datum/reagent/R in reagents.reagent_list)
				if(R.id=="radium"&&s_control)//Can only directly inject radium when AI is in control.
					continue
				dat += "<li><a href='byond://?src=\ref[src];choice=Inject;name=[R.name];tag=[R.id]'><img src=sos_2.png> Inject [R.name]: [(reagents.get_reagent_amount(R.id)-(R.id=="radium"?(a_boost*a_transfer):0))/(R.id=="nutriment"?5:a_transfer)] left</a></li>"
			dat += "</ul>"
		if(1)
			dat += "<h4><img src=sos_5.png> Atmospheric Scan:</h4>"//Headers don't need breaks. They are automatically placed.
			var/turf/T = get_turf(U.loc)
			if (isnull(T))
				dat += "Unable to obtain a reading."
			else
				var/datum/gas_mixture/environment = T.return_air()

				var/pressure = environment.return_pressure()
				var/total_moles = environment.total_moles()

				dat += "Air Pressure: [round(pressure,0.1)] kPa"

				if (total_moles)
					var/o2_level = environment.gasses[OXYGEN]/total_moles
					var/n2_level = environment.gasses[NITROGEN]/total_moles
					var/co2_level = environment.gasses[CARBONDIOXIDE]/total_moles
					var/plasma_level = environment.gasses[PLASMA]/total_moles
					var/unknown_level =  1-(o2_level+n2_level+co2_level+plasma_level)
					dat += "<ul>"
					dat += "<li>Nitrogen: [round(n2_level*100)]%</li>"
					dat += "<li>Oxygen: [round(o2_level*100)]%</li>"
					dat += "<li>Carbon Dioxide: [round(co2_level*100)]%</li>"
					dat += "<li>Plasma: [round(plasma_level*100)]%</li>"
					dat += "</ul>"
					if(unknown_level > 0.01)
						dat += "OTHER: [round(unknown_level)]%<br>"

					dat += "Temperature: [round(environment.temperature-T0C)]&deg;C"
		if(2)
			if(k_unlock==7||!s_control)
				dat += "<a href='byond://?src=\ref[src];choice=32'><img src=sos_1.png> Hidden Menu</a>"
			dat += "<h4><img src=sos_12.png> Anonymous Messenger:</h4>"//Anonymous because the receiver will not know the sender's identity.
			dat += "<h4><img src=sos_6.png> Detected Devices:</h4>"
			var/list/users_online = list()
			for(var/obj/item/device/tablet/T in tablets_list)
				if(T.network() && T.core && T.core.owner && T.messengeron)
					users_online.Add(T)
			dat += "<h3>Users Online</h3>"
			for(var/obj/item/device/tablet/T in users_online)
				dat += "[T.owner] ([T.ownjob]) - <a href='byond://?src=\ref[src];choice=Message;target=\ref[T]'>Message</a><br>"
			dat += "<ul>"
			dat += "</ul>"
		if(32)
			dat += "<h4><img src=sos_1.png> Hidden Menu:</h4>"
			if(s_control)
				dat += "Please input password: "
				dat += "<a href='byond://?src=\ref[src];choice=Unlock Kamikaze'><b>HERE</b></a><br>"
				dat += "<br>"
				dat += "Remember, you will not be able to recharge energy during this function. If energy runs out, the suit will auto self-destruct.<br>"
				dat += "Use with caution. De-initialize the suit when energy is low."
			else
				//Only leaving this in for funnays. CAN'T LET YOU DO THAT STAR FOX
				dat += "<b>WARNING</b>: Hostile runtime intrusion detected: operation locked. The Spider Clan is watching you, <b>INTRUDER</b>."
				dat += "<b>ERROR</b>: TARANTULA.v.4.77.12 encryption algorithm detected. Unable to decrypt archive.<br>"
		if(4)
			dat += {"
					<h4><img src=sos_6.png> Ninja Manual:</h4>
					<h5>Who they are:</h5>
					Space ninjas are a special type of ninja, specifically one of the space-faring type. The vast majority of space ninjas belong to the Spider Clan, a cult-like sect, which has existed for several hundred years. The Spider Clan practice a sort of augmentation of human flesh in order to achieve a more perfect state of being and follow Postmodern Space Bushido. They also kill people for money. Their leaders are chosen from the oldest of the grand-masters, people that have lived a lot longer than any mortal man should.<br>Being a sect of technology-loving fanatics, the Spider Clan have the very best to choose from in terms of hardware--cybernetic implants, exoskeleton rigs, hyper-capacity batteries, and you get the idea. Some believe that much of the Spider Clan equipment is based on reverse-engineered alien technology while others doubt such claims.<br>Whatever the case, their technology is absolutely superb.
					<h5>How they relate to other SS13 organizations:</h5>
					<ul>
					<li>*<b>Nanotrasen</b> and the Syndicate are two sides of the same coin and that coin is valuable.</li>
					<li>*<b>The Space Wizard Federation</b> is a problem, mainly because they are an extremely dangerous group of unpredictable individuals--not to mention the wizards hate technology and are in direct opposition of the Spider Clan. Best avoided or left well-enough alone. How to battle: wizards possess several powerful abilities to steer clear off. Blind in particular is a nasty spell--jaunt away if you are blinded and never approach a wizard in melee. Stealth may also work if the wizard is not wearing thermal scanners--don't count on this. Run away if you feel threatened and await a better opportunity.</li>
					<li>*<b>Changeling Hivemind</b>: extremely dangerous and to be killed on sight. How to battle: they will likely try to absorb you. Adrenaline boost, then phase shift into them. If you get stung, use SpiderOS to inject counter-agents. Stealth may also work but detecting a changeling is the real battle.</li>
					<li>*<b>Xeno Hivemind</b>: their skulls make interesting kitchen decorations and are challenging to best, especially in larger nests. How to battle: they can see through your stealth guise and energy stars will not work on them. Best killed with a Phase Shift or at range. If you happen on a projectile stun weapon, use it and then close in to melee.</li>
					</ul>
					<h5>The reason they (you) are here:</h5>
					Space ninjas are renowned throughout the known controlled space as fearless spies, infiltrators, and assassins. They are sent on missions of varying nature by Nanotrasen, the Syndicate, and other shady organizations and people. To hire a space ninja means serious business.
					<h5>Their playstyle:</h5>
					A mix of traitor, changeling, and wizard. Ninjas rely on energy, or electricity to be precise, to keep their suits running (when out of energy, a suit hibernates). Suits gain energy from objects or creatures that contain electrical charge. APCs, cell batteries, rechargers, SMES batteries, cyborgs, mechs, and exposed wires are currently supported. Through energy ninjas gain access to special powers--while all powers are tied to the ninja suit, the most useful of them are verb activated--to help them in their mission.<br>It is a constant struggle for a ninja to remain hidden long enough to recharge the suit and accomplish their objective; despite their arsenal of abilities, ninjas can die like any other. Unlike wizards, ninjas do not possess good crowd control and are typically forced to play more subdued in order to achieve their goals. Some of their abilities are specifically designed to confuse and disorient others.<br>With that said, it should be perfectly possible to completely flip the fuck out and rampage as a ninja.
					<h5>Their powers:</h5>
					There are two primary types: Equipment and Abilties. Passive effect are always on. Active effect must be turned on and remain active only when there is energy to do so. Ability costs are listed next to them.
					<b>Equipment</b>: cannot be tracked by AI (passive), faster speed (passive), stealth (active), vision switch (passive if toggled), voice masking (passive), SpiderOS (passive if toggled), energy drain (passive if toggled).
					<ul>
					<li><i>Voice masking</i> generates a random name the ninja can use over the radio and in-person. Although, the former use is recommended.</li>
					<li><i>Toggling vision</i> cycles to one of the following: thermal, meson, or darkness vision. The starting mode allows one to scout the identity of those in view, revealing their role. Traitors, revolutionaries, wizards, and other such people will be made known to you.</li>
					<li><i>Stealth</i>, when activated, drains more battery charge and works similarly to a syndicate cloak. The cloak will deactivate when most Abilities are utilized.</li>
					<li><i>On-board AI</i>: The suit is able to download an AI much like an intelicard. Check with SpiderOS for details once downloaded.</li>
					<li><i>SpiderOS</i> is a specialized, PDA-like screen that allows for a small variety of functions, such as injecting healing chemicals directly from the suit. You are using it now, if that was not already obvious. You may also download AI modules directly to the OS.</li>
					</ul>
					<b>Abilities</b>:
					<ul>
					<li>*<b>Phase Shift</b> (<i>2000E</i>) and <b>Phase Jaunt</b> (<i>1000E</i>) are unique powers in that they can both be used for defense and offense. Jaunt launches the ninja forward facing up to 9 squares, somewhat randomly selecting the final destination. Shift can only be used on turf in view but is precise (cannot be used on walls). Any living mob in the area teleported to is instantly gibbed (mechs are damaged, huggers and other similar critters are killed). It is possible to teleport with a target, provided you grab them before teleporting.</li>
					<li>*<b>Energy Blade</b> (<i>500E</i>) is a highly effective weapon. It is summoned directly to the ninja's hand and can also function as an EMAG for certain objects (doors/lockers/etc). You may also use it to cut through walls and disabled doors. Experiment! The blade will crit humans in two hits. This item cannot be placed in containers and when dropped or thrown disappears. Having an energy blade drains more power from the battery each tick.</li>
					<li>*<b>EM Pulse</b> (<i>2500E</i>) is a highly useful ability that will create an electromagnetic shockwave around the ninja, disabling technology whenever possible. If used properly it can render a security force effectively useless. Of course, getting beat up with a toolbox is not accounted for.</li>
					<li>*<b>Energy Star</b> (<i>500E</i>) is a ninja star made of green energy AND coated in poison. It works by picking a random living target within range and can be spammed to great effect in incapacitating foes. Just remember that the poison used is also used by the Xeno Hivemind (and will have no effect on them).</li>
					<li>*<b>Energy Net</b> (<i>2000E</i>) is a non-lethal solution to incapacitating humanoids. The net is made of non-harmful phase energy and will halt movement as long as it remains in effect--it can be destroyed. If the net is not destroyed, after a certain time it will teleport the target to a holding facility for the Spider Clan and then vanish. You will be notified if the net fails or succeeds in capturing a target in this manner. Combine with energy stars or stripping to ensure success. Abduction never looked this leet.</li>
					<li>*<b>Adrenaline Boost</b> (<i>1 E. Boost/3</i>) recovers the user from stun, weakness, and paralysis. Also injects 20 units of radium into the bloodstream.</li>
					<li>*<b>Smoke Bomb</b> (<i>1 Sm.Bomb/10</i>) is a weak but potentially useful ability. It creates harmful smoke and can be used in tandem with other powers to confuse enemies.</li>
					<li>*<b>???</b>: unleash the <b>True Ultimate Power!</b></li>
					<h4>IMPORTANT:</h4>
					<ul>
					<li>*Make sure to toggle Special Interaction from the Ninja Equipment menu to interact differently with certain objects.</li>
					<li>*Your starting power cell can be replaced if you find one with higher maximum energy capacity by clicking on your suit with the higher capacity cell.</li>
					<li>*Conserve your energy. Without it, you are very vulnerable.</li>
					</ul>
					That is all you will need to know. The rest will come with practice and talent. Good luck!
					<h4>Master /N</h4>
					"}//This has always bothered me but not anymore!
		if(5)
			var/laws
			dat += "<h4><img src=sos_13.png> AI Control:</h4>"
			//var/mob/living/silicon/ai/A = AI
			if(AI)//If an AI exists.
				dat += "Stored AI: <b>[A.name]</b><br>"
				dat += "System integrity: [(A.health+100)/2]%<br>"

				//I personally think this makes things a little more fun. Ninjas can override all but law 0.
				//if (A.laws.zeroth)
				//	laws += "<li>0: [A.laws.zeroth]</li>"

				for (var/index = 1, index <= A.laws.ion.len, index++)
					var/law = A.laws.ion[index]
					if (length(law) > 0)
						var/num = ionnum()
						laws += "<li>[num]. [law]</li>"

				var/number = 1
				for (var/index = 1, index <= A.laws.inherent.len, index++)
					var/law = A.laws.inherent[index]
					if (length(law) > 0)
						laws += "<li>[number]: [law]</li>"
						number++

				for (var/index = 1, index <= A.laws.supplied.len, index++)
					var/law = A.laws.supplied[index]
					if (length(law) > 0)
						laws += "<li>[number]: [law]</li>"
						number++

				dat += "<h4>Laws:</h4><ul>[laws]<li><a href='byond://?src=\ref[src];choice=Override AI Laws'><i>*Override Laws*</i></a></li></ul>"

				if (!flush)
					dat += "<A href='byond://?src=\ref[src];choice=Purge AI'>Purge AI</A><br>"
				else
					dat += "<b>Purge in progress...</b><br>"
				dat += " <A href='byond://?src=\ref[src];choice=Wireless AI'>[A.control_disabled ? "Enable" : "Disable"] Wireless Activity</A>"
		if(6)
			dat += {"
					<h4><img src=sos_6.png> Activate Abilities:</h4>
					<ul>
					<li><a href='byond://?src=\ref[src];choice=Trigger Ability;name=Phase Jaunt;cost= (10E)'><img src=sos_13.png> Phase Jaunt</a></li>
					<li><a href='byond://?src=\ref[src];choice=Trigger Ability;name=Phase Shift;cost= (20E)'><img src=sos_13.png> Phase Shift</a></li>
					<li><a href='byond://?src=\ref[src];choice=Trigger Ability;name=Energy Blade;cost= (5E)'><img src=sos_13.png> Energy Blade</a></li>
					<li><a href='byond://?src=\ref[src];choice=Trigger Ability;name=Energy Star;cost= (5E)'><img src=sos_13.png> Energy Star</a></li>
					<li><a href='byond://?src=\ref[src];choice=Trigger Ability;name=Energy Net;cost= (20E)'><img src=sos_13.png> Energy Net</a></li>
					<li><a href='byond://?src=\ref[src];choice=Trigger Ability;name=EM Burst;cost= (25E)'><img src=sos_13.png> EM Pulse</a></li>
					<li><a href='byond://?src=\ref[src];choice=Trigger Ability;name=Smoke Bomb;cost='><img src=sos_13.png> Smoke Bomb</a></li>
					<li><a href='byond://?src=\ref[src];choice=Trigger Ability;name=Adrenaline Boost;cost='><img src=sos_13.png> Adrenaline Boost</a></li>
					</ul>
					"}
		if(7)
			dat += "<h4><img src=sos_4.png> Research Stored:</h4>"
			if(t_disk)
				dat += "<a href='byond://?src=\ref[src];choice=Eject Disk'>Eject Disk</a><br>"
			dat += "<ul>"
			if(istype(stored_research,/list))//If there is stored research. Should be but just in case.
				for(var/datum/tech/current_data in stored_research)
					dat += "<li>"
					dat += "[current_data.name]: [current_data.level]"
					if(t_disk)//If there is a disk inserted. We can either write or overwrite.
						dat += " <a href='byond://?src=\ref[src];choice=Copy to Disk;target=\ref[current_data]'><i>*Copy to Disk</i></a><br>"
					dat += "</li>"
			dat += "</ul>"
	dat += "</body></html>"

	//Setting the can>resize etc to 0 remove them from the drag bar but still allows the window to be draggable.
	display_to << browse(dat,"window=spideros;size=400x444;border=1;can_resize=1;can_close=0;can_minimize=0")

//=======//SPIDEROS TOPIC PROC//=======//

/obj/item/clothing/suit/space/space_ninja/Topic(href, href_list)
	..()
	var/mob/living/carbon/human/U = affecting
	var/mob/living/silicon/ai/A = AI
	var/display_to = s_control ? U : A//Who do we want to display certain messages to?

	if(s_control)
		if(!affecting||U.stat||!s_initialized)//Check to make sure the guy is wearing the suit after clicking and it's on.
			U << "\red Your suit must be worn and active to use this function."
			U << browse(null, "window=spideros")//Closes the window.
			return

		if(k_unlock!=7&&href_list["choice"]!="Return")
			var/u1=text2num(href_list["choice"])
			var/u2=(u1?abs(abs(k_unlock-u1)-2):1)
			k_unlock=(!u2? k_unlock+1:0)
			if(k_unlock==7)
				U << "Anonymous Messenger blinks."
	else
		if(!affecting||A.stat||!s_initialized||A.loc!=src)
			A << "\red This function is not available at this time."
			A << browse(null, "window=spideros")//Closes the window.
			return

	switch(href_list["choice"])
		if("Close")
			display_to << browse(null, "window=spideros")
			return
		if("Refresh")//Refresh, goes to the end of the proc.
		if("Return")//Return
			if(spideros<=9)
				spideros=0
			else
				spideros = round(spideros/10)//Best way to do this, flooring to nearest integer.

		if("Shock")
			var/damage = min(cell.charge, rand(50,150))//Uses either the current energy left over or between 50 and 150.
			if(damage>1)//So they don't spam it when energy is a factor.
				spark_system.start()//SPARKS THERE SHALL BE SPARKS
				U.electrocute_act(damage, src,0.1,1)//The last argument is a safety for the human proc that checks for gloves.
				cell.charge -= damage
			else
				A << "\red <b>ERROR</b>: \black Not enough energy remaining."
		if("Message")
			var/obj/item/device/tablet/P = locate(href_list["target"])
			var/t = input(U, "Please enter untraceable message.") as text
			t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
			if(!t||U.stat||U.wear_suit!=src||!s_initialized)//Wow, another one of these. Man...
				display_to << browse(null, "window=spideros")
				return
			if(!P.core)//So it doesn't freak out if the object no-longer exists.
				display_to << "\red Error: unable to deliver message."
				display_spideros()
				return
			if(!P.messengeron)
				display_to << "\red Error: unable to deliver message."
				display_spideros()
				return
			P.alert_self("<b>an unknown source:</b>","[t]")
			display_to << "Message sent."
			display_spideros()
		if("Inject")
			if( (href_list["tag"]=="radium"? (reagents.get_reagent_amount("radium"))<=(a_boost*a_transfer) : !reagents.get_reagent_amount(href_list["tag"])) )//Special case for radium. If there are only a_boost*a_transfer radium units left.
				display_to << "\red Error: the suit cannot perform this function. Out of [href_list["name"]]."
			else
				reagents.reaction(U, 2)
				reagents.trans_id_to(U, href_list["tag"], href_list["tag"]=="nutriment"?5:a_transfer)//Nutriment is a special case since it's very potent. Shouldn't influence actual refill amounts or anything.
				display_to << "Injecting..."
				U << "You feel a tiny prick and a sudden rush of substance in to your veins."

		if("Trigger Ability")
			var/ability_name = href_list["name"]+href_list["cost"]//Adds the name and cost to create the full proc name.
			var/proc_arguments//What arguments to later pass to the proc, if any.
			var/targets[] = list()//To later check for.
			var/safety = 0//To later make sure we're triggering the proc when needed.
			switch(href_list["name"])//Special case.
				if("Phase Shift")
					safety = 1
					for(var/turf/T in oview(5,loc))
						targets.Add(T)
				if("Energy Net")
					safety = 1
					for(var/mob/living/carbon/M in oview(5,loc))
						targets.Add(M)
			if(targets.len)//Let's create an argument for the proc if needed.
				proc_arguments = pick(targets)
				safety = 0
			if(!safety)
				A << "You trigger [href_list["name"]]."
				U << "[href_list["name"]] suddenly triggered!"
				call(src,ability_name)(proc_arguments)
			else
				A << "There are no potential [href_list["name"]=="Phase Shift"?"destinations" : "targets"] in view."

		if("Unlock Kamikaze")
			if(input(U)=="Divine Wind")
				if( !(U.stat||U.wear_suit!=src||!s_initialized) )
					if( !(cell.charge<=1||s_busy) )
						s_busy = 1
						for(var/i, i<4, i++)
							switch(i)
								if(0)
									U << "\blue Engaging mode...\n\black<b>CODE NAME</b>: \red <b>KAMIKAZE</b>"
								if(1)
									U << "\blue Re-routing power nodes... \nUnlocking limiter..."
								if(2)
									U << "\blue Power nodes re-routed. \nLimiter unlocked."
								if(3)
									grant_kamikaze(U)//Give them verbs and change variables as necessary.
									U.regenerate_icons()//Update their clothing.
									ninjablade()//Summon two energy blades.
									message_admins("\blue [key_name_admin(U)] used KAMIKAZE mode.")//Let the admins know.
									s_busy = 0
									return
							sleep(s_delay)
					else
						U << "\red <b>ERROR<b>: \black Unable to initiate mode."
				else
					U << browse(null, "window=spideros")
					s_busy = 0
					return
			else
				U << "\red ERROR: WRONG PASSWORD!"
				k_unlock = 0
				spideros = 0
			s_busy = 0

		if("Eject Disk")
			var/turf/T = get_turf(loc)
			if(!U.get_active_hand())
				U.put_in_hands(t_disk)
				t_disk.add_fingerprint(U)
				t_disk = null
			else
				if(T)
					t_disk.loc = T
					t_disk = null
				else
					U << "\red <b>ERROR<b>: \black Could not eject disk."

		if("Copy to Disk")
			var/datum/tech/current_data = locate(href_list["target"])
			U << "[current_data.name] successfully [(!t_disk.stored) ? "copied" : "overwritten"] to disk."
			t_disk.stored = current_data

		if("Configure pAI")
			pai.attack_self(U)

		if("Eject pAI")
			var/turf/T = get_turf(loc)
			if(!U.get_active_hand())
				U.put_in_hands(pai)
				pai.add_fingerprint(U)
				pai = null
			else
				if(T)
					pai.loc = T
					pai = null
				else
					U << "\red <b>ERROR<b>: \black Could not eject pAI card."

		if("Override AI Laws")
			var/law_zero = A.laws.zeroth//Remembers law zero, if there is one.
			A.laws = new /datum/ai_laws/ninja_override
			A.set_zeroth_law(law_zero)//Adds back law zero if there was one.
			A.show_laws()
			U << "\blue Law Override: <b>SUCCESS</b>."

		if("Purge AI")
			var/confirm = alert("Are you sure you want to purge the AI? This cannot be undone once started.", "Confirm purge", "Yes", "No")
			if(U.stat||U.wear_suit!=src||!s_initialized)
				U << browse(null, "window=spideros")
				return
			if(confirm == "Yes"&&AI)
				if(A.laws.zeroth)//Gives a few seconds to re-upload the AI somewhere before it takes full control.
					s_busy = 1
					for(var/i,i<5,i++)
						if(AI==A)
							switch(i)
								if(0)
									A << "\red <b>WARNING</b>: \black purge procedure detected. \nNow hacking host..."
									U << "\red <b>WARNING</b>: HACKING ATï¿½ï¿½TEMPï¿½ IN PR0GRESs!"
									spideros = 0
									k_unlock = 0
									U << browse(null, "window=spideros")
								if(1)
									A << "Disconnecting neural interface..."
									U << "\red <b>WARï¿½NING</b>: ï¿½Rï¿½O0ï¿½Grï¿½--S 2&3%"
								if(2)
									A << "Shutting down external protocol..."
									U << "\red <b>WARNING</b>: Pï¿½ï¿½ï¿½ï¿½RÖ†Grï¿½5S 677^%"
									cancel_stealth()
								if(3)
									A << "Connecting to kernel..."
									U << "\red <b>WARNING</b>: ï¿½Rï¿½rï¿½R_404"
									A.control_disabled = 0
								if(4)
									A << "Connection established and secured. Menu updated."
									U << "\red <b>Wï¿½r#nING</b>: #%@!!WÈ†|_4ï¿½54@ \nUnï¿½B88l3 Tï¿½ Lï¿½-ï¿½o-Lï¿½CaT2 ##$!ï¿½RNï¿½0..%.."
									grant_AI_verbs()
									return
							sleep(s_delay)
						else	break
					s_busy = 0
					U << "\blue Hacking attempt disconnected. Resuming normal operation."
				else
					flush = 1
					A.suiciding = 1
					A << "Your core files are being purged! This is the end..."
					spawn(0)
						display_spideros()//To refresh the screen and let this finish.
					while (A.stat != 2)
						A.adjustOxyLoss(2)
						A.updatehealth()
						sleep(10)
					killai()
					U << "Artificial Intelligence was terminated. Rebooting..."
					flush = 0

		if("Wireless AI")
			A.control_disabled = !A.control_disabled
			A << "AI wireless has been [A.control_disabled ? "disabled" : "enabled"]."
		else//If it's not a defined function, it's a menu.
			spideros=text2num(href_list["choice"])

	display_spideros()//Refreshes the screen by calling it again (which replaces current screen with new screen).
	return

//=======//SPECIAL AI FUNCTIONS//=======//

/obj/item/clothing/suit/space/space_ninja/proc/ai_holo(var/turf/T in oview(3,affecting))//To have an internal AI display a hologram to the AI and ninja only.
	set name = "Display Hologram"
	set desc = "Channel a holographic image directly to the user's field of vision. Others will not see it."
	set category = null
	set src = usr.loc

	if(s_initialized&&affecting&&affecting.client&&istype(affecting.loc, /turf))//If the host exists and they are playing, and their location is a turf.
		if(!hologram)//If there is not already a hologram.
			hologram = new(T)//Spawn a blank effect at the location.
			hologram.invisibility = 101//So that it doesn't show up, ever. This also means one could attach a number of images to a single obj and display them differently to differnet people.
			hologram.anchored = 1//So it cannot be dragged by space wind and the like.
			hologram.dir = get_dir(T,affecting.loc)
			var/image/I = image(AI.holo_icon,hologram)//Attach an image to object.
			hologram.i_attached = I//To attach the image in order to later reference.
			AI << I
			affecting << I
			affecting << "<i>An image flicks to life nearby. It appears visible to you only.</i>"

			verbs += /obj/item/clothing/suit/space/space_ninja/proc/ai_holo_clear

			ai_holo_process()//Move to initialize
		else
			AI << "\red ERROR: \black Image feed in progress."
	else
		AI << "\red ERROR: \black Unable to project image."
	return

/obj/item/clothing/suit/space/space_ninja/proc/ai_holo_process()
	set background = BACKGROUND_ENABLED

	spawn while(hologram&&s_initialized&&AI)//Suit on and there is an AI present.
		if(!s_initialized||get_dist(affecting,hologram.loc)>3)//Once suit is de-initialized or hologram reaches out of bounds.
			qdel(hologram.i_attached)
			qdel(hologram)

			verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ai_holo_clear
			return
		sleep(10)//Checks every second.

/obj/item/clothing/suit/space/space_ninja/proc/ai_instruction()//Let's the AI know what they can do.
	set name = "Instructions"
	set desc = "Displays a list of helpful information."
	set category = "AI Ninja Equip"
	set src = usr.loc

	AI << "The menu you are seeing will contain other commands if they become available.\nRight click a nearby turf to display an AI Hologram. It will only be visible to you and your host. You can move it freely using normal movement keys--it will disappear if placed too far away."

/obj/item/clothing/suit/space/space_ninja/proc/ai_holo_clear()
	set name = "Clear Hologram"
	set desc = "Stops projecting the current holographic image."
	set category = "AI Ninja Equip"
	set src = usr.loc

	qdel(hologram.i_attached)
	qdel(hologram)

	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ai_holo_clear
	return

/obj/item/clothing/suit/space/space_ninja/proc/ai_hack_ninja()
	set name = "Hack SpiderOS"
	set desc = "Hack directly into the Black Widow(tm) neuro-interface."
	set category = "AI Ninja Equip"
	set src = usr.loc

	display_spideros()
	return

/obj/item/clothing/suit/space/space_ninja/proc/ai_return_control()
	set name = "Relinquish Control"
	set desc = "Return control to the user."
	set category = "AI Ninja Equip"
	set src = usr.loc

	AI << browse(null, "window=spideros")//Close window
	AI << "You have seized your hacking attempt. [affecting.real_name] has regained control."
	affecting << "<b>UPDATE</b>: [AI.real_name] has ceased hacking attempt. All systems clear."

	remove_AI_verbs()
	return

//=======//GENERAL SUIT PROCS//=======//

/obj/item/clothing/suit/space/space_ninja/attackby(obj/item/I, mob/U)
	if(U==affecting)//Safety, in case you try doing this without wearing the suit/being the person with the suit.
		if(istype(I, /obj/item/device/aicard))//If it's an AI card.
			if(s_control)
				I:transfer_ai("NINJASUIT","AICARD",src,U)
			else
				U << "\red <b>ERROR</b>: \black Remote access channel disabled."
			return//Return individually so that ..() can run properly at the end of the proc.
		else if(istype(I, /obj/item/device/paicard) && !pai)//If it's a pai card.
			U:drop_item()
			I.loc = src
			pai = I
			U << "\blue You slot \the [I] into \the [src]."
			updateUsrDialog()
			return
		else if(istype(I, /obj/item/weapon/reagent_containers/glass))//If it's a glass beaker.
			var/total_reagent_transfer//Keep track of this stuff.
			for(var/reagent_id in reagent_list)
				var/datum/reagent/R = I.reagents.has_reagent(reagent_id)//Mostly to pull up the name of the reagent after calculating. Also easier to use than writing long proc paths.
				if(R&&reagents.get_reagent_amount(reagent_id)<r_maxamount+(reagent_id == "radium"?(a_boost*a_transfer):0)&&R.volume>=a_transfer)//Radium is always special.
					//Here we determine how much reagent will actually transfer if there is enough to transfer or there is a need of transfer. Minimum of max amount available (using a_transfer) or amount needed.
					var/amount_to_transfer = min( (r_maxamount+(reagent_id == "radium"?(a_boost*a_transfer):0)-reagents.get_reagent_amount(reagent_id)) ,(round(R.volume/a_transfer))*a_transfer)//In the end here, we round the amount available, then multiply it again.
					R.volume -= amount_to_transfer//Remove from reagent volume. Don't want to delete the reagent now since we need to perserve the name.
					reagents.add_reagent(reagent_id, amount_to_transfer)//Add to suit. Reactions are not important.
					total_reagent_transfer += amount_to_transfer//Add to total reagent trans.
					U << "Added [amount_to_transfer] units of [R.name]."//Reports on the specific reagent added.
					I.reagents.update_total()//Now we manually update the total to make sure everything is properly shoved under the rug.

			U << "Replenished a total of [total_reagent_transfer ? total_reagent_transfer : "zero"] chemical units."//Let the player know how much total volume was added.
			return
		else if(istype(I, /obj/item/weapon/stock_parts/cell))
			if(I:maxcharge>cell.maxcharge&&n_gloves&&n_gloves.candrain)
				U << "\blue Higher maximum capacity detected.\nUpgrading..."
				if (n_gloves&&n_gloves.candrain&&do_after(U,s_delay))
					U.drop_item()
					I.loc = src
					I:charge = min(I:charge+cell.charge, I:maxcharge)
					var/obj/item/weapon/stock_parts/cell/old_cell = cell
					old_cell.charge = 0
					U.put_in_hands(old_cell)
					old_cell.add_fingerprint(U)
					old_cell.corrupt()
					old_cell.updateicon()
					cell = I
					U << "\blue Upgrade complete. Maximum capacity: <b>[round(cell.maxcharge/100)]</b>%"
				else
					U << "\red Procedure interrupted. Protocol terminated."
			return
		else if(istype(I, /obj/item/weapon/disk/tech_disk))//If it's a data disk, we want to copy the research on to the suit.
			var/obj/item/weapon/disk/tech_disk/TD = I
			if(TD.stored)//If it has something on it.
				U << "Research information detected, processing..."
				if(do_after(U,s_delay))
					for(var/datum/tech/current_data in stored_research)
						if(current_data.id==TD.stored.id)
							if(current_data.level<TD.stored.level)
								current_data.level=TD.stored.level
							break
					TD.stored = null
					U << "\blue Data analyzed and updated. Disk erased."
				else
					U << "\red <b>ERROR</b>: \black Procedure interrupted. Process terminated."
			else
				I.loc = src
				t_disk = I
				U << "\blue You slot \the [I] into \the [src]."
			return
	..()

/obj/item/clothing/suit/space/space_ninja/proc/toggle_stealth()
	var/mob/living/carbon/human/U = affecting
	if(s_active)
		cancel_stealth()
	else
		spawn(0)
			anim(U.loc,U,'icons/mob/mob.dmi',,"cloak",,U.dir)
		s_active=!s_active
		U.alpha = 0
		U << "\blue You are now invisible to normal detection."
		for(var/mob/O in oviewers(U))
			O.show_message("[U.name] vanishes into thin air!",1)
	return

/obj/item/clothing/suit/space/space_ninja/proc/cancel_stealth()
	var/mob/living/carbon/human/U = affecting
	if(s_active)
		spawn(0)
			anim(U.loc,U,'icons/mob/mob.dmi',,"uncloak",,U.dir)
		s_active=!s_active
		U.alpha = 255
		U << "\blue You are now visible."
		for(var/mob/O in oviewers(U))
			O.show_message("[U.name] appears from thin air!",1)
		return 1
	return 0

/obj/item/clothing/suit/space/space_ninja/proc/blade_check(mob/living/carbon/U, X = 1)//Default to checking for blade energy.
	switch(X)
		if(1)
			if(istype(U.get_active_hand(), /obj/item/weapon/melee/energy/blade))
				if(cell.charge<=0)//If no charge left.
					U.drop_item()//Blade is dropped from active hand (and deleted).
				else	return 1
			else if(istype(U.get_inactive_hand(), /obj/item/weapon/melee/energy/blade))
				if(cell.charge<=0)
					U.swap_hand()//swap hand
					U.drop_item()//drop blade
				else	return 1
		if(2)
			if(istype(U.get_active_hand(), /obj/item/weapon/melee/energy/blade))
				U.drop_item()
			if(istype(U.get_inactive_hand(), /obj/item/weapon/melee/energy/blade))
				U.swap_hand()
				U.drop_item()
	return 0

/obj/item/clothing/suit/space/space_ninja/examine()
	set src in view()
	..()
	if(s_initialized)
		var/mob/living/carbon/human/U = affecting
		if(s_control)
			U.send_text_to_tab("All systems operational. Current energy capacity: <B>[cell.charge]</B>.", "ic")
			U << "All systems operational. Current energy capacity: <B>[cell.charge]</B>."
			if(!kamikaze)
				U.send_text_to_tab("The CLOAK-tech device is <B>[s_active?"active":"inactive"]</B>.", "ic")
				U << "The CLOAK-tech device is <B>[s_active?"active":"inactive"]</B>."
			else
				U.send_text_to_tab("\red KAMIKAZE MODE ENGAGED!", "ic")
				U << "\red KAMIKAZE MODE ENGAGED!"
			U.send_text_to_tab("There are <B>[s_bombs]</B> smoke bombs remaining.", "ic")
			U.send_text_to_tab("There are <B>[a_boost]</B> adrenaline boosters remaining.", "ic")
			U << "There are <B>[s_bombs]</B> smoke bombs remaining."
			U << "There are <B>[a_boost]</B> adrenaline boosters remaining."
		else
			U.send_text_to_tab("ï¿½rrï¿½R ï¿½aï¿½ï¿½aï¿½ï¿½ No-ï¿½-ï¿½ fï¿½ï¿½Nï¿½ 3RRï¿½r", "ic")
			U <<  "ï¿½rrï¿½R ï¿½aï¿½ï¿½aï¿½ï¿½ No-ï¿½-ï¿½ fï¿½ï¿½Nï¿½ 3RRï¿½r"

/*
===================================================================================
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SPACE NINJA GLOVES>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
===================================================================================
*/

//=======//ENERGY DRAIN PROCS//=======//

/obj/item/clothing/gloves/space_ninja/proc/drain(target_type as text, target, obj/suit)
//Var Initialize
	var/obj/item/clothing/suit/space/space_ninja/S = suit
	var/mob/living/carbon/human/U = S.affecting
	var/obj/item/clothing/gloves/space_ninja/G = S.n_gloves

	var/drain = 0//To drain from battery.
	var/maxcapacity = 0//Safety check for full battery.
	var/totaldrain = 0//Total energy drained.

	G.draining = 1

	if(target_type!="RESEARCH")//I lumped research downloading here for ease of use.
		U << "\blue Now charging battery..."

	switch(target_type)

		if("APC")
			var/obj/machinery/power/apc/A = target
			if(A.cell&&A.cell.charge)
				var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
				spark_system.set_up(5, 0, A.loc)
				while(G.candrain&&A.cell.charge>0&&!maxcapacity)
					drain = rand(G.mindrain,G.maxdrain)
					if(A.cell.charge<drain)
						drain = A.cell.charge
					if(S.cell.charge+drain>S.cell.maxcharge)
						drain = S.cell.maxcharge-S.cell.charge
						maxcapacity = 1//Reached maximum battery capacity.
					if (do_after(U,10))
						spark_system.start()
						playsound(A.loc, "sparks", 50, 1)
						A.cell.charge-=drain
						S.cell.charge+=drain
						totaldrain+=drain
					else	break
				U << "\blue Gained <B>[totaldrain]</B> energy from the APC."
				if(!A.emagged)
					flick("apc-spark", src)
					A.emagged = 1
					A.locked = 0
					A.update_icon()
			else
				U << "\red This APC has run dry of power. You must find another source."

		if("SMES")
			var/obj/machinery/power/smes/A = target
			if(A.charge)
				var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
				spark_system.set_up(5, 0, A.loc)
				while(G.candrain&&A.charge>0&&!maxcapacity)
					drain = rand(G.mindrain,G.maxdrain)
					if(A.charge<drain)
						drain = A.charge
					if(S.cell.charge+drain>S.cell.maxcharge)
						drain = S.cell.maxcharge-S.cell.charge
						maxcapacity = 1
					if (do_after(U,10))
						spark_system.start()
						playsound(A.loc, "sparks", 50, 1)
						A.charge-=drain
						S.cell.charge+=drain
						totaldrain+=drain
					else	break
				U << "\blue Gained <B>[totaldrain]</B> energy from the SMES cell."
			else
				U << "\red This SMES cell has run dry of power. You must find another source."

		if("CELL")
			var/obj/item/weapon/stock_parts/cell/A = target
			if(A.charge)
				if (G.candrain&&do_after(U,30))
					U << "\blue Gained <B>[A.charge]</B> energy from the cell."
					if(S.cell.charge+A.charge>S.cell.maxcharge)
						S.cell.charge=S.cell.maxcharge
					else
						S.cell.charge+=A.charge
					A.charge = 0
					G.draining = 0
					A.corrupt()
					A.updateicon()
				else
					U << "\red Procedure interrupted. Protocol terminated."
			else
				U << "\red This cell is empty and of no use."

		if("MACHINERY")//Can be applied to generically to all powered machinery. I'm leaving this alone for now.
			var/obj/machinery/A = target
			if(A.powered())//If powered.

				var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
				spark_system.set_up(5, 0, A.loc)

				var/obj/machinery/power/apc/B = A.loc.loc:get_apc()//Object.turf.area find APC
				if(B)//If APC exists. Might not if the area is unpowered like Centcom.
					var/datum/powernet/PN = B.terminal.powernet
					while(G.candrain&&!maxcapacity&&!isnull(A))//And start a proc similar to drain from wire.
						drain = rand(G.mindrain,G.maxdrain)
						var/drained = 0
						if(PN&&do_after(U,10))
							drained = min(drain, PN.avail)
							PN.load += drained
							if(drained < drain)//if no power on net, drain apcs
								for(var/obj/machinery/power/terminal/T in PN.nodes)
									if(istype(T.master, /obj/machinery/power/apc))
										var/obj/machinery/power/apc/AP = T.master
										if(AP.operating && AP.cell && AP.cell.charge>0)
											AP.cell.charge = max(0, AP.cell.charge - 5)
											drained += 5
						else	break
						S.cell.charge += drained
						if(S.cell.charge>S.cell.maxcharge)
							totaldrain += (drained-(S.cell.charge-S.cell.maxcharge))
							S.cell.charge = S.cell.maxcharge
							maxcapacity = 1
						else
							totaldrain += drained
						spark_system.start()
						if(drained==0)	break
					U << "\blue Gained <B>[totaldrain]</B> energy from the power network."
				else
					U << "\red Power network could not be found. Aborting."
			else
				U << "\red This recharger is not providing energy. You must find another source."

		if("RESEARCH")
			var/obj/machinery/A = target
			U << "\blue Hacking \the [A]..."
			spawn(0)
				var/turf/location = get_turf(U)
				for(var/mob/living/silicon/ai/AI in player_list)
					AI << "\red <b>Network Alert: Hacking attempt detected[location?" in [location]":". Unable to pinpoint location"]</b>."
			if(A:files&&A:files.known_tech.len)
				for(var/datum/tech/current_data in S.stored_research)
					U << "\blue Checking \the [current_data.name] database."
					if(do_after(U, S.s_delay)&&G.candrain&&!isnull(A))
						for(var/datum/tech/analyzing_data in A:files.known_tech)
							if(current_data.id==analyzing_data.id)
								if(analyzing_data.level>current_data.level)
									U << "\blue Database: \black <b>UPDATED</b>."
									current_data.level = analyzing_data.level
								break//Move on to next.
					else	break//Otherwise, quit processing.
			U << "\blue Data analyzed. Process finished."

		if("WIRE")
			var/obj/structure/cable/A = target
			var/datum/powernet/PN = A.powernet
			while(G.candrain&&!maxcapacity&&!isnull(A))
				drain = (round((rand(G.mindrain,G.maxdrain))/2))
				var/drained = 0
				if(PN&&do_after(U,10))
					drained = min(drain, PN.avail)
					PN.load += drained
					if(drained < drain)//if no power on net, drain apcs
						for(var/obj/machinery/power/terminal/T in PN.nodes)
							if(istype(T.master, /obj/machinery/power/apc))
								var/obj/machinery/power/apc/AP = T.master
								if(AP.operating && AP.cell && AP.cell.charge>0)
									AP.cell.charge = max(0, AP.cell.charge - 5)
									drained += 5
				else	break
				S.cell.charge += drained
				if(S.cell.charge>S.cell.maxcharge)
					totaldrain += (drained-(S.cell.charge-S.cell.maxcharge))
					S.cell.charge = S.cell.maxcharge
					maxcapacity = 1
				else
					totaldrain += drained
				S.spark_system.start()
				if(drained==0)	break
			U << "\blue Gained <B>[totaldrain]</B> energy from the power network."

		if("MECHA")
			var/obj/mecha/A = target
			A.occupant_message("\red Warning: Unauthorized access through sub-route 4, block H, detected.")
			if(A.get_charge())
				while(G.candrain&&A.cell.charge>0&&!maxcapacity)
					drain = rand(G.mindrain,G.maxdrain)
					if(A.cell.charge<drain)
						drain = A.cell.charge
					if(S.cell.charge+drain>S.cell.maxcharge)
						drain = S.cell.maxcharge-S.cell.charge
						maxcapacity = 1
					if (do_after(U,10))
						A.spark_system.start()
						playsound(A.loc, "sparks", 50, 1)
						A.cell.use(drain)
						S.cell.charge+=drain
						totaldrain+=drain
					else	break
				U << "\blue Gained <B>[totaldrain]</B> energy from [src]."
			else
				U << "\red The exosuit's battery has run dry. You must find another source of power."

		if("CYBORG")
			var/mob/living/silicon/robot/A = target
			A << "\red Warning: Unauthorized access through sub-route 12, block C, detected."
			G.draining = 1
			if(A.cell&&A.cell.charge)
				while(G.candrain&&A.cell.charge>0&&!maxcapacity)
					drain = rand(G.mindrain,G.maxdrain)
					if(A.cell.charge<drain)
						drain = A.cell.charge
					if(S.cell.charge+drain>S.cell.maxcharge)
						drain = S.cell.maxcharge-S.cell.charge
						maxcapacity = 1
					if (do_after(U,10))
						A.spark_system.start()
						playsound(A.loc, "sparks", 50, 1)
						A.cell.charge-=drain
						S.cell.charge+=drain
						totaldrain+=drain
					else	break
				U << "\blue Gained <B>[totaldrain]</B> energy from [A]."
			else
				U << "\red Their battery has run dry of power. You must find another source."

		else//Else nothing :<

	G.draining = 0

	return

//=======//GENERAL PROCS//=======//

/obj/item/clothing/gloves/space_ninja/proc/toggled()
	set name = "Toggle Interaction"
	set desc = "Toggles special interaction on or off."
	set category = "Ninja Equip"

	var/mob/living/carbon/human/U = loc
	U << "You <b>[candrain?"disable":"enable"]</b> special interaction."
	candrain=!candrain

/obj/item/clothing/gloves/space_ninja/examine()
	set src in view()
	..()
	if(flags & NODROP)
		var/mob/living/carbon/human/U = loc
		U.send_text_to_tab("The energy drain mechanism is: <B>[candrain?"active":"inactive"]</B>.", "ic")
		U << "The energy drain mechanism is: <B>[candrain?"active":"inactive"]</B>."

/*
===================================================================================
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SPACE NINJA MASK>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
===================================================================================
*/

/obj/item/clothing/mask/gas/voice/space_ninja/New()
	verbs += /obj/item/clothing/mask/gas/voice/space_ninja/proc/togglev
	verbs += /obj/item/clothing/mask/gas/voice/space_ninja/proc/switchm

//This proc is linked to human life.dm. It determines what hud icons to display based on mind special role for most mobs.
/obj/item/clothing/mask/gas/voice/space_ninja/proc/assess_targets(list/target_list, mob/living/carbon/U)
	var/icon/tempHud = 'icons/mob/hud.dmi'
	for(var/mob/living/target in target_list)
		if(iscarbon(target))
			switch(target.mind.special_role)
				if("traitor")
					U.client.images += image(tempHud,target,"hudtraitor")
				if("Revolutionary","Head Revolutionary")
					U.client.images += image(tempHud,target,"hudrevolutionary")
				if("Cultist")
					U.client.images += image(tempHud,target,"hudcultist")
				if("Changeling")
					U.client.images += image(tempHud,target,"hudchangeling")
				if("Wizard","Fake Wizard")
					U.client.images += image(tempHud,target,"hudwizard")
				if("Hunter","Sentinel","Drone","Queen")
					U.client.images += image(tempHud,target,"hudalien")
				if("Syndicate")
					U.client.images += image(tempHud,target,"hudoperative")
				if("Death Commando")
					U.client.images += image(tempHud,target,"huddeathsquad")
				if("Space Ninja")
					U.client.images += image(tempHud,target,"hudninja")
				else//If we don't know what role they have but they have one.
					U.client.images += image(tempHud,target,"hudunknown1")
		else if(issilicon(target))//If the silicon mob has no law datum, no inherent laws, or a law zero, add them to the hud.
			var/mob/living/silicon/silicon_target = target
			if(!silicon_target.laws||(silicon_target.laws&&(silicon_target.laws.zeroth||!silicon_target.laws.inherent.len)))
				if(isrobot(silicon_target))//Different icons for robutts and AI.
					U.client.images += image(tempHud,silicon_target,"hudmalborg")
				else
					U.client.images += image(tempHud,silicon_target,"hudmalai")
	return 1

/obj/item/clothing/mask/gas/voice/space_ninja/proc/togglev()
	set name = "Toggle Voice"
	set desc = "Toggles the voice synthesizer on or off."
	set category = "Ninja Equip"

	var/mob/U = loc//Can't toggle voice when you're not wearing the mask.
	var/vchange = (alert("Would you like to synthesize a new name or turn off the voice synthesizer?",,"New Name","Turn Off"))
	if(vchange=="New Name")
		var/chance = rand(1,100)
		switch(chance)
			if(1 to 50)//High chance of a regular name.
				voice = "[rand(0,1)==1?pick(first_names_female):pick(first_names_male)] [pick(last_names)]"
			if(51 to 80)//Smaller chance of a clown name.
				voice = "[pick(clown_names)]"
			if(81 to 90)//Small chance of a wizard name.
				voice = "[pick(wizard_first)] [pick(wizard_second)]"
			if(91 to 100)//Small chance of an existing crew name.
				var/names[] = new()
				for(var/mob/living/carbon/human/M in player_list)
					if(M==U||!M.client||!M.real_name)	continue
					names.Add(M.real_name)
				voice = !names.len ? "Cuban Pete" : pick(names)
		U << "You are now mimicking <B>[voice]</B>."
	else
		U << "The voice synthesizer is [voice!="Unknown"?"now":"already"] deactivated."
		voice = "Unknown"
	return

/obj/item/clothing/mask/gas/voice/space_ninja/proc/switchm()
	set name = "Switch Mode"
	set desc = "Switches between Night Vision, Meson, or Thermal vision modes."
	set category = "Ninja Equip"
	//Have to reset these manually since life.dm is retarded like that. Go figure.
	//This will only work for humans because only they have the appropriate code for the mask.
	var/mob/U = loc
	switch(mode)
		if(0)
			mode=1
			U << "Switching mode to <B>Night Vision</B>."
		if(1)
			mode=2
			U.see_in_dark = 2
			U << "Switching mode to <B>Thermal Scanner</B>."
		if(2)
			mode=3
			U.see_invisible = SEE_INVISIBLE_LIVING
			U.sight &= ~SEE_MOBS
			U << "Switching mode to <B>Meson Scanner</B>."
		if(3)
			mode=0
			U.sight &= ~SEE_TURFS
			U << "Switching mode to <B>Scouter</B>."

/obj/item/clothing/mask/gas/voice/space_ninja/examine()
	set src in view()
	..()

	var/mode
	switch(mode)
		if(0)
			mode = "Scouter"
		if(1)
			mode = "Night Vision"
		if(2)
			mode = "Thermal Scanner"
		if(3)
			mode = "Meson Scanner"

	usr.send_text_to_tab("<B>[mode]</B> is active.", "ic")
	usr.send_text_to_tab("Voice mimicking algorithm is set <B>[!vchange?"inactive":"active"]</B>.", "ic")
	usr << "<B>[mode]</B> is active."//Leaving usr here since it may be on the floor or on a person.
	usr << "Voice mimicking algorithm is set <B>[!vchange?"inactive":"active"]</B>."

/*
===================================================================================
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SPACE NINJA NET>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
===================================================================================
*/

/*
It will teleport people to a holding facility after 30 seconds. (Check the process() proc to change where teleport goes)
It is possible to destroy the net by the occupant or someone else.
*/

/obj/effect/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"

	density = 1//Can't pass through.
	opacity = 0//Can see through.
	mouse_opacity = 1//So you can hit it with stuff.
	anchored = 1//Can't drag/grab the trapped mob.

	var/health = 25//How much health it has.
	var/mob/living/affecting = null//Who it is currently affecting, if anyone.
	var/mob/living/master = null//Who shot web. Will let this person know if the net was successful or failed.

	proc
		healthcheck()
			if(health <=0)
				density = 0
				if(affecting)
					var/mob/living/carbon/M = affecting
					M.anchored = 0
					for(var/mob/O in viewers(src, 3))
						O.show_message(text("[] was recovered from the energy net!", M.name), 1, text("You hear a grunt."), 2)
					if(!isnull(master))//As long as they still exist.
						master << "\red <b>ERROR</b>: \black unable to initiate transport protocol. Procedure terminated."
				qdel(src)
			return

	process(var/mob/living/carbon/M as mob)
		var/check = 30//30 seconds before teleportation. Could be extended I guess.
		var/mob_name = affecting.name//Since they will report as null if terminated before teleport.
		//The person can still try and attack the net when inside.
		while(!isnull(M)&&!isnull(src)&&check>0)//While M and net exist, and 30 seconds have not passed.
			check--
			sleep(10)

		if(isnull(M)||M.loc!=loc)//If mob is gone or not at the location.
			if(!isnull(master))//As long as they still exist.
				master << "\red <b>ERROR</b>: \black unable to locate \the [mob_name]. Procedure terminated."
			qdel(src)//Get rid of the net.
			return

		if(!isnull(src))//As long as both net and person exist.
			//No need to check for countdown here since while() broke, it's implicit that it finished.

			density = 0//Make the net pass-through.
			invisibility = 101//Make the net invisible so all the animations can play out.
			health = INFINITY//Make the net invincible so that an explosion/something else won't kill it while, spawn() is running.
			for(var/obj/item/W in M)
				if(istype(M,/mob/living/carbon/human))
					if(W==M:w_uniform)	continue//So all they're left with are shoes and uniform.
					if(W==M:shoes)	continue
				M.unEquip(W)

			spawn(0)
				playsound(M.loc, 'sound/effects/sparks4.ogg', 50, 1)
				anim(M.loc,M,'icons/mob/mob.dmi',,"phaseout",,M.dir)

			M.loc = pick(holdingfacility)//Throw mob in to the holding facility.
			M << "\red You appear in a strange place!"

			spawn(0)
				var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
				spark_system.set_up(5, 0, M.loc)
				spark_system.start()
				playsound(M.loc, 'sound/effects/phasein.ogg', 25, 1)
				playsound(M.loc, 'sound/effects/sparks2.ogg', 50, 1)
				anim(M.loc,M,'icons/mob/mob.dmi',,"phasein",,M.dir)
				qdel(src)//Wait for everything to finish, delete the net. Else it will stop everything once net is deleted, including the spawn(0).

			for(var/mob/O in viewers(src, 3))
				O.show_message(text("[] vanished!", M), 1, text("You hear sparks flying!"), 2)

			if(!isnull(master))//As long as they still exist.
				master << "\blue <b>SUCCESS</b>: \black transport procedure of \the [affecting] complete."

			M.anchored = 0//Important.

		else//And they are free.
			M << "\blue You are free of the net!"
		return

	bullet_act(var/obj/item/projectile/Proj)
		health -= Proj.damage
		healthcheck()
		..()

	ex_act(severity)
		switch(severity)
			if(1.0)
				health-=50
			if(2.0)
				health-=50
			if(3.0)
				health-=prob(50)?50:25
		healthcheck()
		return

	blob_act()
		health-=50
		healthcheck()
		return

	hitby(AM as mob|obj)
		..()
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\red <B>[src] was hit by [AM].</B>"), 1)
		var/tforce = 0
		if(ismob(AM))
			tforce = 10
		else
			tforce = AM:throwforce
		playsound(src.loc, 'sound/weapons/slash.ogg', 80, 1)
		health = max(0, health - tforce)
		healthcheck()
		..()
		return

	attack_hand()
		if (HULK in usr.mutations)
			usr << text("\blue You easily destroy the energy net.")
			for(var/mob/O in oviewers(src))
				O.show_message(text("\red [] rips the energy net apart!", usr), 1)
			health-=50
		healthcheck()
		return

	attack_paw()
		return attack_hand()

	attack_alien()
		if (islarva(usr))
			return
		usr << text("\green You claw at the net.")
		for(var/mob/O in oviewers(src))
			O.show_message(text("\red [] claws at the energy net!", usr), 1)
		playsound(src.loc, 'sound/weapons/slash.ogg', 80, 1)
		health -= rand(10, 20)
		if(health <= 0)
			usr << text("\green You slice the energy net to pieces.")
			for(var/mob/O in oviewers(src))
				O.show_message(text("\red [] slices the energy net apart!", usr), 1)
		healthcheck()
		return

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		var/aforce = W.force
		health = max(0, health - aforce)
		healthcheck()
		..()
		return

proc/create_ninja_mind(key)
	var/datum/mind/Mind = new /datum/mind(key)
	Mind.assigned_role = "MODE"
	Mind.special_role = "Space Ninja"
	ticker.mode.traitors |= Mind			//Adds them to current traitor list. Which is really the extra antagonist list.
	return Mind