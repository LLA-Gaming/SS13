/datum/program/builtin/settings
	name = "Settings"
	app_id = "settings"

	use_app()
		dat = "<h2>System Settings:</h2>"
		dat += {"Processor: IntelliTech LW-S<br>"}
		dat += {"GPU: S-Vidya 2555-m<br>"}
		dat += {"System Ram: 256GB<br>"}
		dat += {"Core: <a href='byond://?src=\ref[src];choice=EjectCore'>Eject</a><br>"}
		dat += {"<a href='byond://?src=\ref[src];choice=Ringtone'>Ringtone</a><br>"}
		dat += {"<a href='byond://?src=\ref[src];choice=Sound'>[tablet.core.volume ? "Sound: On" : "Sound: Off"]</a><br>"}
		dat += {"<a href='byond://?src=\ref[src];choice=System Alerts'>[tablet.system_alerts ? "System Alerts: On" : "System Alerts: Off"]</a><br>"}
		dat += "<h2>Application Settings:</h2>"
		for(var/datum/program/PRG in tablet.core.programs)
			if(PRG.utility) continue
			if(PRG.drm && PRG.built_in && !PRG.usesalerts) continue
			if(!PRG.drm)
				dat += {"<A href='?src=\ref[src];choice=Delete;target=\ref[PRG]'> <b>X</b> </a>"}
			dat += {"[PRG.name] "}
			if(!PRG.built_in)
				dat += {"<A href='?src=\ref[src];choice=Category;target=\ref[PRG]'>[PRG.secondary ? "Secondary" : "Primary"]</a>"}
			if(PRG.usesalerts)
				dat += {"<A href='?src=\ref[src];choice=Alerts;target=\ref[PRG]'>[PRG.alerts ? "Alerts: On" : "Alerts: Off"]</a>"}
			dat += {"<br>"}
	Topic(href, href_list)
		if (!..()) return
		switch(href_list["choice"])
			if("EjectCore")
				if(!tablet.can_eject)
					usr << "<span class='notice'>You cannot remove the Core</span>"
				else
					tablet.popup.close()
					usr.unset_machine()
					tablet.core.loaded = null
					tablet.core.loc = get_turf(tablet.loc)
					if(tablet.id)
						tablet.id.loc = get_turf(tablet.loc)
						tablet.id = null
					usr << "<span class='notice'>You remove the Core from the [name].</span>"
					tablet.core = null
					tablet.attack_self(usr)
					return
			if("Ringtone")
				var/t = stripped_input(usr, "Please enter message", name, null) as text
				if (t)
					if(tablet.hidden_uplink && tablet.hidden_uplink.check_trigger(usr, trim(lowertext(t)), trim(lowertext(tablet.lock_code))))
						usr << "The tablet flashes red."
						tablet.core.loaded = null
						tablet.popup.close()
						usr.unset_machine()
					else
						t = copytext(sanitize(t), 1, 20)
						tablet.core.ttone = t
			if("Sound")
				tablet.core.volume = !tablet.core.volume
			if("Delete")
				var/datum/program/P = locate(href_list["target"])
				qdel(P)
			if("Category")
				var/datum/program/P = locate(href_list["target"])
				P.secondary = !P.secondary
			if("Alerts")
				var/datum/program/P = locate(href_list["target"])
				P.alerts = !P.alerts
			if("System Alerts")
				tablet.system_alerts = !tablet.system_alerts
		use_app()
		tablet.attack_self(usr)
