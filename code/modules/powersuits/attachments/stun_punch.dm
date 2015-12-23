/obj/item/weapon/powersuit_attachment/stun_punch
	name = "stun punch module"
	attachment_type = POWERSUIT_PRIMARY

	power_punch(var/mob/living/victim, var/mob/living/assaulter, var/obj/item/organ/limb/affecting, var/armor_block, var/a_intent)

		if(!victim.lying || a_intent != "disarm")
			return

		attached_to.cell.charge -= 500

		victim.visible_message("<span class='danger'>[assaulter] stun-punchs [victim]!</span>", \
						"<span class='userdanger'>[assaulter] stun-punchs [victim]!</span>")
		playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
		//logging
		if (victim.stat == DEAD)
			add_logs(assaulter, victim, "stun punched", addition=" (DAMAGE: [fist_damage]) (REMHP: DEAD)")
		else
			add_logs(assaulter, victim, "stun punched", addition=" (DAMAGE: [fist_damage]) (REMHP: [victim.health - fist_damage])")

		//dunk
		victim.Weaken(4)

		return 1

datum/design/ps_stun_punch
	name = "Power Suit Module Design (Stun Punch)"
	desc = "Stun Punch"
	id = "ps_stun_punch"
	build_type = 16
	req_tech = list("combat" = 6,"engineering" = 5)
	build_path = /obj/item/weapon/powersuit_attachment/cosmic_kick
	category = "Power Suit Equipment"
