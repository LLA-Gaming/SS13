/obj/item/weapon/powersuit_attachment/adrenaline_injector
	name = "adrenaline injector module"
	attachment_type = POWERSUIT_SECONDARY

	activate_module()
		attached_to.cell.charge -= 2500

		attached_to.occupant << "<span class='notice'>You feel a sudden surge of energy!</span>"
		attached_to.occupant.SetStunned(0)
		attached_to.occupant.SetWeakened(0)
		attached_to.occupant.SetParalysis(0)
		attached_to.occupant.lying = 0
		attached_to.occupant.update_canmove()

		attached_to.occupant.reagents.add_reagent("synaptizine", 10)
		attached_to.occupant.reagents.add_reagent("hyperzine", 10)
		attached_to.occupant.say("*scream")

