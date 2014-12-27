/obj/item/device/thinktronic_parts/program/general/honk
	name = "Honk Synthesizer"
	favorite = 1 //ALWAYS A FAVORITE
	var/last_honk = null

	Topic(href, href_list) // This is here
		var/obj/item/device/thinktronic_parts/HDD/hdd = loc
		var/obj/item/device/thinktronic/PDA = hdd.loc
		switch(href_list["choice"])//Now we switch based on choice.
			if ("Open")
				if ( !(last_honk && world.time < last_honk + 20) )
					playsound(loc, 'sound/items/bikehorn.ogg', 50, 1)
					last_honk = world.time
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