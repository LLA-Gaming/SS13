/obj/item/weapon/powersuit_attachment/hudvision
	name = "HUD-Vision module"
	attachment_type = POWERSUIT_SECONDARY
	var/list/huds = list()
	var/mode = 0

	New()
		..()
		huds.Add(new /obj/item/clothing/glasses/meson(src)) //meson
		huds.Add(new /obj/item/clothing/glasses/night(src)) //night
		huds.Add(new /obj/item/clothing/glasses/hud/atmos(src)) //atmos
		huds.Add(new /obj/item/clothing/glasses/hud/security(src)) //security
		huds.Add(new /obj/item/clothing/glasses/hud/health/(src)) // medical


	activate_module()
		mode++
		if(mode > huds.len)
			mode = 0
		if(!mode)
			attached_to.current_vision = null
			attached_to.occupant << "You turn HUD-Vision off"
			active_vision = 0
			return
		else
			if(istype(huds[mode],/obj/item/clothing/glasses/))
				attached_to.current_vision = huds[mode]
				attached_to.occupant << "You toggle HUD-vision to [huds[mode]]"
				active_vision = 1