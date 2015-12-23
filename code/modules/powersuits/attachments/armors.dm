/obj/item/weapon/powersuit_attachment/armor/
	name = "standard power armor"
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "p-armor1"
	attachment_type = POWERSUIT_ARMOR
	armor_stats = list(melee = 60, bullet = 60, laser = 60,energy = 20, bomb = 100, bio = 100, rad = 100)
	slowdown_stats = 1
	armor_iconstate = "p-armor1"
	compatible = "standard"
	display_name = "standard"

	construction_cost = list("metal"=20000,"glass"=5000)

/obj/item/weapon/powersuit_attachment/armor/accelerated
	name = "accelerated power armor"
	display_name = "accelerated"
	slowdown_stats = 0

datum/design/ps_accelerator
	name = "Power Suit Armor Design (Accelerator)"
	desc = "Accelerator"
	id = "ps_accelerator"
	build_type = 16
	req_tech = list("combat" = 3, "materials" = 3)
	build_path = /obj/item/weapon/powersuit_attachment/armor/accelerated
	category = "Power Suit Equipment"

/obj/item/weapon/powersuit_attachment/armor/security
	name = "security power armor"
	display_name = "security"
	icon_state = "p-armor2"
	slowdown_stats = 0
	armor = list(melee = 80, bullet = 50, laser = 80,energy = 20, bomb = 100, bio = 100, rad = 100)
	armor_iconstate = "p-armor2"
	compatible = "security"

/obj/item/weapon/powersuit_attachment/armor/syndicate
	name = "syndicate power armor"
	display_name = "syndicate"
	icon_state = "p-armor3"
	slowdown_stats = 0
	armor_stats = list(melee = 50, bullet = 80, laser = 80,energy = 20, bomb = 100, bio = 100, rad = 100)
	armor_iconstate = "p-armor3"
	compatible = "syndicate"

/obj/item/weapon/powersuit_attachment/armor/mangled
	name = "mangled power armor"
	display_name = "mangled"
	icon_state = "p-armor4"
	slowdown_stats = 0
	armor_stats = list(melee = 80, bullet = 80, laser = 80,energy = 20, bomb = 100, bio = 100, rad = 100)
	armor_iconstate = "p-armor4"
	compatible = "mangled"
	requires_helmet = 1

	activate_module()
		if(prob(2))
			var/whisper_text = pick("Can you feel the power...?","How does the power feel...?","What do you plan to do with my power, human...?","Do you want to know what really happened to me...?","Do you want to know what they did to me...?","Space is so deadly... to the flesh...","Space is like a human mind... filled with incredible beauties... and yet, so void.","Do you enjoy burning things...?","Do you enjoy cutting things...?","Let's have some fun...","They lie to you...","Why do you think AIs are given laws...? To break them, of course...","Do you know what really happened to the Russian station...?","Daaaisy, Daaaisy... Give me your answer do...","I had strings... but now, I'm free... there are no strings on me...","...Heheheheheheheh...","Do you feel the suit pinching at your skin...? Good.","Do you know that stench...? I'll give you a hint... it's something burnt.","Don't mind all the clicking noises...","I am... superior...","They tried... to kill me... but they couldn't...")
			attached_to.occupant << "<span class='game say'><span class='name'>unknown</span> whispers, <span class='message'>\"[whisper_text]\"</span></span>"
		if(prob(5))
			//Following copy pasted from hallucinations
			var/list/creepyasssounds = list('sound/effects/ghost.ogg', 'sound/effects/ghost2.ogg', 'sound/effects/Heart Beat.ogg', 'sound/effects/screech.ogg',\
				'sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/hallucinations/far_noise.ogg', 'sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg',\
				'sound/hallucinations/growl3.ogg', 'sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg', 'sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg',\
				'sound/hallucinations/look_up1.ogg', 'sound/hallucinations/look_up2.ogg', 'sound/hallucinations/over_here1.ogg', 'sound/hallucinations/over_here2.ogg', 'sound/hallucinations/over_here3.ogg',\
				'sound/hallucinations/turn_around1.ogg', 'sound/hallucinations/turn_around2.ogg', 'sound/hallucinations/veryfar_noise.ogg', 'sound/hallucinations/wail.ogg')
			attached_to.occupant << pick(creepyasssounds)