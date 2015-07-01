/datum/program/custodiallocator
	name = "Custodial Locator"
	app_id = "janilocator"


	use_app()

		dat = "<h4>Persistent Custodial Object Locator</h4>"

		var/turf/cl = get_turf(src)
		if (cl)
			dat += "Current Orbital Location: <b>\[[cl.x],[cl.y]\]</b>"

			dat += "<h4>Located Mops:</h4>"

			var/ldat
			for (var/obj/item/weapon/mop/M in world)
				var/turf/ml = get_turf(M)

				if(ml)
					if (ml.z != cl.z)
						continue
					var/direction = get_dir(src, M)
					ldat += "Mop - <b>\[[ml.x],[ml.y] ([uppertext(dir2text(direction))])\]</b> - [M.reagents.total_volume ? "Wet" : "Dry"]<br>"

			if (!ldat)
				dat += "None"
			else
				dat += "[ldat]"

			dat += "<h4>Located Janitorial Cart:</h4>"

			ldat = null
			for (var/obj/structure/janitorialcart/B in world)
				var/turf/bl = get_turf(B)

				if(bl)
					if (bl.z != cl.z)
						continue
					var/direction = get_dir(src, B)
					ldat += "Cart - <b>\[[bl.x],[bl.y] ([uppertext(dir2text(direction))])\]</b> - Water level: [B.reagents.total_volume]/100<br>"

			if (!ldat)
				dat += "None"
			else
				dat += "[ldat]"

			dat += "<h4>Located Cleanbots:</h4>"

			ldat = null
			for (var/obj/machinery/bot/cleanbot/B in world)
				var/turf/bl = get_turf(B)

				if(bl)
					if (bl.z != cl.z)
						continue
					var/direction = get_dir(src, B)
					ldat += "Cleanbot - <b>\[[bl.x],[bl.y] ([uppertext(dir2text(direction))])\]</b> - [B.on ? "Online" : "Offline"]<br>"

			if (!ldat)
				dat += "None"
			else
				dat += "[ldat]"

		else
			dat += "ERROR: Unable to determine current location."