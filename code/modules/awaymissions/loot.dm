/obj/effect/spawner/lootdrop
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x2"
	color = "#00FF00"
	var/lootcount = 1		//how many items will be spawned
	var/lootdoubles = 1		//if the same item can be spawned twice
	var/list/loot			//a list of possible items to spawn e.g. list(/obj/item, /obj/structure, /obj/effect)

/obj/effect/spawner/lootdrop/New()
	if(loot && loot.len)
		for(var/i = lootcount, i > 0, i--)
			if(!loot.len) break
			var/lootspawn = pickweight(loot)
			if(!lootdoubles)
				loot.Remove(lootspawn)

			if(lootspawn)
				new lootspawn(get_turf(src))
	qdel(src)

/obj/effect/spawner/lootdrop/armory_contraband
	name = "armory contraband gun spawner"
	lootdoubles = 0
	loot = list(
				/obj/item/weapon/gun/projectile/automatic/pistol = 8,
				/obj/item/weapon/gun/projectile/shotgun/combat = 5,
				/obj/item/weapon/gun/projectile/revolver/mateba,
				/obj/item/weapon/gun/projectile/automatic/deagle
				)

/obj/effect/spawner/lootdrop/vault
	name = "vault loot spawner"
	lootdoubles = 0
	lootcount = 2
	loot = list(
				/obj/item/weapon/twohanded/fireaxe = 1,
				/obj/item/toy/katana = 1,
				/obj/item/clothing/head/bearpelt = 1,
				/obj/item/clothing/suit/billydonka = 1,
				/obj/item/weapon/melee/classic_baton = 1
				)

/obj/effect/spawner/lootdrop/maint
	name = "maint loot spawner"
	loot = list(
				/obj/effect/spawner/lootdrop/maint/common = 12,
				/obj/effect/spawner/lootdrop/maint/uncommon = 10,
				/obj/effect/spawner/lootdrop/maint/rare = 1
				)

/obj/effect/spawner/lootdrop/maint/common
	name = "common maint loot spawner"
	lootcount = 2
	lootdoubles = 0
	loot = list(
				/obj/item/bodybag = 1,
				/obj/item/clothing/gloves/fyellow = 1,
				/obj/item/clothing/head/hardhat = 1,
				/obj/item/clothing/head/hardhat/red = 1,
				/obj/item/clothing/head/that{throwforce = 1; throwing = 1} = 1,
				/obj/item/clothing/head/ushanka = 1,
				/obj/item/clothing/head/welding = 1,
				/obj/item/clothing/mask/gas = 5,
				/obj/item/clothing/suit/hazardvest = 1,
				/obj/item/clothing/under/rank/vice = 1,
				/obj/item/device/assembly/prox_sensor = 4,
				/obj/item/device/assembly/timer = 3,
				/obj/item/device/flashlight = 4,
				/obj/item/device/flashlight/pen = 1,
				/obj/item/device/multitool = 2,
				/obj/item/device/radio/off = 2,
				/obj/item/device/t_scanner = 3,
				/obj/item/stack/cable_coil = 2,
				/obj/item/stack/medical/bruise_pack = 1,
				/obj/item/stack/rods{amount = 10} = 4,
				/obj/item/stack/rods{amount = 23} = 1,
				/obj/item/stack/rods{amount = 50} = 1,
				/obj/item/stack/sheet/cardboard = 2,
				/obj/item/stack/sheet/metal{amount = 20} = 1,
				/obj/item/stack/sheet/mineral/plasma{layer = 2.9} = 1,
				/obj/item/stack/sheet/rglass = 1,
				/obj/item/weapon/book/manual/wiki/engineering_construction = 1,
				/obj/item/weapon/book/manual/wiki/engineering_hacking = 1,
				/obj/item/weapon/coin/silver = 1,
				/obj/item/weapon/coin/twoheaded = 1,
				/obj/item/weapon/contraband/poster = 1,
				/obj/item/weapon/crowbar = 1,
				/obj/item/weapon/crowbar/red = 1,
				/obj/item/weapon/extinguisher = 11,
				/obj/item/weapon/pen = 1,
				/obj/item/weapon/reagent_containers/spray/pestspray = 1,
				/obj/item/weapon/stock_parts/cell = 3,
				/obj/item/weapon/storage/belt/utility = 2,
				/obj/item/weapon/storage/box = 2,
				/obj/item/weapon/storage/box/cups = 1,
				/obj/item/weapon/storage/box/donkpockets = 1,
				/obj/item/weapon/storage/box/lights/mixed = 3,
				/obj/item/weapon/storage/fancy/cigarettes/dromedaryco = 1,
				/obj/item/weapon/storage/toolbox/mechanical = 1,
				/obj/item/weapon/screwdriver = 3,
				/obj/item/weapon/tank/emergency_oxygen = 2,
				/obj/item/weapon/vending_refill/cola = 1,
				/obj/item/weapon/weldingtool = 3,
				/obj/item/weapon/wirecutters = 1,
				/obj/item/weapon/wrench = 4,
				"" = 11
				)

/obj/effect/spawner/lootdrop/maint/uncommon
	name = "uncommon maint loot spawner"
	lootcount = 1
	lootdoubles = 0
	loot = list(
				/obj/item/clothing/gloves/white{color = "yellow"; desc = "The colors are a bit dodgy."; icon_state = "yellow"; item_color = "yellow"; item_state = "ygloves"; name = "insulated gloves"} = 1,
				/obj/item/clothing/glasses/meson = 1,
				/obj/item/clothing/glasses/sunglasses = 1,
				/obj/item/bodybag = 1,
				/obj/item/clothing/gloves/yellow = 1,
				/obj/item/stack/sheet/rglass = 2,
				/obj/item/device/assembly/igniter = 2,
				/obj/item/weapon/hand_labeler = 2,
				/obj/item/weapon/reagent_containers/spray/pestspray = 3,
				/obj/item/weapon/stock_parts/cell/high = 1,
				/obj/item/weapon/storage/box/donkpockets = 3,
				/obj/item/weapon/storage/box/lights/mixed = 3,
				/obj/item/weapon/storage/box/winkingman = 2,
				/obj/item/clothing/mask/cigarette/rollie = 2,
				/obj/item/weapon/grenade/stink = 1,
				/obj/item/weapon/hand_labeler = 1
				)

/obj/effect/spawner/lootdrop/maint/rare
	name = "rare maint loot spawner"
	lootcount = 1
	loot = list(
				/obj/item/weapon/gun/energy/disabler{name = "dusty disabler"} = 1,
				/obj/item/device/flash{name = "dusty flash"} = 1,
				/obj/item/weapon/reagent_containers/food/snacks/burger/superbite = 1,
				/obj/item/weapon/grenade/smokebomb{name = "dusty smoke bomb"} = 1,
				/obj/item/weapon/storage/belt{name = "multibelt"} = 1
				)

/obj/effect/spawner/lootdrop/maint/litter
	name = "maint litter loot spawner"
	lootcount = 1
	loot = list(
				/obj/item/weapon/screwdriver = 2,
				/obj/item/weapon/wrench = 2,
				/obj/item/weapon/weldingtool = 2,
				/obj/item/weapon/crowbar = 2,
				/obj/item/weapon/wirecutters = 2,
				/obj/item/device/multitool = 2,
				/obj/item/clothing/head/cone = 8,
				/obj/item/weapon/storage/box = 2,
				/obj/item/weapon/storage/box/cups = 2,
				/obj/item/weapon/storage/box/donkpockets = 3,
				/obj/item/weapon/storage/box/lights/mixed = 3,
				/obj/item/weapon/storage/box/winkingman = 1,
				/obj/item/trash/semki = 8,
				/obj/item/trash/popcorn = 8,
				/obj/item/trash/can = 8,
				/obj/item/trash/deadmouse = 3,
				/obj/item/weapon/storage/toolbox/mechanical = 1,
				/obj/item/clothing/mask/cigarette/rollie = 3,
				/obj/item/stack/sheet/metal{amount = 20} = 3,
				/obj/item/stack/sheet/glass{amount = 20} = 3,
				)

/obj/effect/spawner/lootdrop/maint/blackmarket
	name = "blackmarket loot spawner"
	lootcount = 5
	loot = list(
				/obj/item/device/lightreplacer = 1,
				/obj/item/device/flash/synthetic = 1,
				/obj/item/device/laser_pointer = 1,
				/obj/item/device/healthanalyzer = 1,
				/obj/item/device/assembly/igniter = 1,
				/obj/item/device/assembly/infra = 1,
				/obj/item/device/assembly/mousetrap = 1,
				/obj/item/device/assembly/prox_sensor = 1,
				/obj/item/device/assembly/signaler = 1,
				/obj/item/device/assembly/timer = 1,
				/obj/item/device/assembly/voice = 1,
				/obj/item/weapon/razor = 1,
				/obj/item/weapon/wirerod = 1,
				)