/obj/item/device/paicard
	name = "personal AI device"
	icon = 'icons/obj/aicards.dmi'
	icon_state = "pai"
	item_state = "electronic"
	w_class = 2.0
	slot_flags = SLOT_BELT
	origin_tech = "programming=2"
	var/obj/item/device/radio/borg/radio
	var/looking_for_personality = 0
	var/mob/living/silicon/pai/pai
	var/emagged = 0
	var/datum/browser/popup = null

/obj/item/device/paicard/New()
	..()
	overlays += "pai-off"

/obj/item/device/paicard/Destroy()
	//Will stop people throwing friend pAIs into the singularity so they can respawn
	if(!isnull(pai))
		pai.death(0)
	..()

/obj/item/device/paicard/attack_self(mob/living/user)
	if(!(user.stat || user.restrained() || user.paralysis || user.stunned || user.weakened))
		user.set_machine(src)
		var/dat = ""
		if(pai)
			dat += {"
					<div class='statusDisplay'>
					<center>
					"}
			if(!pai.master_dna || !pai.master)
				dat += {"
						Owner: None!<br>
						<a href='byond://?src=\ref[src];choice=SetDNA'>Imprint Master DNA</a><br>
						"}
			if(pai.master_dna || pai.master)
				dat += {"
						Owner: [pai.master]<br>
						DNA: [pai.master_dna]<br>
						"}
			dat += {"
					Installed Personality: [pai.name] <a href='byond://?src=\ref[src];choice=WIPE'>WIPE</a><br>
					<a href='byond://?src=\ref[src];choice=Law'>Configure Directives</a><br>
					</center>
					</div>
					"}

			dat += {"<h3>Prime Directive</h3>"}
			dat += {"[pai.laws.zeroth]<br>"}
			dat += {"<h3>Additional Directives</h3>"}
			for(var/slaws in pai.laws.supplied)
				dat += {"[slaws]"}
			dat += {"<br>"}
			dat += {"<h3>Radio Settings</h3>"}
			if(radio)
				dat += "Transmit: <A href='byond://?src=\ref[src];wires=[WIRE_TRANSMIT]'>[(radio.wires.IsIndexCut(WIRE_TRANSMIT)) ? "Disabled" : "Enabled"]</A><br>"
				dat += "Receive: <A href='byond://?src=\ref[src];wires=[WIRE_RECEIVE]'>[(radio.wires.IsIndexCut(WIRE_RECEIVE)) ? "Disabled" : "Enabled"]</A><br>"
			else
				dat += "<font color=red><i>Radio firmware not loaded. Please install a pAI personality to load firmware.</i></font><br>"

		else
			if(looking_for_personality)
				dat += "Requesting AI personalities from central database... If there are no entries, or if a suitable entry is not listed, check again later as more personalities may be added."
				var/list/available = list()
				for(var/datum/paiCandidate/c in paiController.pai_candidates)
					if(c.ready)
						var/found = 0
						for(var/mob/dead/observer/o in player_list)
							if(o.key == c.key)
								found = 1
						if(found)
							available.Add(c)

				dat += "<table>"

				for(var/datum/paiCandidate/c in available)
					dat += "<tr class=\"d0\"><td>Name:</td><td>[c.name]</td></tr>"
					dat += "<tr class=\"d1\"><td>Description:</td><td>[c.description]</td></tr>"
					dat += "<tr class=\"d0\"><td>Preferred Role:</td><td>[c.role]</td></tr>"
					dat += "<tr class=\"d1\"><td>OOC Comments:</td><td>[c.comments]</td></tr>"
					dat += "<tr class=\"d2\"><td><a href='byond://?src=\ref[paiController];download=1;candidate=\ref[c];device=\ref[src]'>\[Download [c.name]\]</a></td><td></td></tr>"

				dat += "</table>"
			else
				dat += "<a href='byond://?src=\ref[src];choice=Search'>Request pAI Personality</a><br>"

		popup = new(user, "paicard", "[src]")
		popup.set_content(dat)
		popup.title = {"<div align="left">Personal AI User Controls</div><div align="right"><a href='byond://?src=\ref[src];choice=Refresh'>Refresh</a><a href='byond://?src=\ref[src];choice=Close'>Close</a></div>"}
		popup.window_options = "size=480x640;border=0;can_resize=1;can_close=0;can_minimize=0"
		popup.open()

/obj/item/device/paicard/Topic(href, href_list)
	var/mob/U = usr
	switch(href_list["choice"])//Now we switch based on choice.
		if ("Close")
			U << browse(null, "window=[popup.window_id]")
			popup.close()
			U.unset_machine()
			return
	if(!(usr.stat || usr.restrained() || usr.paralysis || usr.stunned || usr.weakened))
		add_fingerprint(U)
		U.set_machine(src)
		switch(href_list["choice"])//Now we switch based on choice.
			if ("Search")
				paiController.requestRecruits()
				src.looking_for_personality = 1
			if ("SetDNA")
				if(pai)
					if(pai.master_dna)
						return
					if(!istype(usr, /mob/living/carbon))
						usr << "<span class='notice'>You don't have any DNA, or your DNA is incompatible with this device.</span>"
					else
						var/mob/living/carbon/M = usr
						pai.master = M.real_name
						pai.master_dna = M.dna.unique_enzymes
						pai << "<span class='notice'>You have been bound to a new master.</span>"
					if(pai.tablet)
						pai.tablet.update_label()
						pai.tablet.attack_self(pai)
			if ("WIPE")
				var/confirm = input("Are you CERTAIN you wish to delete the current personality? This action cannot be undone.", "Personality Wipe") in list("Yes", "No")
				if(confirm == "Yes")
					if(pai)
						pai << "<span class='warning'>You feel yourself slipping away from reality.</span>"
						pai << "<span class='danger'>Byte by byte you lose your sense of self.</span>"
						pai << "<span class='userdanger'>Your mental faculties leave you.</span>"
						pai << "<span class='rose'>oblivion... </span>"
						pai.death(0)
					removePersonality()
			if ("Law")
				var/newlaws = copytext(sanitize(input("Enter any additional directives you would like your pAI personality to follow. Note that these directives will not override the personality's allegiance to its imprinted master. Conflicting directives will be ignored.", "pAI Directive Configuration", pai.laws.supplied[1]) as message),1,MAX_MESSAGE_LEN)
				if(newlaws && pai)
					pai.add_supplied_law(0,newlaws)
					pai << "Your supplemental directives have been updated. Your new directives are:"
					pai << "Prime Directive : <br>[pai.laws.zeroth]"
					for(var/slaws in pai.laws.supplied)
						pai << "Supplemental Directives: <br>[slaws]"
		if(href_list["wires"])
			var/t1 = text2num(href_list["wires"])
			if(radio)
				radio.wires.CutWireIndex(t1)
		src.attack_self(U)

/obj/item/device/paicard/proc/setPersonality(mob/living/silicon/pai/personality)
	src.pai = personality
	src.overlays += "pai-happy"

/obj/item/device/paicard/proc/removePersonality()
	src.pai = null
	src.overlays.Cut()
	src.overlays += "pai-off"

/obj/item/device/paicard/proc/setEmotion(var/emotion)
	if(pai)
		src.overlays.Cut()
		switch(emotion)
			if(1) src.overlays += "pai-happy"
			if(2) src.overlays += "pai-cat"
			if(3) src.overlays += "pai-extremely-happy"
			if(4) src.overlays += "pai-face"
			if(5) src.overlays += "pai-laugh"
			if(6) src.overlays += "pai-off"
			if(7) src.overlays += "pai-sad"
			if(8) src.overlays += "pai-angry"
			if(9) src.overlays += "pai-what"

/obj/item/device/paicard/proc/alertUpdate()
	var/turf/T = get_turf(src)
	if(T)
		T.visible_message("<span class ='info'>[src] flashes a message across its screen, \"Additional personalities available for download.\"", 3, "\blue [src] bleeps electronically.</span>", 2)
	else
		visible_message("<span class ='info'>[src] flashes a message across its screen, \"Additional personalities available for download.\"", 3, "\blue [src] bleeps electronically.</span>", 2)

/obj/item/device/paicard/emp_act(severity)
	if(pai)
		pai.emp_act(severity)
	..()

/obj/item/device/paicard/attackby(obj/item/C as obj, mob/user as mob)
	..()
	if(istype(C, /obj/item/weapon/card/emag))
		if(!emagged)
			user << "<span class='notice'>You emag the pAI.</span>"
			emagged = 1
			return

//Left this here because Flavo loves when I leave old code commented out -DingleFlop

/*
/obj/item/device/paicard/attack_self(mob/user)
	if (!in_range(src, user))
		return
	user.set_machine(src)
	var/dat = "<TT><B>Personal AI Device</B><BR>"
	if(pai && (!pai.master_dna || !pai.master))
		dat += "<a href='byond://?src=\ref[src];setdna=1'>Imprint Master DNA</a><br>"
	if(pai)
		dat += "Installed Personality: [pai.name]<br>"
		dat += "Prime directive: <br>[pai.laws.zeroth]<br>"
		for(var/slaws in pai.laws.supplied)
			dat += "Additional directives: <br>[slaws]<br>"
		dat += "<a href='byond://?src=\ref[src];setlaws=1'>Configure Directives</a><br>"
		dat += "<br>"
		dat += "<h3>Device Settings</h3><br>"
		if(radio)
			dat += "<b>Radio Uplink</b><br>"
			dat += "Transmit: <A href='byond://?src=\ref[src];wires=[WIRE_TRANSMIT]'>[(radio.wires.IsIndexCut(WIRE_TRANSMIT)) ? "Disabled" : "Enabled"]</A><br>"
			dat += "Receive: <A href='byond://?src=\ref[src];wires=[WIRE_RECEIVE]'>[(radio.wires.IsIndexCut(WIRE_RECEIVE)) ? "Disabled" : "Enabled"]</A><br>"
		else
			dat += "<b>Radio Uplink</b><br>"
			dat += "<font color=red><i>Radio firmware not loaded. Please install a pAI personality to load firmware.</i></font><br>"
		dat += "<A href='byond://?src=\ref[src];wipe=1'>\[Wipe current pAI personality\]</a><br>"
	else
		if(looking_for_personality)
			var/list/available = list()
			for(var/datum/paiCandidate/c in paiController.pai_candidates)
				if(c.ready)
					var/found = 0
					for(var/mob/dead/observer/o in player_list)
						if(o.key == c.key)
							found = 1
					if(found)
						available.Add(c)
			dat += {"
					<style type="text/css">

					p.top {
						background-color: #AAAAAA; color: black;
					}

					tr.d0 td {
						background-color: #CC9999; color: black;
					}
					tr.d1 td {
						background-color: #9999CC; color: black;
					}
					tr.d2 td {
						background-color: #99CC99; color: black;
					}
					</style>
					"}
			dat += "<p class=\"top\">Requesting AI personalities from central database... If there are no entries, or if a suitable entry is not listed, check again later as more personalities may be added.</p>"

			dat += "<table>"

			for(var/datum/paiCandidate/c in available)
				dat += "<tr class=\"d0\"><td>Name:</td><td>[c.name]</td></tr>"
				dat += "<tr class=\"d1\"><td>Description:</td><td>[c.description]</td></tr>"
				dat += "<tr class=\"d0\"><td>Preferred Role:</td><td>[c.role]</td></tr>"
				dat += "<tr class=\"d1\"><td>OOC Comments:</td><td>[c.comments]</td></tr>"
				dat += "<tr class=\"d2\"><td><a href='byond://?src=\ref[paiController];download=1;candidate=\ref[c];device=\ref[src]'>\[Download [c.name]\]</a></td><td></td></tr>"

			dat += "</table>"
		else
			dat += "No personality is installed.<br>"
			dat += "<A href='byond://?src=\ref[src];request=1'>\[Request personal AI personality\]</a><br>"
			dat += "Each time this button is pressed, a request will be sent out to any available personalities. Check back often and alot time for personalities to respond. This process could take anywhere from 15 seconds to several minutes, depending on the available personalities' timeliness."
	user << browse(dat, "window=paicard")
	onclose(user, "paicard")
	return

/obj/item/device/paicard/Topic(href, href_list)

	if(!usr || usr.stat)
		return

	if(href_list["request"])
		paiController.requestRecruits()
		src.looking_for_personality = 1

	if(pai)
		if(href_list["setdna"])
			if(pai.master_dna)
				return
			if(!istype(usr, /mob/living/carbon))
				usr << "<span class='notice'>You don't have any DNA, or your DNA is incompatible with this device.</span>"
			else
				var/mob/living/carbon/M = usr
				pai.master = M.real_name
				pai.master_dna = M.dna.unique_enzymes
				pai << "<span class='notice'>You have been bound to a new master.</span>"
		if(href_list["wipe"])
			var/confirm = input("Are you CERTAIN you wish to delete the current personality? This action cannot be undone.", "Personality Wipe") in list("Yes", "No")
			if(confirm == "Yes")
				if(pai)
					pai << "<span class='warning'>You feel yourself slipping away from reality.</span>"
					pai << "<span class='danger'>Byte by byte you lose your sense of self.</span>"
					pai << "<span class='userdanger'>Your mental faculties leave you.</span>"
					pai << "<span class='rose'>oblivion... </span>"
					pai.death(0)
				removePersonality()
		if(href_list["wires"])
			var/t1 = text2num(href_list["wires"])
			if(radio)
				radio.wires.CutWireIndex(t1)
		if(href_list["setlaws"])
			var/newlaws = copytext(sanitize(input("Enter any additional directives you would like your pAI personality to follow. Note that these directives will not override the personality's allegiance to its imprinted master. Conflicting directives will be ignored.", "pAI Directive Configuration", pai.laws.supplied[1]) as message),1,MAX_MESSAGE_LEN)
			if(newlaws && pai)
				pai.add_supplied_law(0,newlaws)
				pai << "Your supplemental directives have been updated. Your new directives are:"
				pai << "Prime Directive : <br>[pai.laws.zeroth]"
				for(var/slaws in pai.laws.supplied)
					pai << "Supplemental Directives: <br>[slaws]"
	attack_self(usr)

// 		WIRE_SIGNAL = 1
//		WIRE_RECEIVE = 2
//		WIRE_TRANSMIT = 4
*/