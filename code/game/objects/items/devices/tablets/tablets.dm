var/global/list/obj/item/device/tablet/tablets_list = list()

/obj/item/device/tablet
	name = "\improper tablet"
	desc = "A portable computer by Thinktronic Systems, LTD."
	icon = 'icons/obj/tablets.dmi'
	icon_state = "tablet"
	item_state = "electronic"
	w_class = 1.0
	slot_flags = SLOT_ID | SLOT_BELT
	var/size_w = 480
	var/size_h = 640

	var/owner
	var/ownjob
	var/obj/item/device/tablet_core/core = null
	var/datum/browser/popup = null
	var/messengeron = 1
	var/scanmode
	var/system_alerts = 1
	var/fon = 0
	var/f_lum = 3

	var/laptop = 0

	var/obj/item/weapon/card/id/id = null //Making it possible to slot an ID card into the tablet so it can function as both.
	var/obj/item/radio/integrated/signal/s_radio = null
	var/obj/item/radio/integrated/mule/m_radio = null
	var/obj/item/radio/integrated/beepsky/b_radio = null

	var/obj/item/device/paicard/pai = null

	var/list/apps_builtin = list()
	var/list/apps_primary = list()
	var/list/apps_secondary = list()
	var/list/apps_utilities = list()

	var/lock_code = null
	var/implantlocked = 0
	var/can_eject = 1
	var/can_detonate = 1
	var/bolted = 0
	var/mounted = 0
	var/photo_cooldown = 0

	var/banned = 0

/obj/item/device/tablet/New()
	..()
	new /obj/item/weapon/pen(src)
	tablets_list.Add(src)
	s_radio = new /obj/item/radio/integrated/signal(src)
	s_radio.tablet = src
	m_radio = new /obj/item/radio/integrated/mule(src)
	m_radio.tablet = src
	b_radio = new /obj/item/radio/integrated/beepsky(src)
	b_radio.tablet = src
	core = new /obj/item/device/tablet_core/(src)
	core.programs.Add(new /datum/program/atmosscan)
	core.programs.Add(new /datum/program/assignments)
	if(can_eject && !istype(src,/obj/item/device/tablet/laptop))
		//install a camera on all devices that are not laptops or silicons
		core.programs.Add(new /datum/program/camera)
	//Install built-in apps
	for(var/x in typesof(/datum/program/builtin))
		var/datum/program/builtin/A = new x(src)
		if(!A.app_id)
			del(A)
			continue
		A.tablet = src
		core.programs.Add(A)

/obj/item/device/tablet/Destroy()
	tablets_list.Remove(src)
	if(src.id)
		src.id.loc = get_turf(src.loc)
	..()

/obj/item/device/tablet/attack_self(mob/living/user)
	user.set_machine(src)
	var/dat = ""
	if(can_use(user))
		if(implantlocked)
			if(!user.check_contents_for(implantlocked))
				var/datum/effect/effect/system/spark_spread/S = new/datum/effect/effect/system/spark_spread(get_turf(src))
				S.set_up(3, 0, get_turf(src))
				S.start()
				user << "<div class='warning'>The [src] shocks you.</div>"
				user.AdjustWeakened(2)
				return
		if(active_uplink_check(user))
			return
		if (!core)
			dat += "ERROR: No Hard Drive found.  Please insert Hard Drive.<br><br>"
		if (core)
			if(core.loaded)
				core.loaded.use_app()
			if (!core.owner)
				dat += "Warning: No owner information entered.  Please swipe card.<br><br>"
			else
				if(core.loaded)
					dat += "<a href='byond://?src=\ref[src];choice=Return'>Return</a><hr>"
					dat += core.loaded.dat
					core.loaded.notifications = 0
					check_alerts()
				else
					get_apps_list()
					dat += {"
							<div class='statusDisplay'>
							<center>
							Owner: [core.owner], [core.ownjob]<br>
							"}
					if(istype(user, /mob/living/silicon/pai))
						dat += {"
								Master: [user:master ? "[user:master] DNA: [user:master_dna]" : "None!"]<br>
								"}
					else
						dat += {"
								ID: <A href='?src=\ref[src];choice=Authenticate'>[id ? "[id.registered_name], [id.assignment]" : "----------"]</A><A href='?src=\ref[src];choice=UpdateInfo'>[id ? "Update Tablet Info" : ""]</A><br>
								"}
					dat += {"
							[station_name]<br>[time2text(world.realtime, "MMM DD")] [year_integer+540]<br>[worldtime2text()]<br>
							"}
					for(var/datum/program/P in apps_builtin)
						dat += "<a href='byond://?src=\ref[src];choice=load;target=\ref[P]'>[P.name][P.notifications ? " \[[P.notifications]\]" : ""]</a>"
					dat += {"</center></div>"}
					if(apps_primary.len)
						dat += {"<h3>Primary Applications</h3>"}
					for(var/datum/program/P in sortAtom(apps_primary))
						dat += "<a href='byond://?src=\ref[src];choice=load;target=\ref[P]'>[P.name][P.notifications ? " \[[P.notifications]\]" : ""]</a> "
						dat += "<br>"
					if(apps_secondary.len)
						dat += {"<h3>Secondary Applications</h3>"}
					for(var/datum/program/P in sortAtom(apps_secondary))
						dat += "<a href='byond://?src=\ref[src];choice=load;target=\ref[P]'>[P.name][P.notifications ? " \[[P.notifications]\]" : ""]</a> "
						dat += "<br>"
					if(apps_utilities.len)
						dat += {"<h3>Utilities</h3>"}
					for(var/datum/program/P in sortAtom(apps_utilities))
						dat += "<a href='byond://?src=\ref[src];choice=load;target=\ref[P]'>[P.name][P.notifications ? " \[[P.notifications]\]" : ""]</a> "
						dat += "<br>"
					dat += {"<a href='byond://?src=\ref[src];choice=Network'>[core.neton ? "Network \[On\]" : "Network \[Off\]"]</a><br>"}
					dat += {"<a href='byond://?src=\ref[src];choice=Light'>[fon ? "Flashlight \[On\]" : "Flashlight \[Off\]"]</a><br>"}
					if(pai)
						dat += {"<a href='byond://?src=\ref[src];choice=eject_pai'>Eject pAI[pai.pai ? ": [pai.pai]" : ""]</a> <a href='byond://?src=\ref[src];choice=interact_pai'>pAI Menu</a><br>"}
		var/device = "tablet"
		if(laptop)
			device = "laptop"
		if(istype(user, /mob/living/silicon/pai))
			user:updateTablet(dat)
			return
		popup = new(user, device, "[src]")
		popup.set_content(dat)
		popup.title = {"<div align="left">ThinkTronic OS 3.1</div><div align="right"><a href='byond://?src=\ref[src];choice=Refresh'>Refresh</a><a href='byond://?src=\ref[src];choice=Close'>Close</a></div>"}
		popup.window_options = "size=[size_w]x[size_h];border=0;can_resize=1;can_close=0;can_minimize=0"
		popup.open()

/obj/item/device/tablet/Topic(href, href_list)
	var/mob/U = usr
	switch(href_list["choice"])//Now we switch based on choice.
		if ("Close")
			U << browse(null, "window=[popup.window_id]")
			popup.close()
			U.unset_machine()
			return
	if(can_use(usr))
		add_fingerprint(U)
		U.set_machine(src)
		switch(href_list["choice"])//Now we switch based on choice.
			if ("Return")
				if(core)
					core.loaded = null
			if ("load")
				if(core)
					var/datum/program/P = locate(href_list["target"])
					core.loaded = P
					P.tablet = src
					P.notifications = 0
					core.loaded.use_app(src)
					core.loaded.notifications = 0
					if(!core.loaded.dat)
						core.loaded = null
			if ("Authenticate")
				id_check(U, 1)
			if ("UpdateInfo")
				if(can_eject)
					core.ownjob = id.assignment
					update_label()
			if("Network")
				if(core)
					core.neton = !core.neton
			if("Light")
				if(fon)
					fon = 0
					set_light(0)
				else
					fon = 1
					set_light(f_lum)
			if("eject_pai")
				if(pai)
					pai.loc = get_turf(src.loc)
					pai = null
			if("interact_pai")//Rather than shoot the pAI onto the floor, lets just interact with it while it is in the tablet...
				if(pai)
					pai.attack_self(U)

		if(core && core.loaded)
			core.loaded.use_app()
		src.attack_self(U)

/obj/item/device/tablet/proc/update_label()
	name = "Tablet-[core.owner] ([core.ownjob])" //Name generalisation
	owner = core.owner
	ownjob = core.ownjob

/obj/item/device/tablet/proc/network()
	var/turf/T = get_turf(loc)
	if (!T) return 0
	if (!core) return 0
	if (banned) return 0
	if (core.neton)
		for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
			if(MS.stat & (BROKEN|NOPOWER|EMPED))
				return
			if(MS.active)
				if(MS.z == T.z)//on the same z-level?
					return MS
					break
				else
					for (var/list/obj/machinery/nanonet_router/router in nanonet_routers)
						if(router.z == T.z)//on the same z-level?
							if(router.active)
								return MS
								break

/obj/item/device/tablet/proc/check_alerts()
	overlays.Cut()
	var/N = 0
	if(core)
		for(var/datum/program/P in core.programs)
			if(!P.notifications)
				continue
			N = 1
		if(N)
			if(istype(src,/obj/item/device/tablet/laptop))
				if(mounted)
					overlays.Cut()
					overlays += image('icons/obj/Laptop.dmi', "Laptop_open_r")
				if(!mounted)
					overlays.Cut()
					overlays += image('icons/obj/Laptop.dmi', "Laptop_closed_r")
				return
			if(istype(src,/obj/item/device/tablet/))
				overlays.Cut()
				overlays += image('icons/obj/tablets.dmi', "tablet-r")
				return
			else
				return

/obj/item/device/tablet/proc/alert_self(var/alert,var/details,var/app_id)
	if(!core) return
	var/datum/program/program = null
	if(app_id)
		for(var/datum/program/P in core.programs)
			if(P.app_id == app_id)
				if(P.alertsoff)
					return
				program = P
	if(!network())
		return
	var/mob/living/L = null
	if(src.loc && isliving(src.loc))
		L = src.loc
	if(core.volume)
		playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
		for (var/mob/O in hearers(3, loc))
			O.show_message(text("\icon[src] *[core.ttone]*"))
	if(istype(src,/obj/item/device/tablet/laptop))
		for (var/mob/O in hearers(1, loc))
			O.show_message(text("\icon[src] <b>[alert]</b> - [details]"))
	if(L)
		L << "\icon[src] <b>[alert]</b> - [details]"
	if(program && core)
		program.notifications++
		if(core.loaded && core.loaded == program)
			core.loaded.use_app()
		if(L && L.machine == src)
			src.attack_self(L)
	check_alerts()

/obj/item/device/tablet/proc/explode() //This needs tuning.
	if(!src.can_detonate) return
	if(!core) return
	var/turf/T = get_turf(src.loc)

	if(src.id)
		src.id.loc = get_turf(src.loc)
	if (ismob(loc))
		var/mob/M = loc
		M.show_message("\red Your [src]'s Core ignites into flames!", 1)

	if(T)
		T.hotspot_expose(700,125)
		explosion(T, -1, -1, 2, 3, flame_range = 2)
	qdel(src)

/obj/item/device/tablet/proc/get_apps_list()
	apps_builtin = list()
	apps_primary = list()
	apps_secondary = list()
	apps_utilities = list()

	for(var/datum/program/P in core.programs)
		if(P.utility)
			apps_utilities.Add(P)
			continue
		if(P.built_in)
			apps_builtin.Add(P)
			continue
		if(P.secondary == 0)
			apps_primary.Add(P)
			continue
		if(P.secondary == 1)
			apps_secondary.Add(P)
			continue

/obj/item/device/tablet/attackby(obj/item/C as obj, mob/user as mob)
	..()
	if(core)
		if(istype(C, /obj/item/weapon/card/id))
			var/obj/item/weapon/card/id/idcard = C
			if(!idcard.registered_name)
				user << "<span class='notice'>\The [src] rejects the ID.</span>"
				return
			if(!core.owner)
				core.owner = idcard.registered_name
				core.ownjob = idcard.assignment
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
		if(istype(C, /obj/item/device/tablet_carts/))
			var/obj/item/device/tablet_carts/expand = C
			if(expand.usedup)
				user << "<span class='notice'>This cartridge has been used up.</span>"
				return
			user << "<span class='notice'>You load the cartridge's data into the downloads.</span>"
			for(var/datum/program/P in expand.programs)
				expand.programs.Remove(P)
				var/duplicate = 0
				for(var/datum/program/dup in core.programs)
					if(dup.app_id == P.app_id)
						duplicate = 1
				if(duplicate)
					qdel(P)
				else
					P.secondary = 1
					core.programs.Add(P)
			if(!expand.programs.len)
				expand.name += " (Empty)"
				expand.usedup = 1
		if(istype(C, /obj/item/weapon/spacecash))
			var/obj/item/weapon/spacecash/S = C
			core.cash += S.credits
			qdel(C)
			updateSelfDialog()//For the non-input related code.
			if(S.credits)
				user << "<span class='notice'>You convert the Space Cash into digital currency in your E-Wallet</span>"
			else
				user << "<span class='notice'>ERROR: Counterfeit Space Cash detected. Currency declined</span>"
		if(istype(C, /obj/item/device/toner))
			core.toner = 30
			user << "<span class='notice'>You replace the toner cartridge.</span>"
			qdel(C)
		if(istype(C, /obj/item/weapon/pen))
			var/obj/item/weapon/pen/O = locate() in src
			if(O)
				user << "<span class='notice'>There is already a pen in \the [src].</span>"
			else
				user.drop_item()
				C.loc = src
				user << "<span class='notice'>You slide \the [C] into \the [src].</span>"
		if(istype(C, /obj/item/device/paicard))
			if(pai)
				user << "<span class='notice'>There is already a pai in [src].</span>"
			else
				user.drop_item()
				C.loc = src
				src.pai = C
				user << "<span class='notice'>You put [C] in [src].</span>"
	else
		if(istype(C, /obj/item/device/tablet_core))
			var/obj/item/device/tablet_core/D = C
			core = D
			user.drop_item()
			D.loc = src
			user << "<span class='notice'>You put the core into \the [src]'s slot.</span>"
			update_label()
			updateSelfDialog()//For the non-input related code.

/obj/item/device/tablet/attack(mob/living/carbon/C, mob/living/user as mob)
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

/obj/item/device/tablet/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(scanmode == "Camera" && !photo_cooldown)
		captureimage(A, user, proximity)

		playsound(loc, pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)

		photo_cooldown = 1
		spawn(64)
			photo_cooldown = 0
		return

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
	if(istype(A, /obj/item/weapon/paper))
		var/obj/item/weapon/paper/P = A
		var/exists = 0
		for(var/datum/tablet_data/document/D in core.files)
			if(D.doc == P.info)
				exists = 1
				break
		if(exists)
			user << "\blue Document already exists, aborting scan."
		else
			var/datum/tablet_data/document/doc = new /datum/tablet_data/document/
			doc.fields = P:fields
			doc.doc = P.info
			doc.doc_links = P.info_links
			doc.name = P:name
			user << "\blue Paper scanned."
			core.files.Add(doc)
	if(istype(A, /obj/item/weapon/photo))
		var/obj/item/weapon/photo/P = A
		var/exists = 0
		for(var/datum/tablet_data/photo/D in core.files)
			if(D.photoinfo == P:img)
				exists = 1
				break
		if(exists)
			user << "\blue Photo already exists, aborting scan."
		else
			var/datum/tablet_data/photo/pic = new /datum/tablet_data/photo/
			pic.photoinfo = P.img
			user << "\blue Photo scanned."
			core.files.Add(pic)

//camera stuff

/obj/item/device/tablet/proc/captureimage(atom/target, mob/user, flag)
	var/list/seen
	seen = hear(world.view, target)

	var/list/turfs = list()
	for(var/turf/T in range(1, target))
		if(T in seen)
			turfs += T

	var/icon/temp = icon('icons/effects/96x96.dmi',"")
	temp.Blend("#000", ICON_OVERLAY)
	temp.Blend(camera_get_icon(turfs, target), ICON_OVERLAY)

	var/obj/item/weapon/photo/P = new/obj/item/weapon/photo()
	user.put_in_hands(P)
	var/icon/small_img = icon(temp)
	var/icon/ic = icon('icons/obj/items.dmi',"photo")
	small_img.Scale(8, 8)
	ic.Blend(small_img,ICON_OVERLAY, 10, 13)
	P.icon = ic
	P.img = temp
	P.pixel_x = rand(-10, 10)
	P.pixel_y = rand(-10, 10)

	var/datum/tablet_data/photo/pic = new /datum/tablet_data/photo/
	pic.photoinfo = P.img
	if(target == user)
		user.visible_message("<span class = 'notice'>[user] takes a selfie with \his tablet</span>")
	else
		user.visible_message("<span class = 'notice'>[user] takes a photo with \his tablet</span>")
	core.files.Add(pic)

	qdel(P)

/obj/item/device/tablet/proc/camera_get_icon(list/turfs, turf/center)
	var/atoms[] = list()
	for(var/turf/T in turfs)
		atoms.Add(T)
		for(var/atom/movable/A in T)
			if(A.invisibility) continue
			atoms.Add(A)

	var/list/sorted = list()
	var/j
	for(var/i = 1 to atoms.len)
		var/atom/c = atoms[i]
		for(j = sorted.len, j > 0, --j)
			var/atom/c2 = sorted[j]
			if(c2.layer <= c.layer)
				break
		sorted.Insert(j+1, c)

	var/icon/res = icon('icons/effects/96x96.dmi', "")

	for(var/atom/A in sorted)
		var/icon/img = getFlatIcon(A)
		if(istype(A, /mob/living) && A:lying)
			img.Turn(A:lying)

		var/offX = 32 * (A.x - center.x) + A.pixel_x + 33
		var/offY = 32 * (A.y - center.y) + A.pixel_y + 33
		if(istype(A, /atom/movable))
			offX += A:step_x
			offY += A:step_y

		res.Blend(img, blendMode2iconMode(A.blend_mode), offX, offY)

	for(var/turf/T in turfs)
		res.Blend(getFlatIcon(T.loc), blendMode2iconMode(T.blend_mode), 32 * (T.x - center.x) + 33, 32 * (T.y - center.y) + 33)

	return res

//end camera stuff

/obj/item/device/tablet/proc/id_check(mob/user as mob, choice as num)//To check for IDs; 1 for in-pda use, 2 for out of pda use.
	if(choice == 1)
		if (id)
			remove_id()
		else
			var/obj/item/I = user.get_active_hand()
			if (istype(I, /obj/item/weapon/card/id))
				user.drop_item()
				I.loc = src
				id = I
	else
		var/obj/item/weapon/card/I = user.get_active_hand()
		if (istype(I, /obj/item/weapon/card/id) && I:registered_name)
			var/obj/old_id = id
			user.drop_item()
			I.loc = src
			id = I
			user.put_in_hands(old_id)
	return

/obj/item/device/tablet/GetAccess()
	if(id)
		return id.GetAccess()
	else
		return ..()

/obj/item/device/tablet/GetID()
	return id

/obj/item/device/tablet/proc/remove_id()
	if (id)
		if (ismob(loc))
			var/mob/M = loc
			M.put_in_hands(id)
			usr << "<span class='notice'>You remove the ID from the [name].</span>"
		else
			id.loc = get_turf(src)
		id = null

/obj/item/device/tablet/AltClick(var/mob/user)
	if(!Adjacent(user)) return // Adjacent check
	if(user.stat || user.restrained() || user.paralysis || user.stunned || user.weakened) return

	if(id)
		remove_id()
		return
	else
		verb_remove_pen()
		return

/obj/item/device/tablet/proc/can_use(mob/user)
	if(laptop && !istype(user, /mob/living/silicon))
		if(user && ismob(user))
			if(user.stat || user.restrained() || user.paralysis || user.stunned || user.weakened)
				return 0
			for (user in viewers(1, loc))
				return 1
		return 0
	if(!laptop && !istype(user, /mob/living/silicon))
		if(user && ismob(user))
			if(user.stat || user.restrained() || user.paralysis || user.stunned || user.weakened)
				return 0
			if(loc == user)
				return 1
		return 0
	if(istype(user, /mob/living/silicon))
		if(user.stat)
			return 0
		if(loc == user)
			return 1

/obj/item/device/tablet/MouseDrop(obj/over_object as obj, src_location, over_location)
	var/mob/M = usr
	if((!istype(over_object, /obj/screen)) && can_use(M))
		return attack_self(M)
	return

obj/item/device/tablet/verb/verb_remove_id()
	set category = "Object"
	set name = "Remove id"
	set src in usr

	if(issilicon(usr))
		return

	if ( can_use(usr) )
		if(id)
			remove_id()
		else
			usr << "<span class='notice'>This PDA does not have an ID in it.</span>"
	else
		usr << "<span class='notice'>You cannot do this while restrained.</span>"


obj/item/device/tablet/verb/verb_remove_pen()
	set category = "Object"
	set name = "Remove pen"
	set src in usr

	if(issilicon(usr))
		return

	if ( can_use(usr) )
		var/obj/item/weapon/pen/O = locate() in src
		if(O)
			if (istype(loc, /mob))
				var/mob/M = loc
				if(M.get_active_hand() == null)
					M.put_in_hands(O)
					usr << "<span class='notice'>You remove \the [O] from \the [src].</span>"
					return
			O.loc = get_turf(src)
		else
			usr << "<span class='notice'>This PDA does not have a pen in it.</span>"
	else
		usr << "<span class='notice'>You cannot do this while restrained.</span>"

/obj/item/device/tablet/verb/use_tablet()
	set category = "Object"
	set name = "Use Tablet"
	set src in usr
	if ( can_use(usr) )
		attack_self(usr)
	else
		usr << "<span class='notice'>You cannot do this while restrained.</span>"

/obj/item/device/tablet/ai/verb/use_messenger()
	set category = "AI Commands"
	set name = "Use Tablet"
	set src in usr
	attack_self(usr)

//Tablet flavors//
/obj/item/device/tablet/plain
	icon_state = "tablet"
	New()
		..()
		core.programs.Add(new /datum/program/notekeeper)
		core.programs.Add(new /datum/program/signaller)

/obj/item/device/tablet/medical
	icon_state = "tablet-medical"
	New()
		..()
		core.programs.Add(new /datum/program/crewmonitor)
		core.programs.Add(new /datum/program/notekeeper)
		core.programs.Add(new /datum/program/medrecords)
		core.programs.Add(new /datum/program/medicalscanner)

/obj/item/device/tablet/therapist
	icon_state = "tablet-medical"
	New()
		..()
		core.programs.Add(new /datum/program/notekeeper)
		core.programs.Add(new /datum/program/medrecords)

/obj/item/device/tablet/virology
	icon_state = "tablet-virology"
	New()
		..()
		core.programs.Add(new /datum/program/notekeeper)
		core.programs.Add(new /datum/program/medrecords)
		core.programs.Add(new /datum/program/medicalscanner)


/obj/item/device/tablet/security
	icon_state = "tablet-security"
	New()
		..()
		core.programs.Add(new /datum/program/secrecords)
		core.programs.Add(new /datum/program/securitron_control)
		core.programs.Add(new /datum/program/brigcontrol)
		core.programs.Add(new /datum/program/notekeeper)


/obj/item/device/tablet/captain
	icon_state = "tablet-captain"
	can_detonate = 0
	New()
		..()
		core.programs.Add(new /datum/program/notekeeper)
		core.programs.Add(new /datum/program/crewmanifest)
		core.programs.Add(new /datum/program/setstatus)
		core.programs.Add(new /datum/program/powermonitor{secondary = 1})
		core.programs.Add(new /datum/program/medrecords)
		core.programs.Add(new /datum/program/medicalscanner)
		core.programs.Add(new /datum/program/secrecords)
		core.programs.Add(new /datum/program/securitron_control)
		core.programs.Add(new /datum/program/mule_control{secondary = 1})
		core.programs.Add(new /datum/program/reagentscanner)
		core.programs.Add(new /datum/program/radscanner)
		core.programs.Add(new /datum/program/gasscanner)
		core.programs.Add(new /datum/program/researchmonitor{secondary = 1})
		core.programs.Add(new /datum/program/enginebuddy{secondary = 1})
		core.programs.Add(new /datum/program/crewmonitor{secondary = 1})
		core.programs.Add(new /datum/program/cargobay{secondary = 1})
		core.programs.Add(new /datum/program/brigcontrol)
		core.programs.Add(new /datum/program/borgmonitor)


/obj/item/device/tablet/chaplain
	icon_state = "tablet-chaplain"
	New()
		..()
		core.programs.Add(new /datum/program/notekeeper)


/obj/item/device/tablet/clown
	icon_state = "tablet-clown"
	desc = "A portable computer by Thinktronic Systems, LTD. The surface is coated with polytetrafluoroethylene and banana drippings."
	New()
		..()
		core.programs.Add(new /datum/program/notekeeper)
		core.programs.Add(new /datum/program/honk)
		core.programs.Add(new /datum/program/spacebattle)
		core.programs.Add(new /datum/program/theoriontrail)
	Crossed(AM as mob|obj) //Clown Tablet is slippery.
		if (istype(AM, /mob/living/carbon))
			var/mob/living/carbon/M = AM
			M.slip(8, 5, src, NO_SLIP_WHEN_WALKING)


/obj/item/device/tablet/engineer
	icon_state = "tablet-engineer"
	New()
		..()
		core.programs.Add(new /datum/program/enginebuddy)
		core.programs.Add(new /datum/program/notekeeper)
		core.programs.Add(new /datum/program/powermonitor)


/obj/item/device/tablet/janitor
	icon_state = "tablet-janitor"
	New()
		..()
		core.programs.Add(new /datum/program/notekeeper)
		core.programs.Add(new /datum/program/custodiallocator)


/obj/item/device/tablet/science
	icon_state = "tablet-science"
	New()
		..()
		core.programs.Add(new /datum/program/researchmonitor)
		core.programs.Add(new /datum/program/gasscanner)
		core.programs.Add(new /datum/program/signaller)
		core.programs.Add(new /datum/program/notekeeper)


/obj/item/device/tablet/qm
	icon_state = "tablet-qm"
	New()
		..()
		core.programs.Add(new /datum/program/mule_control)
		core.programs.Add(new /datum/program/cargobay)
		core.programs.Add(new /datum/program/notekeeper)


/obj/item/device/tablet/mime
	icon_state = "tablet-mime"
	New()
		..()
		core.programs.Add(new /datum/program/notekeeper)
		core.ttone = "silence"

/obj/item/device/tablet/hop
	icon_state = "tablet-hop"
	New()
		..()
		core.programs.Add(new /datum/program/secrecords)
		core.programs.Add(new /datum/program/mule_control)
		core.programs.Add(new /datum/program/cargobay)
		core.programs.Add(new /datum/program/notekeeper)
		core.programs.Add(new /datum/program/crewmanifest)
		core.programs.Add(new /datum/program/setstatus)


/obj/item/device/tablet/ce
	icon_state = "tablet-ce"
	New()
		..()
		core.programs.Add(new /datum/program/enginebuddy)
		core.programs.Add(new /datum/program/notekeeper)
		core.programs.Add(new /datum/program/crewmanifest)
		core.programs.Add(new /datum/program/setstatus)
		core.programs.Add(new /datum/program/powermonitor)
		core.programs.Add(new /datum/program/gasscanner)


/obj/item/device/tablet/cmo
	icon_state = "tablet-cmo"
	New()
		..()
		core.programs.Add(new /datum/program/crewmonitor)
		core.programs.Add(new /datum/program/notekeeper)
		core.programs.Add(new /datum/program/medicalscanner)
		core.programs.Add(new /datum/program/medrecords)
		core.programs.Add(new /datum/program/crewmanifest)
		core.programs.Add(new /datum/program/setstatus)



/obj/item/device/tablet/rd
	icon_state = "tablet-rd"
	New()
		..()
		core.programs.Add(new /datum/program/researchmonitor)
		core.programs.Add(new /datum/program/borgmonitor)
		core.programs.Add(new /datum/program/crewmanifest)
		core.programs.Add(new /datum/program/setstatus)
		core.programs.Add(new /datum/program/reagentscanner)
		core.programs.Add(new /datum/program/gasscanner)
		core.programs.Add(new /datum/program/signaller)
		core.programs.Add(new /datum/program/notekeeper)



/obj/item/device/tablet/hos
	icon_state = "tablet-hos"
	New()
		..()
		core.programs.Add(new /datum/program/secrecords)
		core.programs.Add(new /datum/program/securitron_control)
		core.programs.Add(new /datum/program/brigcontrol)
		core.programs.Add(new /datum/program/notekeeper)
		core.programs.Add(new /datum/program/crewmanifest)
		core.programs.Add(new /datum/program/setstatus)


/obj/item/device/tablet/lawyer
	icon_state = "tablet-lawyer"
	New()
		..()
		core.programs.Add(new /datum/program/secrecords)
		core.programs.Add(new /datum/program/brigcontrol)
		core.programs.Add(new /datum/program/notekeeper)
		core.programs.Add(new /datum/program/theoriontrail)


/obj/item/device/tablet/hydro
	icon_state = "tablet-hydro"
	New()
		..()

		core.programs.Add(new /datum/program/notekeeper)


/obj/item/device/tablet/roboticist
	icon_state = "tablet-roboticist"
	New()
		..()
		core.programs.Add(new /datum/program/borgmonitor)
		core.programs.Add(new /datum/program/notekeeper)


/obj/item/device/tablet/miner
	icon_state = "tablet-miner"
	New()
		..()
		core.programs.Add(new /datum/program/notekeeper)


/obj/item/device/tablet/library
	icon_state = "tablet-library"
	New()
		..()

		core.programs.Add(new /datum/program/notekeeper)


/obj/item/device/tablet/atmos
	icon_state = "tablet-atmos"
	New()
		..()
		core.programs.Add(new /datum/program/notekeeper)
		core.programs.Add(new /datum/program/gasscanner)


/obj/item/device/tablet/genetics
	icon_state = "tablet-genetics"
	New()
		..()
		core.programs.Add(new /datum/program/crewmonitor)
		core.programs.Add(new /datum/program/notekeeper)
		core.programs.Add(new /datum/program/medrecords)
		core.programs.Add(new /datum/program/medicalscanner)
		core.programs.Add(new /datum/program/radscanner)


/obj/item/device/tablet/chemist
	icon_state = "tablet-chemistry"
	New()
		..()
		core.programs.Add(new /datum/program/notekeeper)
		core.programs.Add(new /datum/program/medrecords)
		core.programs.Add(new /datum/program/reagentscanner)


/obj/item/device/tablet/warden
	icon_state = "tablet-warden"
	New()
		..()
		core.programs.Add(new /datum/program/secrecords)
		core.programs.Add(new /datum/program/securitron_control)
		core.programs.Add(new /datum/program/brigcontrol)
		core.programs.Add(new /datum/program/notekeeper)


/obj/item/device/tablet/bartender
	icon_state = "tablet-bartender"
	New()
		..()

		core.programs.Add(new /datum/program/notekeeper)


/obj/item/device/tablet/cargo
	icon_state = "tablet-cargo"
	New()
		..()
		core.programs.Add(new /datum/program/mule_control)
		core.programs.Add(new /datum/program/cargobay)
		core.programs.Add(new /datum/program/notekeeper)


/obj/item/device/tablet/chef
	icon_state = "tablet-chef"
	New()
		..()

		core.programs.Add(new /datum/program/notekeeper)


/obj/item/device/tablet/detective
	icon_state = "tablet-detective"
	New()
		..()
		core.programs.Add(new /datum/program/secrecords)

		core.programs.Add(new /datum/program/notekeeper)


/obj/item/device/tablet/clear
	icon_state = "tablet-clear"
/obj/item/device/tablet/syndi
	icon_state = "tablet-syndi"
	messengeron = 0
	can_detonate = 0
	New()
		..()
		core.owner = "John Doe"
		core.ownjob = "Unknown"
		core.programs.Add(new /datum/program/hackingtools)
		core.programs.Add(new /datum/program/GPS)
		core.programs.Add(new /datum/program/signaller)
		core.programs.Add(new /datum/program/poddoor)
		update_label()

/obj/item/device/tablet/perseus
	icon_state = "tablet-perc"
	messengeron = 0
	New()
		..()
		core.neton = 0
		implantlocked = /obj/item/weapon/implant/enforcer
		core.programs.Add(new /datum/program/percblastdoors)
		core.programs.Add(new /datum/program/percimplants)
		core.programs.Add(new /datum/program/percmissions)
		core.programs.Add(new /datum/program/percshuttlelock)
		core.programs.Add(new /datum/program/secrecords)
		core.programs.Add(new /datum/program/brigcontrol)
		core.programs.Add(new /datum/program/notekeeper)
		core.programs.Add(new /datum/program/crewmanifest)

/obj/item/device/tablet/ai
	can_eject = 0
	can_detonate = 0
/obj/item/device/tablet/pai
	can_eject = 0
	can_detonate = 0

//Some spare Tablets in a box
/obj/item/weapon/storage/box/tablets
	name = "spare Tablets"
	desc = "A box of spare Tablets."
	icon = 'icons/obj/storage.dmi'
	icon_state = "pda"
	New()
		..()
		new /obj/item/device/tablet(src)
		new /obj/item/device/tablet(src)
		new /obj/item/device/tablet(src)
		new /obj/item/device/tablet_core(src)
		new /obj/item/device/tablet_core(src)
		new /obj/item/device/tablet_core(src)