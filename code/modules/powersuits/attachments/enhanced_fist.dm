/obj/item/weapon/powersuit_attachment/enhanced_fist
	name = "power fist module"
	attachment_type = POWERSUIT_PRIMARY
	fist_damage = 9

	power_punch(var/mob/living/carbon/human/victim, var/mob/living/assaulter, var/obj/item/organ/limb/affecting, var/armor_block, var/a_intent)

		if(a_intent == "harm")
			var/fist_damage = 9
			victim.visible_message("<span class='danger'>[assaulter] pulverizes [victim]!</span>", \
							"<span class='userdanger'>[assaulter] pulverizes [victim]!</span>")
			var/hitsound = pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg')
			playsound(src, hitsound, 50, 1)

			victim.apply_damage(fist_damage, BRUTE, affecting, armor_block)
			//logging
			if (victim.stat == DEAD)
				add_logs(assaulter, victim, "power punched", addition=" (DAMAGE: [fist_damage]) (REMHP: DEAD)")
			else
				add_logs(assaulter, victim, "power punched", addition=" (DAMAGE: [fist_damage]) (REMHP: [victim.health - fist_damage])")
			return 1

		if(a_intent == "disarm" && !victim.lying)
			var/mob/living/M = assaulter
			add_logs(M, victim, "disarmed")
			var/randn = rand(1, 100)
			if(randn <= 50)
				victim.apply_effect(2, WEAKEN, victim.run_armor_check(affecting, "melee"))
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				victim.visible_message("<span class='danger'>[M] has pushed [victim]!</span>",
								"<span class='userdanger'>[M] has pushed [victim]!</span>")
				victim.forcesay(hit_appends)
				step_away(victim,src,15)
				return 1

			var/talked = 0	// BubbleWrap

			if(randn >= 51)
				//BubbleWrap: Disarming breaks a pull
				if(victim.pulling)
					victim.visible_message("<span class='warning'>[M] has broken [victim]'s grip on [victim.pulling]!</span>")
					talked = 1
					victim.stop_pulling()

				//BubbleWrap: Disarming also breaks a grab - this will also stop someone being choked, won't it?
				if(istype(victim.l_hand, /obj/item/weapon/grab))
					var/obj/item/weapon/grab/lgrab = victim.l_hand
					if(lgrab.affecting)
						victim.visible_message("<span class='warning'>[M] has broken [victim]'s grip on [lgrab.affecting]!</span>")
						talked = 1
					spawn(1)
						qdel(lgrab)
				if(istype(victim.r_hand, /obj/item/weapon/grab))
					var/obj/item/weapon/grab/rgrab = victim.r_hand
					if(rgrab.affecting)
						victim.visible_message("<span class='warning'>[M] has broken [victim]'s grip on [rgrab.affecting]!</span>")
						talked = 1
					spawn(1)
						qdel(rgrab)
				//End BubbleWrap

				if(!talked)	//BubbleWrap
					victim.drop_item()
					victim.visible_message("<span class='danger'>[M] has disarmed [victim]!</span>", \
									"<span class='userdanger'>[M] has disarmed [victim]!</span>")
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				return 1


		return 0

