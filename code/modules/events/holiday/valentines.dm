/datum/round_event_control/valentines
	name = "Valentines"
	holidayID = "Valentine's Day"
	typepath = /datum/round_event/valentines
	event_flags = EVENT_SPECIAL
	weight = 10
	max_occurrences = 1

/datum/round_event/valentines/
	alert_when = 40
	var/mob/living/carbon/human/special_someone

	Start()
		if (!prevent_stories) EventStory("Happy Valentine's Day!")
		//pick the valentine
		var/list/cmembers = list()
		for(var/mob/living/carbon/human/H in living_mob_list)
			if(H.mind && H.mind.is_crewmember())
				cmembers.Add(H)
		special_someone = safepick(cmembers)
		if(special_someone)
			var/obj/item/weapon/storage/box/C = new /obj/item/weapon/storage/box
			if(!special_someone.equip_to_slot_if_possible(C, slot_l_hand, 0, 1, 1)) //slot in left hand if possible
				special_someone.equip_to_slot_if_possible(C, slot_r_hand, 0, 1, 1) //slot in right hand if possible
			special_someone << "<span class = 'warning'>Love is in the air tonight, you have been given a box of carnations!</span>"
			for(var/i = 0 , i<7, i++)
				var/obj/item/clothing/mask/carnation/special_carnation = new /obj/item/clothing/mask/carnation(C)
				special_carnation.name = "[special_someone.real_name]'s carnation"
				special_carnation.desc = "this carnation represents the love and affection of [special_someone.real_name]"
		else //umm no valentine, put something else
			special_someone = "Ian"
		//give everyone a carnation
		for(var/mob/living/carbon/human/H in living_mob_list)
			if(!H.mind) continue //no NPCs
			if(H == special_someone) continue
			var/picked_type = pick(/obj/item/clothing/mask/carnation/pink,/obj/item/clothing/mask/carnation/white,/obj/item/clothing/mask/carnation/blue)
			var/obj/item/clothing/mask/carnation/C = new picked_type
			C.name = "[H.real_name]'s carnation"
			C.desc = "this carnation represents the love and affection of [H.real_name]"
			if(H.equip_to_appropriate_slot(C)) //slot in something if possible
				continue
			if(H.equip_to_slot_if_possible(C, slot_l_hand, 0, 1, 1)) //slot in left hand if possible
				continue
			if(H.equip_to_slot_if_possible(C, slot_r_hand, 0, 1, 1)) //slot in right hand if possible
				continue
			else
				C.loc = get_turf(H)
				continue //give up and spawn it on the floor

	Alert()
		if(special_someone) //the game should avoid announcing if its a false alarm
			priority_announce("[special_someone] is in need of a special someone", "Happy Valentine's Day")



//items
/obj/item/clothing/mask/carnation
	name = "carnation"
	desc = "to give to that special someone"
	icon = 'icons/obj/valentine.dmi'
	slot_flags = SLOT_MASK
	w_class = 2
	icon_state = "rose_red"
	item_state = "rose_red"

/obj/item/clothing/mask/carnation/pink
	icon_state = "rose_pink"
	item_state = "rose_pink"

/obj/item/clothing/mask/carnation/white
	icon_state = "rose_white"
	item_state = "rose_white"

/obj/item/clothing/mask/carnation/blue
	icon_state = "rose_blue"
	item_state = "rose_blue"