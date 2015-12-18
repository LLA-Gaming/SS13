/obj/item/clothing/suit/space/powersuit
	name = "power suit"
	icon_state = "p-armor1"
	w_class = 4
	flags = STOPSPRESSUREDMAGE | THICKMATERIAL
	var/model_name = "standard"
	var/powered = 0
	var/s_busy = 0
	var/mob/living/carbon/human/occupant
	var/obj/item/clothing/head/space/powerhelmet/helmet
	var/obj/item/weapon/powersuit_attachment/primary_attachment
	var/obj/item/weapon/powersuit_attachment/secondary_attachment
	var/obj/item/weapon/powersuit_attachment/armor_attachment

	var/helmet_type
	var/cell_type
	var/primary_attachment_type
	var/secondary_attachment_type
	var/armor_attachment_type

	var/obj/item/weapon/stock_parts/cell/fusion/cell

	//default stats
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	slowdown = 4 // super slow unless powered

	New()
		..()
		verbs += /obj/item/clothing/suit/space/powersuit/proc/toggle_power
		verbs += /obj/item/clothing/suit/space/powersuit/proc/interact_suit
		grant_equip_verbs()
		if(helmet_type)
			helmet = new helmet_type
		if(cell_type)
			cell = new cell_type
		if(primary_attachment_type)
			primary_attachment = new primary_attachment_type
		if(secondary_attachment_type)
			secondary_attachment = new secondary_attachment_type
		if(armor_attachment_type)
			armor_attachment = new armor_attachment_type

		update_stats()

	MouseDrop_T(var/atom/dropping, var/mob/user)
		if(istype(dropping, /mob/living/carbon/human))
			if(dropping == user)
				enter_suit(dropping)

	item_stripped()
		unpower()
		leave_suit()

	attack_hand(mob/living/user)
		return //too heavy to pick up

	emp_act()
		unpower()

	attackby(var/obj/item/I, mob/user as mob)
		if(istype(I, /obj/item/weapon/powersuit_attachment))
			if(s_busy)
				return
			if(powered)
				user << "You must turn off the suit before adding attachments"
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
	spawn while(cell && cell.charge>=0 && occupant && powered)

		//gather energy cost
		var/total_cost = 5
		for(var/obj/item/weapon/powersuit_attachment/A in src.contents)
			total_cost += A.cost
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
			usr << "\red Unable to begin powering process, armor attachment not found"
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
		for(var/i=1,i<=4,i++)
			switch(i)
				if(1)
					occupant<< "\blue Powering down..."
				if(2)
					occupant<< "\blue Powering down core modules."
				if(3)
					occupant<< "\blue Unlocking suit from user"
				if(4)
					occupant<< "\blue Suit successfully powered down"
			if(!s_busy)
				return
			sleep(30)
		unpower()
		s_busy = 0
		return

/obj/item/clothing/suit/space/powersuit/proc/power()
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
	if(occupant.head == helmet)
		toggle_helmet()
	occupant.unEquip(occupant.wear_suit, 1)
	occupant = null
	playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)

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
			return 1
		if(occupant.head == helmet)
			occupant.unEquip(occupant.head, 1)
			occupant.update_inv_wear_suit()
			helmet.flags &= ~NODROP
			helmet.loc = src
			playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)
			return 1
	else
		occupant << "error: missing helmet module"

/obj/item/clothing/suit/space/powersuit/proc/update_stats()
	name = "[model_name] power suit"
	if(armor_attachment && armor_attachment.display_name)
		name = "[armor_attachment.display_name] [name]"
	if(powered)
		if(armor_attachment)
			armor = armor_attachment.armor_stats
			slowdown = armor_attachment.slowdown_stats
		else
			armor = initial(armor)
			slowdown = initial(slowdown)
	else
		slowdown = initial(slowdown)



/obj/item/clothing/suit/space/powersuit/proc/power_punch(var/mob/living/victim, var/mob/living/assaulter, var/obj/item/organ/limb/affecting, var/armor_block, var/a_intent)
	if(powered)
		if(primary_attachment)
			if(primary_attachment.power_punch(victim, assaulter, affecting, armor_block))
				return 1
		else if(secondary_attachment)
			if(secondary_attachment.power_punch(victim, assaulter, affecting, armor_block))
				return 1
		if(a_intent == "harm")
			var/fist_damage = 9
			victim.visible_message("<span class='danger'>[assaulter] pulverizes [victim]!</span>", \
							"<span class='userdanger'>[assaulter] pulverizes [victim]!</span>")
			var/hitsound = pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg')
			playsound(src, hitsound, 50, 1)

			victim.apply_damage(fist_damage, BRUTE, affecting, armor_block)
			//logging
			if (victim.stat == DEAD)
				add_logs(assaulter, victim, "power punched", addition=" (DAMAGE: [fist_damage]) (REMHP: DEAD)")
			else
				add_logs(assaulter, victim, "power punched", addition=" (DAMAGE: [fist_damage]) (REMHP: [victim.health - fist_damage])")
			return 1


///Helmets
/obj/item/clothing/head/space/powerhelmet
	name = "power suit helmet"
	icon_state = "p-helmet1-1"
	flags = HEADCOVERSEYES | BLOCKHAIR | HEADCOVERSMOUTH | STOPSPRESSUREDMAGE | THICKMATERIAL
	flags_inv = HIDEMASK | HIDEEARS | HIDEEYES | HIDEFACE
	var/list/compatible = list()

/obj/item/clothing/head/space/powerhelmet/chameleon
	icon_state = "p-helmet1-1"
	compatible = list(/obj/item/clothing/suit/space/powersuit/standard)

/obj/item/clothing/head/space/powerhelmet/bugman
	icon_state = "p-helmet1-2"
	compatible = list(/obj/item/clothing/suit/space/powersuit/standard)

/obj/item/clothing/head/space/powerhelmet/hunter
	icon_state = "p-helmet1-3"
	compatible = list(/obj/item/clothing/suit/space/powersuit/standard)

/obj/item/clothing/head/space/powerhelmet/security
	icon_state = "p-helmet2-2"
	compatible = list(/obj/item/clothing/suit/space/powersuit/security)

/obj/item/clothing/head/space/powerhelmet/syndicate
	icon_state = "p-helmet3-2"
	compatible = list(/obj/item/clothing/suit/space/powersuit/syndicate)


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
	var/wearing_helmet = "N/A"
	if(helmet)
		wearing_helmet = "Inactive"
		if(occupant.head == helmet)
			wearing_helmet = "Active"
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
	if(powered)
		dat += "Helmet: [wearing_helmet]<br>"
		dat += "Power Core: [cell ? "[cell.charge] / [cell.maxcharge]" : "N/A"]<br>"
		dat += "Armor Ratings:<br>"
		for(var/X in armor)
			dat += "[TAB][X]: [armor[X]]%<br>"
		dat += "[TAB]speed: [speed_text]%<br>"
	else
		dat += "POWER OFFLINE"
	dat += "</div>"
	dat += "<h3>Attachments</h3>"
	dat += "<div class='statusDisplay'>"
	dat += "Primary Attachment: [primary_attachment ? "<a href='byond://?src=\ref[src];choice=remove;target=\ref[primary_attachment]'>[primary_attachment.name]</a>" : "N/A"]<br>"
	dat += "Secondary Attachment: [secondary_attachment ? "<a href='byond://?src=\ref[src];choice=remove;target=\ref[secondary_attachment]'>[secondary_attachment.name]</a> - <a href='byond://?src=\ref[src];choice=activate;target=\ref[secondary_attachment]'>Activate</a>" : "N/A"]<br>"
	dat += "Armor Attachment: [armor_attachment ? "<a href='byond://?src=\ref[src];choice=remove;target=\ref[armor_attachment]'>[armor_attachment.name]</a>" : "N/A"]<br>"
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
			if(!powered)
				var/obj/item/weapon/powersuit_attachment/P = locate(href_list["target"])
				switch(P.attachment_type)
					if(POWERSUIT_ARMOR)
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
			else
				U << "You must turn off the suit before removing attachments"
		if ("activate")
			if(powered)
				var/obj/item/weapon/powersuit_attachment/A = locate(href_list["target"])
				A.activate_module()
			else
				U << "[src] needs to be powered to use this"
	interact_suit()