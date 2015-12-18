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
			add_logs(assaulter, victim, "stun punched", addition=" (DAMAGE: 0) (REMHP: DEAD)")
		else
			add_logs(assaulter, victim, "stun punched", addition=" (DAMAGE: 0) (REMHP: [victim.health - 0])")

		//dunk
		victim.Weaken(4)

		return 1