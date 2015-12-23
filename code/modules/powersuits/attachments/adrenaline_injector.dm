/obj/item/weapon/powersuit_attachment/adrenaline_injector
	name = "adrenaline injector module"
	attachment_type = POWERSUIT_SECONDARY

	activate_module()
		if(!attached_to.turbo)
			attached_to.cell.charge -= 2500

			attached_to.occupant << "<span class='notice'>You feel a sudden surge of energy!</span>"
			attached_to.occupant.SetStunned(0)
			attached_to.occupant.SetWeakened(0)
			attached_to.occupant.SetParalysis(0)
			attached_to.occupant.lying = 0
			attached_to.occupant.update_canmove()

			attached_to.occupant.reagents.add_reagent("synaptizine", 10)
			attached_to.occupant.say("*scream")

			//TURBO MODE
			var/obj/item/clothing/suit/space/powersuit/suit = attached_to
			suit.turbo = 1
			suit.slowdown = -1
			spawn(100)
				suit.turbo = 0
				suit.update_stats()

datum/design/ps_adrenaline_injector
	name = "Power Suit Module Design (Adrenaline Injector)"
	desc = "Adrenaline Injector"
	id = "ps_adrenaline_injector"
	build_type = 16
	req_tech = list("combat" = 4, "biotech"=4)
	build_path = /obj/item/weapon/powersuit_attachment/adrenaline_injector
	category = "Power Suit Equipment"
