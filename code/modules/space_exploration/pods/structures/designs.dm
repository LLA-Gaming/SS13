/datum/design

	/*
	* Weapons
	*/

	p_disruptor/
		name = "disruptor laser"
		id = "pdisruptor"
		req_tech = list("combat" = 5, "materials" = 5, "engineering" = 5)
		category = "Weapons"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/primary/projectile/disruptor

	p_xray/
		name = "x-ray laser"
		id = "pxraylaser"
		req_tech = list("combat" = 3, "materials" = 3, "engineering" = 3)
		category = "Weapons"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/primary/projectile/xray

	p_laser/
		name = "laser carbine Mk I"
		id = "plaser"
		req_tech = list("combat" = 2, "materials" = 2, "engineering" = 2)
		category = "Weapons"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/primary/projectile/laser

	p_heavylaser/
		name = "laser carbine Mk II"
		id = "pheavylaser"
		req_tech = list("combat" = 3, "materials" = 2, "engineering" = 2)
		category = "Weapons"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/primary/projectile/heavylaser

	p_deathlaser/
		name = "laser carbine Mk III"
		id = "pdeathlaser"
		req_tech = list("combat" = 4, "materials" = 4, "engineering" = 4)
		category = "Weapons"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/primary/projectile/deathlaser

	p_taser/
		name = "taser carbine"
		id = "ptaser"
		req_tech = list("combat" = 1, "materials" = 1, "engineering" = 1)
		category = "Weapons"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/primary/projectile/taser

	p_disabler/
		name = "disabler carbine"
		id = "pdisabler"
		req_tech = list("combat" = 1, "materials" = 1, "engineering" = 1)
		category = "Weapons"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/primary/projectile/disabler

	p_phaser/
		name = "phaser carbine"
		id = "pphaser"
		category = "Weapons"
		req_tech = list("combat" = 2, "materials" = 2, "engineering" = 2)
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/primary/projectile/phaser

	p_neutron_cannon/
		name = "neutron cannon"
		id = "pneutroncannon"
		category = "Weapons"
		req_tech = list("combat" = 3, "materials" = 3, "engineering" = 3)
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/primary/projectile/neutron_cannon

	p_r45/
		name = ".45 repeater"
		id = "p45r"
		req_tech = list("combat" = 2, "materials" = 2, "engineering" = 2)
		category = "Weapons"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/primary/projectile/bullet/r45

	p_r9mm/
		name = "9mm repeater"
		id = "p9mmr"
		req_tech = list("combat" = 3, "materials" = 3, "engineering" = 3)
		category = "Weapons"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/primary/projectile/bullet/r9mm

	p_r10mm/
		name = "10mm repeater"
		id = "p10mmr"
		category = "Weapons"
		req_tech = list("combat" = 4, "materials" = 4, "engineering" = 4)
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/primary/projectile/bullet/r10mm

	p_r75/
		name = ".75 HE repeater"
		id = "p75mmr"
		req_tech = list("combat" = 5, "materials" = 5, "engineering" = 5)
		category = "Weapons"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/primary/projectile/bullet/r75

	p_drill/
		name = "mining drill"
		id = "pdrill"
		req_tech = list("engineering" = 1)
		category = "Utility"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/primary/melee/drill

	p_plasma_drill/
		name = "mining plasma cutter"
		id = "pplasmacutter"
		req_tech = list("engineering" = 2, "magnets" = 2)
		category = "Utility"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/primary/melee/drill/plasma

	p_missile_rack/
		name = "missile rack"
		id = "pmissilerack"
		req_tech = list("combat" = 4, "materials" = 4, "engineering" = 4)
		category = "Weapons"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/primary/projectile/missile

	/*
	* Ammunition
	*/

	p_missile/
		name = "HE missile"
		id = "phemissile"
		req_tech = list("combat" = 4, "materials" = 4, "engineering" = 4)
		category = "Ammunition"
		build_type = PODFAB
		build_path = /obj/item/missile

	p_45_ammo/
		name = ".45 ammo box"
		id = "p45ammo"
		req_tech = list("combat" = 2, "materials" = 2, "engineering" = 2)
		category = "Ammunition"
		build_type = PODFAB
		build_path = /obj/item/ammo_box/c45

	p_9mm_ammo/
		name = "9mm ammo box"
		id = "p9mmammo"
		req_tech = list("combat" = 3, "materials" = 3, "engineering" = 3)
		category = "Ammunition"
		build_type = PODFAB
		build_path = /obj/item/ammo_box/c9mm

	p_10mm_ammo/
		name = "10mm ammo box"
		id = "p10mmammo"
		req_tech = list("combat" = 4, "materials" = 4, "engineering" = 4)
		category = "Ammunition"
		build_type = PODFAB
		build_path = /obj/item/ammo_box/c10mm

	p_75_ammo/
		name = ".75 HE ammo box"
		id = "p75ammo"
		req_tech = list("combat" = 5, "illegal" = 4, "materials" = 5, "engineering" = 5)
		category = "Ammunition"
		build_type = PODFAB
		build_path = /obj/item/ammo_box/magazine/m75

	/*
	* Shield
	*/

	p_plasma_shield/
		name = "plasma shield"
		id = "pplasmaforcefield"
		req_tech = list("magnets" = 2, "powerstorage" = 2, "materials" = 2)
		category = "Shield"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/shield/plasma

	p_neutron_shield/
		name = "neutron shield"
		id = "pneutronshield"
		req_tech = list("magnets" = 3, "powerstorage" = 3, "materials" = 3)
		category = "Shield"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/shield/neutron

	p_higgs_boson_shield/
		name = "higgs-boson shield"
		id = "phiggsbosonshield"
		req_tech = list("magnets" = 4, "powerstorage" = 4, "materials" = 5)
		category = "Shield"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/shield/higgs_boson

	p_antimatter_shield/
		name = "antimatter shield"
		id = "pantimattershield"
		req_tech = list("magnets" = 5, "powerstorage" = 5, "materials" = 6)
		category = "Shield"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/shield/antimatter

	/*
	* Engines
	*/

	p_engine_plasma/
		name = "plasma engine"
		id = "pengineplasma"
		category = "Engine"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/engine/plasma
		req_tech = list("powerstorage" = 1)

	p_engine_plasma_advanced/
		name = "advanced plasma engine"
		id = "pengineplasmaadvanced"
		category = "Engine"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/engine/plasma/advanced
		req_tech = list("powerstorage" = 4, "materials" = 4)

	p_engine_uranium/
		name = "uranium engine"
		id = "pengineuranium"
		category = "Engine"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/engine/uranium
		req_tech = list("powerstorage" = 1)

	p_engine_uranium_advanced/
		name = "advanced uranium engine"
		id = "pengineuraniumadvanced"
		category = "Engine"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/engine/uranium/advanced
		req_tech = list("powerstorage" = 4, "materials" = 4)

	p_engine_wood/
		name = "wood engine"
		id = "penginewood"
		category = "Engine"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/engine/wood
		req_tech = list("powerstorage" = 1)

	p_engine_wood_advanced/
		name = "advanced wood engine"
		id = "penginewoodadvanced"
		category = "Engine"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/engine/wood/advanced
		req_tech = list("powerstorage" = 4, "materials" = 4)

	/*
	* Cargo Holds
	*/

	p_cargo_little/
		name = "little cargo hold"
		id = "pcargolittle"
		category = "Cargo Hold"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/cargo/small
		req_tech = list("engineering" = 1, "materials" = 1)

	P_cargo_medium/
		name = "medium cargo hold"
		id = "pcargomedium"
		category = "Cargo Hold"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/cargo/medium
		req_tech = list("engineering" = 2, "materials" = 2)

	p_cargo_large/
		name = "large cargo hold"
		id = "pcargolarge"
		category = "Cargo Hold"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/cargo/large
		req_tech = list("engineering" = 4, "materials" = 4)

	p_cargo_industrial/
		name = "industrial cargo hold"
		id = "pcargoindustrial"
		category = "Cargo Hold"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/cargo/industrial
		req_tech = list("engineering" = 1, "materials" = 1)

	/*
	* Construction Parts
	*/

	p_construction_left_frame/
		name = "left frame"
		id = "pcleftframe"
		category = "Construction"
		build_type = PODFAB
		build_path = /obj/item/weapon/storage/box/pod_frame_left
		req_tech = list("materials" = 1)

	p_construction_right_frame/
		name = "right frame"
		id = "pcrightframe"
		category = "Construction"
		build_type = PODFAB
		build_path = /obj/item/weapon/storage/box/pod_frame_right
		req_tech = list("materials" = 1)

	p_construction_circuits/
		name = "circuits"
		id = "pccircuits"
		category = "Construction"
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/circuits
		req_tech = list("materials" = 1)

	p_construction_control/
		name = "control"
		id = "pccontrol"
		category = "Construction"
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/control
		req_tech = list("materials" = 1)

	p_construction_covers/
		name = "covers"
		id = "pccovers"
		category = "Construction"
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/covers
		req_tech = list("materials" = 1)

	p_construction_armor_light/
		name = "light armor"
		id = "pcarmorlight"
		category = "Construction"
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/armor/light
		req_tech = list("engineering" = 1, "materials" = 1)

	p_construction_armor_gold/
		name = "gold armor"
		id = "pcarmorgold"
		category = "Construction"
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/armor/gold
		req_tech = list("engineering" = 2, "materials" = 2)

	p_construction_armor_heavy/
		name = "heavy armor"
		id = "pcarmorheavy"
		category = "Construction"
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/armor/heavy
		req_tech = list("engineering" = 4, "materials" = 4, "combat" = 3)

	p_construction_armor_industrial/
		name = "industrial armor"
		id = "pcarmorindustrial"
		category = "Construction"
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/armor/industrial
		req_tech = list("engineering" = 4, "materials" = 4)

	p_construction_armor_prototype/
		name = "prototype armor"
		id = "pcarmorprototype"
		category = "Construction"
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/armor/prototype
		req_tech = list("engineering" = 5, "materials" = 6, "illegal" = 2)

	p_construction_armor_precursor/
		name = "precursor armor"
		id = "pcarmorprecursor"
		category = "Construction"
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/armor/precursor
		req_tech = list("engineering" = 5, "materials" = 6, "illegal" = 4)

	/*
	* Secondary Systems
	*/

	p_ore_collector/
		name = "ore collector"
		id = "porecollector"
		category = "Secondary"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/secondary/ore_collector
		req_tech = list("engineering" = 1)

	p_outward_ripple/
		name = "outward bluespace ripple generator"
		id = "poutwardripple"
		category = "Secondary"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/secondary/bluespace_ripple
		req_tech = list("bluespace" = 4, "magnets" = 4, "programming" = 4, "combat" = 4)

	p_inward_ripple/
		name = "inward bluespace ripple generator"
		id = "pinwardripple"
		category = "Secondary"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/secondary/bluespace_ripple/inward
		req_tech = list("bluespace" = 4, "magnets" = 4, "programming" = 4, "combat" = 4)

	p_smoke_screen/
		name = "smoke screen synthesizer"
		id = "psmokescreen"
		category = "Secondary"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/secondary/smoke_screen
		req_tech = list("engineering" = 2, "materials" = 2)

	p_autoloader/
		name = "autoloader"
		id = "pautoloader"
		category = "Secondary"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/secondary/autoloader
		req_tech = list("engineering" = 2)

	p_gimbal/
		name = "gimbal mount"
		id = "pgimbal"
		category = "Secondary"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/secondary/gimbal
		req_tech = list("engineering" = 4, "materials" = 4, "combat" = 3)

	p_wormhole_generator/
		name = "wormhole generator"
		id = "pwormholegen"
		category = "Secondary"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/secondary/wormhole_generator
		req_tech = list("engineering" = 4, "materials" = 4, "bluespace" = 3)

	p_seating_module/
		name = "seating module"
		id = "pseatingmodule"
		category = "Secondary"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/secondary/seating_module
		req_tech = list("engineering" = 1)

	p_ejection_seats/
		name = "ejection seats"
		id = "pejectionseats"
		category = "Secondary"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/secondary/ejection_seats
		req_tech = list("engineering" = 2, "materials" = 2)

	p_mech_storage/
		name = "mech storage"
		id = "pmechstorage"
		category = "Secondary"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/secondary/mech_storage
		req_tech = list("engineering" = 1, "materials" = 1)

	/*
	* Sensors
	*/

	p_lifeform_sensor/
		name = "lifeform sensor"
		id = "plifeformsensor"
		category = "Sensor"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/sensor/lifeform
		req_tech = list("engineering" = 2, "powerstorage" = 2, "magnets" = 2, "programming" = 2)

	p_gps/
		name = "gps"
		id = "pgps"
		category = "Sensor"
		build_type = PODFAB
		build_path = /obj/item/weapon/pod_attachment/sensor/gps
		req_tech = list("programming" = 1)