/obj/machinery/computer3/server
	name			= "server"
	icon			= 'icons/obj/computer3.dmi'
	icon_state		= "serverframe"
	show_keyboard	= 0

/obj/machinery/computer3/server/rack
	name = "server rack"
	icon_state = "rackframe"

	spawn_parts = list(/obj/item/part/computer/storage/hdd,/obj/item/part/computer/networking/radio/subspace)

	update_icon()
		//overlays.Cut()
		return

	attack_hand() // Racks have no screen, only AI can use them
		return
