/obj/item/device/thinktronic/laptop
	name = "Laptop"
	icon = 'icons/obj/Laptop.dmi'
	icon_state = "Laptop_closed"
	w_class = 3
	hasmessenger = 1
	devicetype = "Laptop"
	slot_flags = SLOT_BELT
	volume = 2 // louder so you can hear it without it being in your hand.
	ram = 512
	var/ownjob
	var/lock_code = "" // Lockcode to unlock uplink
	var/bolted = 0 // screwdrive to bolt it to a desk

/obj/item/device/thinktronic/laptop/attackby(obj/item/C as obj, mob/user as mob)
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
		if(istype(C, /obj/item/weapon/paper))
			var/obj/item/weapon/paper/A = C
			var/exists = 0
			for(var/obj/item/device/thinktronic_parts/data/document/D in HDD)
				if(D.doc == A.info)
					exists = 1
					break
			if(exists)
				user << "\blue Document already exists, aborting scan."
			else
				var/obj/item/device/thinktronic_parts/data/document/doc = new /obj/item/device/thinktronic_parts/data/document(HDD)
				doc.fields = A:fields
				doc.doc = A.info
				doc.doc_links = A.info_links
				doc.name = A:name
				user << "\blue Paper scanned."
		if(istype(C, /obj/item/weapon/photo))
			var/obj/item/weapon/photo/A = C
			var/exists = 0
			for(var/obj/item/device/thinktronic_parts/data/photo/D in HDD)
				if(D.photoinfo == A:img)
					exists = 1
					break
			if(exists)
				user << "\blue Photo already exists, aborting scan."
			else
				var/obj/item/device/thinktronic_parts/data/photo/pic = new /obj/item/device/thinktronic_parts/data/photo(HDD)
				pic.photoinfo = A.img
				user << "\blue Photo scanned."
	if(!HDD)
		if(istype(C, /obj/item/device/thinktronic_parts/core))
			var/obj/item/device/thinktronic_parts/core/D = C
			HDD = D
			user.drop_item()
			D.loc = src
			user << "<span class='notice'>You put the Hard Drive into \the [src]'s slot.</span>"
			update_label()
			updateSelfDialog()//For the non-input related code.
	if(istype(C, /obj/item/weapon/screwdriver))
		if(loc == usr) return
		if(bolted)
			bolted = 0
			anchored = 0
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			user << "<span class='notice'>You unbolt [src] from the ground</span>"
		else
			bolted = 1
			anchored = 1
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			user << "<span class='notice'>You bolt [src] to the ground</span>"

/obj/item/device/thinktronic/laptop/proc/update_label()
	if(!shared)
		name = "Laptop-[HDD.owner] ([HDD.ownjob])" //Name generalisation

/obj/item/device/thinktronic/laptop/proc/toggle_mount()
	if(loc == usr) return
	if(mounted)
		mounted = 0
		icon_state = "Laptop_closed"
		updateSelfDialog()//For the non-input related code.
		unalerted(0,0)
	else
		mounted = 1
		icon_state = "Laptop_open"
		updateSelfDialog()//For the non-input related code.
		unalerted(0,0)

/obj/item/device/thinktronic/laptop/MouseDrop(obj/over_object as obj, src_location, over_location)
	var/mob/M = usr
	if(can_use(M) && src in oview(1))
		return toggle_mount()
	return

/obj/item/device/thinktronic/laptop/verb/toggle_laptop()
	set name = "Toggle Laptop"
	set category = "Object"
	set src in oview(1)
	toggle_mount()
	add_fingerprint(usr)


/obj/item/device/thinktronic/laptop/plain
	name = "Unclaimed Laptop"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/plain(src)
		HDD.messengeron = 0

//Shared Laptops

/obj/item/device/thinktronic/laptop/medical
	shared = 1
	anchored = 1
	bolted = 1
	name = "Medbay Laptop"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/medlaptop(src)
		HDD.owner = "Medbay Staff"
		HDD.ownjob = "Medbay"

/obj/item/device/thinktronic/laptop/research
	shared = 1
	anchored = 1
	bolted = 1
	name = "Research Laptop"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/scilaptop(src)
		HDD.owner = "Research Staff"
		HDD.ownjob = "Science"

/obj/item/device/thinktronic/laptop/engineering
	shared = 1
	anchored = 1
	bolted = 1
	name = "Engineering Laptop"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/englaptop(src)
		HDD.owner = "Engineering Staff"
		HDD.ownjob = "Engineering"

/obj/item/device/thinktronic/laptop/security
	shared = 1
	anchored = 1
	bolted = 1
	name = "Security Laptop"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/seclaptop(src)
		HDD.owner = "Security Staff"
		HDD.ownjob = "Security"

/obj/item/device/thinktronic/laptop/cargo
	shared = 1
	anchored = 1
	bolted = 1
	name = "Cargobay Laptop"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/cargolaptop(src)
		HDD.owner = "Cargo Staff"
		HDD.ownjob = "Cargo"

/obj/item/device/thinktronic/laptop/public
	shared = 1
	anchored = 1
	bolted = 1
	name = "Public Laptop"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/public(src)
		HDD.owner = "Public Access #[rand(1,100)]"
		HDD.ownjob = "Public"
		HDD.messengeron = 0

/obj/item/device/thinktronic/laptop/prison
	shared = 1
	anchored = 1
	bolted = 1
	name = "Prison Laptop"

	New()
		..()
		HDD = new /obj/item/device/thinktronic_parts/core/public(src)
		HDD.owner = "Prisoner"
		HDD.ownjob = "Prisoner"
		HDD.banned = 1
		HDD.neton = 0
		HDD.messengeron = 0