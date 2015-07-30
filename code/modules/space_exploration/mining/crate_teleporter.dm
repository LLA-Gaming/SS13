/obj/item/device/crate_teleporter
	name = "crate teleporter"
	desc = "Set the destination, and teleport crates."
	icon_state = "crate_teleporter"
	w_class = 2
	m_amt = 2000
	origin_tech = "bluesppace=2;engineering=2"
	var/obj/item/device/crate_tp_pad/destination = 0
	var/charges = 5
	var/recharge_cooldown = 100
	var/last_recharge = 0
	var/last_teleport = 0
	var/teleport_cooldown = 75
	var/teleporting = 0

	examine()
		..()
		usr << "<span class='info'>Charges: [charges]</span>"

	New()
		..()
		processing_objects.Add(src)

	process()
		if(world.time >= (last_recharge + recharge_cooldown))
			if(charges >= initial(charges))
				return 0
			charges++
			last_recharge = world.time

	proc/Teleport(var/obj/structure/closet/crate/crate)
		if(!destination)
			return 0

		if(!crate)
			return 0

		if(crate.z == 2 || destination.z == 2)
			return 0

		crate.loc = get_turf(destination)

		var/datum/effect/effect/system/spark_spread/sparks = new()
		sparks.set_up(5, 0, get_turf(src))
		sparks.start()

		sparks.set_up(5, 0, get_turf(destination))
		sparks.start()

		playsound(get_turf(src), 'sound/effects/phasein.ogg', 100)
		playsound(get_turf(destination), 'sound/effects/phasein.ogg', 100)

		return 1

	afterattack(var/atom/A, var/mob/living/user)
		if(istype(A, /obj/structure/closet/crate))
			var/obj/structure/closet/crate/crate = A

			if(teleporting)
				user << "<span class='warning'>The [src] is already teleporting a crate.</span>"
				return 0

			if(world.time < (last_teleport + teleport_cooldown))
				user << "<span class='warning'>The [src] is still cooling down..</span>"
				return 0

			if(!destination)
				user << "<span class='warning'>No destinaton is set.</span>"
				return 0

			if(destination.IsOccupied())
				user << "<span class='warning'>The destination is occupied.</span>"
				return 0

			teleporting = 1
			user << "<span class='info'>Initiating teleport...</span>"
			if(do_after(user, 50))
				if(get_dist(user, crate) > 1)
					teleporting = 0
					return 0

				teleporting = 0

				var/result = Teleport(crate)
				if(!result)
					user << "<span class='warning'>Teleport failed.</span>"
				else
					user << "<span class='info'>Teleport succesful.</span>"
					charges--
					last_teleport = world.time
			else
				teleporting = 0

		return 0

	attack_self(var/mob/living/user)
		var/list/destinations = list()

		for(var/obj/item/device/crate_tp_pad/pad in crate_teleporter_pads)
			if(!pad.id)
				continue

			destinations[pad.id] = pad

		var/selected_id = input("Select destination", "Input") in destinations + "Cancel"
		if(!selected_id || selected_id == "Cancel")
			return 0

		var/obj/item/device/crate_tp_pad/pad
		for(var/obj/item/device/crate_tp_pad/_pad in crate_teleporter_pads)
			if(_pad.id == selected_id)
				pad = _pad

		if(pad)
			destination = pad
			user << "<span class='info'>New destination set to '[pad.id]'</span>"
		else
			user << "<span class='warning'>Unable to locate pad.</span>"

/*
* Teleport Pad
*/

var/list/crate_teleporter_pads = list()

/obj/item/device/crate_tp_pad
	name = "crate teleporter linkage pad"
	desc = "A destination for crate teleporters."
	icon_state = "crate_tp_pad"
	anchored = 1
	var/id = 0 // Should be a string to identify, not a number

	examine()
		..()
		usr << "<span class='info'>Current ID is '[id ? id : "undefined"]'</span>"

	proc/IsAvailable()
		var/area/A = get_area(src)
		return A.use_power(100, EQUIP) && id && anchored && istype(loc, /turf)

	proc/IsOccupied()
		return (locate(/obj/structure/closet/crate) in get_turf(src))

	attack_hand(var/mob/living/user)
		if(!anchored)
			..(user)
		else
			return 0

	attackby(var/obj/item/I, var/mob/living/user)
		if(istype(get_turf(src), /turf/space))
			return 0

		if(istype(I, /obj/item/weapon/wrench) && istype(loc, /turf))
			user << "<span class='info'>You start to [anchored ? "detach" : "attach"] the [src] to the [get_turf(src)].</span>"
			if(do_after(user, 20))
				anchored = !anchored
				user << "<span class='info'>You [anchored ? "attach" : "detach"] the [src] from the [get_turf(src)].</span>"

	proc/CheckDuplication(var/id)
		for(var/obj/item/device/crate_tp_pad/pad in crate_teleporter_pads)
			if(pad.id == id)
				return 0

		return 1

	attack_self(var/mob/living/user)
		var/max_length = 32

		var/new_id = input("Please enter a new ID. Enter nothing to cancel. Maximum length is [max_length]", "Input") as text
		new_id = copytext(sanitize(trim(new_id)), 1, max_length)

		if(!CheckDuplication(new_id))
			user << "<span class='warning'>That ID is already being used.</span>"
			return 0
		if(!new_id)
			return 0

		id = new_id
		user << "<span class='info'>You change the ID to '[new_id]'.</span>"

	New()
		..()
		crate_teleporter_pads += src

