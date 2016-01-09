/obj/structure/triage_table
	name = "triage table"
	icon = 'icons/obj/structures.dmi'
	icon_state = "triage_table"
	density = 1
	anchored = 1

	broken/
		name = "broken triage table"
		icon_state = "triage_table_broken"

	bloody/
		name = "bloody triage table"
		icon_state = "triage_table_bloody"

/obj/structure/alien_artifact
	name = "strange artifact"
	icon = 'icons/obj/structures.dmi'
	icon_state = "alien_artifact"
	density = 1

	artifact2/
		icon_state = "alien_artifact_2"

/obj/machinery/keycard_trigger
	name = "key-card terminal"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"

	var/_accepts = "*PATH HERE*"
	var/completed = 0

	initialize()
		if(istext(_accepts))
			_accepts = text2path(_accepts)

	update_icon()
		if(!completed)
			icon_state = "auth_off"
		else
			icon_state = "auth_on"

	attackby(var/obj/item/I, var/mob/living/L)
		if(completed)
			L << "<span class='info'>\The [src] is already activated.</span>"
			return 0

		if(!istype(I, _accepts))
			L << "<span class='warning'>\The [src] refuses \the [I].</span>"
			playsound(get_turf(src), 'sound/machines/buzz-sigh.ogg', 50)
			return 0

		L << "<span class='info'>You swipe \the [I].</span>"
		playsound(get_turf(src), 'sound/machines/chime.ogg', 50)

		var/obj/effect/trigger_modules/conditional/keycard_trigger/trigger = locate() in get_turf(src)
		if(trigger)
			trigger.triggered = 1

		completed = 1

		update_icon()