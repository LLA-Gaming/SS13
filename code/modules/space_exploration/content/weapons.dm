/turf/proc/AllAdjacentTurfs()
	var/list/turfs = list()
	for(var/turf/T in orange(src, 1))
		turfs += T
	return turfs

/obj/item/ammo_casing/energy/beam
	name = "beam weapon lens"
	select_name = "beam"
	e_cost = 2500
	fire_sound = 'sound/weapons/emr7.wav'
	var/beam_icon_state = "emr7"
	var/beam_duration = 3.0
	var/beam_max_length = 20
	var/damage = 20
	var/damage_type = BURN
	var/cooldown = 20
	var/last_fired = 0

	fire(atom/target as mob|obj|turf, mob/living/user as mob|obj, params, var/distro, var/quiet)
		if((last_fired + cooldown) > world.time)
			user << "<span class='warning'>\The [src] is still cooling down.</span>"
			return 0

		BB = null

		var/turf/target_location = get_turf(target)
		var/turf/start_location = get_step(get_turf(user), get_dir(get_turf(user), target_location))

		// Don't want to (mostly) cross over dense turfs (e.g. walls)
		var/list/path = AStar(start_location, target_location, /turf/proc/AllAdjacentTurfs, /turf/proc/Distance)
		for(var/turf/T in path)
			if(T.density)
				var/index = path.Find(T)
				path.Cut(index)

		listclearnulls(path)

		target_location = path[length(path)]

		spawn(1)
			var/list/created_overlays = start_location.Beam(target_location, beam_icon_state, 'icons/obj/projectiles.dmi', beam_duration, beam_max_length, 0)

			var/list/affected_turfs = list()
			for(var/obj/effect/overlay/beam/B in created_overlays)
				var/turf/T = get_turf(B)
				var/px = B.pixel_x
				var/py = B.pixel_y

				while(px > 0)
					T = get_step(T, EAST)
					px -= 32

				while(px < 0)
					T = get_step(T, WEST)
					px += 32

				while(py > 0)
					T = get_step(T, NORTH)
					py -= 32

				while(py < 0)
					T = get_step(T, SOUTH)
					py += 32

				affected_turfs += T

			if(!affected_turfs.Find(target_location))
				affected_turfs += target_location

			for(var/turf/T in affected_turfs)
				for(var/mob/living/L in T)
					L.apply_damage(damage, damage_type)
					T.visible_message("<span class='danger'>[L] is hit by the beam!</span>")
					add_logs(user, L, "shot", object="[src]", addition=" (DAMAGE: [damage]) (REMHP: [(L.health - src.damage)]) (BEAM)")

		last_fired = world.time

		user.changeNext_move(8)
		update_icon()

		return 1

/obj/item/weapon/gun/energy/beam
	name = "beam weapon"
	desc = "A futuristic looking weapon that fires beams of energy."
	icon_state = "freezegun"
	ammo_type = list(/obj/item/ammo_casing/energy/beam)
	cell_type = /obj/item/weapon/stock_parts/cell/super

	shoot_with_empty_chamber(var/mob/living/user)
		if(istype(chambered, /obj/item/ammo_casing/energy/beam))
			var/obj/item/ammo_casing/energy/beam/B = chambered
			if((B.last_fired + B.cooldown) > world.time)
				return 0

		..()

	emr7/
		name = "prototype EMR-7"
		icon_state = "emr"
		item_state = "emr"
