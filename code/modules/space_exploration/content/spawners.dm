// All spawner variables are prefixed with "_" so the variables appear at the top of the instance editor.

/obj/effect/spawner/space_exploration
	name = "spawner"
	icon = 'icons/effects/spawners.dmi'
	icon_state = "undefined"
	invisibility = 101

	var/list/_loot = list()
	var/_delete_after_spawn = 1
	var/_spawn_amount = 1
	var/_allow_duplicates = 0

	New()
		..()

		spawn(10)
			Spawn()

			if(_delete_after_spawn)
				qdel(src)

	proc/Spawn()
		return 0

	basic/
		name = "basic spawner"
		icon_state = "basic"

		Spawn()
			_spawn_amount = min(_spawn_amount, length(_loot))

			for(var/i = 0; _spawn_amount > i; i++)
				var/picked = pick(_loot)
				if(!ispath(picked))
					picked = text2path(picked)

				new picked(get_turf(src))
				if(!_allow_duplicates)
					_loot -= picked

		grenades/
			name = "grenade spawner"
			_loot = list(/obj/item/weapon/grenade/empgrenade, /obj/item/weapon/grenade/flashbang, /obj/item/weapon/grenade/smokebomb,
					/obj/item/weapon/grenade/flashbang/clusterbang)

		tool/
			name = "tool spawner"
			_loot = list(/obj/item/weapon/screwdriver, /obj/item/weapon/wrench, /obj/item/weapon/weldingtool, /obj/item/weapon/crowbar, /obj/item/weapon/wirecutters)

		makeshift_weapon/
			name = "makeshift weapon spawner"
			_loot = list(/obj/item/weapon/melee/baton/cattleprod, /obj/item/weapon/twohanded/spear)

		battery/
			name = "battery spawner"
			_loot = list(/obj/item/weapon/stock_parts/cell, /obj/item/weapon/stock_parts/cell/crap, /obj/item/weapon/stock_parts/cell/high,
						/obj/item/weapon/stock_parts/cell/hyper, /obj/item/weapon/stock_parts/cell/super)

		cash/
			name = "cash spawner"
			_loot = list(/obj/item/weapon/spacecash, /obj/item/weapon/spacecash/c10, /obj/item/weapon/spacecash/c100, /obj/item/weapon/spacecash/c1000,
					 /obj/item/weapon/spacecash/c20, /obj/item/weapon/spacecash/c200, /obj/item/weapon/spacecash/c50, /obj/item/weapon/spacecash/c500)


	// The set spawner will spawn sets of items (e.g. the master will pick an item and the slaves will spawn the corresponding item)
	spawner_set/
		name = "set spawner slave"
		icon_state = "set_slave"

		var/_id

		master/
			name = "set spawner master"
			icon_state = "set_master"

			Spawn()
				var/list/slaves = list()
				for(var/obj/effect/spawner/space_exploration/spawner_set/spawner in world)
					if(istype(spawner, /obj/effect/spawner/space_exploration/spawner_set/master))
						continue

					if(spawner._id && spawner._id == _id)
						slaves += spawner

				var/index = rand(1, length(_loot))

				for(var/obj/effect/spawner/space_exploration/spawner_set/slave in slaves)
					if(length(slave._loot) < index)
						log_game("Set Slave with ID '[slave._id]' does not have sufficient loot configured.")
						continue

					for(var/i = 0; slave._spawn_amount > i; i++)
						var/path = slave._loot[index]
						new path(get_turf(slave))
