/obj/item/clothing
	name = "clothing"
	var/flash_protect = 0		//Malk: What level of bright light protection item has. 1 = Flashers, Flashes, & Flashbangs | 2 = Welding | -1 = OH GOD WELDING BURNT OUT MY RETINAS
	var/tint = 0				//Malk: Sets the item's level of visual impairment tint, normally set to the same as flash_protect
	var/up = 0					//	   but seperated to allow items to protect but not impair vision, like space helmets
	var/visor_flags = null
	var/visor_flags_inv = null

//Ears: currently only used for headsets and earmuffs
/obj/item/clothing/ears
	name = "ears"
	w_class = 1.0
	throwforce = 0
	slot_flags = SLOT_EARS

/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon_state = "earmuffs"
	item_state = "earmuffs"


//Glasses
/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/glasses.dmi'
	w_class = 2.0
	flags = GLASSESCOVERSEYES
	slot_flags = SLOT_EYES
	var/vision_flags = 0
	var/darkness_view = 2//Base human is 2
	var/invis_view = SEE_INVISIBLE_LIVING
	var/emagged = 0
	var/hud = null
	var/list/icon/current = list() //the current hud icons

/obj/item/clothing/glasses/proc/process_hud(var/mob/M)
	return

/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
          // in a lit area (via pixel_x,y or smooth movement), can see those pixels
BLIND     // can't see anything
*/


//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = 2.0
	icon = 'icons/obj/clothing/gloves.dmi'
	siemens_coefficient = 0.50
	body_parts_covered = HANDS
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(var/atom/A, var/proximity)
	return 0 // return 1 to cancel attack_hand()

//Head
/obj/item/clothing/head
	name = "head"
	icon = 'icons/obj/clothing/hats.dmi'
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD

//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi'
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK
	var/alloweat = 0
	var/can_flip = null
	var/is_flipped = 1
	var/ignore_flip = 0

	/obj/item/clothing/mask/verb/togglemask()
		set name = "Toggle Mask"
		set category = "Object"
		set src in usr
		if(ignore_flip)
			return
		else
			if(!usr.canmove || usr.stat || usr.restrained())
				return
			if(!can_flip)
				usr << "You try pushing \the [src] out of the way, but it is very uncomfortable and you look like a fool. You push it back into place."
				return
			if(src.is_flipped == 2)
				src.icon_state = initial(icon_state)
				gas_transfer_coefficient = initial(gas_transfer_coefficient)
				permeability_coefficient = initial(permeability_coefficient)
				flags = initial(flags)
				flags_inv = initial(flags_inv)
				usr << "You push \the [src] back into place."
				src.is_flipped = 1
			else
				src.icon_state += "_up"
				usr << "You push \the [src] out of the way."
				gas_transfer_coefficient = null
				permeability_coefficient = null
				flags = null
				flags_inv = null
				src.is_flipped = 2
			usr.update_inv_wear_mask()

/obj/item/clothing/mask/attack_self()
	togglemask()


//Override this to modify speech like luchador masks.
/obj/item/clothing/mask/proc/speechModification(message)
	return message

//Shoes
/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/obj/clothing/shoes.dmi'
	desc = "Comfortable-looking shoes."
	gender = PLURAL //Carn: for grammarically correct text-parsing
	var/chained = 0

	body_parts_covered = FEET
	slot_flags = SLOT_FEET

	permeability_coefficient = 0.50
	slowdown = SHOES_SLOWDOWN

//Suit
/obj/item/clothing/suit
	icon = 'icons/obj/clothing/suits.dmi'
	name = "suit"
	var/fire_resist = T0C+100
	allowed = list(/obj/item/weapon/tank/emergency_oxygen)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING
	var/blood_overlay_type = "suit"
	var/can_toggle = 1
	var/is_toggled = 0
	var/has_hood = null
	var/coat_color = null

//Spacesuit
//Note: Everything in modules/clothing/spacesuits should have the entire suit grouped together.
//      Meaning the the suit is defined directly after the corrisponding helmet. Just like below!
/obj/item/clothing/head/helmet/space
	name = "space helmet"
	icon_state = "space"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment."
	flags = HEADCOVERSEYES | BLOCKHAIR | HEADCOVERSMOUTH | STOPSPRESSUREDMAGE | THICKMATERIAL
	item_state = "space"
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	flash_protect = 2

/obj/item/clothing/suit/space
	name = "space suit"
	desc = "A suit that protects against low pressure environments. Has a big 13 on the back."
	icon_state = "space"
	item_state = "s_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	flags = STOPSPRESSUREDMAGE | THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency_oxygen)
	slowdown = 2
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT


//Under clothing
/obj/item/clothing/under
	icon = 'icons/obj/clothing/uniforms.dmi'
	name = "under"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_ICLOTHING
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	var/fitted = 1// For use in alternate clothing styles for women, if clothes vary from a jumpsuit in shape, set this to 0
	var/has_sensor = 1//For the crew computer 2 = unable to change mode
	var/sensor_mode = 0
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/
	var/can_roll = 1
	var/rolled_down = 1
	var/suit_color = null
	var/obj/item/clothing/tie/hastie = null

/obj/item/clothing/under/attackby(obj/item/I, mob/user)
	attachTie(I, user)
	..()

/obj/item/clothing/under/proc/attachTie(obj/item/I, mob/user)
	if(istype(I, /obj/item/clothing/tie))
		if(hastie)
			if(user)
				user << "<span class='warning'>[src] already has an accessory.</span>"
			return
		else
			if(user)
				user.drop_item()
			hastie = I
			I.loc = src
			if(user)
				user << "<span class='notice'>You attach [I] to [src].</span>"
			I.transform *= 0.5	//halve the size so it doesn't overpower the under
			I.pixel_x += 8
			I.pixel_y -= 8
			I.layer = FLOAT_LAYER
			overlays += I


			if(istype(loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = loc
				H.update_inv_w_uniform(0)

			return


/obj/item/clothing/under/examine()
	set src in view()
	..()
	switch(src.sensor_mode)
		if(0)
			usr.send_text_to_tab("Its sensors appear to be disabled.", "ic")
			usr << "Its sensors appear to be disabled."
		if(1)
			usr.send_text_to_tab("Its binary life sensors appear to be enabled.", "ic")
			usr << "Its binary life sensors appear to be enabled."
		if(2)
			usr.send_text_to_tab("Its vital tracker appears to be enabled.", "ic")
			usr << "Its vital tracker appears to be enabled."
		if(3)
			usr.send_text_to_tab("Its vital tracker and tracking beacon appear to be enabled.", "ic")
			usr << "Its vital tracker and tracking beacon appear to be enabled."
	if(hastie)
		usr.send_text_to_tab("\A [hastie] is attached to it.", "ic")
		usr << "\A [hastie] is attached to it."

atom/proc/generate_uniform(index,t_color)
	var/icon/female_uniform_icon	= icon("icon"='icons/mob/uniform.dmi', "icon_state"="[t_color]_s")
	var/icon/female_s				= icon("icon"='icons/mob/uniform.dmi', "icon_state"="female_s")
	female_uniform_icon.Blend(female_s, ICON_MULTIPLY)
	female_uniform_icon 			= fcopy_rsc(female_uniform_icon)
	female_uniform_icons[index] = female_uniform_icon

/obj/item/clothing/under/proc/set_sensors(mob/usr as mob)
	var/mob/M = usr
	if (istype(M, /mob/dead/)) return
	if (usr.stat || usr.restrained()) return
	if(has_sensor >= 2)
		usr << "The controls are locked."
		return 0
	if(has_sensor <= 0)
		usr << "This suit does not have any sensors."
		return 0

	var/list/modes = list("Off", "Binary vitals", "Exact vitals", "Exact vitals + Tracking beacon")
	var/switchMode = input("Select a sensor mode:", "Suit Sensor Mode", modes[sensor_mode + 1]) in modes
	if(get_dist(usr, src) > 1)
		usr << "You have moved too far away."
		return
	sensor_mode = modes.Find(switchMode) - 1

	if (src.loc == usr)
		switch(sensor_mode)
			if(0)
				usr << "You disable your suit's remote sensing equipment."
			if(1)
				usr << "Your suit will now only report whether you are alive or dead."
			if(2)
				usr << "Your suit will now only report your exact vital lifesigns."
			if(3)
				usr << "Your suit will now report your exact vital lifesigns as well as your coordinate position."
	else if (istype(src.loc, /mob))
		switch(sensor_mode)
			if(0)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("\red [usr] disables [src.loc]'s remote sensing equipment.", 1)
			if(1)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[usr] turns [src.loc]'s remote sensors to binary.", 1)
			if(2)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[usr] sets [src.loc]'s sensors to track exact vitals.", 1)
			if(3)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[usr] sets [src.loc]'s sensors to maximum.", 1)

/obj/item/clothing/under/verb/toggle()
	set name = "Toggle Suit Sensors"
	set category = "Object"
	set src in usr
	set_sensors(usr)
	..()

/obj/item/clothing/under/verb/rolldown()
	set name = "Roll Down Jumpsuit"
	set category = "Object"
	set src in usr
	if(usr.stat)
		return
	if(!can_roll)
		usr << "You cannot roll down this suit."
		return
	if(src.rolled_down == 2)
		src.item_color = initial(item_color)
		src.item_color = src.suit_color //colored jumpsuits are shit and break without this
		usr << "You put your arms through the sleeves and zip up the jumpsuit."
		src.rolled_down = 1
	else
		src.item_color += "_d"
		usr << "You unzip and roll down the jumpsuit."
		src.rolled_down = 2
	usr.update_inv_w_uniform()
	..()

/obj/item/clothing/under/verb/removetie()
	set name = "Remove Accessory"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if(hastie)
		hastie.transform *= 2
		hastie.pixel_x -= 8
		hastie.pixel_y += 8
		hastie.layer = initial(hastie.layer)
		overlays = null
		usr.put_in_hands(hastie)
		hastie = null

		if(istype(loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = loc
			H.update_inv_w_uniform(0)

/obj/item/clothing/under/New()
	sensor_mode = pick(0,1,2,3)
	rolled_down = 1
	suit_color = item_color
	..()


/obj/item/clothing/proc/weldingvisortoggle()			//Malk: proc to toggle welding visors on helmets, masks, goggles, etc.
	if(usr.canmove && !usr.stat && !usr.restrained())
		if(up)
			up = !up
			flags |= (visor_flags)
			flags_inv |= (visor_flags_inv)
			icon_state = initial(icon_state)
			usr << "You pull the [src] down."
			flash_protect = initial(flash_protect)
			tint = initial(tint)
		else
			up = !up
			flags &= ~(visor_flags)
			flags_inv &= ~(visor_flags_inv)
			icon_state = "[initial(icon_state)]up"
			usr << "You push the [src] up."
			flash_protect = 0
			tint = 0

	if(istype(src, /obj/item/clothing/head))			//makes the mob-overlays update
		usr.update_inv_head(0)
	if(istype(src, /obj/item/clothing/glasses))
		usr.update_inv_glasses(0)
	if(istype(src, /obj/item/clothing/mask))
		usr.update_inv_wear_mask(0)