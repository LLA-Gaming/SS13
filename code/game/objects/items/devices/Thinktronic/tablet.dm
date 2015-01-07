/obj/item/device/thinktronic/tablet
	icon = 'icons/obj/tablets.dmi'
	item_state = "electronic"
	w_class = 1.0
	hasmessenger = 1
	devicetype = "Tablet"
	slot_flags = SLOT_ID | SLOT_BELT
	var/owner
	var/ownjob
	var/lock_code = "" // Lockcode to unlock uplink

/obj/item/device/thinktronic/tablet/New()
	..()
	new /obj/item/weapon/pen(src)

/obj/item/device/thinktronic/tablet/attackby(obj/item/C as obj, mob/user as mob)
	..()
	if(HDD)
		if(istype(C, /obj/item/weapon/card/id))
			var/obj/item/weapon/card/id/idcard = C
			if(!idcard.registered_name)
				user << "<span class='notice'>\The [src] rejects the ID.</span>"
				return
			if(!HDD.owner)
				HDD.owner = idcard.registered_name
				HDD.ownjob = idcard.assignment
				update_label()
				user << "<span class='notice'>Card scanned.</span>"
			else
				//Basic safety check. If either both objects are held by user or PDA is on ground and card is in hand.
				if(((src in user.contents) && (C in user.contents)) || (istype(loc, /turf) && in_range(src, user) && (C in user.contents)) )
					if( can_use(user) )//If they can still act.
						id_check(user, 2)
						user << "<span class='notice'>You put the ID into \the [src]'s slot.</span>"
						updateSelfDialog()//Update self dialog on success.
				return	//Return in case of failed check or when successful.
			updateSelfDialog()//For the non-input related code.
		if(istype(C, /obj/item/device/thinktronic_parts/expansioncarts/))
			var/obj/item/device/thinktronic_parts/expansioncarts/expand = C
			user << "<span class='notice'>You load the cartridge's data into the downloads. The cartridge is consumed by the [devicetype]</span>"
			for(var/obj/item/device/thinktronic_parts/prog in expand)
				var/obj/item/device/thinktronic_parts/NewD = new prog.type(cart)
				NewD.sentby = format_text(C.name)
				updateSelfDialog()//For the non-input related code.
			qdel(C)
		if(istype(C, /obj/item/weapon/spacecash))
			var/obj/item/weapon/spacecash/S = C
			HDD.cash += S.credits
			qdel(C)
			updateSelfDialog()//For the non-input related code.
			if(S.credits)
				user << "<span class='notice'>You convert the Space Cash into digital currency in your E-Wallet</span>"
			else
				user << "<span class='notice'>ERROR: Counterfeit Space Cash detected. Currency declined</span>"
		if(istype(C, /obj/item/device/toner))
			HDD.toner = 30
			user << "<span class='notice'>You replace the toner cartridge.</span>"
			qdel(C)
	else
		if(istype(C, /obj/item/device/thinktronic_parts/core))
			var/obj/item/device/thinktronic_parts/core/D = C
			HDD = D
			user.drop_item()
			D.loc = src
			user << "<span class='notice'>You put the Hard Drive into \the [src]'s slot.</span>"
			update_label()
			updateSelfDialog()//For the non-input related code.

/obj/item/device/thinktronic/tablet/attack(mob/living/carbon/C, mob/living/user as mob)
	if(istype(C))
		switch(scanmode)

			if("Health")
				user.visible_message(text("<span class='alert'>[] has analyzed []'s vitals!</span>", user, C))
				healthscan(user, C, 1)
				src.add_fingerprint(user)

			if("Radiation")
				for (var/mob/O in viewers(C, null))
					O.show_message("\red [user] has analyzed [C]'s radiation levels!", 1)

				user.show_message("\blue Analyzing Results for [C]:")
				if(C.radiation)
					user.show_message("\green Radiation Level: \black [C.radiation]")
				else
					user.show_message("\blue No radiation detected.")

/obj/item/device/thinktronic/tablet/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return

	switch(scanmode)
		if("Reagent")
			if(!isnull(A.reagents))
				if(A.reagents.reagent_list.len > 0)
					var/reagents_length = A.reagents.reagent_list.len
					user << "\blue [reagents_length] chemical agent[reagents_length > 1 ? "s" : ""] found."
					for (var/re in A.reagents.reagent_list)
						user << "\blue \t [re]"
				else
					user << "\blue No active chemical agents found in [A]."
			else
				user << "\blue No significant chemical agents found in [A]."

		if("Gas")
			if (istype(A, /obj/item/weapon/tank))
				var/obj/item/weapon/tank/T = A
				atmosanalyzer_scan(T.air_contents, user, T)
			else if (istype(A, /obj/machinery/portable_atmospherics))
				var/obj/machinery/portable_atmospherics/T = A
				atmosanalyzer_scan(T.air_contents, user, T)
			else if (istype(A, /obj/machinery/atmospherics/pipe))
				var/obj/machinery/atmospherics/pipe/T = A
				atmosanalyzer_scan(T.parent.air, user, T)
			else if (istype(A, /obj/machinery/power/rad_collector))
				var/obj/machinery/power/rad_collector/T = A
				if(T.P) atmosanalyzer_scan(T.P.air_contents, user, T)
			else if (istype(A, /obj/item/weapon/flamethrower))
				var/obj/item/weapon/flamethrower/T = A
				if(T.ptank) atmosanalyzer_scan(T.ptank.air_contents, user, T)
	if (istype(A, /obj/item/weapon/paper) && HDD.owner)
		var/exists = 0
		for(var/obj/item/device/thinktronic_parts/data/document/D in HDD)
			if(D.doc == A:info)
				exists = 1
				break
		if(exists)
			user << "\blue Document already exists, aborting scan."
		else
			var/obj/item/device/thinktronic_parts/data/document/doc = new /obj/item/device/thinktronic_parts/data/document(HDD)
			doc.fields = A:fields
			doc.doc = A:info
			doc.doc_links = A:info_links
			user << "\blue Paper scanned."
	if (istype(A, /obj/item/weapon/photo) && HDD.owner)
		var/exists = 0
		for(var/obj/item/device/thinktronic_parts/data/photo/D in HDD)
			if(D.photoinfo == A:img)
				exists = 1
				break
		if(exists)
			user << "\blue Photo already exists, aborting scan."
		else
			var/obj/item/device/thinktronic_parts/data/photo/pic = new /obj/item/device/thinktronic_parts/data/photo(HDD)
			pic.photoinfo = A:img
			user << "\blue Photo scanned."


/obj/item/device/thinktronic/tablet/proc/update_label()
	name = "Tablet-[HDD.owner] ([HDD.ownjob])" //Name generalisation

/obj/item/device/thinktronic/tablet/MouseDrop(obj/over_object as obj, src_location, over_location)
	var/mob/M = usr
	if((!istype(over_object, /obj/screen)) && can_use(M))
		return attack_self(M)
	return

/obj/item/device/thinktronic/tablet/verb/use_tablet()
	set category = "Object"
	set name = "Use Tablet"
	set src in usr
	if ( can_use(usr) )
		attack_self(usr)
	else
		usr << "<span class='notice'>You cannot do this while restrained.</span>"

/obj/item/device/thinktronic/tablet/ai/verb/use_messenger()
	set category = "AI Commands"
	set name = "Use Tablet"
	set src in usr
	attack_self(usr)



//Tablet flavors//
/obj/item/device/thinktronic/tablet/plain
	icon_state = "tablet"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/plain/(src)

/obj/item/device/thinktronic/tablet/medical
	icon_state = "tablet-medical"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/medical(src)

/obj/item/device/thinktronic/tablet/virology
	icon_state = "tablet-virology"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/virology(src)

/obj/item/device/thinktronic/tablet/security
	icon_state = "tablet-security"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/security(src)

/obj/item/device/thinktronic/tablet/captain
	icon_state = "tablet-captain"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/captain(src)

/obj/item/device/thinktronic/tablet/chaplain
	icon_state = "tablet-chaplain"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/chaplain(src)

/obj/item/device/thinktronic/tablet/clown
	icon_state = "tablet-clown"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/clown(src)

/obj/item/device/thinktronic/tablet/engineer
	icon_state = "tablet-engineer"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/engineer(src)

/obj/item/device/thinktronic/tablet/janitor
	icon_state = "tablet-janitor"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/janitor(src)

/obj/item/device/thinktronic/tablet/science
	icon_state = "tablet-science"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/science(src)

/obj/item/device/thinktronic/tablet/qm
	icon_state = "tablet-qm"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/qm(src)

/obj/item/device/thinktronic/tablet/mime
	icon_state = "tablet-mime"
	volume = 0

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/mime(src)

/obj/item/device/thinktronic/tablet/hop
	icon_state = "tablet-hop"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/hop(src)

/obj/item/device/thinktronic/tablet/ce
	icon_state = "tablet-ce"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/ce(src)

/obj/item/device/thinktronic/tablet/cmo
	icon_state = "tablet-cmo"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/cmo(src)

/obj/item/device/thinktronic/tablet/rd
	icon_state = "tablet-rd"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/rd(src)

/obj/item/device/thinktronic/tablet/hos
	icon_state = "tablet-hos"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/hos(src)

/obj/item/device/thinktronic/tablet/lawyer
	icon_state = "tablet-lawyer"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/lawyer(src)

/obj/item/device/thinktronic/tablet/hydro
	icon_state = "tablet-hydro"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/hydro(src)

/obj/item/device/thinktronic/tablet/roboticist
	icon_state = "tablet-roboticist"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/roboticist(src)

/obj/item/device/thinktronic/tablet/miner
	icon_state = "tablet-miner"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/miner(src)

/obj/item/device/thinktronic/tablet/library
	icon_state = "tablet-library"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/library(src)

/obj/item/device/thinktronic/tablet/atmos
	icon_state = "tablet-atmos"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/atmos(src)

/obj/item/device/thinktronic/tablet/genetics
	icon_state = "tablet-genetics"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/genetics(src)

/obj/item/device/thinktronic/tablet/chemist
	icon_state = "tablet-chemistry"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/chemist(src)

/obj/item/device/thinktronic/tablet/warden
	icon_state = "tablet-warden"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/warden(src)

/obj/item/device/thinktronic/tablet/bartender
	icon_state = "tablet-bartender"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/bartender(src)

/obj/item/device/thinktronic/tablet/cargo
	icon_state = "tablet-cargo"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/cargo(src)

/obj/item/device/thinktronic/tablet/chef
	icon_state = "tablet-chef"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/chef(src)

/obj/item/device/thinktronic/tablet/detective
	icon_state = "tablet-detective"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/detective(src)

/obj/item/device/thinktronic/tablet/clear
	icon_state = "tablet-clear"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core(src)

/obj/item/device/thinktronic/tablet/syndi
	icon_state = "tablet-syndi"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/syndi(src)
		HDD.owner = "John Doe"
		HDD.ownjob = "Unknown"

/obj/item/device/thinktronic/tablet/ai
	candetonate = 0
	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/ai(src)

/obj/item/device/thinktronic/tablet/pai
	candetonate = 0
	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/pai(src)

/obj/item/device/thinktronic/tablet/clown/Crossed(AM as mob|obj) //Clown Tablet is slippery.
	if (istype(AM, /mob/living/carbon))
		var/mob/living/carbon/M = AM
		M.slip(8, 5, src, NO_SLIP_WHEN_WALKING)