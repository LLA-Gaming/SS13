/obj/item/clothing/suit/space/powersuit
	name = "power suit"
	desc = "a powered suit of armor, too heavy to pick up normally"
	icon_state = "p-armor1"
	var/armor_iconstate = "p-armor0"
	w_class = 4
	flags = STOPSPRESSUREDMAGE | THICKMATERIAL
	heavy = 1
	unacidable = 1
	anchored = 1
	var/model_name = "standard"
	var/powered = 0
	var/s_busy = 0
	var/mob/living/carbon/human/occupant
	var/obj/item/clothing/head/helmet/space/powerhelmet/helmet
	var/obj/item/weapon/powersuit_attachment/primary_attachment
	var/obj/item/weapon/powersuit_attachment/secondary_attachment
	var/obj/item/weapon/powersuit_attachment/armor_attachment

	var/helmet_type
	var/cell_type
	var/primary_attachment_type
	var/secondary_attachment_type
	var/armor_attachment_type

	var/obj/item/weapon/stock_parts/cell/fusion/cell

	var/footstep = 0

	var/turbo = 0

	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/device/flashlight/seclite)

	//default stats
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 50)
	slowdown = 4 // super slow unless powered

	//eyeball stuff
	var/obj/item/clothing/glasses/current_vision

	New()
		..()
		verbs += /obj/item/clothing/suit/space/powersuit/proc/toggle_power
		verbs += /obj/item/clothing/suit/space/powersuit/proc/interact_suit
		grant_equip_verbs()
		if(helmet_type)
			helmet = new helmet_type(src)
			helmet.attached_to = src
		if(cell_type)
			cell = new cell_type(src)
		if(primary_attachment_type)
			primary_attachment = new primary_attachment_type(src)
			primary_attachment.attached_to = src
		if(secondary_attachment_type)
			secondary_attachment = new secondary_attachment_type(src)
			secondary_attachment.attached_to = src
		if(armor_attachment_type)
			armor_attachment = new armor_attachment_type(src)
			armor_attachment.attached_to = src

		update_stats()

	update_icon()
		icon_state = "[armor_iconstate][powered ? "_on" : ""]"
		if(helmet && helmet.on_state)
			helmet.icon_state = "[initial(helmet.icon_state)][powered ? "_on" : ""]"
		if(occupant)
			occupant.regenerate_icons()


	MouseDrop_T(var/atom/dropping, var/mob/user)
		if(istype(dropping, /mob/living/carbon/human))
			if(dropping == user)
				enter_suit(dropping)

	item_stripped()
		store_helmet()
		unpower()
		leave_suit()

	attack_hand(mob/living/user)
		if(src.loc == user) //if they are wearing it
			if(armor_attachment)
				remove_attachment(armor_attachment)
				return
			else
				leave_suit()
		return //too heavy to pick up

	emp_act()
		cell.charge = cell.charge / 2 // half the power cell
		unpower()
		occupant.Weaken(7)
		occupant << "\red you are forcifully ejected from the suit"
		leave_suit()

	attackby(var/obj/item/I, mob/user as mob)
		if(istype(I, /obj/item/clothing/head/helmet/space/powerhelmet))
			attach_helmet(I,user)
			return
		if(istype(I, /obj/item/weapon/powersuit_attachment))
			if(s_busy)
				return
			if(powered)
				user << "You must turn off the suit before adding attachments"
				return
			var/obj/item/weapon/powersuit_attachment/P = I
			if(P)
				switch(P.attachment_type)
					if(POWERSUIT_ARMOR)
						if(armor_attachment)
							user << "this slot is occupied with [armor_attachment]"
						else
							user.remove_from_mob(I)
							P.attached_to = src
							armor_attachment = P
							P.loc = src
					if(POWERSUIT_PRIMARY)
						if(primary_attachment)
							user << "this slot is occupied with [primary_attachment]"
						else
							user.remove_from_mob(I)
							P.attached_to = src
							primary_attachment = P
							P.loc = src
					if(POWERSUIT_SECONDARY)
						if(secondary_attachment)
							user << "this slot is occupied with [secondary_attachment]"
						else
							user.remove_from_mob(I)
							P.attached_to = src
							secondary_attachment = P
							P.loc = src
					else
						user << "this doesn't seem to fit anywhere."
				update_stats()
		else if(istype(I, /obj/item/weapon/stock_parts/cell/))
			if(!cell)
				if(istype(I,/obj/item/weapon/stock_parts/cell/fusion))
					user.remove_from_mob(I)
					cell = I
					cell.loc = src
				else
					user << "[src] requires a power core instead of a power cell"
			else
				user << "[src] already has a [cell]"
		else if(istype(I, /obj/item/weapon/crowbar))
			interact_suit()
		else
			..()

/obj/item/clothing/suit/space/powersuit/proc/power_tick() // as long as the suit is powered this proc will run every tick
	set background = BACKGROUND_ENABLED

	//Runs in the background while the powersuit is powered.
	spawn while(cell && occupant && powered)

		//gather energy cost
		var/total_cost = 5
		for(var/obj/item/weapon/powersuit_attachment/A in src.contents)
			total_cost += A.cost
		if(armor_attachment)
			armor_attachment.activate_module()
		//deplete energy
		if(istype(occupant, /mob/living/carbon/human/npc))
			total_cost = 0 // UNLIMITED POWWERRRRRR (for npcs)
		cell.charge-=total_cost
		if(cell.charge<=0)
			cell.charge=0
			occupant << "\red [src]'s power has depleted"
			unpower()

		sleep(10)//Checks every second.

/obj/item/clothing/suit/space/powersuit/proc/enter_suit(var/mob/living/carbon/human/H)
	if(powered || s_busy || H.restrained() || H.stat)
		return
	if(H.wear_suit)
		H << "You cannot enter [src] while wearing suits"
		return
	if(H.canmove)
		occupant = H
		occupant.loc = src.loc
		occupant.canmove = 0
		sleep(5)
		occupant.canmove = 1
		occupant.dir = dir
		occupant.equip_to_slot_if_possible(src,slot_wear_suit,0,0,1)
		playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)

/obj/item/clothing/suit/space/powersuit/proc/toggle_power()
	set category = "P. Suit"
	set name = "Toggle Power"
	set src in usr
	if(s_busy || occupant.restrained() || occupant.stat)
		return
	s_busy = 1
	if(!powered)
		if(!cell)
			usr << "\red Unable to begin powering process, missing core"
			s_busy = 0
			return
		if(!cell.charge)
			usr << "\red Unable to begin powering process, power core empty"
			s_busy = 0
			return
		if(!armor_attachment)
			usr << "\red Unable to begin powering process, missing armor attachment"
			s_busy = 0
			return
		for(var/i=1,i<=4,i++)
			switch(i)
				if(1)
					occupant << "\blue Powering up..."
				if(2)
					occupant<< "\blue Locking suit to user"
				if(3)
					occupant<< "\blue Booting up core modules."
				if(4)
					occupant<< "\blue All systems nominal."
			if(!s_busy)
				return
			sleep(30)

		power()
		s_busy = 0
		return
	else
		occupant<< "\blue Powering down."
		unpower()
		s_busy = 0
		return

/obj/item/clothing/suit/space/powersuit/proc/power()
	if(armor_attachment.requires_helmet)
		if(!helmet)
			occupant << "\red Unable to complete powering process helmet required"
		else
			if(helmet != occupant.head)
				toggle_helmet()
	powered = 1
	remove_equip_verbs()
	power_tick()
	s_busy = 0
	update_stats()

/obj/item/clothing/suit/space/powersuit/proc/unpower()
	powered = 0
	grant_equip_verbs()
	s_busy = 0
	update_stats()

/obj/item/clothing/suit/space/powersuit/proc/leave_suit()
	set category = "P. Suit"
	set name = "Leave Power Suit"
	set src in usr
	if(powered || s_busy || occupant.restrained() || occupant.stat)
		return
	if(!isturf(loc.loc)) //raptorblaze, if you find this hear in your search for loc.loc, its here for a reason
		occupant << "You cannot take off [src] here!"
		return
	if(occupant.head == helmet)
		toggle_helmet()
	occupant.unEquip(occupant.wear_suit, 1)
	occupant = null
	playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)
	update_stats()

/obj/item/clothing/suit/space/powersuit/verb/toggle_helmet()
	set category = "P. Suit"
	set name = "Toggle Helmet"
	set src in usr
	if(occupant.restrained() || occupant.stat)
		return
	if(helmet)
		if(occupant.head != helmet)
			if(occupant.wear_suit != src)
				occupant << "You must be wearing [src] to wear the helmet."
				return
			if(occupant.head)
				occupant << "You're already wearing something on your head."
				return
			occupant.equip_to_slot_if_possible(helmet,slot_head,0,0,1)
			helmet.flags |= NODROP
			occupant.update_inv_wear_suit()
			playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)
			update_stats()
			return 1
		if(occupant.head == helmet)
			if(!powered)
				store_helmet()
				return 1
			else if(armor_attachment && !armor_attachment.requires_helmet)
				store_helmet()
				return 1
			else
				occupant << "you cannot remove [helmet]"

/obj/item/clothing/suit/space/powersuit/proc/update_stats()
	name = "power suit"
	if(armor_attachment)
		heavy = 1
		armor_iconstate = armor_attachment.armor_iconstate
		if(armor_attachment.display_name)
			name = "[armor_attachment.display_name] [name]"

		if(powered)
			if(armor_attachment)
				armor = armor_attachment.armor_stats
				if(!turbo)
					slowdown = armor_attachment.slowdown_stats
				if(helmet)
					helmet.armor = armor
		else
			armor = armor_attachment.unpowered_armor
			if(!turbo)
				slowdown = initial(slowdown)
			armor_iconstate = armor_attachment.armor_iconstate
			if(helmet)
				helmet.armor = armor

	if(!armor_attachment)
		if(!turbo)
			slowdown = initial(slowdown)
		if(!armor_attachment)
			name = "naked power suit"
			heavy = 0
			armor_iconstate = initial(armor_iconstate)
			armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 50)
			if(!turbo)
				slowdown = 0

	if(occupant && helmet && occupant.head == helmet)
		if(!secondary_attachment || !secondary_attachment.active_vision)
			current_vision = null

	update_icon()



/obj/item/clothing/suit/space/powersuit/proc/power_punch(var/mob/living/victim, var/mob/living/assaulter, var/obj/item/organ/limb/affecting, var/armor_block, var/a_intent)
	if(powered)
		if(primary_attachment)
			if(primary_attachment.power_punch(victim, assaulter, affecting, armor_block, a_intent))
				return 1
		else if(secondary_attachment)
			if(secondary_attachment.power_punch(victim, assaulter, affecting, armor_block, a_intent))
				return 1

/obj/item/clothing/suit/space/powersuit/proc/remove_attachment(var/obj/item/weapon/powersuit_attachment/P)
	if(s_busy)
		return
	if(!powered)
		switch(P.attachment_type)
			if(POWERSUIT_ARMOR)
				if (occupant.head == helmet)
					remove_helmet()
				P.attached_to = null
				armor_attachment = null
				P.loc = get_turf(src)
			if(POWERSUIT_PRIMARY)
				P.attached_to = null
				primary_attachment = null
				P.loc = get_turf(src)
			if(POWERSUIT_SECONDARY)
				P.attached_to = null
				secondary_attachment = null
				P.loc = get_turf(src)
		if(occupant)
			occupant.put_in_active_hand(P)
	else
		occupant << "You must turn off the suit before removing attachments"
	update_stats()

/obj/item/clothing/suit/space/powersuit/proc/remove_helmet(var/obj/item/clothing/head/helmet/space/powerhelmet/H,var/forced=0)
	if(powered && !forced)
		occupant << "You must turn off the suit before removing attachments"
		return
	if(s_busy)
		return
	if (occupant.head == helmet)
		toggle_helmet()
	if(H)
		H.loc = get_turf(src)
		if(occupant)
			occupant.put_in_active_hand(H)
		H.attached_to = null
		if(helmet)
			helmet.armor = initial(helmet.armor)
		helmet = null
	update_stats()

/obj/item/clothing/suit/space/powersuit/proc/store_helmet()
	if(occupant)
		if(helmet && helmet == occupant.head)
			occupant.unEquip(occupant.head, 1)
			occupant.update_inv_wear_suit()
			helmet.flags &= ~NODROP
			helmet.loc = src
			playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)

/obj/item/clothing/suit/space/powersuit/proc/attach_helmet(var/obj/item/clothing/head/helmet/space/powerhelmet/H, var/mob/user)
	if(s_busy)
		return
	if(!powered)
		if(!helmet)
			if(armor_attachment)
				if(armor_attachment.compatible == H.compatible)
					user.remove_from_mob(H)
					helmet = H
					H.loc = src
					H.attached_to = src
					update_stats()
					return 1
				else
					user << "[H] is not compatible with [armor_attachment]"
			else
				user << "attaching helmets require armor first"
		else
			user << "this slot is occupied with [helmet]"
		return
	update_stats()

///Helmets
/obj/item/clothing/head/helmet/space/powerhelmet
	name = "power suit helmet"
	icon_state = "p-helmet1-1"
	//flags = HEADCOVERSEYES | BLOCKHAIR | HEADCOVERSMOUTH | STOPSPRESSUREDMAGE | THICKMATERIAL
	//flags_inv = HIDEMASK | HIDEEARS | HIDEEYES | HIDEFACE
	unacidable = 1
	armor = list(melee = 30, bullet = 15, laser = 30,energy = 10, bomb = 10, bio = 50, rad = 50)
	var/compatible
	var/on_state = 0
	var/obj/item/clothing/suit/space/powersuit/attached_to

	var/construction_time = 500
	var/list/construction_cost = list("metal"=20000,"glass"=5000)

	attack_hand(mob/living/user)
		var/mob/living/carbon/human/H = user
		if(attached_to)
			if(ishuman(user))
				if(H.head == src)
					if(H.wear_suit == attached_to)
						attached_to.remove_helmet(src)
						return
		..()

	mob_can_equip(mob/M, slot, disable_warning = 0)
		var/mob/living/carbon/human/H = M
		if(istype(H))
			var/obj/item/clothing/suit/space/powersuit/powersuit = H.wear_suit
			if(istype(powersuit))
				if(powersuit.armor_attachment)
					if(compatible != powersuit.armor_attachment.compatible)
						return 0
				if(powersuit.powered || powersuit.s_busy)
					if(powersuit.helmet)
						if(powersuit.helmet != src)
							return
					else
						return

		if(..())
			return 1

	equipped(mob/M, slot)
		var/mob/living/carbon/human/H = M
		if(ishuman(H))
			if(slot == slot_head && attached_to != H.wear_suit)
				if(istype(H.wear_suit,/obj/item/clothing/suit/space/powersuit/))
					var/obj/item/clothing/suit/space/powersuit/P = H.wear_suit
					P.attach_helmet(src,M)
					playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)

/obj/item/clothing/head/helmet/space/powerhelmet/chameleon
	name = "chameleon power helmet"
	icon_state = "p-helmet1-1"
	compatible = "standard"

/obj/item/clothing/head/helmet/space/powerhelmet/bugman
	name = "bugman power helmet"
	icon_state = "p-helmet1-2"
	compatible = "standard"

/obj/item/clothing/head/helmet/space/powerhelmet/hunter
	name = "hunter power helmet"
	icon_state = "p-helmet1-3"
	compatible = "standard"

/obj/item/clothing/head/helmet/space/powerhelmet/security
	name = "security power helmet"
	icon_state = "p-helmet2-2"
	compatible = "security"

/obj/item/clothing/head/helmet/space/powerhelmet/syndicate
	name = "syndicate power helmet"
	icon_state = "p-helmet3-2"
	compatible = "syndicate"

/obj/item/clothing/head/helmet/space/powerhelmet/mangled
	name = "mangled power helmet"
	icon_state = "p-helmet4"
	compatible = "mangled"
	on_state = 1

//Verb modifiers

/obj/item/clothing/suit/space/powersuit/proc/grant_equip_verbs()
	//give back the ability to leave suit
	verbs += /obj/item/clothing/suit/space/powersuit/proc/leave_suit

/obj/item/clothing/suit/space/powersuit/proc/remove_equip_verbs()
	//take away the ability to leave suit
	verbs -= /obj/item/clothing/suit/space/powersuit/proc/leave_suit


//interface

/obj/item/clothing/suit/space/powersuit/proc/interact_suit()
	set category = "P. Suit"
	set name = "Open Interface"
	set src in usr
	if(!occupant)
		return
	if(occupant != usr)
		return
	if(occupant.restrained() || occupant.stat)
		return
	var/speed_text = 0
	switch(slowdown)
		if(-INFINITY to -1)
			speed_text = 200
		if(0)
			speed_text = 100
		if(1)
			speed_text = 75
		if(2)
			speed_text = 50
		else
			speed_text = 0
	var/dat = ""
	//display stats
	dat += "<h3>Status</h3>"
	dat += "<div class='statusDisplay'>"
	if(occupant)
		dat += "Occupant: [occupant]<br>"
	dat += "Power Core: [cell ? "[cell.charge] / [cell.maxcharge]" : "N/A"][cell ? " - <a href='byond://?src=\ref[src];choice=remove_cell;target=\ref[cell]'>Remove</a>" : ""]<br>"
	dat += "Armor Ratings:<br>"
	for(var/X in armor)
		dat += "[TAB][X]: [armor[X]]%<br>"
	dat += "[TAB]speed: [speed_text]%<br>"
	dat += "</div>"
	dat += "<h3>Attachments</h3>"
	dat += "<div class='statusDisplay'>"
	dat += "Primary Attachment: [primary_attachment ? "<a href='byond://?src=\ref[src];choice=remove;target=\ref[primary_attachment]'>[primary_attachment.name]</a>" : "N/A"]<br>"
	dat += "Secondary Attachment: [secondary_attachment ? "<a href='byond://?src=\ref[src];choice=remove;target=\ref[secondary_attachment]'>[secondary_attachment.name]</a> - <a href='byond://?src=\ref[src];choice=activate;target=\ref[secondary_attachment]'>Toggle</a>" : "N/A"]<br>"
	dat += "Armor Attachment: [armor_attachment ? "<a href='byond://?src=\ref[src];choice=remove;target=\ref[armor_attachment]'>[armor_attachment.name]</a>" : "N/A"]<br>"
	dat += "Helmet Attachment: [helmet ? "<a href='byond://?src=\ref[src];choice=remove_helmet;target=\ref[helmet]'>[helmet.name]</a>" : "N/A"]<br>"
	dat += "</div>"
	//display attachments
	var/datum/browser/popup = new(usr, "powersuit", "[src]")
	popup.set_content(dat)
	popup.title = "[name] control panel"
	popup.window_options = "size=480x640;can_resize=1"
	popup.open()

	return

/obj/item/clothing/suit/space/powersuit/Topic(href, href_list)
	if(s_busy)
		return
	var/mob/U = usr
	if(occupant != usr)
		return
	if(occupant.restrained() || occupant.stat)
		return
	switch(href_list["choice"])//Now we switch based on choice.
		if ("remove")
			remove_attachment(locate(href_list["target"]))
		if ("remove_helmet")
			remove_helmet(locate(href_list["target"]))
		if ("remove_cell")
			if(cell && !powered)
				cell.loc = get_turf(src)
				cell = null
		if ("activate")
			if(powered)
				var/obj/item/weapon/powersuit_attachment/A = locate(href_list["target"])
				A.activate_module()
			else
				U << "[src] needs to be powered to use this"
	update_stats()
	interact_suit()