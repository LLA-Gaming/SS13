/obj/item/weapon/disk/rift_data
	name = "mysterious lost data disk"
	desc = "Who knows what this might be."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk0"
	item_state = "card-id"
	w_class = 1.0
	New()
		..()
		icon_state = "datadisk[pick(0,1,2)]"

/obj/item/weapon/disk/research_data
	name = "research_data"
	desc = "Who knows what this might be."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk0"
	item_state = "card-id"
	w_class = 1.0
	New()
		..()
		icon_state = "datadisk[pick(0,1,2)]"

/datum/supply_packs/xeno_artifact
	name = "Xeno Artifact"
	contains = list(/obj/machinery/bot/floorbot)
	containertype = /obj/structure/closet/crate/
	notavailable = 1