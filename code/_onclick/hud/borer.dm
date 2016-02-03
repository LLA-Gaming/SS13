/datum/hud/proc/borer_hud(ui_style = 'icons/mob/screen_midnight.dmi')
	adding = list()

	lingchemdisplay = new /obj/screen()
	lingchemdisplay.name = "chemicals stored"
	lingchemdisplay.icon_state = "power_display"
	lingchemdisplay.screen_loc = ui_lingchemdisplay
	adding += lingchemdisplay

	mymob.healths = new /obj/screen()
	mymob.healths.icon_state = null
	mymob.healths.name = "health"
	mymob.healths.screen_loc = ui_health
	adding += mymob.healths

	mymob.staminas = new /obj/screen()
	mymob.staminas.icon_state = null
	mymob.staminas.name = "stamina"
	mymob.staminas.screen_loc = ui_stamina
	adding += mymob.staminas

	mymob.nutrition_icon = new /obj/screen()
	mymob.nutrition_icon.icon_state = null
	mymob.nutrition_icon.name = "nutrition"
	mymob.nutrition_icon.screen_loc = ui_nutrition
	adding += mymob.nutrition_icon

	mymob.client.screen = null
	mymob.client.screen += adding