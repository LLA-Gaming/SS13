/*
* Fabricator Circuit Board
*/

/obj/item/weapon/circuitboard/podfab
	name = "circuit board (Pod Fabricator)"
	build_path = /obj/machinery/part_fabricator/pod
	board_type = "machine"
	origin_tech = "programming=3;engineering=3"
	req_components = list(
							"/obj/item/weapon/stock_parts/matter_bin" = 2,
							"/obj/item/weapon/stock_parts/manipulator" = 1,
							"/obj/item/weapon/stock_parts/micro_laser" = 1,
							"/obj/item/weapon/stock_parts/console_screen" = 1)

/*
* Pod Fabricator
*/

/obj/machinery/part_fabricator/pod
	name = "space pod fabricator"
	icon_state = "pod-fab"
	build_type = PODFAB
	place_dir = 0
	req_access = list()
	board_type = /obj/item/weapon/circuitboard/podfab

	New()
		..()

		var/list/categories = list()
		for(var/datum/design/D in files.known_designs)
			if(!(D.category in categories))
				categories += D.category
				add_part_set(D.category, list())

		listclearnulls(part_sets)

		convert_designs()

/*
* RnD Console
*/

/obj/machinery/computer/rdconsole/podbay
	name = "Pod Manufacturing R&D Console"
	id = 3
	req_access = list()
