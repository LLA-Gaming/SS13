/datum/program/
	var/name = "Program Name"
	var/dat
	var/obj/item/device/tablet/tablet = null
	var/alertsoff = 0
	var/built_in = 0
	var/app_id
	var/secondary = 0
	var/utility = 0
	var/togglemode = 0
	var/toggleon
	var/price = 0

	//settings
	var/alerts = 1 //are alerts enabled on the program
	var/usesalerts = 0
	var/drm = 0
	var/notifications = 0 // shows a [1] when there is a new notification on the application.

/datum/program/builtin/
	built_in = 1
	drm = 1

/datum/program/proc/use_app()
	return

/datum/program/Topic(href, href_list)
	if(!tablet)
		return 0
	if(!tablet.core)
		return 0
	if(!tablet.can_use(usr))
		return 0
	notifications = 0
	tablet.check_alerts()
	return 1