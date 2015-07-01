/datum/program/mule_control
	name = "Delivery Bot Control"
	app_id = "mulebotcontrol"

	use_app()
		var/obj/item/radio/integrated/mule/QC = tablet.m_radio
		if(!QC)
			dat = "Interlink Error - Please reboot system."
			return

		dat = "<h4>M.U.L.E. bot Interlink V0.8</h4>"

		if(!QC.active)
			// list of bots
			if(!QC.botlist || (QC.botlist && QC.botlist.len==0))
				dat += "No bots found.<BR>"

			else
				for(var/obj/machinery/bot/mulebot/B in QC.botlist)
					dat += format_text("<A href='byond://?src=\ref[QC];op=control;bot=\ref[B]'>[B] at [get_area(B)]</A><BR>")

			dat += "<BR><A href='byond://?src=\ref[QC];op=scanbots'>Scan for active bots</A><BR>"

		else	// bot selected, control it

			dat += format_text("<B>[QC.active]</B><BR> Status: (<A href='byond://?src=\ref[QC];op=control;bot=\ref[QC.active]'><i>refresh</i></A>)<BR>")

			if(!QC.botstatus)
				dat += "Waiting for response...<BR>"
			else

				dat += format_text("Location: [QC.botstatus["loca"] ]<BR>")
				dat += "Mode: "

				switch(QC.botstatus["mode"])
					if(0)
						dat += "Ready"
					if(1)
						dat += "Loading/Unloading"
					if(2)
						dat += "Navigating to Delivery Location"
					if(3)
						dat += "Navigating to Home"
					if(4)
						dat += "Waiting for clear path"
					if(5,6)
						dat += "Calculating navigation path"
					if(7)
						dat += "Unable to locate destination"
				var/obj/structure/closet/crate/C = QC.botstatus["load"]
				dat += format_text("<BR>Current Load: [ !C ? "<i>none</i>" : "[C.name] (<A href='byond://?src=\ref[QC];op=unload'><i>unload</i></A>)" ]<BR>")
				dat += format_text("Destination: [!QC.botstatus["dest"] ? "<i>none</i>" : QC.botstatus["dest"] ] (<A href='byond://?src=\ref[QC];op=setdest'><i>set</i></A>)<BR>")
				dat += format_text("Power: [QC.botstatus["powr"]]%<BR>")
				dat += format_text("Home: [!QC.botstatus["home"] ? "<i>none</i>" : QC.botstatus["home"] ]<BR>")
				dat += format_text("Auto Return Home: [QC.botstatus["retn"] ? "<B>On</B> <A href='byond://?src=\ref[QC];op=retoff'>Off</A>" : "(<A href='byond://?src=\ref[QC];op=reton'><i>On</i></A>) <B>Off</B>"]<BR>")
				dat += format_text("Auto Pickup Crate: [QC.botstatus["pick"] ? "<B>On</B> <A href='byond://?src=\ref[QC];op=pickoff'>Off</A>" : "(<A href='byond://?src=\ref[QC];op=pickon'><i>On</i></A>) <B>Off</B>"]<BR><BR>")

				dat += format_text("\[<A href='byond://?src=\ref[QC];op=stop'>Stop</A>\] ")
				dat += format_text("\[<A href='byond://?src=\ref[QC];op=go'>Proceed</A>\] ")
				dat += format_text("\[<A href='byond://?src=\ref[QC];op=home'>Return Home</A>\]<BR>")
				dat += format_text("<HR><A href='byond://?src=\ref[QC];op=botlist'>Return to bot list</A>")