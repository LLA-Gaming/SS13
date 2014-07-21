/*
* All vanity items go here. (ex. perc zippo, perc cigs, drinks, bobblehead)
*/


/*
* Perc Zippo
*/

/obj/item/weapon/lighter/zippo/perc
	name = "Limited Edition Award Zippo in Recognition of Meritorious Service"
	desc = "This precious limited edition zippo is an award only issued to the longest serving and most meritorious of Enforcers."
	icon_state = "p_zippo"
	item_state = "zippo"
	icon_on = "p_zippoon"
	icon_off = "p_zippo"

/*
* Bobblehead
*/

/obj/item/weapon/bobblehead/blackwell
	name = "Theodore Blackwell"
	desc = "This commemorative bobble head statue is placed here in observance and respect of the Perseus C.E.O. and founder, Theodore Blackwell."
	icon = 'icons/obj/items.dmi'
	icon_state = "bobble"


/*
* Drinks
*/

/obj/item/weapon/reagent_containers/food/drinks/purpledrank
	name = "Purple Drank"
	desc = "Assertive without being pushy, this sweet and fizzy urban beverage is good for what ails you."
	icon_state = "purple_can"

	New()
		..()
		reagents.add_reagent("nuka_cola", 20)
		reagents.add_reagent("lemonjuice", 10)
		reagents.add_reagent("space_drugs", 10)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/drinks/xenoschlag
	name = "Xenoschlag"
	desc = "Black as midnight in a coal mine, this robust oatmeal stout with a bite has dropped many seasoned Enforcers. You were warned."
	icon_state = "xenoschlag"

	New()
		..()
		reagents.add_reagent("atomicbomb", 30)
		reagents.add_reagent("ice", 5)
		reagents.add_reagent("nuka_cola", 5)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/*
* Help Paper
*/

/obj/item/weapon/paper/perseus
	name = "paper- 'RE:HELP!'"
	info = "TO: Acting Heads of the station </br>FROM: the desk of a Dr. Gregory S. Thompson</br>SUBJECT: RE:Help!</br></br>   \
	Due to the hazardous conditions you reported, we here at Nanotransen have moved to hire a crack private military company named 'PERSEUS' to ASSIST \
	in higher priority incidents that happen on the station. They specialise in the capture and extermination of external and internal threats for colonies, \
	ships, and space stations. Their notible experience include combat and capture of xenomorphic alien species, Counter corperation intellegence, and syndicate \
	operatives. Also they utilise expirimental and potentially unethical human augmetation for everything from weapon implant locks to remote mental communications, \
	but there should be no need for concern on your end. Although they do not directly fall under yours or the captains chain of command they have been instructed to work \
	along side you. We ask that you please do your best to help each other, after all you are all on the same side. Keep up the good work and stay out of trouble.</br>              \
	 -Thompson"

/*
* Perc Cigs
*/

/obj/item/weapon/storage/fancy/cigarettes/perc
	name = "Perc Brand Cigarette packet"
	desc = "A pack of Perc Brand Cigarettes. Sponsored by Perseus, the merc team that always smokes Perc. Now with 20% more nicotine."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "pcigpacket"
	item_state = "pcigpacket"
	can_hold = list("/obj/item/clothing/mask/cigarette", "/obj/item/weapon/lighter/zippo/perc")

/*
* Victory Cigar
*/

/obj/item/clothing/mask/cigarette/cigar/victory
	name = "Victory Smokes"
	desc = "Space Cuban cigars, meant only to be smoked in celebration of a job well done."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"