/datum/program/hackingtools
	name = "SyndiHax"
	app_id = "syndihax"
	var/shock_charges = 5

	use_app()
		var/obj/machinery/nanonet_server/server
		for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
			if(MS.active)
				server = MS
		if(server)
			dat = "<h4>Device List - Detonation Charges: [shock_charges]</h4>"
			for(var/obj/item/device/tablet/T in tablets_list)
				if(T == tablet) continue
				if(!T.can_detonate) continue
				if(T.network() && T.core && T.core.owner && T.messengeron)
					dat += {" [T.core.owner] ([T.core.ownjob])"}
					dat += {" - "}
					dat += {"<a href='byond://?src=\ref[src];choice=Cash;target=\ref[T]'>Steal Cash</a>"}
					dat += {" - "}
					dat += {"<a href='byond://?src=\ref[src];choice=Detonate;target=\ref[T]'>Ignite Core</a>"}
					dat += {"<br>"}


	Topic(href, href_list)
		if (!..()) return
		switch(href_list["choice"])
			if("Cash")
				var/obj/item/device/tablet/T = locate(href_list["target"])
				if(!isnull(T) && T.core)
					tablet.core.cash += T.core.cash
					if(T.core.cash)
						usr.show_message("\blue Funds withdrawn!", 1)
					T.core.cash = 0
			if("Detonate")
				var/obj/item/device/tablet/T = locate(href_list["target"])
				if(!isnull(T))
					if (T.messengeron && shock_charges > 0)
						shock_charges--
						if((T.hidden_uplink))
							usr.show_message("\red An error flashes on your [src].", 1)
						else
							usr.show_message("\blue Success!", 1)
							T.explode()
				else
					usr << "Tablet not found."
		use_app()
		tablet.attack_self(usr)

/datum/program/poddoor
	name = "Toggle Ship Doors"
	app_id = "synd_blastdoors"
	drm = 1
	use_app()

		for(var/obj/machinery/door/poddoor/M in world)
			if(M.id == "smindicate")
				if(M.density)
					M.open()
				else
					M.close()