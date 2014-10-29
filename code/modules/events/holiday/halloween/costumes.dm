/*
* Costume Packs
*/

/proc/getCostumeList()
	var/costumes[] = list()

	for(var/path in (typesof(/datum/costume_pack) - /datum/costume_pack))
		var/datum/costume_pack/C = new path()
		costumes[C.name] = path

	return costumes

/client/proc/spawncostume()
	set name = "Spawn Costume"
	set category = "Fun"

	var/costumes[] = getCostumeList()
	var/costume = input("Select Costume", "Select") as anything in costumes

	var/path = costumes[costume]
	path = text2path("[path]")
	if(!ispath(path))
		usr << "\red Invalid Path, '[path]'."
		return 0

	var/datum/costume_pack/C = new path()
	C.SpawnBox(get_turf(mob))

/obj/item/weapon/storage/box/costume_box
	icon_state = "costume_box"

	New(var/loc, var/specific, var/spawnItems = 1)
		..()
		if(!spawnItems) return
		var/typepath = pick(typesof(/datum/costume_pack) - /datum/costume_pack)
		if(specific)
			if(ispath(specific))
				typepath = specific
		var/datum/costume_pack/costume = new typepath()
		costume.FillBox(src)

/datum/costume_pack
	var/name = "Custome Pack"
	var/list/parts = list()

	proc/SpawnBox(var/turf/T)
		if(!T)	return
		var/obj/item/weapon/storage/box/costume_box/box = new(T, 0, 0)
		FillBox(box)
		box.name = "'[name]' costume"

	proc/FillBox(var/obj/item/weapon/storage/box/costume_box/box)
		if(!box)	return
		for(var/typepath in parts)
			new typepath(box)
		box.name = "'[name]' costume"

	New(var/obj/item/weapon/storage/box/costume_box/box)
		..()
		if(box)	FillBox(box)
		else	return

	// Custom

	batman/
		name = "The Dark Knight"
		parts = list(/obj/item/clothing/head/batman, /obj/item/clothing/under/batman, \
					/obj/item/clothing/gloves/batman, /obj/item/clothing/shoes/jackboots, \
					/obj/item/clothing/mask/balaclava)

	friday13th/
		name = "Friday the 13th"
		parts = list(/obj/item/clothing/mask/jason, /obj/item/clothing/under/jason, \
					/obj/item/clothing/suit/jason)

	// Other

	fakewizard/
		name = "Fake Wizard"
		parts = list(/obj/item/clothing/suit/wizrobe/fake, /obj/item/clothing/head/wizard/fake, /obj/item/weapon/staff)

	witch/
		name = "Fake Witch"
		parts = list(/obj/item/clothing/suit/wizrobe/marisa/fake, /obj/item/clothing/head/witchwig, /obj/item/weapon/staff/broom, \
					/obj/item/clothing/under/sundress)

	chicken/
		name = "Chicken"
		parts = list(/obj/item/clothing/head/chicken, /obj/item/clothing/suit/chickensuit)

	xeno/
		name = "Xenomorph"
		parts = list(/obj/item/clothing/head/xenos, /obj/item/clothing/suit/xenos)

	pirate/
		name = "Pirate"
		parts = list(/obj/item/clothing/under/pirate, /obj/item/clothing/head/bandana, /obj/item/clothing/glasses/eyepatch)

	pirate_captain/
		name = "Pirate Captain"
		parts = list(/obj/item/clothing/under/pirate, /obj/item/clothing/head/pirate, /obj/item/clothing/glasses/eyepatch)

	russian1/
		name = "Russian"
		parts = list(/obj/item/clothing/under/soviet, /obj/item/clothing/head/ushanka)

	russian2/
		name = "Russian"
		parts = list(/obj/item/clothing/under/soviet, /obj/item/clothing/head/bearpelt)

	plaguedoctor/
		name = "Plague Doctor"
		parts = list(/obj/item/clothing/mask/gas/plaguedoctor, /obj/item/clothing/head/plaguedoctorhat, /obj/item/clothing/suit/bio_suit/plaguedoctorsuit)

	gladiator/
		name = "Gladiator"
		parts = list(/obj/item/clothing/head/helmet/gladiator, /obj/item/clothing/under/gladiator)

	owl/
		name = "Owl"
		parts = list(/obj/item/clothing/mask/gas/owl_mask, /obj/item/clothing/under/owl)

	sexyclown/
		name = "Sexy Clown"
		parts = list(/obj/item/clothing/under/sexyclown, /obj/item/clothing/mask/gas/sexyclown)

	sexymime/
		name = "Sexy Mime"
		parts = list(/obj/item/clothing/under/sexymime, /obj/item/clothing/mask/gas/sexymime)

	animalmask/
		name = "Animal Mask"
		parts = list(/obj/item/clothing/mask/pig, /obj/item/clothing/mask/horsehead)

	monkey/
		name = "Monkey"
		parts = list(/obj/item/clothing/mask/gas/monkeymask, /obj/item/clothing/suit/monkeysuit)

	imperium_monk/
		name = "Imperium Monk"
		parts = list(/obj/item/clothing/suit/imperium_monk)

	schoolgirl/
		name = "Schoolgirl"
		parts = list(/obj/item/clothing/head/kitty, /obj/item/clothing/under/schoolgirl)

	pumpkinhead/
		name = "Pumpkinhead"
		parts = list(/obj/item/clothing/head/hardhat/pumpkinhead)

	cueball/
		name = "Cueball"
		parts = list(/obj/item/clothing/under/scratch, /obj/item/clothing/head/cueball)

	jensen/
		name = "Jensen"
		parts = list(/obj/item/clothing/glasses/hud/security/jensenshades, /obj/item/clothing/under/rank/head_of_security/jensen, /obj/item/clothing/suit/armor/hos/jensen)

	roman/
		name = "Roman"
		parts = list(/obj/item/clothing/head/helmet/roman, /obj/item/clothing/under/roman, /obj/item/clothing/shoes/roman, /obj/item/weapon/shield/riot/roman)

	roman_legionaire/
		name = "Roman Legionaire"
		parts = list(/obj/item/clothing/head/helmet/roman/legionaire, /obj/item/clothing/under/roman, /obj/item/clothing/shoes/roman, /obj/item/weapon/shield/riot/roman)

	scottish/
		name = "Scotsman"
		parts = list(/obj/item/clothing/under/kilt, /obj/item/clothing/head/beret)

	judge/
		name = "Judge"
		parts = list(/obj/item/clothing/suit/judgerobe, /obj/item/clothing/head/powdered_wig)

	cardboard/
		name = "Cardboard"
		parts = list(/obj/item/clothing/head/cardborg, /obj/item/clothing/suit/cardborg)

	mario/
		name = "Mario"
		parts = list(/obj/item/clothing/under/color/red, /obj/item/clothing/head/soft/red, /obj/item/clothing/suit/apron/overalls)

	luigi/
		name = "Luigi"
		parts = list(/obj/item/clothing/under/color/green, /obj/item/clothing/head/soft/green, /obj/item/clothing/suit/apron/overalls)

	sombrero/
		name = "Mexican"
		parts = list(/obj/item/clothing/head/sombrero, /obj/item/clothing/suit/poncho)

	gentleman/
		name = "Gentleman"
		parts = list(/obj/item/clothing/head/bowler, /obj/item/clothing/mask/fakemoustache, /obj/item/clothing/glasses/monocle, \
					/obj/item/clothing/under/sl_suit, /obj/item/weapon/cane)

	headslime/
		name = "Headslime"
		parts = list(/obj/item/clothing/head/collectable/slime)

	cubanpete/
		name = "Cuban Pete"
		parts = list(/obj/item/clothing/head/collectable/petehat)

	fake_syndicate/
		name = "Fake Syndicate"
		parts = list(/obj/item/clothing/under/syndicate/tacticool, /obj/item/clothing/shoes/jackboots, /obj/item/toy/sword, \
					/obj/item/toy/crossbow, /obj/item/toy/ammo/gun, /obj/item/toy/gun, /obj/item/clothing/suit/syndicatefake, \
					/obj/item/clothing/head/syndicatefake)

	hastur/
		name = "Hastur"
		parts = list(/obj/item/clothing/head/hasturhood, /obj/item/clothing/suit/hastur)

	redcoat/
		name = "Redcoat"
		parts = list(/obj/item/clothing/under/redcoat, /obj/item/clothing/gloves/white/redcoat, /obj/item/clothing/head/redcoat)


	mads_costume/
		name = "Mad's"
		parts = list(/obj/item/clothing/under/gimmick/rank/captain/suit, /obj/item/clothing/suit/labcoat/mad, /obj/item/clothing/head/flatcap, \
					/obj/item/clothing/glasses/gglasses)

	devil/
		name = "Devil"
		parts = list(/obj/item/clothing/head/demonhorns)

	wings/
		name = "Wings"
		parts = list(/obj/item/clothing/suit/hallowings)

	vc/
		name = "VC"
		parts = list(/obj/item/clothing/head/paddyhat, /obj/item/clothing/under/vcuniform, /obj/item/clothing/suit/chestrig)

	soldier/
		name = "Soldier"
		parts = list(/obj/item/clothing/head/soldier_hat, /obj/item/clothing/under/soldier_uniform, /obj/item/clothing/suit/webbing)


/*
* Costume Items
*/

//Batman

/obj/item/clothing/head/batman
	name = "batman helmet"
	icon_state = "bmhead"
	item_state = "xenos_helm"

/obj/item/clothing/under/batman
	name = "batman uniform"
	icon_state = "bmuniform"
	item_color = "bmuniform"

/obj/item/clothing/gloves/batman
	name = "batman gloves"
	icon_state = "bmgloves"

// Friday the 13th / Jason Vorhees

/obj/item/clothing/mask/jason
	name = "hockey mask"
	icon_state = "hockeymask"

/obj/item/clothing/under/jason
	name = "bloody jumpsuit"
	icon_state = "jasonsuit"
	item_color = "jasonsuit"

/obj/item/clothing/suit/jason
	name = "bloody coat"
	icon_state = "bloodycoat"

// VC

/obj/item/clothing/head/paddyhat
	name = "paddy hat"
	icon_state = "paddyhat"

/obj/item/clothing/under/vcuniform
	name = "vc uniform"
	icon_state = "vc_uniform"
	item_color = "vc_uniform"

/obj/item/clothing/suit/chestrig
	name = "chestrig"
	icon_state = "vc_chestrig"

// Soldier

/obj/item/clothing/head/soldier_hat
	name = "helmet"
	icon_state = "soldier_helmet"

/obj/item/clothing/under/soldier_uniform
	name = "soldier uniform"
	icon_state = "soldier_uniform"
	item_color = "soldier_uniform"

/obj/item/clothing/suit/webbing
	name = "webbing"
	icon_state = "soldier_webbing"
