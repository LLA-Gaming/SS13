/datum/program/builtin/nanostore
	name = "NanoStore"
	app_id = "nanostore"

	use_app()
		if(!tablet.network())
			dat = "ERROR: No connection found"
			return
		var/obj/machinery/nanonet_server/server
		for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
			if(MS.active)
				server = MS
		if(server)
			dat = "<h3>NanoStore</h3>"
			for(var/datum/program/P in sortAtom(server.programs))
				if(!P.price) continue
				dat += "<div class='statusDisplay'>"
				dat += "[P.name]"
				dat += " - $[P.price]"
				dat += " <a href='byond://?src=\ref[src];choice=BuyApp;target=\ref[P]'>Buy</a>"
				dat += "</div>"

	Topic(href, href_list)
		if (!..()) return
		switch(href_list["choice"])
			if("BuyApp")
				var/datum/program/program = locate(href_list["target"])
				var/duplicate = 0
				for(var/datum/program/dup in tablet.core.programs)
					if(dup.app_id == program.app_id)
						duplicate = 1
				if(!duplicate)
					if(program.price <= tablet.core.cash)
						tablet.core.cash -= program.price
						tablet.core.programs.Add(new program.type)
						usr << "Application Purchased, downloaded and installed"
					else
						usr << "ERROR: Insufficient Funds"
				else
					usr << "ERROR: You already own [program.name]"