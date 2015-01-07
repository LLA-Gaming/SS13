/obj/item/device/thinktronic_parts/program/general/hackingtools
	name = "SyndiHax"
	DRM = 1
	var/shock_charges = 5

	use_app() //Put all the HTML here
		dat = "<h4>Device List - Detonation Charges: [shock_charges]</h4>"
		for(var/obj/item/device/thinktronic/devices in thinktronic_devices)
			var/obj/item/device/thinktronic_parts/core/D = devices.HDD
			var/obj/item/device/thinktronic_parts/core/hdd = loc // variable for interactin with the HDD
			var/obj/item/device/thinktronic/PDA = hdd.loc // variable for interacting with the Device itself
			if(!D) continue
			if(devices.network() && devices.hasmessenger == 1 && D.neton && D.owner && D.messengeron && devices.candetonate)
				if(devices.device_ID == PDA.device_ID) continue
				dat += {" [D.owner] ([devices.devicetype])"}
				dat += {" - "}
				dat += {"<a href='byond://?src=\ref[src];choice=Cash;target=\ref[devices]'>Steal Cash</a>"}
				dat += {" - "}
				dat += {"<a href='byond://?src=\ref[src];choice=Detonate;target=\ref[devices]'>Ignite Hard Drive</a>"}
				dat += {"<br>"}


	Topic(href, href_list) // This is here
		..()
		var/obj/item/device/thinktronic_parts/core/hdd = loc // variable for interactin with the HDD
		var/obj/item/device/thinktronic/PDA = hdd.loc // variable for interacting with the Device itself
		switch(href_list["choice"])
			if("Cash")
				var/obj/item/device/thinktronic/T = locate(href_list["target"])
				if(!isnull(T))
					hdd.cash += T.HDD.cash
					T.HDD.cash = 0
					usr.show_message("\blue Funds withdrawn!", 1)
				PDA.attack_self(usr)
			if("Detonate")
				var/obj/item/device/thinktronic/T = locate(href_list["target"])
				if(!isnull(T))
					if (T.HDD.messengeron && shock_charges > 0)
						shock_charges--
						if((T.hidden_uplink))
							usr.show_message("\red An error flashes on your [src].", 1)
						else
							usr.show_message("\blue Success!", 1)
							T.explode()
				else
					usr << "PDA not found."
				PDA.attack_self(usr)