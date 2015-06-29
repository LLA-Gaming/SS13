/datum/program/secrecords
	name = "Security Records"
	app_id = "secrecords"
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
			dat += "<center><h4>Security Record</h4></center>"

			if(active1 in data_core.general)
				dat += "Name: [active1.fields["name"]] ID: [active1.fields["id"]]<br>"
				dat += "Sex: [active1.fields["sex"]]<br>"
				dat += "Age: [active1.fields["age"]]<br>"
				dat += "Rank: [active1.fields["rank"]]<br>"
				dat += "Fingerprint: [active1.fields["fingerprint"]]<br><br>"
			if(active3)
				dat += text("<BR>\n<CENTER><B>Security Data</B></CENTER><BR>\nCriminal Status: []", active3.fields["criminal"])

				dat += "<BR>\n<BR>\nMinor Crimes:<BR>\n"
				dat +={"<table style="text-align:center;" border="1" cellspacing="0" width="100%">
<tr>
<th>Crime</th>
<th>Details</th>
<th>Author</th>
<th>Time Added</th>
</tr>"}
				for(var/datum/data/crime/c in active3.fields["min_crim"])
					dat += "<tr><td>[c.crimeName]</td>"
					dat += "<td>[c.crimeDetails]</td>"
					dat += "<td>[c.author]</td>"
					dat += "<td>[c.time]</td>"
					dat += "</tr>"
				dat += "</table>"

				dat += "<BR>\nMedium Crimes: <BR>\n"
				dat +={"<table style="text-align:center;" border="1" cellspacing="0" width="100%">
<tr>
<th>Crime</th>
<th>Details</th>
<th>Author</th>
<th>Time Added</th>
</tr>"}
				for(var/datum/data/crime/c in active3.fields["med_crim"])
					dat += "<tr><td>[c.crimeName]</td>"
					dat += "<td>[c.crimeDetails]</td>"
					dat += "<td>[c.author]</td>"
					dat += "<td>[c.time]</td>"
					dat += "</tr>"
				dat += "</table>"

				dat += "<BR>\nMajor Crimes: <BR>\n"
				dat +={"<table style="text-align:center;" border="1" cellspacing="0" width="100%">
<tr>
<th>Crime</th>
<th>Details</th>
<th>Author</th>
<th>Time Added</th>
</tr>"}
				for(var/datum/data/crime/c in active3.fields["maj_crim"])
					dat += "<tr><td>[c.crimeName]</td>"
					dat += "<td>[c.crimeDetails]</td>"
					dat += "<td>[c.author]</td>"
					dat += "<td>[c.time]</td>"
					dat += "</tr>"
				dat += "</table>"

				dat += "<BR>\nCapital Crimes: <BR>\n"
				dat +={"<table style="text-align:center;" border="1" cellspacing="0" width="100%">
<tr>
<th>Crime</th>
<th>Details</th>
<th>Author</th>
<th>Time Added</th>
</tr>"}
				for(var/datum/data/crime/c in active3.fields["cap_crim"])
					dat += "<tr><td>[c.crimeName]</td>"
					dat += "<td>[c.crimeDetails]</td>"
					dat += "<td>[c.author]</td>"
					dat += "<td>[c.time]</td>"
					dat += "</tr>"
				dat += "</table>"

				dat += "<br>"

				dat += "<center><h4>Comments/Log:</h4></center>"
				var/counter = 1
				while(active3.fields[text("com_[]", counter)])
					dat += "<div class='statusDisplay'>"
					dat += "<center>"
					dat += text("[]<BR>", active3.fields[text("com_[]", counter)])
					dat += "</center>"
					dat += "</div>"
					counter++
			else
				dat += "<b>Record Lost!</b><br>"

			dat += "<br>"


	Topic(href, href_list)
		if (!..()) return
		switch(href_list["choice"])
			if("Security Records")
				active1 = find_record("id", href_list["target"], data_core.general)
				if(active1)
					active3 = find_record("id", href_list["target"], data_core.security)
				mode = 2
				if(!active3)
					active1 = null
			if("CloseRecord")
				active1 = null
				active2 = null
				mode = 1
		use_app()
		tablet.attack_self(usr)