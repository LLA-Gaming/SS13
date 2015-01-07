/obj/item/device/thinktronic_parts/program/utility/medscanner
	name = "Medical Scanner"
	togglemode = 1

	Topic(href, href_list) // This is here

		var/obj/item/device/thinktronic_parts/core/hdd = loc
		var/obj/item/device/thinktronic/PDA = hdd.loc
		switch(href_list["choice"])//Now we switch based on choice.
			if ("Toggle")
				if(toggleon)
					toggleon = 0
					PDA.scanmode = null
				else
					for(var/obj/item/device/thinktronic_parts/program/utility/PRG in hdd)
						if(togglemode)
							if(PRG == src) continue
							PRG.toggleon = 0
					toggleon = 1
					PDA.scanmode = "Health"
				PDA.attack_self(usr)
			if("Delete")
				qdel(src)
				PDA.scanmode = null
				PDA.attack_self(usr)
				return

