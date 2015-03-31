//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//TODO: Make these simple_animals

/obj/item/clothing/mask/facehugger/beepsky
	name = "huggable beepsky"
	desc = "It has some sort of a tube at the end of its baton."
	icon = 'icons/mob/alien_b.dmi'
	icon_state = "facehugger_b"
	item_state = "facehugger_b"
	w_class = 1 //note: can be picked up by aliens unlike most other items of w_class below 4
	flags = MASKCOVERSMOUTH | MASKCOVERSEYES | MASKINTERNALS
	throw_range = 5

/obj/item/clothing/mask/facehugger/beepsky/examine()
	..()
	switch(stat)
		if(DEAD,UNCONSCIOUS)
			usr.send_text_to_tab("\red \b [src] is not moving.", "ic")
			usr << "\red \b [src] is not moving."
		if(CONSCIOUS)
			usr.send_text_to_tab("\red \b [src] seems to be active.", "ic")
			usr << "\red \b [src] seems to be active."
	if (sterile)
		usr.send_text_to_tab("\red \b It looks like the baton has been removed.", "ic")
		usr << "\red \b It looks like the baton has been removed."
	return

/obj/item/clothing/mask/facehugger/throw_impact(atom/hit_atom)
	..()
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]"
		Attach(hit_atom)

/obj/item/clothing/mask/facehugger/beepsky/Impregnate(mob/living/target as mob)
	if(!target || target.stat == DEAD) //was taken off or something
		return

	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(C.wear_mask != src)
			return

	if(!sterile)
		//target.contract_disease(new /datum/disease/alien_embryo(0)) //so infection chance is same as virus infection chance
		target.visible_message("\red \b [src] falls limp after violating [target]'s face!")

		Die()

		if(!target.getlimb(/obj/item/organ/limb/robot/chest) && !(target.status_flags & XENO_HOST))
			new /obj/item/alien_embryo/beepsky(target)


		if(iscorgi(target))
			var/mob/living/simple_animal/corgi/C = target
			src.loc = get_turf(C)
			C.facehugger = null
	else
		target.visible_message("\red \b [src] violates [target]'s face!")
	return
