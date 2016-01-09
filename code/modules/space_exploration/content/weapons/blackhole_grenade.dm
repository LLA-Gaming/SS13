/obj/item/weapon/grenade/blackhole
	name = "black hole grenade"
	desc = "A piece of modern technology. It contains a miniturized singularity generator."
	icon_state = "blackhole"
	origin_tech = "materials=4;combat=3;bluespace=3"
	var/range = 3

	prime()
		update_mob()

		var/turf/location = get_turf(src)
		var/obj/effect/effect = new(location)
		effect.icon = 'icons/effects/effects.dmi'
		effect.icon_state = "bhole3"
		effect.transform *= 3

		// Badmin prevention
		range = Clamp(range, 1, 7)

		var/list/ranges = list()
		for(var/i = 1; i <= range, i++)
			ranges += i

		var/has_pulled = 0
		var/delete = 0

		pulling:
			for(var/i in ranges)
				var/list/turfs = circlerange(location, i)
				if(i > 1) // Only want one "layer" at a time.
					turfs ^= circlerange(location, i - 1)

				for(var/turf/T in turfs)
					for(var/atom/movable/M in T)
						if(delete)
							if(i <= round(range/2))
								if(!istype(M, /mob/living))
									qdel(M)
								else
									M:gib()

						if(!istype(M, /mob/dead/observer))
							step(M, get_dir(M, location))

					if(delete)
						qdel(T)

				sleep(4)

		ranges = list()
		for(var/i = range; i > 0; i--)
			ranges += i

		if(!has_pulled)
			delete = 1
			has_pulled = 1
			goto pulling

		if(effect)
			qdel(effect)

		qdel(src)
