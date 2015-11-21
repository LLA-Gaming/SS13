/datum/program/notekeeper
	name = "Notekeeper Pro"
	app_id = "notekeeper"
	price = 10
	var/datum/tablet_data/document/loadeddoc = null
	var/mode = 0

	use_app()


		dat = ""
		if(loadeddoc)
			if(mode)
				dat += "<div class='statusDisplay'><center>Mode: <a href='byond://?src=\ref[src];choice=Mode'>Book</a></center></div>"
			else
				dat += "<div class='statusDisplay'><center>Mode: <a href='byond://?src=\ref[src];choice=Mode'>Note</a></center></div>"
			dat += "<center><h2>[loadeddoc.name]</h2></center><hr>"
			if(mode)
				dat += "<center><a href='byond://?src=\ref[src];choice=Add2Doc'>Add To</a><a href='byond://?src=\ref[src];choice=RenameDoc'>Rename</a><a href='byond://?src=\ref[src];choice=PrintDoc'>Print (toner: [tablet.core.toner])</a><a href='byond://?src=\ref[src];choice=CloseDoc'>Close Document</a></center>"
			else
				dat += "<center><a href='byond://?src=\ref[src];choice=EditDoc'>Edit</a><a href='byond://?src=\ref[src];choice=RenameDoc'>Rename</a><a href='byond://?src=\ref[src];choice=PrintDoc'>Print (toner: [tablet.core.toner])</a><a href='byond://?src=\ref[src];choice=CloseDoc'>Close Document</a></center>"
			dat += "<div class='statusDisplay'>"
			dat += "[loadpaper()]"
			dat += "</div'>"
		else
			dat += {"<a href='byond://?src=\ref[src];choice=NewDoc'>New</a><hr>"}
			for(var/datum/tablet_data/document/DATA in tablet.core.files)
				dat += {"<a href='byond://?src=\ref[src];choice=DeleteDoc;target=\ref[DATA]'><b>X</b> </a>"}
				dat += {"<a href='byond://?src=\ref[src];choice=OpenDoc;target=\ref[DATA]'>[DATA.name]</a><br>"}


	Topic(href, href_list)

		if (!..()) return
		switch(href_list["choice"])//Now we switch based on choice.
			if ("EditDoc")
				editpaper()
			if ("Add2Doc")
				addpaper()
			if ("Mode")
				mode = !mode
			if ("RenameDoc")
				var/t = input(usr, "Name", loadeddoc.name, null) as text
				t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
				if (!t)
					return
				if(!tablet.can_use(usr))
					return
				loadeddoc.name = t
			if ("NewDoc")
				var/datum/tablet_data/document/D = new /datum/tablet_data/document/
				tablet.core.files.Add(D)
				loadeddoc = D
			if ("CloseDoc")
				loadeddoc = null
			if ("DeleteDoc")
				var/datum/tablet_data/document/D = locate(href_list["target"])
				loadeddoc = null
				qdel(D)
			if ("PrintDoc")
				if(tablet.core.toner >= 1)
					var/mob/M = tablet.loc
					var/obj/item/weapon/paper/C = new /obj/item/weapon/paper
					C.fields = loadeddoc.fields
					C.info = loadeddoc.doc
					C.info_links = loadeddoc.doc_links
					C.loc = M.loc
					if(usr.put_in_hands(C))
						tablet.core.toner -= 1
					else
						qdel(C)
						usr << "<span class='notice'>You couldn't print because your hands are full.</span>"
				else
					usr << "ERROR: Replace printer toner"
			if ("OpenDoc")
				var/datum/tablet_data/document/D = locate(href_list["target"])
				loadeddoc = D
		use_app()
		tablet.attack_self(usr)

	proc/editpaper()
		var/oldt = loadeddoc.doc
		oldt = replacetext(oldt, "<center>", "\[center\]")
		oldt = replacetext(oldt, "</center>", "\[/center\]")
		oldt = replacetext(oldt, "<BR>", "\[br\]")
		oldt = replacetext(oldt, "<B>", "\[b\]")
		oldt = replacetext(oldt, "</B>", "\[/b\]")
		oldt = replacetext(oldt, "<I>", "\[i\]")
		oldt = replacetext(oldt, "</I>", "\[/i\]")
		oldt = replacetext(oldt, "<U>", "\[u\]")
		oldt = replacetext(oldt, "</U>", "\[/u\]")
		oldt = replacetext(oldt, "<font size=\"3\">", "\[large\]")
		oldt = replacetext(oldt, "<font size=\"4\">", "\[large\]")
		oldt = replacetext(oldt, "</font>", "\[/large\]")
		oldt = replacetext(oldt, "<span class=\"paper_field\"></span>", "\[field\]")
		oldt = replacetext(oldt, "<li>", "\[*\]")
		oldt = replacetext(oldt, "<HR>", "\[hr\]")
		oldt = replacetext(oldt, "<font size = \"1\">", "\[small\]")
		oldt = replacetext(oldt, "</font>", "\[/small\]")
		oldt = replacetext(oldt, "<ul>", "\[list\]")
		oldt = replacetext(oldt, "</ul>", "\[/list\]")
		var/t =  strip_html_simple(input("Enter what you want to write:", "Write", oldt, null)  as message, MAX_MESSAGE_LEN)
		// Encode everything from BBcode to html
		t = replacetext(t, "\[center\]", "<center>")
		t = replacetext(t, "\[/center\]", "</center>")
		t = replacetext(t, "\[br\]", "<BR>")
		t = replacetext(t, "\[b\]", "<B>")
		t = replacetext(t, "\[/b\]", "</B>")
		t = replacetext(t, "\[i\]", "<I>")
		t = replacetext(t, "\[/i\]", "</I>")
		t = replacetext(t, "\[u\]", "<U>")
		t = replacetext(t, "\[/u\]", "</U>")
		t = replacetext(t, "\[large\]", "<FONT size=\"3\">")
		t = replacetext(t, "\[large\]", "<font size=\"4\">")
		t = replacetext(t, "\[/large\]", "</font>")
		t = replacetext(t, "\[sign\]", "")
		t = replacetext(t, "\[field\]", "<span class=\"paper_field\"></span>")
		t = replacetext(t, "\[*\]", "<li>")
		t = replacetext(t, "\[hr\]", "<HR>")
		t = replacetext(t, "\[small\]", "<font size = \"1\">")
		t = replacetext(t, "\[/small\]", "</font>")
		t = replacetext(t, "\[list\]", "<ul>")
		t = replacetext(t, "\[/list\]", "</ul>")
		var/laststart = 1
		while(1)
			var/i = findtext(t, "<span class=\"paper_field\">", laststart)
			if(i == 0)
				break
			laststart = i+1
			loadeddoc.fields++
		loadeddoc.doc = t
		updateinfolinks()

	proc/addpaper()
		var/t =  strip_html_simple(input("Enter what you want to write:", "Write", null)  as message, MAX_MESSAGE_LEN)
		// Encode everything from BBcode to html
		t = replacetext(t, "\[center\]", "<center>")
		t = replacetext(t, "\[/center\]", "</center>")
		t = replacetext(t, "\[br\]", "<BR>")
		t = replacetext(t, "\[b\]", "<B>")
		t = replacetext(t, "\[/b\]", "</B>")
		t = replacetext(t, "\[i\]", "<I>")
		t = replacetext(t, "\[/i\]", "</I>")
		t = replacetext(t, "\[u\]", "<U>")
		t = replacetext(t, "\[/u\]", "</U>")
		t = replacetext(t, "\[large\]", "<FONT size=\"3\">")
		t = replacetext(t, "\[large\]", "<font size=\"4\">")
		t = replacetext(t, "\[/large\]", "</font>")
		t = replacetext(t, "\[sign\]", "")
		t = replacetext(t, "\[field\]", "<span class=\"paper_field\"></span>")
		t = replacetext(t, "\[*\]", "<li>")
		t = replacetext(t, "\[hr\]", "<HR>")
		t = replacetext(t, "\[small\]", "<font size = \"1\">")
		t = replacetext(t, "\[/small\]", "</font>")
		t = replacetext(t, "\[list\]", "<ul>")
		t = replacetext(t, "\[/list\]", "</ul>")
		var/laststart = 1
		while(1)
			var/i = findtext(t, "<span class=\"paper_field\">", laststart)
			if(i == 0)
				break
			laststart = i+1
			loadeddoc.fields++
		if(loadeddoc.doc)
			loadeddoc.doc += "<br>"
		loadeddoc.doc += t
		updateinfolinks()


	proc/updateinfolinks()
		loadeddoc.doc_links = loadeddoc.doc
		var/i = 0
		for(i=1,i<=loadeddoc.fields,i++)
			addtofield(i, "<font face=\"[loadeddoc.deffont]\"><A href='?src=\ref[src];write=[i]'>write</A></font>", 1)
		loadeddoc.doc_links = loadeddoc.doc_links + "<font face=\"[loadeddoc.deffont]\"><A href='?src=\ref[src];write=end'>write</A></font>"


	proc/addtofield(id, text, links = 0)
		var/locid = 0
		var/laststart = 1
		var/textindex = 1
		while(1)
			var/istart = 0
			if(links)
				istart = findtext(loadeddoc.doc_links, "<span class=\"paper_field\">", laststart)
			else
				istart = findtext(loadeddoc.doc, "<span class=\"paper_field\">", laststart)

			if(istart == 0)
				return

			laststart = istart+1
			locid++
			if(locid == id)
				var/iend = 1
				if(links)
					iend = findtext(loadeddoc.doc_links, "</span>", istart)
				else
					iend = findtext(loadeddoc.doc, "</span>", istart)

				//textindex = istart+26
				textindex = iend
				break

		if(links)
			var/before = copytext(loadeddoc.doc_links, 1, textindex)
			var/after = copytext(loadeddoc.doc_links, textindex)
			loadeddoc.doc_links = before + text + after
		else
			var/before = copytext(loadeddoc.doc, 1, textindex)
			var/after = copytext(loadeddoc.doc, textindex)
			loadeddoc.doc = before + text + after
			updateinfolinks()
	proc/loadpaper()
		var/t = loadeddoc.doc
		t = replacetext(t, "<font face=\"[loadeddoc.deffont]\" color=", "<font face=\"[loadeddoc.deffont]\" nocolor=")
		t = replacetext(t, "<font face=\"[loadeddoc.crayonfont]\" color=", "<font face=\"[loadeddoc.crayonfont]\" nocolor=")
		t = replacetext(t, "<span class=\"paper_field\"></span>", "________")
		return t

