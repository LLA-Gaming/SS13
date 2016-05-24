/datum/round_event_control/mystery_gift
	name = "Spawn a Mystery Gift"
	typepath = /datum/round_event/mystery_gift
	event_flags = EVENT_ROUNDSTART | EVENT_HIDDEN
	weight = 10

/datum/round_event/mystery_gift
	var/area/impact_area = null
	var/round_start = 0 //round start variation if non-zero

	Setup()
		if(!round_start)
			impact_area = FindEventAreaNearPeople()
		else
			impact_area = FindEventAreaAwayFromPeople()
		if(!impact_area)
			CancelSelf()

	Start()
		for(var/mob/living/carbon/human/L in area_contents(impact_area))
			events.AddAwards("eventmedal_mysterygift",list("[L.key]"))
		var/list/impact_turfs = FindImpactTurfs(impact_area)
		if(impact_turfs.len)
			var/turf/landing = pick(impact_turfs)
			var/list/considering = list()
			for(var/X in supply_shuttle.supply_packs)
				var/datum/supply_packs/P = supply_shuttle.supply_packs[X] // WHY ARE SUPPLY PACKS CODED LIKE THIS?!!?!?!?!?
				if(P.containertype in typesof(/obj/structure/closet/crate))
					considering.Add(P)
			var/datum/supply_packs/picked = safepick(considering)
			if(picked)
				var/obj/structure/closet/crate/C = new /obj/structure/closet/crate(landing)
				C.name = picked.containername
				for(var/typepath in picked.contains)
					if(!typepath)	continue
					var/atom/I = new typepath(C)
					I.name = "Mysterious " + I.name
				if(picked.access)
					C.req_access = list()
					C.req_access += text2num(picked.access)
				var/obj/structure/bigDelivery/P = new /obj/structure/bigDelivery(get_turf(C))
				C.loc = P
				P.wrapped = C
				P.name = "Mysterious Gift"
				P.icon_state = "giftcrate"
				if(!round_start)
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(5, 0, get_turf(P))
					s.start()