/*
* All vending machine related stuff goes here.
*/

/*
* Perc Chef
*/

/obj/machinery/vending/percchef
	name = "PercTech Automated Chef"
	desc = "A grumpy automated food processor machine courtesy of Perctech."
	icon_state = "percchef"

	products = list(/obj/item/weapon/reagent_containers/food/snacks/enchiladas = 3, /obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato = 3,
	/obj/item/weapon/reagent_containers/food/snacks/fries = 3, /obj/item/weapon/reagent_containers/food/snacks/fishfingers = 3,
	/obj/item/weapon/reagent_containers/food/snacks/eggplantparm = 3, /obj/item/weapon/reagent_containers/food/snacks/carrotcakeslice = 3,
	/obj/item/weapon/reagent_containers/food/snacks/omelette = 3, /obj/item/weapon/reagent_containers/food/snacks/tomatosoup = 3,
	/obj/item/weapon/reagent_containers/food/snacks/waffles = 3, /obj/item/weapon/reagent_containers/food/snacks/sandwich = 3,
	/obj/item/weapon/reagent_containers/food/snacks/meatballspagetti = 3, /obj/item/weapon/reagent_containers/food/snacks/cubancarp = 3,
	/obj/item/weapon/reagent_containers/food/snacks/stew =3, /obj/item/weapon/reagent_containers/food/snacks/burger/superbite = 1,
	/obj/item/weapon/reagent_containers/food/snacks/candiedapple = 3, /obj/item/weapon/reagent_containers/food/snacks/applepie = 3,
	/obj/item/weapon/reagent_containers/food/snacks/cherrypie = 3, /obj/item/weapon/reagent_containers/food/snacks/xenomeat = 3,
	/obj/item/weapon/reagent_containers/food/snacks/sliceable/store/chocolatecake = 3)

	product_ads = "Oui Oui!;Bon appetit!;Oh putain! Qu'est-ce que c'est ça? Ça c’est dégueulasse!;Profitez de votre crasse cochon!"
	contraband = list(/obj/item/weapon/reagent_containers/food/snacks/wishsoup = 1)
	req_access_txt = "66"

/*
* Perseus Medical
*/

/obj/machinery/vending/percmed
	name = "PercMed Plus"
	desc = "Perseus Medical drug dispenser."
	icon_state = "percmed"
	icon_deny = "percmed-deny"
	req_access_txt = "66"

	products = list(/obj/item/weapon/reagent_containers/glass/bottle/antitoxin = 4, /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline = 4,
	/obj/item/weapon/reagent_containers/glass/bottle/stoxin = 4,/obj/item/weapon/reagent_containers/glass/bottle/toxin = 4,
	/obj/item/weapon/reagent_containers/syringe/antiviral = 4,/obj/item/weapon/reagent_containers/syringe = 12, /obj/item/device/healthanalyzer = 5,
	/obj/item/weapon/reagent_containers/glass/beaker = 4,/obj/item/weapon/reagent_containers/dropper = 2, /obj/item/stack/medical/bruise_pack = 6,
	/obj/item/stack/medical/ointment = 6, /obj/item/weapon/stimpack/perseus = 10)

	contraband = list(/obj/item/weapon/reagent_containers/pill/tox = 3, /obj/item/weapon/reagent_containers/pill/stox = 4, /obj/item/weapon/reagent_containers/pill/antitox = 6)

/*
* PercTech Vendor
*/

/obj/machinery/vending/perctech
	name = "PercTech"
	desc = "A Perseus equipment vendor"
	icon_state = "perseus"
	icon_deny = "perseus-deny"
	req_access_txt = "66"
	products = list(/obj/item/weapon/handcuffs = 10,/obj/item/weapon/grenade/flashbang = 2, /obj/item/device/flash = 5,
	/obj/item/weapon/tank/perseus = 8, /obj/item/weapon/tank/oxygen = 4,/obj/item/weapon/storage/fancy/cigarettes/perc = 5,
	/obj/item/weapon/storage/box/matches = 5, /obj/item/weapon/plastique/breach = 5, /obj/item/clothing/mask/cigarette/cigar/victory = 6)

	contraband = list(/obj/item/weapon/tank/jetpack/oxygen/perctech = 2, /obj/item/weapon/storage/fancy/donut_box = 2)

/*
* Perseus Booze-O-Mat
*/

/obj/machinery/vending/boozeomat/perc
	products = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/gin = 5,/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla = 5,/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth = 5,/obj/item/weapon/reagent_containers/food/drinks/bottle/rum = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/wine = 5,/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua = 5,/obj/item/weapon/reagent_containers/food/drinks/beer = 6,
					/obj/item/weapon/reagent_containers/food/drinks/ale = 6,/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice = 4,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tomatojuice = 4,/obj/item/weapon/reagent_containers/food/drinks/bottle/limejuice = 4,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cream = 4,/obj/item/weapon/reagent_containers/food/drinks/soda_cans/tonic = 8,
					/obj/item/weapon/reagent_containers/food/drinks/soda_cans/cola = 8, /obj/item/weapon/reagent_containers/food/drinks/soda_cans/sodawater = 15,
					/obj/item/weapon/reagent_containers/food/drinks/drinkingglass = 30,/obj/item/weapon/reagent_containers/food/drinks/ice = 9,
					/obj/item/weapon/reagent_containers/food/drinks/purpledrank = 6, /obj/item/weapon/reagent_containers/food/drinks/xenoschlag = 6)
	req_access_txt = "66"

/*
*
*/

/obj/machinery/smartfridge/prisoner
	name = "\improper PercTech gear storage"
	icon = 'icons/obj/perseus_vending.dmi'
	icon_state = "Percprisoner"
	layer = 2.9
	anchored = 1
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0
	flags = NOREACT
	icon_on = "smartfridge"
	icon_off = "Percprisoner"
	item_quants = list()
	density = 0
	req_access = list(access_penforcer)

	accept_check(var/obj/item/O as obj)
		if(istype(O, /obj/item))
			return 1
		return 0

/obj/machinery/smartfridge/prisoner/New()
	..()
	for(var/i = 0, i<6, i++)
		new /obj/item/clothing/under/color/orange(src)
		new /obj/item/clothing/shoes/sneakers/orange(src)
		new /obj/item/weapon/handcuffs(src)
		new /obj/item/clothing/mask/muzzle(src)
		new /obj/item/clothing/suit/straight_jacket(src)
		new /obj/item/clothing/glasses/sunglasses/blindfold(src)
	item_quants["orange shoes"] = 6
	item_quants["orange jumpsuit"] = 6
	item_quants["handcuffs"] = 6
	item_quants["muzzle"] = 6
	item_quants["straight jacket"] = 6
	item_quants["blindfold"] = 6



/obj/machinery/vending/percleisure
	name = "PercTech Leisure Vendor"
	icon = 'icons/obj/perseus_vending.dmi'
	icon_state = "Percleisure"
	icon_deny = "Percleisure_rejection"
	density = 0
	product_slogans = "Get yourself a few toys to spice up that boring prisoner life!"
	products = list(/obj/item/toy/balloon = 4, /obj/item/toy/spinningtoy = 4, /obj/item/toy/gun = 4,
					/obj/item/toy/ammo/gun = 6, /obj/item/toy/crossbow = 4, /obj/item/toy/ammo/crossbow = 20, /obj/item/toy/sword = 4,
					/obj/item/toy/katana = 4, /obj/item/toy/crayon = 4, /obj/item/toy/snappop = 15)

	contraband = list(/obj/item/toy/prize/ripley = 1, /obj/item/toy/prize/fireripley = 1, /obj/item/toy/prize/deathripley = 1,
					/obj/item/toy/prize/gygax = 1, /obj/item/toy/prize/durand = 1, /obj/item/toy/prize/honk = 1,
					/obj/item/toy/prize/marauder = 1, /obj/item/toy/prize/seraph = 1, /obj/item/toy/prize/mauler = 1,
					/obj/item/toy/prize/odysseus = 1, /obj/item/toy/prize/phazon = 1)
	req_access = list(access_penforcer)

