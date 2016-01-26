/datum/wires/telepad
	holder_type = /obj/machinery/telepad
	wire_count = 4

var/const/TELEPAD_ACTIVATE = 1
var/const/TELEPAD_SEND_RECEIVE = 2
var/const/TELEPAD_CALIBRATE = 4
var/const/TELEPAD_LINK = 8

/datum/wires/telepad/CanUse(var/mob/living/L)
	var/obj/machinery/telepad/T = holder
	if(T.panel_open)
		return 1
	return 0

/datum/wires/telepad/GetInteractWindow()
	var/obj/machinery/telepad/T = holder
	. += ..()
	. += "<BR>The green light is [T.computer ? "on" : "off"].<BR>"
	. += "The red light is [T.cant_activate ? "on" : "off"].<BR>"
	. += "The orange light is [T.cant_switch ? "on" : "off"].<BR>"
	. += "The purple light is [T.cant_calibrate ? "on" : "off"].<BR>"
	. += "The yellow light is [T.cant_link ? "on" : "off"].<BR>"
	if(T.computer)
		. += "A [T.computer.sending ? "light blue" : "dark blue"] light is on.<BR>"

/datum/wires/telepad/UpdatePulsed(var/index)
	var/obj/machinery/telepad/T = holder
	var/obj/machinery/computer/telescience/C = T.computer
	switch(index)
		if(TELEPAD_ACTIVATE)
			if(T.computer)
				C.teleport(usr)
		if(TELEPAD_SEND_RECEIVE)
			if(T.computer)
				C.sending = !C.sending
		if(TELEPAD_CALIBRATE)
			if(T.computer)
				C.recalibrate()
				C.sparks()
		if(TELEPAD_LINK)
			if(T.computer)
				C.telepad = null
				T.computer = null

/datum/wires/telepad/UpdateCut(var/index, var/mended)
	var/obj/machinery/telepad/T = holder
	switch(index)
		if(TELEPAD_ACTIVATE)
			T.cant_activate = !mended
		if(TELEPAD_SEND_RECEIVE)
			T.cant_switch = !mended
		if(TELEPAD_CALIBRATE)
			T.cant_calibrate = !mended
		if(TELEPAD_LINK)
			T.cant_link = !mended
			if(T.computer)
				T.computer.telepad = null
				T.computer = null