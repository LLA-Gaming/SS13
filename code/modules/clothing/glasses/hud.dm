/obj/item/clothing/glasses/hud
	name = "HUD"
	desc = "A heads-up display that provides important info in (almost) real time."
	flags = null //doesn't protect eyes because it's a monocle, duh
	origin_tech = "magnets=3;biotech=2"
	hud = 1
	var/hud_range = 10 // Variable used to configure how far out it pre-loads overlays. Testing showed at 16 provided the most seamless performance. Tiles still must be *in view* to be pre-loaded.

/* /obj/item/clothing/glasses/hud/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/card/emag))
		if(emagged == 0)
			emagged = 1
			user << "<span class='warning'>PZZTTPFFFT</span>"
			desc = desc+ " The display flickers slightly."
		else
			user << "<span class='warning'>It is already emagged!</span>" */ //No emags allowed

/obj/item/clothing/glasses/hud/emp_act(severity)
	if(emagged == 0)
		emagged = 1
		desc = desc + " The display flickers slightly."


/obj/item/clothing/glasses/hud/health
	name = "Health Scanner HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	icon_state = "healthhud"
	proc
		RoundHealth(health)


	RoundHealth(health)
		switch(health)
			if(100 to INFINITY)
				return "health100"
			if(70 to 100)
				return "health80"
			if(50 to 70)
				return "health60"
			if(30 to 50)
				return "health40"
			if(18 to 30)
				return "health25"
			if(5 to 18)
				return "health10"
			if(1 to 5)
				return "health1"
			if(-99 to 0)
				return "health0"
			else
				return "health-100"
		return "0"


	process_hud(var/mob/M)
		if(!M)	return
		if(!M.client)	return
		var/client/C = M.client
		var/image/holder
		for(var/mob/living/carbon/human/patient in view(hud_range,M))
			var/foundVirus = 0
			for(var/datum/disease/D in patient.viruses)
				if(!D.hidden[SCANNER])
					foundVirus++
			if(!C) continue

			holder = patient.hud_list[HEALTH_HUD]
			if(patient.stat == 2)
				holder.icon_state = "hudhealth-100"
			else
				holder.icon_state = "hud[RoundHealth(patient.health)]"
			C.images += holder

			holder = patient.hud_list[STATUS_HUD]
			if(patient.stat == 2)
				holder.icon_state = "huddead"
			else if(patient.status_flags & XENO_HOST)
				holder.icon_state = "hudxeno"
			else if(foundVirus)
				holder.icon_state = "hudill"
			else
				holder.icon_state = "hudhealthy"
			C.images += holder

/obj/item/clothing/glasses/hud/health/night
	name = "Night Vision Health Scanner HUD"
	desc = "An advanced medical head-up display that allows doctors to find patients in complete darkness."
	icon_state = "healthhudnight"
	item_state = "glasses"
	darkness_view = 8
	invis_view = SEE_INVISIBLE_MINIMUM

/obj/item/clothing/glasses/hud/security
	name = "Security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status and security records."
	icon_state = "securityhud"
	var/alerts = 1

/obj/item/clothing/glasses/hud/security/sunglasses
	name = "HUDSunglasses"
	desc = "Sunglasses with a HUD."
	icon_state = "sunhud"
	darkness_view = 1
	flash_protect = 1
	tint = 1
/obj/item/clothing/glasses/hud/security/night
	name = "Night Vision Security HUD"
	desc = "An advanced heads-up display which provides id data and vision in complete darkness."
	icon_state = "securityhudnight"
	darkness_view = 8
	invis_view = SEE_INVISIBLE_MINIMUM

obj/item/clothing/glasses/hud/security/gars
	name = "HUD GAR glasses"
	desc = "GAR glasses with a HUD."
	icon_state = "gars"
	item_state = "garb"
	darkness_view = 1
	flash_protect = 1
	tint = 1
	force = 10
	throwforce = 10
	attack_verb = list("sliced")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = 1
	bleedprob = 35

obj/item/clothing/glasses/hud/security/supergars
	name = "SUPER HUD GAR glasses"
	desc = "SUPER GAR glasses with a HUD."
	icon_state = "supergars"
	item_state = "garb"
	darkness_view = 1
	flash_protect = 1
	tint = 1
	force = 12
	throwforce = 12
	attack_verb = list("sliced")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = 1
	bleedprob = 35

/obj/item/clothing/glasses/hud/security/sunglasses/emp_act(severity)
	if(emagged == 0)
		emagged = 1
		desc = desc + " The display flickers slightly."

/obj/item/clothing/glasses/hud/security/jensenshades
	name = "Augmented shades"
	desc = "Polarized bioneural eyewear, designed to augment your vision."
	icon_state = "jensenshades"
	item_state = "jensenshades"
	vision_flags = SEE_MOBS
	invis_view = 2

/obj/item/clothing/glasses/hud/security/verb/toggle_hud_alerts()
	set category = "Object"
	set name = "Toggle HUD Alerts"
	set src in usr
	if(alerts)
		usr << "You turn alerts off"
		alerts = 0
		return
	if(!alerts)
		usr << "You turn alerts on"
		alerts = 1
		return

/obj/item/clothing/glasses/hud/security/process_hud(var/mob/M)
	if(!M)	return
	if(!M.client)	return
	var/client/C = M.client
	var/image/holder
	for(var/mob/living/carbon/human/perp in view(hud_range,M))
		holder = perp.hud_list[ID_HUD]
		holder.icon_state = "hudno_id"
		if(perp.wear_id)
			holder.icon_state = "hud[ckey(perp.wear_id.GetJobName())]"
		C.images += holder


		for(var/obj/item/weapon/implant/I in perp)
			if(I.implanted)
				if(istype(I,/obj/item/weapon/implant/tracking))
					holder = perp.hud_list[IMPTRACK_HUD]
					holder.icon_state = "hud_imp_tracking"
				else if(isloyal(perp))
					holder = perp.hud_list[IMPLOYAL_HUD]
					holder.icon_state = "hud_imp_loyal"
				else if(istype(I,/obj/item/weapon/implant/chem))
					holder = perp.hud_list[IMPCHEM_HUD]
					holder.icon_state = "hud_imp_chem"
				else
					continue
				C.images += holder
				break

		var/perpname = perp.get_face_name(perp.get_id_name(""))
		if(perpname)
			var/datum/data/record/R = find_record("name", perpname, data_core.security)
			if(R)
				holder = perp.hud_list[WANTED_HUD]
				switch(R.fields["criminal"])
					if("*Arrest*")		holder.icon_state = "hudwanted"
					if("Incarcerated")	holder.icon_state = "hudincarcerated"
					if("Parolled")		holder.icon_state = "hudparolled"
					if("Released")		holder.icon_state = "hudreleased"
					else
						continue
				C.images += holder

/obj/item/clothing/glasses/hud/atmos
	name = "Atmospheric Scanner HUD"
	desc = "An advanced display used to observe atmospheric data in an area."
	icon_state = "atmoshud"
	item_state = "atmoshud"
	action_button_name = "Set HUD Mode"
	var/intensity = 64 // The value, 0-255, that determines opaqueness of the overlay
	var/list/images = list()
	var/list/modes = list("Pressure","Temperature","Off")
	var/currentmode = 1 // Represents which mode in the list modes is currently active

	//Moved these to the object itself for simplicity's sake
	var/Red = 0
	var/Blue = 0
	var/Green = 0

/obj/item/clothing/glasses/hud/atmos/Destroy()
	for (var/turf/T in images)
		ClearImage(T)
	..()

/obj/item/clothing/glasses/hud/atmos/proc/select_mode()
	//Handles current mode selection and changing
	if (!modes.len) return //No possible modes? Must be broked
	if (currentmode < 1) //Just Checking to prevent problems
		currentmode = 1
	else currentmode++
	if (currentmode > modes.len)
		currentmode = 1

	for (var/turf/T in images) //After switching modes, erase the images we have.
		ClearImage(T)
	return

/obj/item/clothing/glasses/hud/atmos/attack_self(mob/user)
	//Allows the HUD mode to be changed by clicking, this will normally occur via the action button
	select_mode()
	usr << "You switch the HUD to [modes[currentmode]]."
	add_fingerprint(user)
	..()

/obj/item/clothing/glasses/hud/atmos/equipped(mob/M, slot)
	//Purges the HUD images if the item is removed. Also controls whether or not the action button displays
	if (slot != slot_glasses)
		action_button_name = null
		for (var/turf/I in src.images)
			ClearImage(I)
	else
		action_button_name = "Set HUD Mode"
	..()

/obj/item/clothing/glasses/hud/atmos/proc/ClearImage(var/turf/T)
	//People are gonna ask why this is necessary, and its because otherwise the lag clearing all these at once generates is stupendous. This eases them out much nicer.
	set background = 1
	var/image/trash = src.images[T]
	src.images -= T
	spawn(0)
		qdel(trash)
	return

/obj/item/clothing/glasses/hud/atmos/proc/CalculateColor(var/Temperature, var/Pressure)

	if(modes[currentmode] == "Temperature")
		if (((Temperature - T20C) <= 10) && ((Temperature - T20C) >= -10)) return
		else if (Temperature < T20C)
			Blue = (255/T20C) * (T20C - Temperature)
		else if (Temperature > T20C)
			Red = (255/T20C) * ((Temperature - T20C)/2)

	else if(modes[currentmode] == "Pressure")
		if (((Pressure - ONE_ATMOSPHERE) <= 20) && ((Pressure - ONE_ATMOSPHERE) >= -20)) return
		else if (Pressure < ONE_ATMOSPHERE)
			Green = (255/ONE_ATMOSPHERE) * (ONE_ATMOSPHERE - Pressure)
		else if (Pressure > ONE_ATMOSPHERE)
			Red = (255/ONE_ATMOSPHERE) * ((Pressure - ONE_ATMOSPHERE))
			Green = Red

	//Clamp to ensure all vars are in the proper range
	Red = Clamp(Red, 0, 255)
	Green = Clamp(Green, 0, 255)
	Blue = Clamp(Blue, 0, 255)

/obj/item/clothing/glasses/hud/atmos/process_hud(var/mob/M)
	set background = 1

	//Make checks to ensure any of this is necessary
	if(!M)	return
	if(!M.client)	return
	if(modes[currentmode] == "Off") return

	//Clear any no longer in view
	for (var/turf/I in images)
		if(!(I in view(M.client)))
			ClearImage(I)


	//Initialize all the vars we'll need
	var/client/C = M.client
	var/datum/gas_mixture/air = null
	var/Pressure = null
	var/Temperature = null
	var/image/holder = null

	//Check every viewable turf to see if it needs an overlay
	for (var/turf/T in view(hud_range, C))
		Red = 0
		Green = 0
		Blue = 0
		air = T.return_air()
		Temperature = air.return_temperature()
		Pressure = air.return_pressure() //saving a bit of work
		if (istype(T, /turf/unsimulated/) || istype(T, /turf/space/) || T.density) //Tiles exempt from this display
			if (T in images) //Any tiles that changed from a simulated one to one of the exempted tiles
				ClearImage(T)
			continue

		if (T in images) //If we already have an image for the turf, lets just update the color
			holder = images[T]

			CalculateColor(Temperature,Pressure)

			if (!(Red || Green || Blue)) //Delete if its no longer needed
				ClearImage(T)
			else
				if (holder) holder.color = rgb(Red,Green,Blue,intensity) //Set the new color,
			continue

		else //Make the new image

			holder = new/image()
			holder.icon = 'icons/effects/effects.dmi'
			holder.icon_state = "overlay"
			holder.loc = T
			holder.layer = T.layer

			CalculateColor(Temperature,Pressure)

			if (!(Red || Green || Blue)) //Prevents orphan objects accumulating
				qdel(holder)
				continue

			holder.color = rgb(Red,Green,Blue,intensity) //Apply the color we calculated
			C.images += holder //Apply the image to the client's vision
			src.images[holder.loc] = holder //This is a reference list so that the created images can be pruned and maintained as needed. If the HUD is removed the contents of this list are as well

			continue
