/datum/program/signaller
	name = "Remote Signaling System"
	app_id = "remotesignalingsystem"
	var/obj/item/radio/integrated/radio = null

	use_app()
		radio = tablet.s_radio
		dat = "<h2>Remote Signaling System</h2>"

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


	Topic(href, href_list)
		if (!..()) return
		switch(href_list["choice"])
			if("Send Signal")
				spawn( 0 )
					radio:send_signal("ACTIVATE")
					tablet.attack_self(usr)
					return

			if("Signal Frequency")
				var/new_frequency = sanitize_frequency(radio:frequency + text2num(href_list["sfreq"]))
				radio:set_frequency(new_frequency)

			if("Signal Code")
				radio:code += text2num(href_list["scode"])
				radio:code = round(radio:code)
				radio:code = min(100, radio:code)
				radio:code = max(1, radio:code)
		use_app()
		tablet.attack_self(usr)