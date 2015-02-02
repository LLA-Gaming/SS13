/obj/item/device/thinktronic_parts/program/general/crewmanifest
	name = "Crew Manifest"


	use_app() //Put all the HTML here


		dat = ""//Youl want to start dat off blank or youl just keep duplicating every click.
		dat = "<h4>Crew Manifest</h4>"
		dat += "Entries cannot be modified from this terminal.<br><br>"
		if(data_core.general)
			for (var/datum/data/record/t in sortRecord(data_core.general))
				dat += "[t.fields["name"]] - [t.fields["rank"]]<br>"
		dat += "<br>"