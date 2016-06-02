/obj/item/clothing/glasses/meson
	name = "Optical Meson Scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	item_state = "glasses"
	origin_tech = "magnets=2;engineering=2"
	vision_flags = SEE_TURFS
	invis_view = SEE_INVISIBLE_MINIMUM

/*
/obj/item/clothing/glasses/meson/advanced
	name = "Advanced Optical Meson Scanner"
	desc = "More powerful than your standard mesons, these ones make everything appear to be lit extremely brightly."
*/

/obj/item/clothing/glasses/science
	name = "Science Goggles"
	desc = "nothing"
	icon_state = "purple"
	item_state = "glasses"

/obj/item/clothing/glasses/night
	name = "Night Vision Goggles"
	desc = "You can totally see in the dark now!"
	icon_state = "night"
	item_state = "glasses"
	origin_tech = "magnets=4"
	action_button_name = "Toggle Night Vision Goggles."
	darkness_view = 8
	invis_view = SEE_INVISIBLE_MINIMUM
	var/onoff = 1 //1 is on, 0 is off

/obj/item/clothing/glasses/night/proc/toggle()
	if (onoff)
		onoff = 0
		darkness_view = 2
		invis_view = SEE_INVISIBLE_LIVING
	else
		onoff = 1
		darkness_view = initial(darkness_view)
		invis_view = initial(invis_view)
	return

/obj/item/clothing/glasses/night/attack_self(mob/user)
	toggle()
	if (onoff)
		usr << "You switch the [name] on."
	else
		usr << "You switch the [name] off."
	add_fingerprint(user)
	..()

/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	desc = "Yarr."
	icon_state = "eyepatch"
	item_state = "eyepatch"

/obj/item/clothing/glasses/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state = "headset" // lol

/obj/item/clothing/glasses/material
	name = "Optical Material Scanner"
	desc = "Very confusing glasses."
	icon_state = "material"
	item_state = "glasses"
	origin_tech = "magnets=3;engineering=3"
	vision_flags = SEE_OBJS
	invis_view = SEE_INVISIBLE_MINIMUM

/obj/item/clothing/glasses/regular
	name = "Prescription Glasses"
	desc = "Made by Nerd. Co."
	icon_state = "glasses"
	item_state = "glasses"

/obj/item/clothing/glasses/regular/hipster
	name = "Prescription Glasses"
	desc = "Made by Uncool. Co."
	icon_state = "hipster_glasses"
	item_state = "hipster_glasses"

/obj/item/clothing/glasses/regular/reading
	name = "Reading Glasses"
	desc = "Made by Nerd. Co."
	icon_state = "readingglasses"
	item_state = "readingglasses"

/obj/item/clothing/glasses/gglasses
	name = "Green Glasses"
	desc = "Forest green glasses, like the kind you'd wear when hatching a nasty scheme."
	icon_state = "greenglasses"
	item_state = "greenglasses"

/obj/item/clothing/glasses/sunglasses
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Enhanced shielding blocks many flashes."
	name = "sunglasses"
	icon_state = "sun"
	item_state = "sunglasses"
	darkness_view = 1
	flash_protect = 1
	tint = 1

/obj/item/clothing/glasses/sunglasses/garb
	desc = "Go beyond impossible and kick reason to the curb!"
	name = "black gar glasses"
	icon_state = "garb"
	item_state = "garb"
	force = 10
	throwforce = 10
	attack_verb = list("sliced")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = 1
	bleedprob = 35

/obj/item/clothing/glasses/sunglasses/supergarb
	desc = "Believe in us humans."
	name = "black super gar glasses"
	icon_state = "supergarb"
	item_state = "garb"
	force = 12
	throwforce = 12
	attack_verb = list("sliced")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = 1
	bleedprob = 35

/obj/item/clothing/glasses/welding
	name = "welding goggles"
	desc = "Protects the eyes from welders, approved by the mad scientist association."
	icon_state = "welding-g"
	item_state = "welding-g"
	action_button_name = "Toggle Welding Goggles"
	flash_protect = 2
	tint = 2
	visor_flags = GLASSESCOVERSEYES
	visor_flags_inv = HIDEEYES


/obj/item/clothing/glasses/welding/attack_self()
	toggle()


/obj/item/clothing/glasses/welding/verb/toggle()
	set category = "Object"
	set name = "Adjust welding goggles"
	set src in usr

	weldingvisortoggle()


/obj/item/clothing/glasses/sunglasses/blindfold
	name = "blindfold"
	desc = "Covers the eyes, preventing sight."
	icon_state = "blindfold"
	item_state = "blindfold"
//	vision_flags = BLIND	//handled in life.dm/handle_regular_hud_updates()
	flash_protect = 2
	tint = 3			// to make them blind

/obj/item/clothing/glasses/sunglasses/big
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Larger than average enhanced shielding blocks many flashes."
	icon_state = "bigsunglasses"
	item_state = "bigsunglasses"

/obj/item/clothing/glasses/thermal
	name = "Optical Thermal Scanner"
	desc = "Thermals in the shape of glasses."
	icon_state = "thermal"
	item_state = "glasses"
	origin_tech = "magnets=3"
	action_button_name = "Toggle Thermal Vision"
	vision_flags = SEE_MOBS
	darkness_view = 2
	invis_view = 2
	flash_protect = -1

	emp_act(severity)
		if(istype(src.loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/M = src.loc
			M << "\red The Optical Thermal Scanner overloads and blinds you!"
			if(M.glasses == src)
				M.eye_blind = 3
				M.eye_blurry = 5
				M.disabilities |= NEARSIGHTED
				spawn(100)
					M.disabilities &= ~NEARSIGHTED
		..()

	attack_self(mob/living/user as mob)
		if (vision_flags)
			vision_flags = null
			icon_state = "thermal_off"
			user << "You turn off the [name]"
			darkness_view = 1
			flash_protect = initial(flash_protect)
			user.update_inv_glasses(0)
			return
		if (!vision_flags)
			if(user.machine && istype(user.machine, /obj/machinery/computer/security))
				return
			vision_flags = SEE_MOBS
			icon_state = initial(icon_state)
			user << "You turn on the [name]"
			darkness_view = initial(darkness_view)
			flash_protect = initial(flash_protect)
			user.update_inv_glasses(0)
			return
		return

/obj/item/clothing/glasses/thermal/syndi	//These are now a traitor item, concealed as mesons.	-Pete
	name = "Optical Meson Scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	origin_tech = "magnets=3;syndicate=4"

/obj/item/clothing/glasses/thermal/monocle
	name = "Thermoncle"
	desc = "A monocle thermal."
	icon_state = "thermoncle"
	flags = null //doesn't protect eyes because it's a monocle, duh

/obj/item/clothing/glasses/thermal/eyepatch
	name = "Optical Thermal Eyepatch"
	desc = "An eyepatch with built-in thermal optics"
	icon_state = "eyepatch"
	item_state = "eyepatch"

/obj/item/clothing/glasses/threed
	name = "3D glasses"
	desc = "A pair of glasses used to watch films in red-cyan anaglyph 3D."
	icon_state = "threed"
	item_state = "glasses"

/obj/item/clothing/glasses/thermal/jensen
	name = "Optical Thermal Implants"
	desc = "A set of implantable lenses designed to augment your vision"
	icon_state = "thermalimplants"
	item_state = "syringe_kit"


//Hypno-spectacles, that do absolutely nothing.

/obj/item/clothing/glasses/hypno
	name = "hypno-spectacles"
	desc = "A pair of glasses which claim to have the ability to hypnotize people."
	icon_state = "hypnospecs"
	item_state = "glasses"
	action_button_name = "Activate Hypno-Spectacles"
	var/cooldown = 0

/obj/item/clothing/glasses/hypno/attack_self(mob/user)
	if (user.get_item_by_slot(slot_glasses) != src)
		user << "<span class='alert'>You must be wearing the glasses to ogle.</span>"
		return
	if (cooldown < world.time)
		cooldown = world.time + 600 //1 minute.
		user.visible_message("<span class='warning'>[user] ogles you disconcertingly!</span>", "<span class='notice'>You ogle everyone nearby.</span>")
	else
		var/timeleft = (cooldown - world.time)
		user << "<span class='notice'>The glasses are recharging, you must wait [round(timeleft/10)] seconds before you can ogle again.</span>"
