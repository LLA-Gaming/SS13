/obj/effect/blob/shield
	name = "strong blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_idle"
	desc = "Some blob creature thingy"
	health = 75
	fire_resist = 2

	New()
		var/turf/simulated/S = get_turf(src)
		if(S)
			S.blocks_air = 1
			S.thermal_conductivity = 0
		air_update_turf(1)
		..()

	Destroy()
		var/turf/simulated/S = get_turf(src)
		if(S)
			S.blocks_air = 0
			S.thermal_conductivity = initial(S.thermal_conductivity)
		air_update_turf(1)
		..()

/obj/effect/blob/shield/update_icon()
	if(health <= 0)
		qdel(src)
		return
	return

/obj/effect/blob/shield/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return

/obj/effect/blob/shield/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSBLOB))	return 1
	return 0
