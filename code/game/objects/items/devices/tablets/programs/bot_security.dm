/datum/program/securitron_control
	name = "Securitron Control"
	app_id = "beepskycontrol"

	use_app()

		var/obj/item/radio/integrated/beepsky/SC = tablet.b_radio
		if(!SC)
			dat = "Interlink Error - Please reboot system."
			return

		dat = "<h4>Securitron Interlink</h4>"

		if(!SC.active)
			// list of bots
			if(!SC.botlist || (SC.botlist && SC.botlist.len==0))
				dat += "No bots found.<BR>"

			else
				for(var/obj/machinery/bot/secbot/B in SC.botlist)
					dat += format_text("<A href='byond://?src=\ref[SC];op=control;bot=\ref[B]'>[B] at [B.loc.loc]</A><BR>")

			dat += format_text("<BR><A href='byond://?src=\ref[SC];op=scanbots'>Scan for active bots</A><BR>")

		else	// bot selected, control it

			dat += format_text("<B>[SC.active]</B><BR> Status: (<A href='byond://?src=\ref[SC];op=control;bot=\ref[SC.active]'><i>refresh</i></A>)<BR>")

			if(!SC.botstatus)
				dat += "Waiting for response...<BR>"
			else

				dat += format_text("Location: [SC.botstatus["loca"] ]<BR>")
				dat += "Mode: "

				switch(SC.botstatus["mode"])
					if(0)
						dat += "Ready"
					if(1)
						dat += "Apprehending target"
					if(2,3)
						dat += "Arresting target"
					if(4)
						dat += "Starting patrol"
					if(5)
						dat += "On patrol"
					if(6)
						dat += "Responding to summons"

				dat += "<BR>\[<A href='byond://?src=\ref[SC];op=stop'>Stop Patrol</A>\] "
				dat += "\[<A href='byond://?src=\ref[SC];op=go'>Start Patrol</A>\] "
				dat += "\[<A href='byond://?src=\ref[SC];op=summon'>Summon Bot</A>\]<BR>"
				dat += "<HR><A href='byond://?src=\ref[SC];op=botlist'>Return to bot list</A>"