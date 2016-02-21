/datum/program/camera
	name = "Camera \[Off\]"
	app_id = "camera"
	utility = 1
	togglemode = 1

	use_app()
		if(toggleon)
			toggleon = 0
			tablet.scanmode = null
			name = "Camera \[Off\]"
		else
			for(var/datum/program/PRG in tablet.core.programs)
				if(PRG.togglemode)
					if(PRG == src) continue
					PRG.toggleon = 0
					PRG.name = initial(PRG.name)
			toggleon = 1
			tablet.scanmode = "Camera"
			name = "Camera \[On\]"