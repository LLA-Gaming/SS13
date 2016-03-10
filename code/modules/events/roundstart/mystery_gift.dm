/datum/round_event_control/mystery_gift
	name = "Mystery Gift"
	typepath = /datum/round_event/mystery_gift
	event_flags = EVENT_ROUNDSTART
	weight = 10

/datum/round_event/mystery_gift
	var/area/impact_area = null

	Setup()
		impact_area = FindEventAreaAwayFromPeople()
		if(!impact_area)
			CancelSelf()

	Start()
		var/list/impact_turfs = FindImpactTurfs(impact_area)
		if(impact_turfs.len)
			var/turf/landing = pick(impact_turfs)
			var/obj/structure/closet/crate/C = new /obj/structure/closet/crate/(landing)
			new /obj/item/weapon/storage/belt{name = "multi-belt"}(landing)
			new /obj/item/clothing/gloves/yellow(landing)
			new /obj/item/device/multitool(landing)
			new /obj/item/weapon/storage/toolbox/mechanical(landing)
			C.close()
			var/obj/structure/bigDelivery/P = new /obj/structure/bigDelivery(get_turf(C))
			C.loc = P
			P.wrapped = C
			P.name = "Mysterious Gift"
			P.icon_state = "giftcrate"







