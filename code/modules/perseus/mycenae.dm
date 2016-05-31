/*
* All ship related stuff goes here.
*/

/datum/configuration/var/mycenae_starts_at_centcom = 0

/area/security/perseus/mycenaeiii
	name = "Perseus Ship: The Mycenae"
	icon_state = "perseus"
	dynamic_lighting = 0
	requires_power = 0
	has_gravity = 1
	power_equip = 1

	New()
		..()
		spawn(5)
			power_equip = 1
/*
* Decal Nameplate
*/

/obj/decoration/sign/mycenae
	desc = "The name plate of the ship.'"
	name = "Mycenae"
	icon = 'icons/obj/decals.dmi'
	icon_state = "perc1"
	anchored = 1.0
	opacity = 0
	density = 0

/*
* Enforcer Locker
*/

/obj/structure/closet/secure_closet/enforcer
	name = "Perseus Enforcer Equipment"
	req_access = list(access_penforcer)
	icon_state = "enforcer_locked"
	icon_closed = "enforcer"
	icon_locked = "enforcer_locked"
	icon_opened = "enforcer_opened"
	icon_broken = "enforcer_broken"
	icon_off = "enforcer_off"

	New()
		..()
		new /obj/item/clothing/shoes/combat(src)
		new /obj/item/clothing/suit/armor/lightarmor(src)
		new /obj/item/clothing/head/helmet/space/pershelmet(src)
		new /obj/item/clothing/mask/gas/voice/perseus_voice(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/weapon/storage/box/flashbangs(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/handcuffs(src)
		new /obj/item/weapon/shield/riot/perc(src)
		new /obj/item/weapon/gun/energy/ep90(src)
		new /obj/item/weapon/stun_knife(src)
		new /obj/item/weapon/stock_parts/cell/magazine/ep90(src)


/*
* Commander Locker
*/

/obj/structure/closet/secure_closet/commander
	name = "Perseus Commander Equipment"
	req_access = list(access_pcommander)
	icon_state = "commander_locked"
	icon_closed = "commander"
	icon_locked = "commander_locked"
	icon_opened = "commander_opened"
	icon_broken = "commander_broken"
	icon_off = "commander_off"

	New()
		..()
		new /obj/item/clothing/under/perseus_fatigues(src)
		new /obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey(src)
		new /obj/item/clothing/head/helmet/space/persberet(src)
		new /obj/item/clothing/shoes/combat(src)
		new /obj/item/clothing/under/space/skinsuit(src)
		new /obj/item/clothing/suit/armor/lightarmor(src)
		new /obj/item/clothing/mask/gas/voice/perseus_voice(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/ammo_box/magazine/fiveseven(src)
		new /obj/item/weapon/storage/box/flashbangs(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/handcuffs(src)
		new /obj/item/weapon/shield/riot/perc(src)
		new /obj/item/weapon/gun/energy/ep90(src)
		new /obj/item/weapon/gun/projectile/automatic/fiveseven(src)
		new /obj/item/weapon/stun_knife(src)
		return

/*
* Mixed Locker
*/

/obj/structure/closet/perseus/mixed
	name = "Mixed Closet"

	New()
		..()
		new /obj/item/clothing/suit/blackjacket(src)
		new /obj/item/clothing/suit/blackjacket(src)
		new /obj/item/clothing/suit/blackjacket(src)
		new /obj/item/clothing/suit/blackjacket(src)
		new /obj/item/clothing/suit/blackjacket(src)
		new /obj/item/clothing/suit/blackjacket(src)
		new /obj/item/clothing/suit/wintercoat/perseus(src)
		new /obj/item/clothing/suit/wintercoat/perseus(src)
		new /obj/item/clothing/suit/wintercoat/perseus(src)
		new /obj/item/clothing/suit/wintercoat/perseus(src)
		new /obj/item/clothing/suit/wintercoat/perseus(src)
		new /obj/item/clothing/suit/wintercoat/perseus(src)
		new /obj/item/weapon/storage/backpack/blackpack(src)
		new /obj/item/weapon/storage/backpack/blackpack(src)
		new /obj/item/weapon/storage/backpack/blackpack(src)
		new /obj/item/weapon/storage/backpack/blackpack(src)
		new /obj/item/weapon/storage/backpack/blackpack(src)
		new /obj/item/weapon/storage/backpack/blackpack(src)
		new /obj/item/clothing/under/perseus_uniform(src)
		new /obj/item/clothing/under/perseus_uniform(src)
		new /obj/item/clothing/under/perseus_uniform(src)
		new /obj/item/clothing/under/perseus_uniform(src)
		new /obj/item/clothing/under/perseus_uniform(src)
		new /obj/item/clothing/under/perseus_uniform(src)

/*
* Barrier
*/

/obj/machinery/deployable/barrier/perseus
	name = "PercTech Deployable Barrier"
	desc = "A PercTech deployable barrier. Swipe your Dogtags to lock/unlock it."
	icon_state = "barrier0"

	req_access = list(access_penforcer)

/*
* Evidence Locker
*/

/obj/structure/closet/secure_closet/p_evidence
	name = "PercTech Evidence Locker"
	desc = "A wall mounted locker."
	icon_state = "p_wall_closet_locked"
	icon_opened = "p_wall_closet_open"
	icon_off = "p_wall_closet_off"
	icon_broken = "p_wall_closet_broken"
	icon_closed = "p_wall_closet"
	icon_locked = "p_wall_closet_locked"
	wall_mounted = 1
	req_access = list(access_penforcer)
	large = 0

/*
* Perseus Armory Wall-Locker
*/

/obj/structure/closet/secure_closet/p_armory
	name = "perseus armory locker"
	desc = "A wall mounted locker."
	icon_state = "p_armory_wall_closet_locked"
	icon_opened = "p_armory_wall_closet_open"
	icon_off = "p_armory_wall_closet_off"
	icon_broken = "p_armor_wall_closet_broken"
	icon_closed = "p_armory_wall_closet"
	icon_locked = "p_armory_wall_closet_locked"
	wall_mounted = 1
	req_access = list(access_pcommander)
	large = 0

/*
* Mycenae Moving
*/

/area/security/perseus/mycenae_centcom
	name = "Mycenae Centcom Position"
	icon_state = "perseus_centcom"
	dynamic_lighting = 0
	requires_power = 0
	has_gravity = 1

var/mycenae_at_centcom = 1

/proc/move_mycenae()
	if(mycenae_at_centcom)
		mycenae_at_centcom = 0
		var/area/start_location = locate(/area/security/perseus/mycenae_centcom)
		var/area/normal_location = locate(/area/security/perseus/mycenaeiii)
		spawn(5)
			start_location.move_contents_to(normal_location)
			spawn(5)
				for(var/obj/machinery/telecomms/relay/preset/mining/M in world)
					if(M.id == "Perseus Relay")
						M.listening_level = 3

/*
* Prison Shuttle
*/

/area/shuttle/prison/station
	name = "Prison Shuttle"
	icon_state = "shuttle"
	has_gravity = 1

/area/shuttle/prison/prison
	name = "Prison Shuttle"
	icon_state = "shuttle2"
	has_gravity = 1

var/perseusShuttleAtMycenae = 0
var/perseusShuttleMoving = 0

#define PERSEUS_SHUTTLE_MYCENAE_AREA /area/shuttle/prison/prison
#define PERSEUS_SHUTTLE_STATION_AREA /area/shuttle/prison/station

/obj/machinery/computer/perseus_shuttle_computer
	name = "Prison Shuttle Console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	req_one_access = list(access_security,access_penforcer,access_pcommander)

	var/locked = 1
	var/tempData = ""
	var/perseus_type = 0

	attackby(I as obj, user as mob)
		if(istype(I, /obj/item/weapon/card/emag))
			emagged = 1
			user << "<div class='notice'>You emag the [src].</div>"
			var/datum/effect/effect/system/spark_spread/system = new()
			system.set_up(3, 0, get_turf(src))
			system.start()
			return
		src.attack_hand(user)
		return

	attack_ai(var/mob/user as mob)
		src.attack_hand(user)
		return

	attack_paw(var/mob/user as mob)
		src.attack_hand(user)
		return

	attack_hand(var/mob/user as mob)
		if(!src.allowed(user) && !emagged)
			user << "\red Access Denied."
			return
		if(!emagged)
			if(locked && !perseus_type)
				user << "\red It's locked!"
				return
		user.set_machine(src)
		var/dat
		if(tempData)
			dat = tempData
		else
			dat += "Location: [perseusShuttleMoving ? "Moving" : perseusShuttleAtMycenae ? "Mycenae III" : "Station"]<hr>"
			dat += "<a href='byond://?src=\ref[src];send=1'>Send to [perseusShuttleAtMycenae ? "Station" : "Mycenae"]</a><br><br>"
			if(perseus_type)
				var/s_locked = 0
				for(var/obj/machinery/computer/perseus_shuttle_computer/P in world)
					if(P.perseus_type)	continue
					if(P.locked)
						s_locked = 1
				if(s_locked)
					dat += "<a href='byond://?src=\ref[src];unlock=1'>Unlock</a>"
				else
					dat += "<a href='byond://?src=\ref[src];lock=1'>Lock</a>"
		var/datum/browser/popup = new(usr, "percshuttle", "Prison Shuttle", 575, 450)
		popup.set_content(dat)
		popup.open()

	proc/moveShuttle()
		if(perseusShuttleMoving)
			return
		perseusShuttleMoving = 1

		tempData = "Moving..."

		var/area/mycenae = locate(PERSEUS_SHUTTLE_MYCENAE_AREA)
		var/area/station = locate(PERSEUS_SHUTTLE_STATION_AREA)

		if(!mycenae || !station)
			return

		sleep(70)

		if(perseusShuttleAtMycenae)
			mycenae.move_contents_to(station)
			perseusShuttleAtMycenae = 0
		else
			station.move_contents_to(mycenae)
			perseusShuttleAtMycenae = 1

		tempData = ""
		perseusShuttleMoving = 0

	Topic(href, href_list)
		if(..())	return
		if(href_list["send"])
			moveShuttle()
		if(href_list["lock"])
			for(var/obj/machinery/computer/perseus_shuttle_computer/P in world)
				if(P.perseus_type)	continue
				P.locked = 1
		if(href_list["unlock"])
			for(var/obj/machinery/computer/perseus_shuttle_computer/P in world)
				if(P.perseus_type)	continue
				P.locked = 0
		attack_hand(usr)

/proc/toggle_prison_shuttle_lock()
	for(var/obj/machinery/computer/perseus_shuttle_computer/P in world)
		if(!P.perseus_type)
			P.locked = !P.locked
