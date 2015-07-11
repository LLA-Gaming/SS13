/datum/program/radscanner
	name = "Radiation Scanner \[Off\]"
	app_id = "radscanner"
	utility = 1
	togglemode = 1

	use_app()
		if(toggleon)
			toggleon = 0
			tablet.scanmode = null
			name = "Radiation Scanner \[Off\]"
		else
			for(var/datum/program/PRG in tablet.core.programs)
				if(PRG.togglemode)
					if(PRG == src) continue
					PRG.toggleon = 0
					PRG.name = initial(PRG.name)
			toggleon = 1
			tablet.scanmode = "Radiation"
			name = "Radiation Scanner \[On\]"