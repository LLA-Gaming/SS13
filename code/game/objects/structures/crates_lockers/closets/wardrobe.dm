//Closets can only contain 30 items. Please be careful not to overfill them! (looking at you seclocker)

/obj/structure/closet/wardrobe
	name = "wardrobe"
	desc = "It's a storage closet for standard-issue Nanotrasen attire."
	icon_state = "blue"
	icon_closed = "blue"

/obj/structure/closet/wardrobe/New()
	new /obj/item/clothing/under/color/blue(src)
	new /obj/item/clothing/under/color/blue(src)
	new /obj/item/clothing/under/color/blue(src)
	new /obj/item/clothing/mask/bandana/blue(src)
	new /obj/item/clothing/mask/bandana/blue(src)
	new /obj/item/clothing/mask/bandana/blue(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
	return


/obj/structure/closet/wardrobe/red
	name = "security wardrobe"
	icon_state = "red"
	icon_closed = "red"

/obj/structure/closet/wardrobe/red/New()
	new /obj/item/weapon/storage/backpack/security(src)
	new /obj/item/weapon/storage/backpack/security(src)
	new /obj/item/weapon/storage/backpack/satchel_sec(src)
	new /obj/item/weapon/storage/backpack/satchel_sec(src)
	new /obj/item/clothing/mask/bandana/red(src)
	new /obj/item/clothing/mask/bandana/red(src)
	new /obj/item/clothing/mask/bandana/red(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/suit/armor/vest/jacket(src)
	if(prob(30))
		new /obj/item/clothing/suit/armor/vest/jacket(src)
	new /obj/item/clothing/under/camo(src)
	if(prob(30))
		new /obj/item/clothing/under/camo(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/tie/scarf{color = "#e32636"}(src)
	return

/obj/structure/closet/wardrobe/hos
	name = "\proper head of security's wardrobe"
	icon_state = "red"
	icon_closed = "red"

/obj/structure/closet/wardrobe/hos/New()
	new /obj/item/clothing/suit/wintercoat/security(src)
	new /obj/item/clothing/under/camo(src)
	new /obj/item/clothing/suit/armor/vest/jacket(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/under/hosformalfem(src)
	new /obj/item/clothing/under/hosformalmale(src)
	new /obj/item/clothing/under/rank/head_of_security/jensen(src)
	new /obj/item/clothing/tie/scarf{color = "#e32636"}(src)
	return

/obj/structure/closet/wardrobe/pink
	name = "pink wardrobe"
	icon_state = "pink"
	icon_closed = "pink"

/obj/structure/closet/wardrobe/pink/New()
	new /obj/item/clothing/under/lightpink(src)
	new /obj/item/clothing/under/lightpink(src)
	new /obj/item/clothing/under/lightpink(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/suit/wintercoat/hoodie/pink(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
	return

/obj/structure/closet/wardrobe/black
	name = "black wardrobe"
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/black/New()
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/suit/wintercoat/hoodie/black(src)
	if(prob(30))
		new /obj/item/clothing/suit/labcoat/jacket/leather(src)
		new /obj/item/clothing/suit/labcoat/jacket/biker(src)
	if(prob(40))
		new /obj/item/clothing/mask/bandana/skull(src)
	else
		new /obj/item/clothing/mask/bandana/black(src)
	if(prob(40))
		new /obj/item/clothing/mask/bandana/skull(src)
	else
		new /obj/item/clothing/mask/bandana/black(src)
	if(prob(40))
		new /obj/item/clothing/mask/bandana/skull(src)
	else
		new /obj/item/clothing/mask/bandana/black(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/tie/scarf{color = "#262626"}(src)
	return


/obj/structure/closet/wardrobe/chaplain_black
	name = "chapel wardrobe"
	desc = "It's a storage unit for Nanotrasen-approved religious attire."
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/chaplain_black/New()
	new /obj/item/clothing/under/rank/chaplain(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/suit/nun(src)
	new /obj/item/clothing/head/nun_hood(src)
	new /obj/item/clothing/suit/chaplain_hoodie(src)
	new /obj/item/clothing/head/chaplain_hood(src)
	new /obj/item/clothing/suit/holidaypriest(src)
	new /obj/item/weapon/storage/backpack/cultpack (src)
	new /obj/item/weapon/storage/fancy/candle_box(src)
	new /obj/item/weapon/storage/fancy/candle_box(src)
	return


/obj/structure/closet/wardrobe/green
	name = "green wardrobe"
	icon_state = "green"
	icon_closed = "green"

/obj/structure/closet/wardrobe/green/New()
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/mask/bandana/green(src)
	new /obj/item/clothing/mask/bandana/green(src)
	new /obj/item/clothing/mask/bandana/green(src)
	new /obj/item/clothing/suit/wintercoat/hoodie/green(src)
	new /obj/item/clothing/under/color/lightgreen(src)
	new /obj/item/clothing/under/color/lightgreen(src)
	new /obj/item/clothing/under/color/lightgreen(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/tie/scarf{color = "#009933"}(src)
	return


/obj/structure/closet/wardrobe/orange
	name = "prison wardrobe"
	desc = "It's a storage unit for Nanotrasen-regulation prisoner attire."
	icon_state = "orange"
	icon_closed = "orange"

/obj/structure/closet/wardrobe/orange/New()
	new /obj/item/clothing/under/color/prison(src)
	new /obj/item/clothing/under/color/prison(src)
	new /obj/item/clothing/under/color/prison(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	return


/obj/structure/closet/wardrobe/yellow
	name = "yellow wardrobe"
	icon_state = "yellow"
	icon_closed = "yeloww"

/obj/structure/closet/wardrobe/yellow/New()
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	return


/obj/structure/closet/wardrobe/atmospherics_yellow
	name = "atmospherics wardrobe"
	icon_state = "atmos"
	icon_closed = "atmos"

/obj/structure/closet/wardrobe/atmospherics_yellow/New()
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/suit/wintercoat/atmos(src)
	new /obj/item/clothing/suit/wintercoat/atmos(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	return



/obj/structure/closet/wardrobe/engineering_yellow
	name = "engineering wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/engineering_yellow/New()
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	new /obj/item/clothing/shoes/sneakers/orange(src)
	return


/obj/structure/closet/wardrobe/white
	name = "white wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/white/New()
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	return


/obj/structure/closet/wardrobe/pjs
	name = "pajama wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/pjs/New()
	new /obj/item/clothing/under/pj/red(src)
	new /obj/item/clothing/under/pj/red(src)
	new /obj/item/clothing/under/pj/blue(src)
	new /obj/item/clothing/under/pj/blue(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	return


/obj/structure/closet/wardrobe/toxins_white
	name = "toxins wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/toxins_white/New()
	new /obj/item/weapon/storage/backpack/satchel_tox(src)
	new /obj/item/weapon/storage/backpack/satchel_tox(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/suit/labcoat(src)
	new /obj/item/clothing/suit/labcoat(src)
	new /obj/item/clothing/suit/labcoat(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	return


/obj/structure/closet/wardrobe/robotics_black
	name = "robotics wardrobe"
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/robotics_black/New()
	new /obj/item/clothing/suit/labcoat(src)
	new /obj/item/clothing/suit/labcoat(src)
	new /obj/item/clothing/suit/wintercoat/hoodie/black(src)
	new /obj/item/clothing/under/rank/roboticist(src)
	new /obj/item/clothing/under/rank/roboticist(src)
	if(prob(40))
		new /obj/item/clothing/mask/bandana/skull(src)
	else
		new /obj/item/clothing/mask/bandana/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/head/soft/black(src)
	new /obj/item/clothing/head/soft/black(src)
	return


/obj/structure/closet/wardrobe/chemistry_white
	name = "chemistry wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/chemistry_white/New()
	if(prob(40))
		new /obj/item/weapon/storage/backpack/satchel_chem(src)
	if(prob(40))
		new /obj/item/weapon/storage/backpack/satchel_chem(src)
	new /obj/item/clothing/suit/labcoat/chemist(src)
	new /obj/item/clothing/suit/labcoat/chemist(src)
	new /obj/item/clothing/under/rank/chemist(src)
	new /obj/item/clothing/under/rank/chemist(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	return


/obj/structure/closet/wardrobe/genetics_white
	name = "genetics wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/genetics_white/New()
	if(prob(40))
		new /obj/item/weapon/storage/backpack/satchel_gen(src)
	if(prob(40))
		new /obj/item/weapon/storage/backpack/satchel_gen(src)
	new /obj/item/clothing/suit/labcoat/genetics(src)
	new /obj/item/clothing/suit/labcoat/genetics(src)
	new /obj/item/clothing/under/rank/geneticist(src)
	new /obj/item/clothing/under/rank/geneticist(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	return


/obj/structure/closet/wardrobe/virology_white
	name = "virology wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/virology_white/New()
	if(prob(40))
		new /obj/item/weapon/storage/backpack/satchel_vir(src)
	if(prob(40))
		new /obj/item/weapon/storage/backpack/satchel_vir(src)
	new /obj/item/clothing/suit/labcoat/virologist(src)
	new /obj/item/clothing/suit/labcoat/virologist(src)
	new /obj/item/clothing/under/rank/virologist(src)
	new /obj/item/clothing/under/rank/virologist(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	return


/obj/structure/closet/wardrobe/grey
	name = "grey wardrobe"
	icon_state = "grey"
	icon_closed = "grey"

/obj/structure/closet/wardrobe/grey/New()
	if(prob(40))
		new /obj/item/clothing/suit/wintercoat(src)
	if(prob(40))
		new /obj/item/clothing/suit/wintercoat(src)
	if(prob(40))
		new /obj/item/clothing/suit/wintercoat(src)
	if(prob(40))
		new /obj/item/clothing/shoes/boots(src)
	if(prob(40))
		new /obj/item/clothing/shoes/boots(src)
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/tie/scarf(src)
	new /obj/item/clothing/tie/scarf(src)
	new /obj/item/clothing/tie/scarf(src)
	new /obj/item/clothing/suit/wintercoat/hoodie/pink(src)
	new /obj/item/clothing/suit/wintercoat/hoodie/blue(src)
	new /obj/item/clothing/suit/wintercoat/hoodie/red(src)
	new /obj/item/clothing/head/beanie(src)
	new /obj/item/clothing/head/beanie(src)
	new /obj/item/clothing/head/beanie(src)
	new /obj/item/clothing/head/soft/grey(src)
	new /obj/item/clothing/head/soft/grey(src)
	new /obj/item/clothing/head/soft/grey(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	if(prob(40))
		new /obj/item/clothing/under/assistantformal(src)
	if(prob(40))
		new /obj/item/clothing/under/color/brownoveralls(src)
	return

/obj/structure/closet/wardrobe/mixed
	name = "mixed wardrobe"
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/wardrobe/mixed/New()
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/under/color/blue(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/lightpink(src)
	new /obj/item/clothing/suit/wintercoat/hoodie/random(src)
	new /obj/item/clothing/suit/wintercoat/hoodie/random(src)
	new /obj/item/clothing/suit/wintercoat/hoodie/random(src)
	new /obj/item/clothing/tie/scarf{color = "#999966"}(src) //tan
	new /obj/item/clothing/tie/scarf{color = "#CCCCFF"}(src) //periwinkle
	new /obj/item/clothing/tie/scarf{color = "#ff6699"}(src) //pink
	if(prob(40))
		new /obj/item/clothing/under/color/lightred(src)
	if(prob(40))
		new /obj/item/clothing/under/color/darkred(src)
	if(prob(40))
		new /obj/item/clothing/under/color/darkblue(src)
	new /obj/item/clothing/under/lightpink(src)
	if(prob(40))
		new /obj/item/clothing/under/color/lightgreen(src)
	if(prob(40))
		new /obj/item/clothing/under/color/yellowgreen(src)
	if(prob(40))
		new /obj/item/clothing/under/color/lightbrown(src)
	new /obj/item/clothing/under/color/brown(src)
	if(prob(40))
		new /obj/item/clothing/under/color/lightpurple(src)
	new /obj/item/clothing/under/color/purple(src)
	new /obj/item/clothing/under/color/aqua(src)
	if(prob(40))
		new /obj/item/clothing/under/color/lightblue(src)
	switch(pick("purple", "yellow", "brown"))
		if ("purple")
			new /obj/item/clothing/shoes/sneakers/purple(src)
		if ("yellow")
			new /obj/item/clothing/shoes/sneakers/yellow(src)
		if ("brown")
			new /obj/item/clothing/shoes/sneakers/brown(src)
	switch(pick("blue", "green", "red"))
		if ("blue")
			new /obj/item/clothing/shoes/sneakers/blue(src)
		if ("green")
			new /obj/item/clothing/shoes/sneakers/green(src)
		if ("red")
			new /obj/item/clothing/shoes/sneakers/red(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	return

/obj/structure/closet/wardrobe/clown
	name = "Honk wardrobe"
	desc = "A closet for clowns. Open at your own risks."
	icon_state = "clownclosed"
	icon_closed = "clownclosed"
	icon_opened = "clownopen"

/obj/structure/closet/wardrobe/clown/New()
	new /obj/item/weapon/storage/backpack/clown(src)
	new /obj/item/clothing/under/rank/clown(src)
	new /obj/item/clothing/gloves/rainbow/clown(src)
	new /obj/item/weapon/storage/backpack/dufflebag/clown(src)
	new /obj/item/clothing/mask/gas/clown_hat(src)
	new /obj/item/clothing/shoes/clown_shoes(src)
	new /obj/item/weapon/coin/clown(src)
	return

/obj/structure/closet/wardrobe/mime
	name = "Silent wardrobe"
	desc = "A closet for mimes. Nearly invisible."
	icon_state = "mimeclosed"
	icon_closed = "mimeclosed"
	icon_opened = "mimeopen"

/obj/structure/closet/wardrobe/mime/New()
	new /obj/item/weapon/storage/backpack/mime(src)
	new /obj/item/clothing/under/mime(src)
	new /obj/item/clothing/suit/suspenders
	new /obj/item/clothing/head/beret(src)
	new /obj/item/clothing/mask/gas/mime(src)
	new /obj/item/clothing/shoes/sneakers/mime(src)
	new /obj/item/clothing/gloves/white
	new /obj/item/toy/crayon/mime(src)
	return

/obj/structure/closet/wardrobe/casual
	name = "casual wardrobe"
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/wardrobe/casual/New()
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/mask/bandana/gold(src)
	new /obj/item/clothing/mask/bandana/blue(src)
	new /obj/item/clothing/mask/bandana/blue(src)
	if(prob(40))
		new /obj/item/clothing/mask/bandana/red(src)
	new /obj/item/clothing/mask/bandana/green(src)
	new /obj/item/clothing/mask/bandana/green(src)
	new /obj/item/clothing/suit/labcoat/jacket(src)
	new /obj/item/clothing/suit/labcoat/jacket(src)
	new /obj/item/clothing/suit/labcoat/jacket(src)
	switch(pick("red", "blue"))
		if ("red")
			new /obj/item/clothing/suit/labcoat/jacket/varsity(src)
		if ("blue")
			new /obj/item/clothing/suit/labcoat/jacket/varsity/blue(src)
	switch(pick("red", "blue"))
		if ("red")
			new /obj/item/clothing/suit/labcoat/jacket/varsity(src)
		if ("blue")
			new /obj/item/clothing/suit/labcoat/jacket/varsity/blue(src)
	switch(pick("red", "blue"))
		if ("red")
			new /obj/item/clothing/suit/labcoat/jacket/varsity(src)
		if ("blue")
			new /obj/item/clothing/suit/labcoat/jacket/varsity/blue(src)
	if(prob(40))
		new /obj/item/clothing/under/camo(src)
	if(prob(40))
		new /obj/item/clothing/under/trackpants(src)
	new /obj/item/clothing/under/khaki(src)
	new /obj/item/clothing/under/jeans(src)
	new /obj/item/clothing/under/jeans(src)
	switch(pick("purple", "yellow", "brown"))
		if ("purple")
			new /obj/item/clothing/shoes/sneakers/purple(src)
		if ("yellow")
			new /obj/item/clothing/shoes/sneakers/yellow(src)
		if ("brown")
			new /obj/item/clothing/shoes/sneakers/brown(src)
	switch(pick("blue", "green", "red"))
		if ("blue")
			new /obj/item/clothing/shoes/sneakers/blue(src)
		if ("green")
			new /obj/item/clothing/shoes/sneakers/green(src)
		if ("red")
			new /obj/item/clothing/shoes/sneakers/red(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	if(prob(40))
		new /obj/item/clothing/under/redoveralls(src)
	return

/obj/structure/closet/wardrobe/medical
	name = "medical wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/medical/New()
	new /obj/item/clothing/under/rank/nursesuit (src)
	new /obj/item/clothing/under/rank/nursesuit (src)
	new /obj/item/clothing/head/nursehat(src)
	new /obj/item/clothing/head/nursehat(src)
	new /obj/item/clothing/suit/labcoat/emt(src)
	new /obj/item/clothing/suit/labcoat/emt(src)
	new /obj/item/clothing/suit/wintercoat/medical/emt(src)
	new /obj/item/clothing/suit/wintercoat/medical/emt(src)
	new /obj/item/clothing/shoes/steeltoe(src)
	new /obj/item/clothing/shoes/steeltoe(src)
	new /obj/item/clothing/suit/labcoat(src)
	new /obj/item/clothing/suit/labcoat(src)
	switch(pick("blue", "green", "purple"))
		if ("blue")
			new /obj/item/clothing/under/rank/medical/blue(src)
		if ("green")
			new /obj/item/clothing/under/rank/medical/green(src)
		if ("purple")
			new /obj/item/clothing/under/rank/medical/purple(src)
	switch(pick("blue", "green", "purple"))
		if ("blue")
			new /obj/item/clothing/under/rank/medical/blue(src)
		if ("green")
			new /obj/item/clothing/under/rank/medical/green(src)
		if ("purple")
			new /obj/item/clothing/under/rank/medical/purple(src)
	switch(pick("blue", "green", "purple"))
		if ("blue")
			new /obj/item/clothing/under/rank/medical/blue(src)
		if ("green")
			new /obj/item/clothing/under/rank/medical/green(src)
		if ("purple")
			new /obj/item/clothing/under/rank/medical/purple(src)
	new /obj/item/clothing/under/rank/medical(src)
	new /obj/item/clothing/under/rank/medical(src)
	new /obj/item/clothing/shoes/sneakers/white(src)
	new /obj/item/clothing/shoes/sneakers/white(src)

/obj/structure/closet/wardrobe/therapist
	name = "therapy wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/therapist/New()
	new /obj/item/clothing/under/rank/therapist (src)
	new /obj/item/clothing/under/rank/therapist (src)
	new /obj/item/clothing/shoes/laceup (src)
	new /obj/item/clothing/shoes/laceup (src)
	new /obj/item/clothing/glasses/regular/hipster (src)
	new /obj/item/clothing/glasses/regular (src)


/obj/structure/closet/wardrobe/work
	name = "old work wardrobe"
	desc = "It's a old storage closet for old Nanotrasen attire."
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/New()
	new /obj/item/clothing/gloves/ntwork(src)
	new /obj/item/clothing/gloves/ntwork(src)
	new /obj/item/clothing/shoes/ntwork(src)
	new /obj/item/clothing/shoes/ntwork(src)
	new /obj/item/clothing/under/ntwork(src)
	new /obj/item/clothing/under/ntwork(src)
