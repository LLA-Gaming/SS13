/datum/program/medrecords
	name = "Medical Records"
	app_id = "medicalrecords"
	var/mode = 1
	var/datum/data/record/active1 = null //General
	var/datum/data/record/active2 = null //Medical
	var/datum/data/record/active3 = null //Security

	use_app()
		if(mode == 1)
			dat = "<h4>Medical Record List</h4>"
			if(data_core.general)
				for(var/datum/data/record/R in sortRecord(data_core.general))
					dat += "<a href='byond://?src=\ref[src];choice=Medical Records;target=[R.fields["id"]]'>[R.fields["id"]]: [R.fields["name"]]</a><br>"
			dat += "<br>"
		if(mode == 2)
			dat = {"<a href='byond://?src=\ref[src];choice=CloseRecord'>Close Record</a>"}
			dat += "<h4>Medical Record</h4>"

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

			dat += "<h4>Medical Data</h4>"
			if(active2 in data_core.medical)
				dat += "Blood Type: [active2.fields["blood_type"]]<br><br>"

				dat += "Minor Disabilities: [active2.fields["mi_dis"]]<br>"
				dat += "Details: [active2.fields["mi_dis_d"]]<br><br>"

				dat += "Major Disabilities: [active2.fields["ma_dis"]]<br>"
				dat += "Details: [active2.fields["ma_dis_d"]]<br><br>"

				dat += "Allergies: [active2.fields["alg"]]<br>"
				dat += "Details: [active2.fields["alg_d"]]<br><br>"

				dat += "Current Diseases: [active2.fields["cdi"]]<br>"
				dat += "Details: [active2.fields["cdi_d"]]<br><br>"

				dat += "Important Notes: [active2.fields["notes"]]<br>"
			else
				dat += "<b>Record Lost!</b><br>"

			dat += "<br>"


	Topic(href, href_list)
		if (!..()) return
		switch(href_list["choice"])
			if("Medical Records")
				active1 = find_record("id", href_list["target"], data_core.general)
				if(active1)
					active2 = find_record("id", href_list["target"], data_core.medical)
				mode = 2
				if(!active2)
					active1 = null
			if("CloseRecord")
				active1 = null
				active2 = null
				mode = 1
		use_app()
		tablet.attack_self(usr)