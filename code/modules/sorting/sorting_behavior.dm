/datum/sorting_behavior
	var/name = "blank sorting behavior"
	var/datum/sorting_case/case
	var/condition = 1

	proc/GetCase()
		return 0

	New()
		case = GetCase()

	is_crate/
		name = "is crate"

		GetCase()
			return new/datum/sorting_case/typeof(/obj/structure/closet/crate)

	is_item/
		name = "is item"

		GetCase()
			return new/datum/sorting_case/typeof(/obj/item)

	is_human/
		name = "is human"

		GetCase()
			return new/datum/sorting_case/typeof(/mob/living/carbon/human)

	is_dead/
		name = "is dead"

		GetCase()
			return new/datum/sorting_case/binary("stat", EQUALS, 2)

	is_metal/
		name = "is metal"

		GetCase()
			return new/datum/sorting_case/typeof(/obj/item/stack/sheet/metal)

	is_sheet/
		name = "is sheet"

		GetCase()
			return new/datum/sorting_case/typeof(/obj/item/stack/sheet)

	is_paper/
		name = "is paper"

		GetCase()
			return new/datum/sorting_case/typeof(/obj/item/weapon/paper)

	is_secure_crate/
		name = "is secure crate"

		GetCase()
			return new/datum/sorting_case/typeof(/obj/structure/closet/crate/secure)

	is_delivery/
		name = "is delivery"
		GetCase()
			return new/datum/sorting_case/typeof_any(list(/obj/item/smallDelivery,/obj/structure/bigDelivery))

	is_glass/
		name = "is glass"
		GetCase()
			return new/datum/sorting_case/typeof(/obj/item/stack/sheet/glass)

	is_trash/
		name = "is trash"
		GetCase()
			return new/datum/sorting_case/typeof_any(trash_items)

	has_contents/
		name = "crate has contents"

		GetCase()
			return new/datum/sorting_case/listlength("contents", BIGGER_THAN, 0, list(/obj/structure/closet/crate))

	is_recyclable/
		name = "is recyclable"

		GetCase()
			return new/datum/sorting_case/multiple(list("g_amt", "m_amt"), list(BIGGER_THAN, BIGGER_THAN), list(0, 0), ANY_TRUE)
