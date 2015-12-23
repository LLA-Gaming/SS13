/obj/item/weapon/powersuit_attachment/smoke_bombs
	name = "smoke bomb module"
	attachment_type = POWERSUIT_SECONDARY
	var/cooldown = 0

	activate_module()
		if(cooldown)
			return
		attached_to.cell.charge -= 250

		var/datum/effect/effect/system/bad_smoke_spread/smoke = new /datum/effect/effect/system/bad_smoke_spread()
		smoke.set_up(10, 0, attached_to.loc)
		smoke.start()
		playsound(attached_to.loc, 'sound/effects/bamf.ogg', 50, 2)
		cooldown = 1
		spawn(100)
			cooldown = 0

datum/design/ps_smoke_bombs
	name = "Power Suit Module Design (Smoke Bombs)"
	desc = "Smoke Bomb"
	id = "ps_smoke_bomb"
	build_type = 16
	req_tech = list("combat" = 3)
	build_path = /obj/item/weapon/powersuit_attachment/smoke_bombs
	category = "Power Suit Equipment"
