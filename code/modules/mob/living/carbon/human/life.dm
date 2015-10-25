//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!
#define HUMAN_MAX_OXYLOSS 3 //Defines how much oxyloss humans can get per tick. A tile with no air at all (such as space) applies this value, otherwise it's a percentage of it.
#define HUMAN_CRIT_MAX_OXYLOSS ( (last_tick_duration) /3) //The amount of damage you'll get when in critical condition. We want this to be a 5 minute deal = 300s. There are 100HP to get through, so (1/3)*last_tick_duration per second. Breaths however only happen every 4 ticks.

#define HEAT_DAMAGE_LEVEL_1 2 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 3 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 8 //Amount of damage applied when your body temperature passes the 460K point and you are on fire

#define COLD_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 3 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

#define TINT_IMPAIR 2			//Threshold of tint level to apply weld mask overlay
#define TINT_BLIND 3			//Threshold of tint level to obscure vision fully

/mob/living/carbon/human
	var/oxygen_alert = 0
	var/toxins_alert = 0
	var/fire_alert = 0
	var/pressure_alert = 0
	var/temperature_alert = 0
	var/tinttotal = 0				// Total level of visualy impairing items



/mob/living/carbon/human/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	if (notransform)	return
	if(!loc)			return	// Fixing a null error that occurs when the mob isn't found in the world -- TLE

	..()

	//Apparently, the person who wrote this code designed it so that
	//blinded get reset each cycle and then get activated later in the
	//code. Very ugly. I dont care. Moving this stuff here so its easy
	//to find it.
	blinded = null
	fire_alert = 0 //Reset this here, because both breathe() and handle_environment() have a chance to set it.
	tinttotal = tintcheck() //here as both hud updates and status updates call it


	//TODO: seperate this out
	var/datum/gas_mixture/environment = loc.return_air()

	//No need to update all of these procs if the guy is dead.
	if(stat != DEAD)
		if(air_master.current_cycle%4==2 || failed_last_breath) 	//First, resolve location and get a breath
			breathe() 				//Only try to take a breath every 4 ticks, unless suffocating

		else //Still give containing object the chance to interact
			if(istype(loc, /obj/))
				var/obj/location_as_object = loc
				location_as_object.handle_internal_lifeform(src, 0)

		//Updates the number of stored chemicals for powers
		handle_changeling()

		//Mutations and radiation
		handle_mutations_and_radiation()

		//Chemicals in the body
		handle_chemicals_in_body()

		//Disabilities
		handle_disabilities()

		//Random events (vomiting etc)
		handle_random_events()

	//Handle temperature/pressure differences between body and environment
	handle_environment(environment)

	//Handle the blood
	handle_blood()

	//Check if we're on fire
	handle_fire()

	//stuff in the stomach
	handle_stomach()

	//Status updates, death etc.
	handle_regular_status_updates()		//TODO: optimise ~Carn
	update_canmove()

	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

	handle_regular_hud_updates()

	// Grabbing
	for(var/obj/item/weapon/grab/G in src)
		G.process()


/mob/living/carbon/human/calculate_affecting_pressure(var/pressure)
	..()
	var/pressure_difference = abs( pressure - ONE_ATMOSPHERE )

	var/pressure_adjustment_coefficient = 1	//Determins how much the clothing you are wearing protects you in percent.
	if(wear_suit && (wear_suit.flags & STOPSPRESSUREDMAGE))
		pressure_adjustment_coefficient -= PRESSURE_SUIT_REDUCTION_COEFFICIENT
	if(head && (head.flags & STOPSPRESSUREDMAGE))
		pressure_adjustment_coefficient -= PRESSURE_HEAD_REDUCTION_COEFFICIENT
	pressure_adjustment_coefficient = max(pressure_adjustment_coefficient,0) //So it isn't less than 0
	pressure_difference = pressure_difference * pressure_adjustment_coefficient
	if(pressure > ONE_ATMOSPHERE)
		return ONE_ATMOSPHERE + pressure_difference
	else
		return ONE_ATMOSPHERE - pressure_difference


/mob/living/carbon/human

	proc/handle_disabilities()
		if (disabilities & EPILEPSY)
			if ((prob(1) && paralysis < 1))
				src << "\red You have a seizure!"
				for(var/mob/O in viewers(src, null))
					if(O == src)
						continue
					O.show_message(text("\red <B>[src] starts having a seizure!"), 1)
				Paralyse(10)
				Jitter(1000)
		if (disabilities & COUGHING)
			if ((prob(5) && paralysis <= 1))
				drop_item()
				emote("cough")
		if (disabilities & TOURETTES)
			if ((prob(10) && paralysis <= 1))
				Stun(2)
				switch(rand(1, 3))
					if(1)
						emote("twitch")
					if(2 to 3)
						say("[prob(50) ? ";" : ""][pick("SHIT", "PISS", "FUCK", "CUNT", "COCKSUCKER", "MOTHERFUCKER", "TITS")]")
				var/x_offset = pixel_x + rand(-2,2) //Should probably be moved into the twitch emote at some point.
				var/y_offset = pixel_y + rand(-1,1)
				animate(src, pixel_x = pixel_x + x_offset, pixel_y = pixel_y + y_offset, time = 1)
				animate(pixel_x = initial(pixel_x) , pixel_y = initial(pixel_y), time = 1)
		if (disabilities & NERVOUS)
			if (prob(10))
				stuttering = max(10, stuttering)
		if (getBrainLoss() >= 60 && stat != 2)
			if (prob(3))
				switch(pick(1,2,3))
					if(1)
						say(pick("It's a series of tubes!","Persus halp!!","HELP H-HELP! I'M B-BEING REPRESSED!","put uh donk on et","SOOn TM","I WANNA PET TEH monkeyS","can u give me [pick("telikesis","halk","eppilapse")]?","i want [pick("all aces","capton id","pew pew")]?","luv can bloooom","without oxigen blob don't evoluate?","Nanotransen!","SWAY N CIRCUMGYRATE"))
					if(2)
						say(pick("WE LOOSE!!","BI, tHE bEST OF bOTH WORLDS!!","captain is comdom","SOTP IT!!","roll it easy!","waaaaaagh","sELFIE!!","PACKETS!!!","can yu deepfry this?","wots a weemen?","this is just like one of my japanese animes!!","wANNA pLAY A gAME??","LOCATION!?!"))
					if(3)
						emote("drool")


	proc/handle_mutations_and_radiation()
		if(getFireLoss())
			if((COLD_RESISTANCE in mutations) || (prob(1)))
				heal_organ_damage(0,1)

		if ((HULK in mutations) && health <= 25)
			mutations.Remove(HULK)
			update_mutations()		//update our mutation overlays
			src << "\red You suddenly feel very weak."
			Weaken(3)
			emote("collapse")

		if (radiation)
			if (radiation > 100)
				radiation = 100
				Weaken(10)
				src << "\red You feel weak."
				emote("collapse")

			if (radiation < 0)
				radiation = 0

			else
				switch(radiation)
					if(1 to 49)
						radiation--
						if(prob(25))
							adjustToxLoss(1)
							updatehealth()

					if(50 to 74)
						radiation -= 2
						adjustToxLoss(1)
						if(prob(5))
							radiation -= 5
							Weaken(3)
							src << "\red You feel weak."
							emote("collapse")
						if(prob(15))
							if(!( hair_style == "Shaved") || !(hair_style == "Bald"))
								src << "<span class='danger'>Your hair starts to fall out in clumps...<span>"
								spawn(50)
									facial_hair_style = "Shaved"
									hair_style = "Bald"
									update_hair()
						updatehealth()

					if(75 to 100)
						radiation -= 3
						adjustToxLoss(3)
						if(prob(1))
							src << "\red You mutate!"
							randmutb(src)
							domutcheck(src,null)
							emote("gasp")
						updatehealth()


	proc/breathe()

		if(reagents.has_reagent("lexorin")) return
		if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell)) return

		var/datum/gas_mixture/environment = loc.return_air()
		var/datum/gas_mixture/breath
		// HACK NEED CHANGING LATER
		if(health <= config.health_threshold_crit)
			losebreath++
		if(blood && blood.total_volume <= BLOODLOSS_CRIT)
			losebreath++

		if(losebreath>0) //Suffocating so do not take a breath
			losebreath--
			if (prob(10)) //Gasp per 10 ticks? Sounds about right.
				spawn emote("gasp")
			if(istype(loc, /obj/))
				var/obj/location_as_object = loc
				location_as_object.handle_internal_lifeform(src, 0)
		else
			//First, check for air from internal atmosphere (using an air tank and mask generally)
			breath = get_breath_from_internal(BREATH_VOLUME) // Super hacky -- TLE
			//breath = get_breath_from_internal(0.5) // Manually setting to old BREATH_VOLUME amount -- TLE

			//No breath from internal atmosphere so get breath from location
			if(!breath)
				if(isobj(loc))
					var/obj/location_as_object = loc
					breath = location_as_object.handle_internal_lifeform(src, BREATH_VOLUME)
				else if(isturf(loc))
					var/breath_moles = 0
					/*if(environment.return_pressure() > ONE_ATMOSPHERE)
						// Loads of air around (pressure effect will be handled elsewhere), so lets just take a enough to fill our lungs at normal atmos pressure (using n = Pv/RT)
						breath_moles = (ONE_ATMOSPHERE*BREATH_VOLUME/R_IDEAL_GAS_EQUATION*environment.temperature)
					else*/
						// Not enough air around, take a percentage of what's there to model this properly
					breath_moles = environment.total_moles()*BREATH_PERCENTAGE

					breath = loc.remove_air(breath_moles)
					// Handle chem smoke effect  -- Doohl
					var/block = 0
					if(wear_mask)
						if(wear_mask.flags & BLOCK_GAS_SMOKE_EFFECT)
							block = 1
					if(glasses)
						if(glasses.flags & BLOCK_GAS_SMOKE_EFFECT)
							block = 1
					if(head)
						if(head.flags & BLOCK_GAS_SMOKE_EFFECT)
							block = 1

					if(!block)

						for(var/obj/effect/effect/chem_smoke/smoke in view(1, src))
							if(smoke.reagents.total_volume)
								smoke.reagents.reaction(src, INGEST)
								spawn(5)
									if(smoke)
										smoke.reagents.copy_to(src, 10) // I dunno, maybe the reagents enter the blood stream through the lungs?
								break // If they breathe in the nasty stuff once, no need to continue checking

			else //Still give containing object the chance to interact
				if(istype(loc, /obj/))
					var/obj/location_as_object = loc
					location_as_object.handle_internal_lifeform(src, 0)

		handle_breath(breath)

		if(breath)
			loc.assume_air(breath)


	proc/get_breath_from_internal(volume_needed)
		if(internal)
			if (!contents.Find(internal))
				internal = null
			if (!wear_mask || !(wear_mask.flags & MASKINTERNALS) )
				internal = null
			if(internal)
				return internal.remove_air_volume(volume_needed)
			else if(internals)
				internals.icon_state = "internal0"
		return null


	proc/handle_breath(datum/gas_mixture/breath)
		if((status_flags & GODMODE))
			return

		if(istype(src,/mob/living/carbon/human/npc))
			var/mob/living/carbon/human/npc/NPC = src
			if(NPC.breath_check())
				return

		if(!breath || (breath.total_moles() == 0) || suiciding)
			if(reagents.has_reagent("inaprovaline"))
				return
			if(suiciding)
				adjustOxyLoss(2)//If you are suiciding, you should die a little bit faster
				failed_last_breath = 1
				oxygen_alert = max(oxygen_alert, 1)
				return 0
			if(health >= config.health_threshold_crit)
				adjustOxyLoss(HUMAN_MAX_OXYLOSS)
				failed_last_breath = 1
			else
				adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)
				failed_last_breath = 1

			oxygen_alert = max(oxygen_alert, 1)

			return 0

		var/safe_oxygen_min = 16 // Minimum safe partial pressure of O2, in kPa
		//var/safe_oxygen_max = 140 // Maximum safe partial pressure of O2, in kPa (Not used for now)
		var/safe_co2_max = 10 // Yes it's an arbitrary value who cares?
		var/safe_toxins_max = 0.005
		var/SA_para_min = 1
		var/SA_sleep_min = 5
		var/oxygen_used = 0
		var/breath_pressure = (breath.total_moles()*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME

		//Partial pressure of the O2 in our breath
		var/O2_pp = (breath.gasses[OXYGEN]/breath.total_moles())*breath_pressure
		// Same, but for the toxins
		var/Toxins_pp = (breath.gasses[PLASMA]/breath.total_moles())*breath_pressure
		// And CO2, lets say a PP of more than 10 will be bad (It's a little less really, but eh, being passed out all round aint no fun)
		var/CO2_pp = (breath.gasses[CARBONDIOXIDE]/breath.total_moles())*breath_pressure // Tweaking to fit the hacky bullshit I've done with atmo -- TLE
		//var/CO2_pp = (breath.carbon_dioxide/breath.total_moles())*0.5 // The default pressure value

		if(O2_pp < safe_oxygen_min) 			// Too little oxygen
			if(prob(20))
				spawn(0) emote("gasp")
			if(O2_pp > 0)
				var/ratio = safe_oxygen_min/O2_pp
				adjustOxyLoss(min(5*ratio, HUMAN_MAX_OXYLOSS)) // Don't fuck them up too fast (space only does HUMAN_MAX_OXYLOSS after all!)
				failed_last_breath = 1
				oxygen_used = breath.gasses[OXYGEN]*ratio/6
			else
				adjustOxyLoss(HUMAN_MAX_OXYLOSS)
				failed_last_breath = 1
			oxygen_alert = max(oxygen_alert, 1)
		/*else if (O2_pp > safe_oxygen_max) 		// Too much oxygen (commented this out for now, I'll deal with pressure damage elsewhere I suppose)
			spawn(0) emote("cough")
			var/ratio = O2_pp/safe_oxygen_max
			oxyloss += 5*ratio
			oxygen_used = breath.gasses[OXYGEN]*ratio/6
			oxygen_alert = max(oxygen_alert, 1)*/
		else								// We're in safe limits
			failed_last_breath = 0
			adjustOxyLoss(-5)
			oxygen_used = breath.gasses[OXYGEN]/6
			oxygen_alert = 0

		breath.add_gas(OXYGEN, -1 * oxygen_used)
		breath.add_gas(CARBONDIOXIDE, oxygen_used)

		//CO2 does not affect failed_last_breath. So if there was enough oxygen in the air but too much co2, this will hurt you, but only once per 4 ticks, instead of once per tick.
		if(CO2_pp > safe_co2_max)
			if(!co2overloadtime) // If it's the first breath with too much CO2 in it, lets start a counter, then have them pass out after 12s or so.
				co2overloadtime = world.time
			else if(world.time - co2overloadtime > 120)
				Paralyse(3)
				adjustOxyLoss(3) // Lets hurt em a little, let them know we mean business
				if(world.time - co2overloadtime > 300) // They've been in here 30s now, lets start to kill them for their own good!
					adjustOxyLoss(8)
			if(prob(20)) // Lets give them some chance to know somethings not right though I guess.
				spawn(0) emote("cough")

		else
			co2overloadtime = 0

		if(Toxins_pp > safe_toxins_max) // Too much toxins
			var/ratio = (breath.gasses[PLASMA]/safe_toxins_max) * 10
			//adjustToxLoss(Clamp(ratio, MIN_PLASMA_DAMAGE, MAX_PLASMA_DAMAGE))	//Limit amount of damage toxin exposure can do per second
			if(reagents)
				reagents.add_reagent("plasma", Clamp(ratio, MIN_PLASMA_DAMAGE, MAX_PLASMA_DAMAGE))
			toxins_alert = max(toxins_alert, 1)
		else
			toxins_alert = 0


		if(breath.gasses[NITROUS])	// Nitrous Oxide handling
			var/SA_pp = (breath.gasses[NITROUS]/breath.total_moles())*breath_pressure
			if(SA_pp > SA_para_min) // Enough to make us paralysed for a bit
				Paralyse(3) // 3 gives them one second to wake up and run away a bit!
				if(SA_pp > SA_sleep_min) // Enough to make us sleep as well
					sleeping = max(sleeping+2, 10)
			else if(SA_pp > 0.01)	// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
				if(prob(20))
					spawn(0) emote(pick("giggle", "laugh"))

		if( (abs(310.15 - breath.temperature) > 50) && !(COLD_RESISTANCE in mutations)) // Hot air hurts :(
			if(breath.temperature < 260.15)
				if(prob(20))
					src << "\red You feel your face freezing and an icicle forming in your lungs!"
			else if(breath.temperature > 360.15)
				if(prob(20))
					src << "\red You feel your face burning and a searing heat in your lungs!"

			switch(breath.temperature)
				if(-INFINITY to 120)
					apply_damage(COLD_GAS_DAMAGE_LEVEL_3, BURN, "head")
					fire_alert = max(fire_alert, 1)
				if(120 to 200)
					apply_damage(COLD_GAS_DAMAGE_LEVEL_2, BURN, "head")
					fire_alert = max(fire_alert, 1)
				if(200 to 260)
					apply_damage(COLD_GAS_DAMAGE_LEVEL_1, BURN, "head")
					fire_alert = max(fire_alert, 1)
				if(360 to 400)
					apply_damage(HEAT_GAS_DAMAGE_LEVEL_1, BURN, "head")
					fire_alert = max(fire_alert, 2)
				if(400 to 1000)
					apply_damage(HEAT_GAS_DAMAGE_LEVEL_2, BURN, "head")
					fire_alert = max(fire_alert, 2)
				if(1000 to INFINITY)
					apply_damage(HEAT_GAS_DAMAGE_LEVEL_3, BURN, "head")
					fire_alert = max(fire_alert, 2)

		//Temporary fixes to the alerts.

		return 1

	proc/handle_environment(datum/gas_mixture/environment)
		if(!environment)
			return

		var/loc_temp = get_temperature(environment)
		//world << "Loc temp: [loc_temp] - Body temp: [bodytemperature] - Fireloss: [getFireLoss()] - Thermal protection: [get_thermal_protection()] - Fire protection: [thermal_protection + add_fire_protection(loc_temp)] - Heat capacity: [environment_heat_capacity] - Location: [loc] - src: [src]"

		//Body temperature is adjusted in two steps. Firstly your body tries to stabilize itself a bit.
		if(stat != 2)
			stabilize_temperature_from_calories()

		//After then, it reacts to the surrounding atmosphere based on your thermal protection
		if(!on_fire) //If you're on fire, you do not heat up or cool down based on surrounding gases
			if(loc_temp < bodytemperature)
				//Place is colder than we are
				var/thermal_protection = get_cold_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
				if(thermal_protection < 1)
					bodytemperature += min((1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_COLD_DIVISOR), BODYTEMP_COOLING_MAX)
			else
				//Place is hotter than we are
				var/thermal_protection = get_heat_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
				if(thermal_protection < 1)
					bodytemperature += min((1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_HEAT_DIVISOR), BODYTEMP_HEATING_MAX)

		// +/- 50 degrees from 310.15K is the 'safe' zone, where no damage is dealt.
		if(bodytemperature > BODYTEMP_HEAT_DAMAGE_LIMIT)
			//Body temperature is too hot.
			fire_alert = max(fire_alert, 1)
			switch(bodytemperature)
				if(360 to 400)
					apply_damage(HEAT_DAMAGE_LEVEL_1, BURN)
					fire_alert = max(fire_alert, 2)
				if(400 to 460)
					apply_damage(HEAT_DAMAGE_LEVEL_2, BURN)
					fire_alert = max(fire_alert, 2)
				if(460 to INFINITY)
					if(on_fire)
						apply_damage(HEAT_DAMAGE_LEVEL_3, BURN)
						fire_alert = max(fire_alert, 2)
					else
						apply_damage(HEAT_DAMAGE_LEVEL_2, BURN)
						fire_alert = max(fire_alert, 2)

		else if(bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT)
			fire_alert = max(fire_alert, 1)
			if(!istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
				switch(bodytemperature)
					if(200 to 260)
						apply_damage(COLD_DAMAGE_LEVEL_1, BURN)
						fire_alert = max(fire_alert, 1)
					if(120 to 200)
						apply_damage(COLD_DAMAGE_LEVEL_2, BURN)
						fire_alert = max(fire_alert, 1)
					if(-INFINITY to 120)
						apply_damage(COLD_DAMAGE_LEVEL_3, BURN)
						fire_alert = max(fire_alert, 1)

		// Account for massive pressure differences.  Done by Polymorph
		// Made it possible to actually have something that can protect against high pressure... Done by Errorage. Polymorph now has an axe sticking from his head for his previous hardcoded nonsense!

		var/pressure = environment.return_pressure()
		var/adjusted_pressure = calculate_affecting_pressure(pressure) //Returns how much pressure actually affects the mob.
		switch(adjusted_pressure)
			if(HAZARD_HIGH_PRESSURE to INFINITY)
				adjustBruteLoss( min( ( (adjusted_pressure / HAZARD_HIGH_PRESSURE) -1 )*PRESSURE_DAMAGE_COEFFICIENT , MAX_HIGH_PRESSURE_DAMAGE) )
				pressure_alert = 2
			if(WARNING_HIGH_PRESSURE to HAZARD_HIGH_PRESSURE)
				pressure_alert = 1
			if(WARNING_LOW_PRESSURE to WARNING_HIGH_PRESSURE)
				pressure_alert = 0
			if(HAZARD_LOW_PRESSURE to WARNING_LOW_PRESSURE)
				pressure_alert = -1
			else
				if( !(COLD_RESISTANCE in mutations) )
					adjustBruteLoss( LOW_PRESSURE_DAMAGE )
					pressure_alert = -2
				else
					pressure_alert = -1

		return

///FIRE CODE
	handle_fire()
		if(..())
			return
		var/thermal_protection = get_heat_protection(30000) //If you don't have fire suit level protection, you get a temperature increase
		if((1 - thermal_protection) > 0.0001)
			bodytemperature += BODYTEMP_HEATING_MAX
		return
//END FIRE CODE

	/*
	proc/adjust_body_temperature(current, loc_temp, boost)
		var/temperature = current
		var/difference = abs(current-loc_temp)	//get difference
		var/increments// = difference/10			//find how many increments apart they are
		if(difference > 50)
			increments = difference/5
		else
			increments = difference/10
		var/change = increments*boost	// Get the amount to change by (x per increment)
		var/temp_change
		if(current < loc_temp)
			temperature = min(loc_temp, temperature+change)
		else if(current > loc_temp)
			temperature = max(loc_temp, temperature-change)
		temp_change = (temperature - current)
		return temp_change
	*/

	proc/stabilize_temperature_from_calories()
		switch(bodytemperature)
			if(-INFINITY to 260.15) //260.15 is 310.15 - 50, the temperature where you start to feel effects.
				if(nutrition >= 2) //If we are very, very cold we'll use up quite a bit of nutriment to heat us up.
					nutrition -= 2
				var/body_temperature_difference = 310.15 - bodytemperature
				bodytemperature += max((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), BODYTEMP_AUTORECOVERY_MINIMUM)
			if(260.15 to 360.15)
				var/body_temperature_difference = 310.15 - bodytemperature
				bodytemperature += body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR
			if(360.15 to INFINITY) //360.15 is 310.15 + 50, the temperature where you start to feel effects.
				//We totally need a sweat system cause it totally makes sense...~
				var/body_temperature_difference = 310.15 - bodytemperature
				bodytemperature += min((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM)	//We're dealing with negative numbers

	//This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, CHEST, GROIN, etc. See setup.dm for the full list)
	proc/get_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.
		var/thermal_protection_flags = 0
		//Handle normal clothing
		if(head)
			if(head.max_heat_protection_temperature && head.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= head.heat_protection
		if(wear_suit)
			if(wear_suit.max_heat_protection_temperature && wear_suit.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= wear_suit.heat_protection
		if(w_uniform)
			if(w_uniform.max_heat_protection_temperature && w_uniform.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= w_uniform.heat_protection
		if(shoes)
			if(shoes.max_heat_protection_temperature && shoes.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= shoes.heat_protection
		if(gloves)
			if(gloves.max_heat_protection_temperature && gloves.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= gloves.heat_protection
		if(wear_mask)
			if(wear_mask.max_heat_protection_temperature && wear_mask.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= wear_mask.heat_protection

		return thermal_protection_flags

	proc/get_heat_protection(temperature) //Temperature is the temperature you're being exposed to.
		var/thermal_protection_flags = get_heat_protection_flags(temperature)

		var/thermal_protection = 0.0
		if(thermal_protection_flags)
			if(thermal_protection_flags & HEAD)
				thermal_protection += THERMAL_PROTECTION_HEAD
			if(thermal_protection_flags & CHEST)
				thermal_protection += THERMAL_PROTECTION_CHEST
			if(thermal_protection_flags & GROIN)
				thermal_protection += THERMAL_PROTECTION_GROIN
			if(thermal_protection_flags & LEG_LEFT)
				thermal_protection += THERMAL_PROTECTION_LEG_LEFT
			if(thermal_protection_flags & LEG_RIGHT)
				thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
			if(thermal_protection_flags & FOOT_LEFT)
				thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
			if(thermal_protection_flags & FOOT_RIGHT)
				thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
			if(thermal_protection_flags & ARM_LEFT)
				thermal_protection += THERMAL_PROTECTION_ARM_LEFT
			if(thermal_protection_flags & ARM_RIGHT)
				thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
			if(thermal_protection_flags & HAND_LEFT)
				thermal_protection += THERMAL_PROTECTION_HAND_LEFT
			if(thermal_protection_flags & HAND_RIGHT)
				thermal_protection += THERMAL_PROTECTION_HAND_RIGHT


		return min(1,thermal_protection)

	//See proc/get_heat_protection_flags(temperature) for the description of this proc.
	proc/get_cold_protection_flags(temperature)
		var/thermal_protection_flags = 0
		//Handle normal clothing

		if(head)
			if(head.min_cold_protection_temperature && head.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= head.cold_protection
		if(wear_suit)
			if(wear_suit.min_cold_protection_temperature && wear_suit.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= wear_suit.cold_protection
		if(w_uniform)
			if(w_uniform.min_cold_protection_temperature && w_uniform.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= w_uniform.cold_protection
		if(shoes)
			if(shoes.min_cold_protection_temperature && shoes.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= shoes.cold_protection
		if(gloves)
			if(gloves.min_cold_protection_temperature && gloves.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= gloves.cold_protection
		if(wear_mask)
			if(wear_mask.min_cold_protection_temperature && wear_mask.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= wear_mask.cold_protection

		return thermal_protection_flags

	proc/get_cold_protection(temperature)

		if(COLD_RESISTANCE in mutations)
			return 1 //Fully protected from the cold.

		temperature = max(temperature, 2.7) //There is an occasional bug where the temperature is miscalculated in ares with a small amount of gas on them, so this is necessary to ensure that that bug does not affect this calculation. Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
		var/thermal_protection_flags = get_cold_protection_flags(temperature)

		var/thermal_protection = 0.0
		if(thermal_protection_flags)
			if(thermal_protection_flags & HEAD)
				thermal_protection += THERMAL_PROTECTION_HEAD
			if(thermal_protection_flags & CHEST)
				thermal_protection += THERMAL_PROTECTION_CHEST
			if(thermal_protection_flags & GROIN)
				thermal_protection += THERMAL_PROTECTION_GROIN
			if(thermal_protection_flags & LEG_LEFT)
				thermal_protection += THERMAL_PROTECTION_LEG_LEFT
			if(thermal_protection_flags & LEG_RIGHT)
				thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
			if(thermal_protection_flags & FOOT_LEFT)
				thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
			if(thermal_protection_flags & FOOT_RIGHT)
				thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
			if(thermal_protection_flags & ARM_LEFT)
				thermal_protection += THERMAL_PROTECTION_ARM_LEFT
			if(thermal_protection_flags & ARM_RIGHT)
				thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
			if(thermal_protection_flags & HAND_LEFT)
				thermal_protection += THERMAL_PROTECTION_HAND_LEFT
			if(thermal_protection_flags & HAND_RIGHT)
				thermal_protection += THERMAL_PROTECTION_HAND_RIGHT

		return min(1,thermal_protection)

	/*
	proc/add_fire_protection(var/temp)
		var/fire_prot = 0
		if(head)
			if(head.protective_temperature > temp)
				fire_prot += (head.protective_temperature/10)
		if(wear_mask)
			if(wear_mask.protective_temperature > temp)
				fire_prot += (wear_mask.protective_temperature/10)
		if(glasses)
			if(glasses.protective_temperature > temp)
				fire_prot += (glasses.protective_temperature/10)
		if(ears)
			if(ears.protective_temperature > temp)
				fire_prot += (ears.protective_temperature/10)
		if(wear_suit)
			if(wear_suit.protective_temperature > temp)
				fire_prot += (wear_suit.protective_temperature/10)
		if(w_uniform)
			if(w_uniform.protective_temperature > temp)
				fire_prot += (w_uniform.protective_temperature/10)
		if(gloves)
			if(gloves.protective_temperature > temp)
				fire_prot += (gloves.protective_temperature/10)
		if(shoes)
			if(shoes.protective_temperature > temp)
				fire_prot += (shoes.protective_temperature/10)

		return fire_prot

	proc/handle_temperature_damage(body_part, exposed_temperature, exposed_intensity)
		if(nodamage)
			return
		//world <<"body_part = [body_part], exposed_temperature = [exposed_temperature], exposed_intensity = [exposed_intensity]"
		var/discomfort = min(abs(exposed_temperature - bodytemperature)*(exposed_intensity)/2000000, 1.0)

		if(exposed_temperature > bodytemperature)
			discomfort *= 4

		if(mutantrace == "plant")
			discomfort *= TEMPERATURE_DAMAGE_COEFFICIENT * 2 //I don't like magic numbers. I'll make mutantraces a datum with vars sometime later. -- Urist
		else
			discomfort *= TEMPERATURE_DAMAGE_COEFFICIENT //Dangercon 2011 - now with less magic numbers!
		//world <<"[discomfort]"

		switch(body_part)
			if(HEAD)
				apply_damage(2.5*discomfort, BURN, "head")
			if(CHEST)
				apply_damage(2.5*discomfort, BURN, "chest")
			if(LEGS)
				apply_damage(0.6*discomfort, BURN, "l_leg")
				apply_damage(0.6*discomfort, BURN, "r_leg")
			if(ARMS)
				apply_damage(0.4*discomfort, BURN, "l_arm")
				apply_damage(0.4*discomfort, BURN, "r_arm")
	*/

	proc/handle_chemicals_in_body()
		if(reagents) reagents.metabolize(src)

		if(dna && dna.mutantrace == "plant") //couldn't think of a better place to place it, since it handles nutrition -- Urist
			var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
			if(isturf(loc)) //else, there's considered to be no light
				var/turf/T = loc
				var/area/A = T.loc
				if(A)
					if(A.lighting_use_dynamic)	light_amount = min(10,T.GetLightRange()) - 5 //hardcapped so it's not abused by having a ton of flashlights
					else						light_amount =  5
			nutrition += light_amount
			if(nutrition > 500)
				nutrition = 500
			if(light_amount > 2) //if there's enough light, heal
				heal_overall_damage(1,1)
				adjustToxLoss(-1)
				adjustOxyLoss(-1)
		if(dna && dna.mutantrace == "shadow")
			var/light_amount = 0
			if(isturf(loc))
				var/turf/T = loc
				var/area/A = T.loc
				if(A)
					if(A.lighting_use_dynamic)	light_amount = T.GetLightRange()
					else						light_amount =  10
			if(light_amount > 2) //if there's enough light, start dying
				take_overall_damage(1,1)
			else if (light_amount < 2) //heal in the dark
				heal_overall_damage(1,1)

		//The fucking FAT mutation is the dumbest shit ever. It makes the code so difficult to work with
		if(FAT in mutations)
			if(overeatduration < 100)
				src << "\blue You feel fit again!"
				mutations -= FAT
				update_inv_w_uniform(0)
				update_inv_wear_suit()
		else
			if(overeatduration > 500)
				src << "\red You suddenly feel blubbery!"
				mutations |= FAT
				update_inv_w_uniform(0)
				update_inv_wear_suit()

		// nutrition decrease
		if (nutrition > 0 && stat != 2)
			nutrition = max (0, nutrition - HUNGER_FACTOR)

		if (nutrition > 450)
			if(overeatduration < 600) //capped so people don't take forever to unfat
				overeatduration++
		else
			if(overeatduration > 1)
				overeatduration -= 2 //doubled the unfat rate

		if(dna && dna.mutantrace == "plant")
			if(nutrition < 200)
				take_overall_damage(2,0)

		if (drowsyness)
			drowsyness--
			eye_blurry = max(2, eye_blurry)
			if (prob(5))
				sleeping += 1
				Paralyse(5)

		confused = max(0, confused - 1)
		// decrement dizziness counter, clamped to 0
		if(resting)
			dizziness = max(0, dizziness - 15)
			jitteriness = max(0, jitteriness - 15)
		else
			dizziness = max(0, dizziness - 3)
			jitteriness = max(0, jitteriness - 3)

		updatehealth()

		return //TODO: DEFERRED

	proc/handle_regular_status_updates()
		if(stat == DEAD)	//DEAD. BROWN BREAD. SWIMMING WITH THE SPESS CARP
			blinded = 1
			silent = 0
		else				//ALIVE. LIGHTS ARE ON
			updatehealth()	//TODO
			if(health <= config.health_threshold_dead || !getorgan(/obj/item/organ/brain))
				death()
				blinded = 1
				silent = 0
				return 1


			//UNCONSCIOUS. NO-ONE IS HOME
			if( (getOxyLoss() > 50) || (config.health_threshold_crit >= health) )
				Paralyse(3)

				/* Done by handle_breath()
				if( health <= 20 && prob(1) )
					spawn(0)
						emote("gasp")
				if(!reagents.has_reagent("inaprovaline"))
					adjustOxyLoss(1)*/

			if(hallucination)
				if(hallucination >= 20)
					if(prob(3))
						fake_attack(src)
					if(!handling_hal)
						spawn handle_hallucinations() //The not boring kind!

				if(hallucination<=2)
					hallucination = 0
				else
					hallucination -= 2

			else
				for(var/atom/a in hallucinations)
					qdel(a)

			if(paralysis)
				AdjustParalysis(-1)
				blinded = 1
				stat = UNCONSCIOUS
			else if(sleeping)
				handle_dreams()
				adjustStaminaLoss(-10)
				sleeping = max(sleeping-1, 0)
				blinded = 1
				stat = UNCONSCIOUS
				if( prob(10) && health && !hal_crit )
					spawn(0)
						emote("snore")
			//CONSCIOUS
			else
				stat = CONSCIOUS

			//Eyes
			if(sdisabilities & BLIND)	//disabled-blind, doesn't get better on its own
				blinded = 1
			else if(eye_blind)			//blindness, heals slowly over time
				eye_blind = max(eye_blind-1,0)
				blinded = 1
			else if(tinttotal >= TINT_BLIND)		//covering your eyes heals blurry eyes faster
				eye_blurry = max(eye_blurry-3, 0)
			//	blinded = 1				//now handled under /handle_regular_hud_updates()
			else if(eye_blurry)	//blurry eyes heal slowly
				eye_blurry = max(eye_blurry-1, 0)

			//Ears
			if(sdisabilities & DEAF)	//disabled-deaf, doesn't get better on its own
				ear_deaf = max(ear_deaf, 1)
			else if(istype(ears, /obj/item/clothing/ears/earmuffs))	//resting your ears with earmuffs heals ear damage faster, and slowly heals deafness
				ear_damage = max(ear_damage-0.15, 0)
				ear_deaf = max(ear_deaf-1, 1)
			else if(ear_deaf) //deafness, heals slowly over time
				ear_deaf = max(ear_deaf-1, 0)
			else if(ear_damage < 25)	//ear damage heals slowly under this threshold. otherwise you'll need earmuffs
				ear_damage = max(ear_damage-0.05, 0)

			//Dizziness
			if(dizziness)
				var/client/C = client
				var/pixel_x_diff = 0
				var/pixel_y_diff = 0
				var/temp
				var/saved_dizz = dizziness
				dizziness = max(dizziness-1, 0)
				if(C)
					var/oldsrc = src
					var/amplitude = dizziness*(sin(dizziness * 0.044 * world.time) + 1) / 70 // This shit is annoying at high strength
					src = null
					spawn(0)
						if(C)
							temp = amplitude * sin(0.008 * saved_dizz * world.time)
							pixel_x_diff += temp
							C.pixel_x += temp
							temp = amplitude * cos(0.008 * saved_dizz * world.time)
							pixel_y_diff += temp
							C.pixel_y += temp
							sleep(3)
							if(C)
								temp = amplitude * sin(0.008 * saved_dizz * world.time)
								pixel_x_diff += temp
								C.pixel_x += temp
								temp = amplitude * cos(0.008 * saved_dizz * world.time)
								pixel_y_diff += temp
								C.pixel_y += temp
							sleep(3)
							if(C)
								C.pixel_x -= pixel_x_diff
								C.pixel_y -= pixel_y_diff
					src = oldsrc

			//Jitteryness
			if(jitteriness)
				var/amplitude = min(4, (jitteriness/100) + 1)
				var/pixel_x_diff = rand(-amplitude, amplitude)
				var/pixel_y_diff = rand(-amplitude/3, amplitude/3)

				animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff , time = 2, loop = -1)
				animate(pixel_x = initial(pixel_x) , pixel_y = initial(pixel_y) , time = 2)
				floating = 0 // If we were without gravity, the bouncing animation got stopped, so we make sure we restart the bouncing after the next movement.
				jitteriness = max(jitteriness-1, 0)

			//Other
			if(stunned)
				AdjustStunned(-1)

			if(weakened)
				weakened = max(weakened-1,0)

			if(stuttering)
				stuttering = max(stuttering-1, 0)

			if(slurring)
				slurring = max(slurring-1, 0)

			if(silent)
				silent = max(silent-1, 0)

			if(druggy)
				druggy = max(druggy-1, 0)

			CheckStamina()

			//Werewolf
			if(mind && mind.special_role == "Werewolf")
				if(world.time > ((WEREWOLF_HUMAN_COOLDOWN * 60) * 10) + LastTransformation)
					if(prob(5))
						var/mob/living/carbon/werewolf/W = new /mob/living/carbon/werewolf(src.loc)
						W.Initiate(src)

		return 1

	proc/handle_regular_hud_updates()
		if(!client)	return 0

		for(var/image/hud in client.images)
			if(copytext(hud.icon_state,1,4) == "hud") //ugly, but icon comparison is worse, I believe
				client.images.Remove(hud)

		update_action_buttons()

		if(stat == UNCONSCIOUS)
			//Critical damage passage overlay
			if(health <= config.health_threshold_crit)
				var/image/I = image("icon" = 'icons/mob/screen_full.dmi', "icon_state" = "passage0")
				I.blend_mode = BLEND_OVERLAY //damageoverlay is BLEND_MULTIPLY
				var/severity = 0
				switch(health)
					if(-20 to -10)
						I.icon_state = "passage1"
						severity = 1
					if(-30 to -20)
						I.icon_state = "passage2"
						severity = 2
					if(-40 to -30)
						I.icon_state = "passage3"
						severity = 3
					if(-50 to -40)
						I.icon_state = "passage4"
						severity = 4
					if(-60 to -50)
						I.icon_state = "passage5"
						severity = 5
					if(-70 to -60)
						I.icon_state = "passage6"
						severity = 6
					if(-80 to -70)
						I.icon_state = "passage7"
						severity = 7
					if(-90 to -80)
						I.icon_state = "passage8"
						severity = 8
					if(-95 to -90)
						I.icon_state = "passage9"
						severity = 9
					if(-INFINITY to -95)
						I.icon_state = "passage10"
						severity = 10
				overlay_fullscreen("crit", /obj/screen/fullscreen/crit, severity)
		else
			clear_fullscreen("crit")
			//Oxygen damage overlay
			if(oxyloss)
				var/image/I = image("icon" = 'icons/mob/screen_full.dmi', "icon_state" = "oxydamageoverlay0")
				var/severity = 0
				switch(oxyloss)
					if(10 to 20)
						I.icon_state = "oxydamageoverlay1"
						severity = 1
					if(20 to 25)
						I.icon_state = "oxydamageoverlay2"
						severity = 2
					if(25 to 30)
						I.icon_state = "oxydamageoverlay3"
						severity = 3
					if(30 to 35)
						I.icon_state = "oxydamageoverlay4"
						severity = 4
					if(35 to 40)
						I.icon_state = "oxydamageoverlay5"
						severity = 5
					if(40 to 45)
						I.icon_state = "oxydamageoverlay6"
						severity = 6
					if(45 to INFINITY)
						I.icon_state = "oxydamageoverlay7"
						severity = 7
				overlay_fullscreen("oxy", /obj/screen/fullscreen/oxy, severity)
			else
				clear_fullscreen("oxy")

			//Fire and Brute damage overlay (BSSR)
			var/hurtdamage = src.getBruteLoss() + src.getFireLoss() + src.getBloodLoss() + damageoverlaytemp
			damageoverlaytemp = 0 // We do this so we can detect if someone hits us or not.
			if(hurtdamage)
				var/image/I = image("icon" = 'icons/mob/screen_full.dmi', "icon_state" = "brutedamageoverlay0")
				I.blend_mode = BLEND_ADD
				var/severity = 0
				switch(hurtdamage)
					if(5 to 15)
						I.icon_state = "brutedamageoverlay1"
						severity = 1
					if(15 to 30)
						I.icon_state = "brutedamageoverlay2"
						severity = 2
					if(30 to 45)
						I.icon_state = "brutedamageoverlay3"
						severity = 3
					if(45 to 70)
						I.icon_state = "brutedamageoverlay4"
						severity = 4
					if(70 to 85)
						I.icon_state = "brutedamageoverlay5"
						severity = 5
					if(85 to INFINITY)
						I.icon_state = "brutedamageoverlay6"
						severity = 6
				overlay_fullscreen("brute", /obj/screen/fullscreen/brute, severity)
			else
				clear_fullscreen("brute")

		if( stat == DEAD )
			sight |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)
			see_in_dark = 8
			if(!druggy)		see_invisible = SEE_INVISIBLE_LEVEL_TWO
			if(healths)		healths.icon_state = "health7"	//DEAD healthmeter
		else
			sight &= ~(SEE_TURFS|SEE_MOBS|SEE_OBJS)
			var/see_temp = see_invisible
			see_invisible = SEE_INVISIBLE_LIVING
			if(dna)
				switch(dna.mutantrace)
					if("slime")
						see_in_dark = 3
						see_invisible = SEE_INVISIBLE_LEVEL_ONE
					if("shadow")
						see_in_dark = 8
					else
						see_in_dark = 2

			if(XRAY in mutations)
				sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
				see_in_dark = 8
				see_invisible = SEE_INVISIBLE_LEVEL_TWO

			if(seer)
				see_invisible = SEE_INVISIBLE_OBSERVER

			if(mind && mind.changeling)
				hud_used.lingchemdisplay.invisibility = 0
				hud_used.lingchemdisplay.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'> <font color='#dd66dd'>[src.mind.changeling.chem_charges]</font></div>"
			else
				hud_used.lingchemdisplay.invisibility = 101

			var/helmet_hud = 0

			if(istype(wear_suit, /obj/item/clothing/suit/space/powersuit))
				var/obj/item/clothing/suit/space/powersuit/P = wear_suit
				if(P && P.powered && P.current_vision && head == P.helmet)
					helmet_hud = 1
					var/obj/item/clothing/glasses/G = P.current_vision
					sight |= G.vision_flags
					see_in_dark = G.darkness_view
					see_invisible = G.invis_view
					if(G.hud)
						G.process_hud(src)

			if(istype(wear_mask, /obj/item/clothing/mask/gas/voice/space_ninja))
				var/obj/item/clothing/mask/gas/voice/space_ninja/O = wear_mask
				switch(O.mode)
					if(0)
						var/target_list[] = list()
						for(var/mob/living/target in oview(src))
							if( target.mind&&(target.mind.special_role||issilicon(target)) )//They need to have a mind.
								target_list += target
						if(target_list.len)//Everything else is handled by the ninja mask proc.
							O.assess_targets(target_list, src)
						see_invisible = SEE_INVISIBLE_LIVING
					if(1)
						see_in_dark = 5
						see_invisible = SEE_INVISIBLE_LIVING
					if(2)
						sight |= SEE_MOBS
						see_invisible = SEE_INVISIBLE_LEVEL_TWO
					if(3)
						sight |= SEE_TURFS
						see_invisible = SEE_INVISIBLE_LIVING

			if(glasses && !helmet_hud) //Dont use any goggle stuff if the powersuit helmet is using something
				if(istype(glasses, /obj/item/clothing/glasses))
					var/obj/item/clothing/glasses/G = glasses
					sight |= G.vision_flags
					see_in_dark = G.darkness_view
					see_invisible = G.invis_view
					if(G.hud)
						G.process_hud(src)

			if(druggy)	//Override for druggy
				see_invisible = see_temp

			if(see_override)	//Override all
				see_invisible = see_override

			if(healths)
				switch(hal_screwyhud)
					if(1)	healths.icon_state = "health6"
					if(2)	healths.icon_state = "health7"
					else
						switch(health - (src.getBloodLoss() * health / 100))
							if(100 to INFINITY)		healths.icon_state = "health0"
							if(80 to 100)			healths.icon_state = "health1"
							if(60 to 80)			healths.icon_state = "health2"
							if(40 to 60)			healths.icon_state = "health3"
							if(20 to 40)			healths.icon_state = "health4"
							if(0 to 20)				healths.icon_state = "health5"
							else					healths.icon_state = "health6"
						if(blood.total_volume <= BLOODLOSS_CRIT)
							healths.icon_state = "health6"

			if (staminas)
				if (stat != 2)
					var/threshold = Clamp((health - getBloodLoss()),1,100)
					var/display = 100 - round((Clamp(staminaloss,0,threshold) / threshold * 100))
					switch(display)
						if(99 to 100)		staminas.icon_state = "stamina0"
						if(75 to 98)			staminas.icon_state = "stamina1"
						if(50 to 74)			staminas.icon_state = "stamina2"
						if(25 to 49)			staminas.icon_state = "stamina3"
						if(6 to 24)				staminas.icon_state = "stamina4"
						if(-INFINITY to 5)		staminas.icon_state = "stamina5"
						else					staminas.icon_state = "stamina5"

			if(nutrition_icon)
				switch(nutrition)
					if(450 to INFINITY)				nutrition_icon.icon_state = "nutrition0"
					if(350 to 450)					nutrition_icon.icon_state = "nutrition1"
					if(250 to 350)					nutrition_icon.icon_state = "nutrition2"
					if(150 to 250)					nutrition_icon.icon_state = "nutrition3"
					else							nutrition_icon.icon_state = "nutrition4"

			if(pressure)
				pressure.icon_state = "pressure[pressure_alert]"

			if(pullin)
				if(pulling)								pullin.icon_state = "pull"
				else									pullin.icon_state = "pull0"
//			if(rest)	//Not used with new UI
//				if(resting || lying || sleeping)		rest.icon_state = "rest1"
//				else									rest.icon_state = "rest0"
			if(toxin)
				if(hal_screwyhud == 4 || toxins_alert)	toxin.icon_state = "tox1"
				else									toxin.icon_state = "tox0"
			if(oxygen)
				if(hal_screwyhud == 3 || oxygen_alert)	oxygen.icon_state = "oxy1"
				else									oxygen.icon_state = "oxy0"
			if(fire)
				if(fire_alert)							fire.icon_state = "fire[fire_alert]" //fire_alert is either 0 if no alert, 1 for cold and 2 for heat.
				else									fire.icon_state = "fire0"

			if(bodytemp)
				switch(bodytemperature) //310.055 optimal body temp
					if(370 to INFINITY)		bodytemp.icon_state = "temp4"
					if(350 to 370)			bodytemp.icon_state = "temp3"
					if(335 to 350)			bodytemp.icon_state = "temp2"
					if(320 to 335)			bodytemp.icon_state = "temp1"
					if(300 to 320)			bodytemp.icon_state = "temp0"
					if(295 to 300)			bodytemp.icon_state = "temp-1"
					if(280 to 295)			bodytemp.icon_state = "temp-2"
					if(260 to 280)			bodytemp.icon_state = "temp-3"
					else					bodytemp.icon_state = "temp-4"

//	This checks how much the mob's eyewear impairs their vision
			if(blinded)
				overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
			else
				clear_fullscreen("blind")
			if(tinttotal >= TINT_IMPAIR)
				if(tinted_weldhelh)
					if(tinttotal >= TINT_BLIND)
						blinded = 1								// You get the sudden urge to learn to play keyboard
					else
						overlay_fullscreen("tint", /obj/screen/fullscreen/impaired, 2)
			else
				clear_fullscreen("tint")

			if(eye_stat > 30) overlay_fullscreen("impaired", /obj/screen/fullscreen/impaired, 2)
			else if(eye_stat > 20) overlay_fullscreen("impaired", /obj/screen/fullscreen/impaired, 1)
			else clear_fullscreen("impaired")

			if( disabilities & NEARSIGHTED && !istype(glasses, /obj/item/clothing/glasses/regular) )
				overlay_fullscreen("nearsighted", /obj/screen/fullscreen/impaired, 1)
			else
				clear_fullscreen("nearsighted")


			if(eye_blurry)			overlay_fullscreen("blurry", /obj/screen/fullscreen/blurry)
			else					clear_fullscreen("blurry")
			if(druggy)				overlay_fullscreen("high", /obj/screen/fullscreen/high)
			else					clear_fullscreen("high")

			if(machine)
				if(!machine.check_eye(src))		reset_view(null)
			else
				if(!client.adminobs)			reset_view(null)
		return 1

	proc/handle_random_events()
		// Puke if toxloss is too high
		if(!stat)
			if (getToxLoss() >= 45 && nutrition > 20)
				lastpuke ++
				if(lastpuke >= 25) // about 25 second delay I guess
					Stun(5)

					for(var/mob/O in viewers(world.view, src))
						O.show_message(text("<b>\red [] throws up!</b>", src), 1)
					playsound(loc, 'sound/effects/splat.ogg', 50, 1)

					var/turf/location = loc
					if (istype(location, /turf/simulated))
						location.add_vomit_floor(src, 1)

					nutrition -= 20
					adjustToxLoss(-3)

					// make it so you can only puke so fast
					lastpuke = 0

	proc/handle_stomach()
		spawn(0)
			for(var/mob/living/M in stomach_contents)
				if(M.loc != src)
					stomach_contents.Remove(M)
					continue
				if(istype(M, /mob/living/carbon) && stat != 2)
					if(M.stat == 2)
						M.death(1)
						stomach_contents.Remove(M)
						qdel(M)
						continue
					if(air_master.current_cycle%3==1)
						if(!(M.status_flags & GODMODE))
							M.adjustBruteLoss(5)
						nutrition += 10

	proc/handle_changeling()
		if(mind && mind.changeling)
			mind.changeling.regenerate()

	proc/handle_blood()
		if(!blood) return
		if(isbleeding())
			var/bleed_max = 0
			for(var/obj/item/organ/limb/L in organs)
				bleed_max += L.bleedstate
			bleed_max = Clamp(bleed_max,0,3)
			switch(bleed_max)
				if(1)
					blood.remove_reagent("blood", 0.5)
				if(2)
					blood.remove_reagent("blood", 1)
				if(3)
					blood.remove_reagent("blood", 2)
			bleed_on_floor(bleed_max)
		else
			blood.add_reagent("blood", 0.25)
		//Clotting start
		if(round(blood.total_volume / blood.maximum_volume * 100) <= 50)
			for(var/obj/item/organ/limb/L in organs)
				if(L.bleedstate == 1)
					L.bleeding = 0
					L.bleedstate = 0
		//Clotting end
		switch(getBloodLoss())
			if(20 to 39)
				if(prob(5))
					eye_blurry = 10
			if(40 to 59)
				if(prob(20))
					eye_blurry = 10
				if(prob(5))
					emote("cough")
			if(60 to 79)
				eye_blurry = 10
				if(prob(5))
					emote("cough")
			if(80 to 99)
				eye_blurry = 10
				if(prob(5))
					Paralyse(10)
				if(prob(5))
					emote("cough")
			if(100 to INFINITY)
				Paralyse(10)
		return

/mob/living/carbon/human/getBloodLoss()
	var/amount = 0
	if(blood)
		amount = BLOODLOSS_SAFE - blood.total_volume
		amount = Clamp(amount,0,100)
	var/bleeding = 0
	for(var/obj/item/organ/limb/L in organs)
		if(L.bleeding)
			bleeding = 1
			break
	if(!amount && bleeding)
		amount = 1
	return amount

//Moved this proc here since it deals with bloodloss sorta.
/mob/living/carbon/human/InCritical()
	if(blood && (blood.total_volume <= BLOODLOSS_CRIT && stat == UNCONSCIOUS))
		return 1
	return (health <= config.health_threshold_crit && stat == UNCONSCIOUS)

#undef HUMAN_MAX_OXYLOSS
#undef HUMAN_CRIT_MAX_OXYLOSS
