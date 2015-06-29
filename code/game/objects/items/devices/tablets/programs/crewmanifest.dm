/datum/program/crewmanifest
	name = "Crew Manifest"
	app_id = "crewmanifest"
	price = 20

	use_app()
		dat = "<h4>Crew Manifest</h4>"
		dat += "Entries cannot be modified from this terminal.<br><br>"
		if(data_core.general)
			for (var/datum/data/record/t in sortRecord(data_core.general))
				dat += "[t.fields["name"]] - [t.fields["rank"]]<br>"
		dat += "<br>"