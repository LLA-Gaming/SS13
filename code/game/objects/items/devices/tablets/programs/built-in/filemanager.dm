/datum/program/builtin/filemanager
	name = "Files"
	app_id = "filemanager"
	var/datum/tablet_data/loadeddata
	var/spamcheck = 0

	use_app()
		dat = "<h2>File Manager:</h2>"
		if(loadeddata)
			dat += {"<A href='?src=\ref[src];choice=Close'>Close</a>"}
			dat += "<div class='statusDisplay'>"
			if(istype(loadeddata,/datum/tablet_data/document))
				var/datum/tablet_data/document/D = loadeddata
				dat += D.doc
			if(istype(loadeddata,/datum/tablet_data/chatlog))
				var/datum/tablet_data/chatlog/D = loadeddata
				dat += D.log
			if(istype(loadeddata,/datum/tablet_data/photo))
				var/datum/tablet_data/photo/D = loadeddata
				usr << browse_rsc(D.photoinfo, "tmp_photo.png")
				dat += "<center><img src='tmp_photo.png' width='192' style='-ms-interpolation-mode:nearest-neighbor' /></center>"
			dat += "</div'>"

			return
		if(tablet.core.downloads.len)
			dat += "<h4>Downloads:</h4>"
			dat += "<div class = 'statusDisplay'>"
			for(var/datum/tablet_data/data in tablet.core.downloads)
				dat += {"<A href='?src=\ref[src];choice=Delete;target=\ref[data]'> <b>X</b> </a>"}
				dat += {"File: [data.name]"}
				dat += {"<br>"}
				dat += {"Type: [data.data_type]<br>"}
				dat += {"Sent By: [data.sentby]<br>"}
				dat += {"<A href='?src=\ref[src];choice=Download;target=\ref[data]'>Download [data.data_type]</a>"}
				dat += {"<hr>"}
			dat += "</div>"
		if(tablet.core.files.len)
			dat = "<h4>Files:</h4>"
			dat += "<div class = 'statusDisplay'>"
			for(var/datum/tablet_data/data in tablet.core.files)
				if(istype(data,/datum/tablet_data/conversation)) continue
				dat += {"<A href='?src=\ref[src];choice=Delete;target=\ref[data]'> <b>X</b> </a>"}
				dat += {"[data.name]"}
				dat += {" - <A href='?src=\ref[src];choice=View;target=\ref[data]'>View</a>"}
				dat += {" - <A href='?src=\ref[src];choice=Rename;target=\ref[data]'>Rename</a>"}
				dat += {"<br>"}
			dat += "</div>"
	Topic(href, href_list)
		if (!..()) return
		if(!spamcheck)
			switch(href_list["choice"])
				if("Close")
					loadeddata = null
				if("Delete")
					var/datum/tablet_data/C = locate(href_list["target"])
					qdel(C)
				if("Download")
					var/datum/tablet_data/C = locate(href_list["target"])
					tablet.core.downloads.Remove(C)
					if(istype(C,/datum/tablet_data/program))
						var/datum/tablet_data/program/P = C
						tablet.core.programs.Add(P.program)
					else
						tablet.core.files.Add(C)
				if("View")
					var/datum/tablet_data/C = locate(href_list["target"])
					loadeddata = C
				if("Rename")
					var/datum/tablet_data/C = locate(href_list["target"])
					spamcheck = 1
					var/t = copytext(sanitize(input("Rename", "File Manager", null, null)  as text),1,MAX_MESSAGE_LEN)
					spamcheck = 0
					C.name = t

		use_app()
		tablet.attack_self(usr)