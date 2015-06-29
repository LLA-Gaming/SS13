/obj/item/device/tablet_core
	name = "Computer Core"
	desc = "A Core Disk for portable ThinkTronic devices."
	icon = 'icons/obj/module.dmi'
	icon_state = "mainboard"
	w_class = 1
	var/owner = null // String name of owner
	var/ownjob = null //related to above
	var/cash = 20
	var/toner = 30
	var/list/files = list()
	var/list/downloads = list()

	var/neton = 1
	var/volume = 1
	var/ttone = "beep"

	var/datum/program/loaded
	var/list/programs = list()