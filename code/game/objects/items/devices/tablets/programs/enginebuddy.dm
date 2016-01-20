/datum/program/enginebuddy
	name = "Engine Buddy"
	app_id = "enginebuddy"
	price = 10

	use_app()
		dat = ""
		dat += "<h4>Engine Buddy</h4>"
		dat += "Readme: Hello, this application will attempt to help you setup the station's Singularity Engine. For best results stand near the Particle Accelerator while this device searchs for nearby singularity machinery. Anything colored in red needs your immediate attention in setting up the engine. Be wary of interference."
		dat += "<hr>"
		dat += "<h4>The Singularity</h4>"
		for(var/obj/machinery/the_singularitygen/gen in orange(15, tablet.loc))
			if(gen.anchored)
				dat += "Anchored Singularity Generator found!<br>"
				for(var/obj/machinery/field/generator/F in orange(7, gen))
					if(!F.connected_gens.len)
						dat += "<font color='red'>Singularity Generator is NOT contained</font><br>"
						break
					else
						dat += "<font color='green'>Singularity Generator is contained</font><br>"
						break
		for(var/obj/machinery/singularity/loose in orange(15, tablet.loc))
			for(var/obj/machinery/field/generator/F in orange(7, loose))
				if(!F.connected_gens)
					dat += "<font color='red'>SINGULARITY IS LOOSE</font><br>"
					break
				else
					dat += "<font color='green'>Singularity is contained</font><br>"
					break

		dat += "<h4>SMES units</h4>"
		for(var/obj/machinery/power/smes/SMES in orange(14, tablet.loc))
			dat += "SMES -"
			if(!SMES.inputting)
				dat += " <font color='red'>Not Charging</font> - <br>"
			if(SMES.inputting)
				dat += " <font color='green'>Charging</font> - <br>"
			dat += "[SMES.input_level >= 99999?"<font color='green'>In: [SMES.input_level]</font> - ":"<font color='red'>In: [SMES.input_level]</font> - "]"
			dat += "[SMES.output_level >= 99999?"<font color='green'>Out: [SMES.output_level]</font> - ":"<font color='red'>Out: [SMES.output_level]</font> - "]"
			if(!SMES.input_attempt)
				dat += "<font color='red'>Turn Input On!</font><br>"
			else
				dat += "<br>"

		dat += "<h4>Particle Accelerator</h4>"
		for(var/obj/machinery/particle_accelerator/PA in orange(7, tablet.loc))
			dat += "Particle Strength: <u><b>[PA.strength]</b></u><br>"
			break
		for(var/obj/machinery/particle_accelerator/PA in orange(7, tablet.loc))
			if(!PA) return
			switch(PA.construction_state)
				if(0)
					dat += "[PA.name]: <font color='red'><b>not attached to the flooring</b></font><br>"
				if(1)
					dat += "[PA.name]: <font color='red'><b>it is missing some cables</b></font><br>"
				if(2)
					dat += "[PA.name]: <font color='red'><b>the panel is open</b></font><br>"
				if(3)
					dat += "[PA.name]: <font color='green'><b>assembled</font><br>"
		for(var/obj/structure/particle_accelerator/PA in orange(7, tablet.loc))
			if(!PA) return
			switch(PA.construction_state)
				if(0)
					dat += "[PA.name]: <font color='red'><b>not attached to the flooring</b></font><br>"
				if(1)
					dat += "[PA.name]: <font color='red'><b>it is missing some cables</b></font><br>"
				if(2)
					dat += "[PA.name]: <font color='red'><b>the panel is open</b></font><br>"
				if(3)
					dat += "[PA.name]: <font color='green'><b>assembled</b></font><br>"

		dat += "<h4>Radiation Collectors</h4>"
		for(var/obj/machinery/power/rad_collector/rad in orange(14, tablet.loc))
			if(!rad) return
			if(rad.P)
				if(round(rad.P.air_contents.gasses[PLASMA]/0.29) <= 50)
					dat += "[rad.name]: [rad.active?"<font color='green'>on</font>":"<font color='red'>off</font>"] -  <font color='red'>[rad.P?"Fuel: [round(rad.P.air_contents.gasses[PLASMA]/0.29)]%</font>":"<font color='red'>0%</font>"]<br>"
				if(round(rad.P.air_contents.gasses[PLASMA]/0.29) >= 51)
					dat += "[rad.name]: [rad.active?"<font color='green'>on</font>":"<font color='red'>off</font>"] -  <font color='green'>[rad.P?"Fuel: [round(rad.P.air_contents.gasses[PLASMA]/0.29)]%</font>":"<font color='red'>0%</font>"]<br>"
			else
				dat += "[rad.name]:[rad.active?"<font color='green'>on</font>":"<font color='red'>off</font>"] - <font color='red'>0%</font><br>"

		dat += "<h4>Emitters</h4>"
		for(var/obj/machinery/power/emitter/emit in orange(19, tablet.loc))
			if(emit.active || emit.anchored)
				if(emit.active)
					dat += "[emit.name]: <font color='green'><b>is On</b></font> - "
				if(!emit.active)
					dat += "[emit.name]: <font color='red'><b>is Off</b></font> - "
				if(!emit.avail(emit.active_power_usage))
					dat += "<font color='red'>Needs External Power!</font><br>"
				if(emit.avail(emit.active_power_usage))
					dat += "<font color='green'>Emitter has external power!</font><br>"