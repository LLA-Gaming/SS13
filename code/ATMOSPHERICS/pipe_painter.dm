/obj/item/weapon/pipe_painter
	name = "Pipe Painter"
	desc = "A specialized tool for painting atmospheric pipes and devices."
	icon = 'icons/obj/objects.dmi'
	icon_state = "paint sprayer"
	item_state = "paint sprayer"
	color = "cyan"
	var/list/colors = list("Red" = "red","Blue" = "blue", "Lime" = "#00FF00", "Green" = "#00C000", "Yellow" = "yellow", "Purple" = "#FF00FF", "Cyan" = "cyan", "Pink" = "#FF69B4", "Clear" = "#FFFFFF")
	var/paint_color

	w_class = 2.0

	origin_tech = "engineering=1"

	flags = CONDUCT
	slot_flags = SLOT_BELT

	force = 0
/obj/item/weapon/pipe_painter/New()
	..()
	paint_color = pick(colors)
	return

/obj/item/weapon/pipe_painter/attack_self(mob/user as mob)
	..()
	paint_color = input("Set Color") in colors
	return
