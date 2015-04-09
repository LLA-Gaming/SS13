/proc/getbrokeninhands()
	var/list/righthand_icons = list('icons/mob/inhands/items_righthand.dmi', 'icons/mob/inhands/clothing_righthand.dmi', 'icons/mob/inhands/weapons_righthand.dmi')
	var/list/lefthand_icons = list('icons/mob/inhands/items_lefthand.dmi', 'icons/mob/inhands/clothing_lefthand.dmi', 'icons/mob/inhands/weapons_lefthand.dmi')
	var/list/Lstates
	var/list/Rstates
	for(var/icon/I in lefthand_icons)
		Lstates.Add(I.IconStates())
	for(var/icon/I in righthand_icons)
		Rstates.Add(I.IconStates())



	var/text
	for(var/A in typesof(/obj/item))
		var/obj/item/O = new A( locate(1,1,1) )
		if(!O) continue
		var/icon/J = new(O.icon)
		var/list/istates = J.IconStates()
		if(!Lstates.Find(O.icon_state) && !Lstates.Find(O.item_state))
			if(O.icon_state)
				text += "[O.type] WANTS IN LEFT HAND CALLED\n\"[O.icon_state]\".\n"
		if(!Rstates.Find(O.icon_state) && !Rstates.Find(O.item_state))
			if(O.icon_state)
				text += "[O.type] WANTS IN RIGHT HAND CALLED\n\"[O.icon_state]\".\n"


		if(O.icon_state)
			if(!istates.Find(O.icon_state))
				text += "[O.type] MISSING NORMAL ICON CALLED\n\"[O.icon_state]\" IN \"[O.icon]\"\n"
		if(O.item_state)
			if(!istates.Find(O.item_state))
				text += "[O.type] MISSING NORMAL ICON CALLED\n\"[O.item_state]\" IN \"[O.icon]\"\n"
		text+="\n"
		qdel(O)
	if(text)
		var/F = file("broken_icons.txt")
		fdel(F)
		F << text
		world << "Completely successfully and written to [F]"


