/obj/item/device/thinktronic_parts/program/utility/emergency
	name = "Call Security"
	var/cooldown = 0
	DRM = 1
	deletable = 0

	Topic(href, href_list) // This is here
		var/obj/item/device/thinktronic_parts/core/hdd = loc
		var/obj/item/device/thinktronic/PDA = hdd.loc
		if(PDA.can_use(usr))
			switch(href_list["choice"])//Now we switch based on choice.
				if ("Open")
					if (cooldown)
						usr << "<span class='notice'>Distress call can only be sent every 2 minutes.</span>"
					if (!cooldown)
						playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
						cooldown = 1
						var/area/location = get_area(src)
						broadcast_hud_message("<b>[hdd.owner] is requesting help in [location]!</b>", src)
						usr << "<span class='notice'>Distress call sent.</span>"
						spawn(1200)
							cooldown = 0
				if("Favorite")
					switch (favorite)
						if (0)
							favorite = 1
						if (1)
							favorite = 2
						if (2)
							favorite = 0
					PDA.attack_self(usr)
					return
				if("Alerts")
					switch (alerts)
						if (0)
							alerts = 1
						if (1)
							alerts = 0
					PDA.attack_self(usr)
					return
				if("Delete")
					qdel(src)
					PDA.attack_self(usr)
					return