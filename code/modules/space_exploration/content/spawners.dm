// All spawner variables are prefixed with "_" so the variables appear at the top of the instance editor.

/obj/effect/spawner/space
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
			_loot = list(/obj/item/weapon/stock_parts/cell, /obj/item/weapon/stock_parts/cell/crap, /obj/item/weapon/stock_parts/cell/high)

		rare_battery/
			name = "rare battery spawner"
			_loot = list(/obj/item/weapon/stock_parts/cell/hyper, /obj/item/weapon/stock_parts/cell/super, /obj/item/weapon/stock_parts/cell/fusion)

		cash/
			name = "cash spawner"
			_loot = list(/obj/item/weapon/spacecash, /obj/item/weapon/spacecash/c10, /obj/item/weapon/spacecash/c100, /obj/item/weapon/spacecash/c1000,
					 /obj/item/weapon/spacecash/c20, /obj/item/weapon/spacecash/c200, /obj/item/weapon/spacecash/c50, /obj/item/weapon/spacecash/c500)

		capacitors/
			name = "capacitor spawner"
			_loot = list(/obj/item/weapon/stock_parts/capacitor, /obj/item/weapon/stock_parts/capacitor/adv, /obj/item/weapon/stock_parts/capacitor/super)

		manipulator/
			name = "manipulator spawner"
			_loot = list(/obj/item/weapon/stock_parts/manipulator, /obj/item/weapon/stock_parts/manipulator/nano, /obj/item/weapon/stock_parts/manipulator/pico)

		matter_bin/
			name = "matter bin spawner"
			_loot = list(/obj/item/weapon/stock_parts/matter_bin, /obj/item/weapon/stock_parts/matter_bin/adv, /obj/item/weapon/stock_parts/matter_bin/super)

		micro_laser/
			name = "micro laser spawner"
			_loot = list(/obj/item/weapon/stock_parts/micro_laser, /obj/item/weapon/stock_parts/micro_laser/high, /obj/item/weapon/stock_parts/micro_laser/ultra)

		scanning_module/
			name = "scanning module spawner"
			_loot = list(/obj/item/weapon/stock_parts/scanning_module, /obj/item/weapon/stock_parts/scanning_module/adv, /obj/item/weapon/stock_parts/scanning_module/phasic)

		subspace_part/
			name = "subspace part spawner"
			_loot = list(/obj/item/weapon/stock_parts/subspace/amplifier, /obj/item/weapon/stock_parts/subspace/analyzer, /obj/item/weapon/stock_parts/subspace/ansible,
						/obj/item/weapon/stock_parts/subspace/crystal, /obj/item/weapon/stock_parts/subspace/filter, /obj/item/weapon/stock_parts/subspace/transmitter,
						/obj/item/weapon/stock_parts/subspace/treatment)

		energy_weapon/
			name = "energy weapon spawner"
			_loot = list(/obj/item/weapon/gun/energy/gun, /obj/item/weapon/gun/energy/disabler, /obj/item/weapon/gun/energy/laser, /obj/item/weapon/gun/energy/taser,
							/obj/item/weapon/gun/energy/stunrevolver)

		rare_energy_weapon/
			name = "rare energy weapon spawner"
			_loot = list(/obj/item/weapon/gun/energy/xray, /obj/item/weapon/gun/energy/lasercannon, /obj/item/weapon/gun/energy/temperature, /obj/item/weapon/gun/energy/ionrifle)


	// The set spawner will spawn sets of items (e.g. the master will pick an item and the slaves will spawn the corresponding item)
	set_spawner/
		name = "set spawner slave"
		icon_state = "set_slave"

		var/_id

		master/
			name = "set spawner master"
			icon_state = "set_master"

			projectile_weapon/
				name = "projectile weapon set spawner master"
				_loot = list(/obj/item/weapon/gun/projectile/revolver/detective, /obj/item/weapon/gun/projectile/revolver/doublebarrel,
							/obj/item/weapon/gun/projectile/shotgun/sc_pump)

			rare_projectile_weapon/
				name = "rare projectile weapon set spawner master"
				_loot = list(/obj/item/weapon/gun/projectile/revolver, /obj/item/weapon/gun/projectile/revolver/mateba, /obj/item/weapon/gun/projectile/shotgun,
							/obj/item/weapon/gun/projectile/shotgun/combat, /obj/item/weapon/gun/projectile/automatic/mini_uzi, /obj/item/weapon/gun/projectile/automatic/deagle)

			Spawn()
				var/list/slaves = list()
				for(var/obj/effect/spawner/space/set_spawner/spawner in world)
					if(istype(spawner, /obj/effect/spawner/space/set_spawner/master))
						continue

					if(spawner._id && spawner._id == _id)
						slaves += spawner

				var/index = rand(1, length(_loot))

				for(var/i = 0; _spawn_amount > i; i++)
					var/path = _loot[index]
					new path(get_turf(src))

				for(var/obj/effect/spawner/space/set_spawner/slave/slave in slaves)
					if(length(slave._loot) < index)
						log_game("Set Slave with ID '[slave._id]' does not have sufficient loot configured.")
						continue

					for(var/i = 0; slave._spawn_amount > i; i++)
						var/path = slave._loot[index]
						new path(get_turf(slave))

					qdel(slave)
		slave/
			_delete_after_spawn = 0

			projectile_weapon/
				name = "projectile weapon set spawner slave"
				_loot = list(/obj/item/ammo_box/c38, /obj/item/ammo_casing/shotgun/beanbag, /obj/item/ammo_casing/shotgun/beanbag)

			rare_projectile_weapon/
				name = "rare projectile weapon set spawner slave"
				_loot = list(/obj/item/ammo_box/a357, /obj/item/ammo_box/a357, /obj/item/ammo_casing/shotgun/buckshot, /obj/item/ammo_casing/shotgun/buckshot,
							/obj/item/ammo_box/magazine/uzim45, /obj/item/ammo_box/magazine/m50)


