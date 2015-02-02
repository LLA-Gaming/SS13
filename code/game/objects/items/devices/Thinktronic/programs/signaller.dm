/obj/item/device/thinktronic_parts/program/general/signaller
	name = "Remote Signaling System"
	var/obj/item/tabletradio/integrated/radio = null

	New()
		..()
		radio = new /obj/item/tabletradio/integrated/signal(src)

	use_app()
		dat = "<h4>Remote Signaling System</h4>"

		dat += {"
				<a href='byond://?src=\ref[src];choice=Send Signal'>Send Signal</A><BR>
				Frequency:
				<a href='byond://?src=\ref[src];choice=Signal Frequency;sfreq=-10'>-</a>
				<a href='byond://?src=\ref[src];choice=Signal Frequency;sfreq=-2'>-</a>
				[format_frequency(radio:frequency)]
				<a href='byond://?src=\ref[src];choice=Signal Frequency;sfreq=2'>+</a>
				<a href='byond://?src=\ref[src];choice=Signal Frequency;sfreq=10'>+</a><br>
				<br>
				Code:
				<a href='byond://?src=\ref[src];choice=Signal Code;scode=-5'>-</a>
				<a href='byond://?src=\ref[src];choice=Signal Code;scode=-1'>-</a>
				[radio:code]
				<a href='byond://?src=\ref[src];choice=Signal Code;scode=1'>+</a>
				<a href='byond://?src=\ref[src];choice=Signal Code;scode=5'>+</a><br>"}


	Topic(href, href_list) // This is here
		..()
		var/obj/item/device/thinktronic_parts/core/hdd = loc // variable for interactin with the HDD
		var/obj/item/device/thinktronic/PDA = hdd.loc // variable for interacting with the Device itself
		switch(href_list["choice"])
			if("Send Signal")
				spawn( 0 )
					radio:send_signal("ACTIVATE")
					PDA.attack_self(usr)
					return

			if("Signal Frequency")
				var/new_frequency = sanitize_frequency(radio:frequency + text2num(href_list["sfreq"]))
				radio:set_frequency(new_frequency)
				PDA.attack_self(usr)

			if("Signal Code")
				radio:code += text2num(href_list["scode"])
				radio:code = round(radio:code)
				radio:code = min(100, radio:code)
				radio:code = max(1, radio:code)
				PDA.attack_self(usr)
