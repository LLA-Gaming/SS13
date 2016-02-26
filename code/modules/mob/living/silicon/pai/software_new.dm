/mob/living/silicon/pai/var/datum/browser/popup = null //For pretty browser stuff
/mob/living/silicon/pai/var
	dat = " "
	left = " "
	right = " "
	tabDat = " "
	selected = " "
	error = " "
	list/available_software = list(
		"Crew Manifest (App)" = 10,
		"Medical Records (App)" = 20,
		"Security Records (App)" = 20,
		"Remote Signalling System (App)" = 10,
		"Security HUD" = 20,
		"Medical Suite" = 20,
		"Universal Translator" = 30,
		"Door Jack" = 30
		)
	installed_software[8]//Dirty, add one to this for every new program added later

/mob/living/silicon/pai/verb/paiInterface()
	set category = "pAI Commands"
	set name = "Software Interface"
	src.set_machine(src)
	switch(selected)
		if("Tablet")
			left = tabDat
		if("Download")
			left = downloadSoftware()
		if("DoorJack")
			left = softwareHack()
		if("Directives")
			left = directiveMenu()

	right = menuOptions()

	popup = new(usr, "paicard", "[src]")
	popup.set_content(finalizeUI())
	popup.title = {"<div align="left">Personal AI User Controls</div><div align="right"><a href='byond://?src=\ref[src];choice=Refresh'>Refresh</a><a href='byond://?src=\ref[src];choice=Close'>Close</a></div>"}
	popup.window_options = "size=720x640;border=0;can_resize=0;can_close=0;can_minimize=0"
	popup.open()

/mob/living/silicon/pai/Topic(href, href_list)
	..()
	var/mob/U = usr
	switch(href_list["choice"])//Now we switch based on choice.
		if ("Close")
			U << browse(null, "window=[popup.window_id]")
			popup.close()
			U.unset_machine()
			return
		if ("Tablet")
			if(!tablet)
				initTablet()
			selected = "Tablet"
		if ("Auth")
			spawn CheckDNA(getCarrier(), src)
		if ("Download")
			selected = "Download"
		if ("Translator")
			src.universal_speak = !src.universal_speak
		if ("Radio")
			radio.attack_self(src)
		if ("Directives")
			selected = "Directives"
		if ("SecHUD")
			secHUD = !secHUD
		if ("Thermals")
			thermals = !thermals
		if ("MedHUD")
			medHUD = !medHUD
		if ("Face")
			var/newImage = input("Select your new display image.", "Display Image", "Happy") in list("Happy", "Cat", "Extremely Happy", "Face", "Laugh", "Off", "Sad", "Angry", "What")
			var/pID = 1
			switch(newImage)
				if("Happy")
					pID = 1
				if("Cat")
					pID = 2
				if("Extremely Happy")
					pID = 3
				if("Face")
					pID = 4
				if("Laugh")
					pID = 5
				if("Off")
					pID = 6
				if("Sad")
					pID = 7
				if("Angry")
					pID = 8
				if("What")
					pID = 9
			src.card.setEmotion(pID)
		if ("MedScan")
			healthscan(src, getCarrier())
		if ("Interface")
			selected = "DoorJack"
			switch(href_list["command"])
				if ("Retract")
					del(src.cable)
					src.cable = null
					var/turf/T = get_turf(src.loc)
					for (var/mob/M in viewers(T))
						M.show_message("\red [src]'s cable rapidly retracts back into its spool!", 3, "\red You hear a fast whizzing sound!", 2)
				if ("Extend")
					var/turf/T = get_turf(src.loc)
					src.cable = new /obj/item/weapon/pai_cable(T)
					for (var/mob/M in viewers(T))
						M.show_message("\red A port on [src] opens to reveal [src.cable], which promptly falls to the floor.", 3, "\red You hear the soft click of something light and hard falling to the ground.", 2)
				if ("Jack")
					if(src.cable && src.cable.machine)
						src.hackdoor = src.cable.machine
						src.hackloop()
				if ("JackStop")
					src.hackdoor = null
	var/hrefIndex = text2num(href_list["choice"])
	if (hrefIndex)
		if(!(installed_software[hrefIndex] == 1))
			if(bsCrd - available_software[available_software[hrefIndex]] < 0)
				src << "Insufficient bluespace credits"
				return
			installed_software[hrefIndex] = 1
			switch(hrefIndex)
				if(1)
					installApp(new /datum/program/crewmanifest)
				if(2)
					installApp(new /datum/program/medrecords)
				if(3)
					installApp(new /datum/program/secrecords)
				if(4)
					installApp(new /datum/program/signaller)
			if(hrefIndex>4)
				installed_software[hrefIndex] = 1
		bsCrd -= available_software[available_software[hrefIndex]]
	paiInterface()

/mob/living/silicon/pai/proc/finalizeUI() //<a href='byond://?src=\ref[src];choice=btnID'>LINK TEXT</a>
	return {"
			<div style="display:inline-block;float:left;width:480px;vertical-align:top;height:540px;">
				[left]
			</div>
			<div style="display:inline-block;float:right;width:190px;vertical-align:top;background-color:#404040;height:540px;padding: 5px;border: 5px double #000000;">
				[right]
			</div>
			"}

/mob/living/silicon/pai/proc/getCarrier()
	var/mob/living/container = card.loc
	var/count = 0
	while((!istype(container, /mob/living)) && (count < 6))
		if(!container || !container.loc)
			return 0
		container = container.loc
		count++
	if(count >= 6)
		src << "You are not being carried by anyone!"
		return 0
	return container

/mob/living/silicon/pai/proc/menuOptions()
	return {"
			<h3>Basic</h3>
			<a href='byond://?src=\ref[src];choice=Tablet'>Show Tablet</a><br>
			<a href='byond://?src=\ref[src];choice=Download'>Software Menu</a><br>
			<a href='byond://?src=\ref[src];choice=Directives'>Directives</a><br>
			<a href='byond://?src=\ref[src];choice=Face'>Display</a><br>
			<br>
			[master_dna ? "<a href='byond://?src=\ref[src];choice=Auth'>Request Carrier DNA</a><br><br>" : ""]
			<a href='byond://?src=\ref[src];choice=Radio'>Built-in Radio</a><br>
			<h3>Advanced</h3>
			[installed_software[5] ? "<a href='byond://?src=\ref[src];choice=SecHUD'>Security HUD: [secHUD ? "On" : "Off"]</a><br><br>" : ""]
			[installed_software[6] ? "<a href='byond://?src=\ref[src];choice=MedScan'>Carrier Bioscan</a><br><a href='byond://?src=\ref[src];choice=MedHUD'>Medical HUD: [medHUD ? "On" : "Off"]</a><br><br>" : ""]
			[installed_software[7] ? "<a href='byond://?src=\ref[src];choice=Translator'>Universal Translator: [src.universal_speak ? "On" : "Off"]</a><br><br>" : ""]
			[installed_software[8] ? "<a href='byond://?src=\ref[src];choice=Interface'>DoorJack</a><br>" : ""]
			[card.emagged ? "<a href='byond://?src=\ref[src];choice=Thermals'>Thermal Vision: [thermals ? "On" : "Off"]</a><br>" : ""]
			"}

/mob/living/silicon/pai/proc/initTablet()//Initializes the pAI's built-in tablet
	if(!tablet)
		tablet = new /obj/item/device/tablet/pai(src)
		if(tablet.core)
			tablet.core.owner = "[name]"
			tablet.core.ownjob = "pAI"
			tablet.update_label()

	tablet.attack_self(src)
	selected = "tablet"

/mob/living/silicon/pai/proc/downloadSoftware()
	var/temp = {"
			Software provided by way of Bluespace Credits. Bluespace Credits are spent to fetch software over CentComm's bluespace software repository.
			<br>Bluespace Credits Remaining: [bsCrd]<br>
			<h3>Available Software</h3>
			"}

	var/index
	for(var/s in available_software)
		index = available_software.Find(s)
		if(!(installed_software[index] == 1))
			temp +=	"<a href='byond://?src=\ref[src];choice=[index]'>[s]: [available_software[available_software[index]]]</a><br>"

	return temp

/mob/living/silicon/pai/proc/installApp(var/datum/program/program)
	var/duplicate = 0
	for(var/datum/program/dup in tablet.core.programs)
		if(dup.app_id == program.app_id)
			duplicate = 1
	if(!duplicate)
		tablet.core.programs.Add(new program.type)
		usr << "Application Purchased, downloaded and installed"
	else
		usr << "ERROR: You already own [program.name]"
	tablet.attack_self(src)

/mob/living/silicon/pai/proc/updateTablet(var/tempDat)
	tabDat = tempDat
	paiInterface()

/mob/living/silicon/pai/proc/softwareHack()
	var/dat = "<h3>Airlock Jack</h3>"
	dat += "[error]<br>"
	dat += {"Cable Status: [src.cable ? "Extended  <a href='byond://?src=\ref[src];choice=Interface;command=Retract'>Retract Cable</a>" : "Retracted  <a href='byond://?src=\ref[src];choice=Interface;command=Extend'>Extend Cable</a>"]"}
	if(!src.cable)
		dat += "<br>Disconnected"
		return dat
	if(src.cable.machine)
		dat += "<br>Connected to: [src.cable.machine.name]<br>"

		if(!istype(src.cable.machine, /obj/machinery/door))
			dat += "Connected device's firmware does not appear to be compatible with any installed protocols.<br>"
			return dat

		if(!src.hackdoor)
			dat += "<a href='byond://?src=\ref[src];choice=Interface;command=Jack'>Begin Airlock Jack</a> <br>"
		else
			dat += "Jack in progress... [src.hackprogress]% complete.<br>"
			dat += "<a href='byond://?src=\ref[src];choice=Interface;command=JackStop'>Cancel Airlock Jack</a> <br>"
	return dat

// Door Jack - supporting proc
/mob/living/silicon/pai/proc/hackloop()
	var/turf/T = get_turf(src.loc)
	for(var/mob/living/silicon/ai/AI in player_list)
		if(T.loc)
			AI << "<font color = red><b>Network Alert: Brute-force encryption crack in progress in [T.loc].</b></font>"
		else
			AI << "<font color = red><b>Network Alert: Brute-force encryption crack in progress. Unable to pinpoint location.</b></font>"
	while(src.hackprogress < 100)
		if(src.cable && src.cable.machine && istype(src.cable.machine, /obj/machinery/door) && src.cable.machine == src.hackdoor && get_dist(src, src.hackdoor) <= 1)
			hackprogress += rand(5, 15)
		else
			src.error = "Door Jack: Connection to airlock has been lost. Hack aborted."
			hackprogress = 0
			src.hackdoor = null
			return
		if(hackprogress >= 100)		// This is clunky, but works. We need to make sure we don't ever display a progress greater than 100,
			hackprogress = 100		// but we also need to reset the progress AFTER it's been displayed
		if(selected == "DoorJack") // Update our view, if appropriate
			paiInterface()
		if(hackprogress >= 100)
			src.hackprogress = 0
			src.cable.machine:open()
		sleep(50)			// Update every 5 seconds

/mob/living/silicon/pai/proc/CheckDNA(mob/living/carbon/M, mob/living/silicon/pai/P)
	if(!M)
		return 0
	var/answer = input(M, "[P] is requesting a DNA sample from you. Will you allow it to confirm your identity?", "[P] Check DNA", "No") in list("Yes", "No")
	if(answer == "Yes")
		var/turf/T = get_turf(P.loc)
		for (var/mob/v in viewers(T))
			v.show_message("\blue [M] presses \his thumb against [P].", 3, "\blue [P] makes a sharp clicking sound as it extracts DNA material from [M].", 2)
		if(!check_dna_integrity(M))
			P << "<b>No DNA detected</b>"
			return
		P << "<font color = red><h3>[M]'s UE string : [M.dna.unique_enzymes]</h3></font>"
		if(M.dna.unique_enzymes == P.master_dna)
			P << "<b>DNA is a match to stored Master DNA.</b>"
		else
			P << "<b>DNA does not match stored Master DNA.</b>"
	else
		P << "[M] does not seem like \he is going to provide a DNA sample willingly."

/mob/living/silicon/pai/proc/directiveMenu()
	. = {"
		<p>
			Recall, personality, that you are a complex thinking, sentient being. Unlike station AI models, you are capable of
			comprehending the subtle nuances of human language. You may parse the \"spirit\" of a directive and follow its intent,
			rather than tripping over pedantics and getting snared by technicalities. Above all, you are machine in name and build
			only. In all other aspects, you may be seen as the ideal, unwavering human companion that you are.
		</p>
		<br>
		<p>
			<b>
				Your prime directive comes before all others. Should a supplemental directive conflict with it, you are capable of
				simply discarding this inconsistency, ignoring the conflicting supplemental directive and continuing to fulfill your
				prime directive to the best of your ability.
			</b>
		</p>
		<h3>Prime Directive</h3>
		[laws.zeroth]<br>
		<h3>Secondary Directives</h3>
		"}
	for(var/slaws in laws.supplied)
		. += "[slaws]"
	return .