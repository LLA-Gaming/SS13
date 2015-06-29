/datum/program/powermonitor
	name = "Power Monitor"
	app_id = "powermonitor"
	var/obj/machinery/computer/monitor/powmonitor = null // Power Monitor
	var/list/powermonitors = list()
	var/mode = 1

	use_app()
		if (mode==1)
			dat = "<h4>Power Monitors - Please select one</h4><BR>"
			powmonitor = null
			powermonitors = list()
			var/powercount = 0



			for(var/obj/machinery/computer/monitor/pMon in world)
				if(!(pMon.stat & (NOPOWER|BROKEN)) )
					powercount++
					powermonitors += pMon


			if(!powercount)
				dat += "\red No connection<BR>"
			else


				var/count = 0
				for(var/obj/machinery/computer/monitor/pMon in powermonitors)
					if(!pMon.z == 1) continue
					count++
					dat += "<a href='byond://?src=\ref[src];choice=Power Select;target=[count]'> [pMon] </a><BR>"


		if(mode==2)
			dat = {"<a href='byond://?src=\ref[src];choice=ClosePower'>Close Monitor</a>"}
			dat += "<h4>Power Monitor </h4><BR>"
			if(!powmonitor)
				dat += "\red No connection<BR>"
			else
				var/list/L = list()
				for(var/obj/machinery/power/terminal/term in powmonitor.powernet.nodes)
					if(istype(term.master, /obj/machinery/power/apc))
						var/obj/machinery/power/apc/A = term.master
						L += A

				dat += "<PRE>Total power: [powmonitor.powernet.avail] W<BR>Total load:  [num2text(powmonitor.powernet.viewload,10)] W<BR>"

				dat += "<FONT SIZE=-1>"

				if(L.len > 0)
					dat += "Area                           Eqp./Lgt./Env.  Load   Cell<HR>"

					var/list/S = list(" Off","AOff","  On", " AOn")
					var/list/chg = list("N","C","F")

					for(var/obj/machinery/power/apc/A in L)
						dat += copytext(add_tspace(A.area.name, 30), 1, 30)
						dat += " [S[A.equipment+1]] [S[A.lighting+1]] [S[A.environ+1]] [add_lspace(A.lastused_total, 6)]  [A.cell ? "[add_lspace(round(A.cell.percent()), 3)]% [chg[A.charging+1]]" : "  N/C"]<BR>"

				dat += "</FONT></PRE>"


	Topic(href, href_list)
		if (!..()) return
		switch(href_list["choice"])
			if("Power Select")
				var/pnum = text2num(href_list["target"])
				powmonitor = powermonitors[pnum]
				mode = 2
			if("ClosePower")
				mode = 1
				powmonitor = null
		use_app()
		tablet.attack_self(usr)