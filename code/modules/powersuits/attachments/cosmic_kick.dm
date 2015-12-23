/obj/item/weapon/powersuit_attachment/cosmic_kick
	name = "cosmic kick module"
	attachment_type = POWERSUIT_PRIMARY
	fist_damage = 13

	power_punch(var/mob/living/victim, var/mob/living/assaulter, var/obj/item/organ/limb/affecting, var/armor_block, var/a_intent)

		if(!victim.lying)
			return

		attached_to.cell.charge -= 100

		victim.visible_message("<span class='danger'>[assaulter] kicks [victim]!</span>", \
						"<span class='userdanger'>[assaulter] kicks [victim]!</span>")
		var/hitsound = pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg')
		playsound(src, hitsound, 50, 1)

		victim.apply_damage(fist_damage, BRUTE, affecting, armor_block)

		//logging
		if (victim.stat == DEAD)
			add_logs(assaulter, victim, "cosmic kicked", addition=" (DAMAGE: [fist_damage]) (REMHP: DEAD)")
		else
			add_logs(assaulter, victim, "cosmic kicked", addition=" (DAMAGE: [fist_damage]) (REMHP: [victim.health - fist_damage])")


		//dunk
		victim.Weaken(1)
		spawn(0)
			for(var/i=0;7 > i; i++)
				if(!step(victim, assaulter.dir))
					break
				sleep(0.3)

		return 1

datum/design/ps_cosmic_kick
	name = "Power Suit Module Design (Cosmic Kick)"
	desc = "Cosmic Kick"
	id = "ps_cosmic_kick"
	build_type = 16
	req_tech = list("combat" = 5)
	build_path = /obj/item/weapon/powersuit_attachment/cosmic_kick
	category = "Power Suit Equipment"
