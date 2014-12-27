/obj/item/device/thinktronic_parts/program/sec/secrecords
	name = "Security Records"
	var/mode = 1
	var/datum/data/record/active1 = null //General
	var/datum/data/record/active2 = null //Medical
	var/datum/data/record/active3 = null //Security

	use_app()
		if (mode==1) //security records
			dat = "<h4>Security Record List</h4>"
			if(data_core.general)
				for (var/datum/data/record/R in sortRecord(data_core.general))
					dat += "<a href='byond://?src=\ref[src];choice=Security Records;target=[R.fields["id"]]'>[R.fields["id"]]: [R.fields["name"]]</a><br>"

			dat += "<br>"
		if(mode==2)
			dat = {"<a href='byond://?src=\ref[src];choice=CloseRecord'>Close Record</a>"}
			dat += "<h4>Security Record</h4>"

			if(active1 in data_core.general)
				dat += "Name: [active1.fields["name"]] ID: [active1.fields["id"]]<br>"
				dat += "Sex: [active1.fields["sex"]]<br>"
				dat += "Age: [active1.fields["age"]]<br>"
				dat += "Rank: [active1.fields["rank"]]<br>"
				dat += "Fingerprint: [active1.fields["fingerprint"]]<br>"
				dat += "Physical Status: [active1.fields["p_stat"]]<br>"
				dat += "Mental Status: [active1.fields["m_stat"]]<br>"
			else
				dat += "<b>Record Lost!</b><br>"

			dat += "<br>"

			dat += "<h4>Security Data</h4>"
			if(active3 in data_core.security)
				dat += "Criminal Status: [active3.fields["criminal"]]<br>"

				dat += "Minor Crimes: [active3.fields["mi_crim"]]<br>"
				dat += "Details: [active3.fields["mi_crim"]]<br><br>"

				dat += "Major Crimes: [active3.fields["ma_crim"]]<br>"
				dat += "Details: [active3.fields["ma_crim_d"]]<br><br>"

				dat += "Important Notes:<br>"
				dat += "[active3.fields["notes"]]"
			else
				dat += "<b>Record Lost!</b><br>"

			dat += "<br>"


	Topic(href, href_list) // This is here
		..()
		var/obj/item/device/thinktronic_parts/HDD/hdd = loc // variable for interactin with the HDD
		var/obj/item/device/thinktronic/PDA = hdd.loc // variable for interacting with the Device itself
		switch(href_list["choice"])
			if("Security Records")
				active1 = find_record("id", href_list["target"], data_core.general)
				if(active1)
					active3 = find_record("id", href_list["target"], data_core.security)
				mode = 2
				if(!active3)
					active1 = null
				PDA.attack_self(usr)
			if("CloseRecord")
				active1 = null
				active2 = null
				mode = 1
				PDA.attack_self(usr)