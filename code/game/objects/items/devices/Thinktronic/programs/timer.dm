/obj/item/device/thinktronic_parts/program/general/timer
	name = "Timer"
	var/timing = 0
	var/time = 5
	var/cooldown = 0//To prevent spam

	use_app()
		var/second = time % 60
		var/minute = (time - second) / 60
		dat = ""
		dat += text("<TT><B>Timing Unit</B>\n[] []:[]\n<A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>\n</TT>", (timing ? text("<A href='?src=\ref[];time=0'>Timing</A>", src) : text("<A href='?src=\ref[];time=1'>Not Timing</A>", src)), minute, second, src, src, src, src)

	proc/activate()
		if(!..())	return 0//Cooldown check
		timing = !timing
		return 0

	proc/process_cooldown()							//Called via spawn(10) to have it count down the cooldown var
		return

	proc/timer_end()
		if(cooldown > 0)	return 0
		cooldown = 2
		spawn(10)
			process_cooldown()
		return


	process()
		var/obj/item/device/thinktronic_parts/core/hdd = loc // variable for interactin with the HDD
		var/obj/item/device/thinktronic/PDA = hdd.loc // variable for interacting with the Device itself
		if(timing && (time > 0))
			time--
			PDA.ForceRefresh()
		if(timing && time <= 0)
			timing = 0
			timer_end()
			processing_objects -= src
			for (var/mob/O in hearers(1, PDA.loc))
				if(PDA.volume)
					playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
					O.show_message(text("\icon[PDA] *[hdd.ttone]* - Timer has ended!"))
			PDA.ForceRefresh()
			time = initial(time)
		return

	Topic(href, href_list) // This is here
		..()
		var/obj/item/device/thinktronic_parts/core/hdd = loc // variable for interactin with the HDD
		var/obj/item/device/thinktronic/PDA = hdd.loc // variable for interacting with the Device itself
		if(href_list["time"])
			timing = text2num(href_list["time"])
			if(timing)
				processing_objects += src
			if(!timing)
				processing_objects -= src
			PDA.attack_self(usr)

		if(href_list["tp"])
			var/tp = text2num(href_list["tp"])
			time += tp
			time = min(max(round(time), 1), 600)
			PDA.attack_self(usr)