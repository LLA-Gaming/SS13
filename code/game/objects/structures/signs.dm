/obj/structure/sign
	icon = 'icons/obj/decals.dmi'
	anchored = 1
	opacity = 0
	density = 0
	layer = 3.5

/obj/structure/sign/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			qdel(src)
			return
		else
	return


/obj/structure/sign/blob_act()
	qdel(src)
	return


/obj/structure/sign/map
	name = "station map"
	desc = "A framed picture of the station."

/obj/structure/sign/map/left
	icon_state = "map-left"

/obj/structure/sign/map/right
	icon_state = "map-right"

/obj/structure/sign/securearea
	name = "\improper SECURE AREA"
	desc = "A warning sign which reads 'SECURE AREA'."
	icon_state = "securearea"

/obj/structure/sign/biohazard
	name = "\improper BIOHAZARD"
	desc = "A warning sign which reads 'BIOHAZARD'"
	icon_state = "bio"

/obj/structure/sign/electricshock
	name = "\improper HIGH VOLTAGE"
	desc = "A warning sign which reads 'HIGH VOLTAGE'"
	icon_state = "shock"

/obj/structure/sign/examroom
	name = "\improper EXAM ROOM"
	desc = "A guidance sign which reads 'EXAM ROOM'"
	icon_state = "examroom"

/obj/structure/sign/vacuum
	name = "\improper HARD VACUUM AHEAD"
	desc = "A warning sign which reads 'HARD VACUUM AHEAD'"
	icon_state = "space"

/obj/structure/sign/deathsposal
	name = "\improper DISPOSAL: LEADS TO SPACE"
	desc = "A warning sign which reads 'DISPOSAL: LEADS TO SPACE'"
	icon_state = "deathsposal"

/obj/structure/sign/pods
	name = "\improper ESCAPE PODS"
	desc = "A warning sign which reads 'ESCAPE PODS'"
	icon_state = "pods"

/obj/structure/sign/fire
	name = "\improper DANGER: FIRE"
	desc = "A warning sign which reads 'DANGER: FIRE'"
	icon_state = "fire"


/obj/structure/sign/nosmoking_1
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'"
	icon_state = "nosmoking"


/obj/structure/sign/nosmoking_2
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'"
	icon_state = "nosmoking2"

/obj/structure/sign/bluecross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here.'"
	icon_state = "bluecross"

/obj/structure/sign/bluecross_2
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here.'"
	icon_state = "bluecross2"

/obj/structure/sign/goldenplaque
	name = "The Most Robust Men Award for Robustness"
	desc = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	icon_state = "goldenplaque"

/obj/structure/sign/kiddieplaque
	name = "AI developers plaque"
	desc = "Next to the extremely long list of names and job titles, there is a drawing of a little child. The child appears to be retarded. Beneath the image, someone has scratched the word \"PACKETS\""
	icon_state = "kiddieplaque"

/obj/structure/sign/atmosplaque
	name = "\improper FEA Atmospherics Division plaque"
	desc = "This plaque commemorates the fall of the Atmos FEA division. For all the charred, dizzy, and brittle men who have died in its hands."
	icon_state = "atmosplaque"

/obj/structure/sign/maltesefalcon	//The sign is 64x32, so it needs two tiles. ;3
	name = "The Maltese Falcon"
	desc = "The Maltese Falcon, Space Bar and Grill."

/obj/structure/sign/bar/left
	req_access = list(access_bar)
	icon_state = "maltesefalcon-left"
	var/obj/structure/sign/bar/right/linked

	New()
		..()
		spawn(5)
			linked = locate() in get_step(get_turf(src), EAST)

			if(!linked)
				qdel(src)

	update_icon()
		if(!linked)
			return 0

		linked.icon_state = "[icon_state]-right"
		icon_state = "[icon_state]-left"

	attack_hand(var/mob/living/M)
		if(!src.allowed(M))
			M << "<span class='warning'>Access denied.</span>"
			return 0

		var/list/possible_signs = list("Maltese Falcon" = "maltesefalcon", "Plasma Fire" = "plasmafire", "Winking Corgi" = "winkingcorgi", "Hole in The Hull" = "holeinthehull")
		var/selected = input("Select a new bar sign design", "Input") in possible_signs + "Cancel"
		if(!selected || selected == "Cancel")
			return 0

		icon_state = possible_signs[selected]

		update_icon()

/obj/structure/sign/bar/right
	icon_state = "maltesefalcon-right"

/obj/structure/sign/science			//These 3 have multiple types, just var-edit the icon_state to whatever one you want on the map
	name = "\improper SCIENCE!"
	desc = "A warning sign which reads 'SCIENCE!'"
	icon_state = "science1"

/obj/structure/sign/chemistry
	name = "\improper CHEMISTRY"
	desc = "A warning sign which reads 'CHEMISTRY'"
	icon_state = "chemistry1"

/obj/structure/sign/botany
	name = "\improper HYDROPONICS"
	desc = "A warning sign which reads 'HYDROPONICS'"
	icon_state = "hydro1"

/obj/structure/sign/clown
	name = "\improper Honk! Poster"
	desc = "A poster about Clowns. Honk."
	icon_state = "clown"

/obj/structure/sign/mime
	name = "\improper Mime poster"
	desc = "A poster about the silencious but strong."
	icon_state = "mime"

/obj/structure/sign/ambrosia
	name = "\improper Ambrosia poster"
	desc = "Just a reminder of the only thing you love"
	icon_state = "ambrosia"

/obj/structure/sign/burtlancaster
	name = "\improper Portrait of Burt Lancaster"
	desc = "This is a portrait of Burt Lancaster.  He's never actually been here.  It looks very nice."
	icon_state = "burt"

//direction signs
/obj/structure/sign/directional
	name = "\improper direction sign"
	desc = "This sign tells you where to go"

/obj/structure/sign/directional/bridge
	name = "\improper bridge"
	desc = "The bridge is located here"
	icon_state = "direction_bridge"

/obj/structure/sign/directional/eng
	name = "\improper engineering"
	desc = "Engineering is located here"
	icon_state = "direction_eng"

/obj/structure/sign/directional/supply
	name = "\improper supply"
	desc = "Supply is located here"
	icon_state = "direction_supply"

/obj/structure/sign/directional/sci
	name = "\improper science"
	desc = "Science is located here"
	icon_state = "direction_sci"

/obj/structure/sign/directional/sec
	name = "\improper security"
	desc = "Security is located here"
	icon_state = "direction_sec"

/obj/structure/sign/directional/med
	name = "\improper medical"
	desc = "The medbay is located here"
	icon_state = "direction_med"

/obj/structure/sign/directional/evac
	name = "\improper evacuation"
	desc = "The escape hallway is located here"
	icon_state = "direction_evac"