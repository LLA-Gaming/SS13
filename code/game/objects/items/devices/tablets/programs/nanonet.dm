/datum/program/nanonet
	name = "NanoNet"
	app_id = "nanonet"
	price = 10
	usesalerts = 1
	var/datum/nanonet_profile/auth
	var/display_mode = 0
	var/datum/nanonet_message/displayed_post = null
	var/datum/nanonet_profile/displayed_profile = null
	var/datum/tablet_data/document/displayed_doc = null
	var/datum/nanonet_hashtag/displayed_hashtag = null
	use_app()
		dat = ""
		if(issilicon(usr))
			dat += "ERROR: application not compatiable with silicon users"
			return
		var/obj/machinery/nanonet_server/server = tablet.network()
		if(!server)
			dat += "ERROR: No connection found"
			return
		var/convertmentions = 0
		if(!auth)
			dat += "<center>"
			dat += "<h3>NanoNet</h3>"
			if(tablet.id)
				var/datum/nanonet_profile/account_exists
				for(var/datum/nanonet_profile/P in server.profiles)
					if(P.authentication == tablet.id)
						account_exists = P
						break
				if(account_exists)
					dat += "<A href='?src=\ref[tablet];choice=Authenticate'>@[account_exists.username]</a><br>"
					dat += "<a href='byond://?src=\ref[src];choice=login'>Login</a>"
				else
					dat += "<A href='?src=\ref[tablet];choice=Authenticate'>[tablet.id.registered_name], [tablet.id.assignment]</a><br>"
					dat += "<a href='byond://?src=\ref[src];choice=login'>Create Profile</a>"
			else
				dat += "<A href='?src=\ref[tablet];choice=Authenticate'>----------</a><br>"
				dat += "<a href='byond://?src=\ref[src];choice=login'>Login</a>"
			dat += "</center>"
			return

		dat += "<a href='byond://?src=\ref[src];choice=logout'>Logout</a> - @[auth.username]<br>"
		if(displayed_post && !(displayed_post in server.statuses)) //new post
			dat += "<div class='statusDisplay'>@[auth.username]: [displayed_post.message]<br>"
			if(displayed_post.photo)
				var/datum/tablet_data/photo/P = displayed_post.photo
				usr << browse_rsc(P.photoinfo, "tmp_photo.png")
				dat += "<img src='tmp_photo.png' width='192' style='-ms-interpolation-mode:nearest-neighbor' />"
			dat += "</div>"
			dat += "<a href='byond://?src=\ref[src];choice=add_status'>Edit Message</a><br>"
			dat += "<a href='byond://?src=\ref[src];choice=add_photo'>Add Photo</a><br>"
			dat += "<a href='byond://?src=\ref[src];choice=post_status'>Post</a><br>"
			dat += "<a href='byond://?src=\ref[src];choice=cancel'>Cancel</a><br>"
		else if(displayed_doc)
			dat += {"<A href='?src=\ref[src];choice=cancel'>Close</a>"}
			dat += "<div class='statusDisplay'>"
			if(istype(displayed_doc,/datum/tablet_data/document))
				var/datum/tablet_data/document/D = displayed_doc
				dat += D.doc
			dat += "</div'>"
		else if(displayed_post)
			convertmentions = 1
			dat += "<a href='byond://?src=\ref[src];choice=cancel'>\<--</a><br>"
			dat += "<div class='statusDisplay'>[displayed_post.timestamp] - @[displayed_post.author]: [displayed_post.message]<br>"
			if(displayed_post.photo)
				var/datum/tablet_data/photo/P = displayed_post.photo
				usr << browse_rsc(P.photoinfo, "tmp_photo.png")
				dat += "<img src='tmp_photo.png' width='192' style='-ms-interpolation-mode:nearest-neighbor' />"
			dat += "</div>"
			dat += "<br><a href='byond://?src=\ref[src];choice=like;post=\ref[displayed_post]'>Like</a>"
			dat += "<br><a href='byond://?src=\ref[src];choice=comment_on;post=\ref[displayed_post]'>Add Comment</a>"
			dat += "<br>Comments<br><div class='statusDisplay'>"
			if(displayed_post.liked.len)
				dat += "Likes:"
				dat += "[list2text(displayed_post.liked,",")]<br>"
			for(var/X in displayed_post.comments)
				dat += "[X]<br>"
			dat += "</div>"
		else if(displayed_profile)
			convertmentions = 1
			dat += "<a href='byond://?src=\ref[src];choice=cancel'>\<--</a><br>"
			var/is_followed = (auth in displayed_profile.followers)
			dat += "@[displayed_profile.username] - <a href='byond://?src=\ref[src];choice=follow;profile=\ref[displayed_profile]'>[is_followed ? "Unfollow" : "Follow"]</a>"
			dat += "<br>Followers: [displayed_profile.followers.len]"
			dat += "<br>Likes: [displayed_profile.likes]<br>"
			dat += "<br>Posts:<br>"
			for(var/datum/nanonet_message/M in server.statuses)
				if(M.author != displayed_profile.username) continue
				dat += "<div class='statusDisplay'>@[M.author]: [M.message] ([M.liked.len] likes) ([M.comments.len] comments)"
				if(M.photo)
					dat += "<br>\<File Attached\>"
				dat += "<br><a href='byond://?src=\ref[src];choice=view_post;post=\ref[M]'>View</a>"
				dat += "</div>"
		else if(displayed_hashtag)
			convertmentions = 1
			dat += "<a href='byond://?src=\ref[src];choice=cancel'>\<--</a><br>"
			var/is_followed = (auth in displayed_hashtag.followers)
			dat += "#[displayed_hashtag.hashtag] - <a href='byond://?src=\ref[src];choice=follow;profile=\ref[displayed_profile]'>[is_followed ? "Unfollow" : "Follow"]</a>"
			dat += "<br>Posts:<br>"
			for(var/datum/nanonet_message/M in server.statuses)
				var/contains_hashtag = 0
				for(var/X in M.hashtags)
					if(lowertext(X) == lowertext(displayed_hashtag.hashtag))
						contains_hashtag = 1
				if(!contains_hashtag) continue
				dat += "<div class='statusDisplay'>@[M.author]: [M.message] ([M.liked.len] likes) ([M.comments.len] comments)"
				if(M.photo)
					dat += "<br>\<File Attached\>"
				dat += "<br><a href='byond://?src=\ref[src];choice=view_post;post=\ref[M]'>View</a>"
				dat += "</div>"
		else
			convertmentions = 1
			dat += "<br><a href='byond://?src=\ref[src];mode=0'>Feed</a> | "
			dat += "<a href='byond://?src=\ref[src];mode=1'>Profiles</a> | "
			dat += "<a href='byond://?src=\ref[src];mode=2'>Documents</a><br>"
			switch(display_mode)
				if(0) //front page
					dat += "<h3>Feed</h3>"
					dat += "<a href='byond://?src=\ref[src];choice=add_status'>Create New Post</a><br>"
					dat += "Recent Posts:<br>"
					for(var/datum/nanonet_message/M in server.statuses)
						dat += "<div class='statusDisplay'>@[M.author]: [M.message] ([M.liked.len] likes) ([M.comments.len] comments)"
						if(M.photo)
							dat += "<br>\<File Attached\>"
						dat += "<br><a href='byond://?src=\ref[src];choice=view_post;post=\ref[M]'>View</a>"
						dat += "</div>"
				if(1) //users list
					dat += "<h3>NanoNet Profiles</h3>"
					for(var/datum/nanonet_profile/P in server.profiles)
						dat += "<br>@[P.username]"
				if(2) //"websites"
					convertmentions = 0
					dat += "<h3>NanoNet Document Database</h3>"
					dat += "<br><a href='byond://?src=\ref[src];choice=upload'>Upload</a><br><br>"
					for(var/datum/tablet_data/document/D in server.pages)
						dat += "<br><a href='byond://?src=\ref[src];choice=view_doc;post=\ref[D]'>[D.name]</a>"
		if(convertmentions)
			dat = mention2url(dat,server)

	Topic(href, href_list)
		if (!..()) return
		var/obj/machinery/nanonet_server/server = tablet.network()
		if (!server) return
		//authentication
		if(href_list["mode"])
			display_mode = text2num(href_list["mode"])
		switch(href_list["choice"])
			if("logout")
				auth = null
				display_mode = 0
				displayed_post = null
			if("login")
				if(tablet.id && tablet.id.registered_name && tablet.id.assignment)
					for(var/datum/nanonet_profile/P in server.profiles)
						if(P.authentication == tablet.id)
							auth = P
							break
					if(!auth)
						var/t = copytext(sanitize(input("Create Profile", "Create Profile", null, null)  as text),1,18)
						if(t && tablet.id)
							t = replacetext(t, "@", "")
							for(var/datum/nanonet_profile/P in server.profiles)
								if(lowertext(P.username) == lowertext(t))
									usr << "Cannot create profile: username already exists!"
									use_app()
									tablet.attack_self(usr)
									return
							t = reject_bad_name(t, 1, 18)
							if(!t)
								usr << "Cannot create profile: username contains bad characters!"
								use_app()
								tablet.attack_self(usr)
								return
							t = replacetext(t, " ", "")
							auth = new /datum/nanonet_profile
							auth.username = t
							auth.authentication = tablet.id
							server.profiles.Add(auth)
				else
					usr << "Please insert an ID to log into the NanoNet"
		//posting
			if("cancel")
				displayed_post = null
				displayed_doc = null
				displayed_profile = null
				displayed_hashtag = null
			if("post_status")
				if(displayed_post)
					if(!auth.post_cooldown && displayed_post.message)
						displayed_post.timestamp = "[worldtime2text()]"
						displayed_post.author_profile = auth
						server.statuses.Insert(1,displayed_post)
						auth.uploaded_photos.Add(displayed_post.photo)
						var/list/mentioned = list()
						//gather mentions
						var/msg = html_decode(lowertext(displayed_post.message))
						var/leng = lentext(msg)
						var/counter =1
						var/current
						var/list/skip_me_txt = list()
						while(counter<=leng)
							current = copytext(msg, counter , counter+1)
							if(current == "@")
								var/tend = findtext(msg," ",counter,leng+1)
								var/mentioned_text = copytext(msg,counter+1,tend)
								for(var/i=0, i<=255, i++)
									switch(i)
										// A  .. Z
										if(65 to 90) continue //Uppercase Letters
										// a  .. z
										if(97 to 122) continue //Lowercase Letters
										// 0  .. 9
										if(48 to 57) continue //Numbers
										// _
										if(95) continue // underscore
									mentioned_text = replacetext(mentioned_text,ascii2text(i),"")
								if(mentioned_text in skip_me_txt)
									counter++
									continue
								skip_me_txt.Add(mentioned_text)
								for(var/datum/nanonet_profile/N in server.profiles)
									if(N)
										if(lowertext(N.username) == lowertext(mentioned_text))
											mentioned.Add(lowertext(N.username))
											break
							if(current == "#")
								var/tend = findtext(msg," ",counter,leng+1)
								var/mentioned_text = copytext(msg,counter,tend)
								for(var/i=0, i<=255, i++)
									switch(i)
										// A  .. Z
										if(65 to 90) continue //Uppercase Letters
										// a  .. z
										if(97 to 122) continue //Lowercase Letters
										// 0  .. 9
										if(48 to 57) continue //Numbers
										// _
										if(95) continue // underscore
									mentioned_text = replacetext(mentioned_text,ascii2text(i),"")
								if(mentioned_text in skip_me_txt)
									counter++
									continue
								skip_me_txt.Add(mentioned_text)
								displayed_post.hashtags.Add(mentioned_text)
							counter++
                        //end mentions
						var/list/skip_me = list()
						for(var/obj/item/device/tablet/T in tablets_list)
							var/datum/program/nanonet/N = locate(/datum/program/nanonet) in T.core.programs
							if(N)
								if(N.auth && N.auth == auth) continue
								if(N.auth in auth.followers)
									if(!(T in skip_me))
										T.alert_self("NanoNet:","@[auth.username] posted a new status: [displayed_post.message]","nanonet")
									skip_me.Add(T)
								for(var/X in displayed_post.hashtags)
									for(var/datum/nanonet_hashtag/H in server.hashtags)
										if(X == H.hashtag)
											if(N.auth in H.followers)
												if(!(T in skip_me))
													T.alert_self("NanoNet:","@[auth.username] mentioned #[H.hashtag] in a status: [displayed_post.message]","nanonet")
												skip_me.Add(T)
								for(var/X in mentioned)
									if(X == lowertext(auth.username)) continue
									if(N.auth && lowertext(N.auth.username) == X)
										if(!(T in skip_me))
											T.alert_self("NanoNet:","@[auth.username] mentioned you in a status: [displayed_post.message]","nanonet")
										skip_me.Add(T)
						displayed_post = null
						spawn(300)
							auth.post_cooldown = 0
					else
						usr << "Please wait 30 seconds before making another post"
			if("add_photo")
				var/list/D = list()
				D["Cancel"] = "Cancel"
				for(var/datum/tablet_data/photo/data in tablet.core.files)
					D["Photo: [data.name]"] = data
				var/t = input(usr, "Upload Photo") as null|anything in D
				if(t && t != "Cancel")
					displayed_post.photo = D[t]
			if("upload")
				if(!auth.post_cooldown)
					var/list/D = list()
					D["Cancel"] = "Cancel"
					for(var/datum/tablet_data/document/data in tablet.core.files)
						D["Document: [data.name]"] = data
					var/t = input(usr, "Upload Document") as null|anything in D
					if(t && t != "Cancel")
						displayed_doc = D[t]
						server.pages.Insert(1,displayed_doc)
						auth.post_cooldown = 1
						spawn(300)
							auth.post_cooldown = 0
				else
					usr << "Please wait 30 seconds before making another post"
			if("add_status")
				if(displayed_post)
					var/datum/nanonet_message/safety_check = displayed_post
					var/draft = copytext(sanitize(input("Create Status (140 Character Limit)", "Create Status (140 Character Limit)", null, null)  as text),1,140)
					if(displayed_post && draft && safety_check == displayed_post)
						displayed_post.message = draft
				else
					var/draft = copytext(sanitize(input("Create Status (140 Character Limit)", "Create Status (140 Character Limit)", null, null)  as text),1,140)
					if(draft)
						displayed_post = new()
						displayed_post.message = draft
						displayed_post.author = auth.username
			if("view_post")
				displayed_post = locate(href_list["post"])
				displayed_profile = null
				displayed_hashtag = null
				displayed_doc = null
			if("like")
				if(displayed_post)
					if(!("@[auth.username]" in displayed_post.liked) && auth != displayed_post.author_profile)
						displayed_post.liked.Add("@[auth.username]")
						displayed_post.author_profile.likes++
			if("comment_on")
				if(displayed_post)
					var/datum/nanonet_message/safety_check = displayed_post
					var/draft = copytext(sanitize(input("Create Comment (140 Character Limit)", "Create Status (140 Character Limit)", null, null)  as text),1,140)
					if(displayed_post && draft && safety_check == displayed_post)
						var/list/mentioned = list()
						//gather mentions
						var/msg = html_decode(lowertext(draft))
						var/leng = lentext(msg)
						var/counter =1
						var/current
						var/list/skip_me_txt = list()
						while(counter<=leng)
							current = copytext(msg, counter , counter+1)
							if(current == "@")
								var/tend = findtext(msg," ",counter,leng+1)
								var/mentioned_text = copytext(msg,counter+1,tend)
								for(var/i=0, i<=255, i++)
									switch(i)
										// A  .. Z
										if(65 to 90) continue //Uppercase Letters
										// a  .. z
										if(97 to 122) continue //Lowercase Letters
										// 0  .. 9
										if(48 to 57) continue //Numbers
										// _
										if(95) continue // underscore
									mentioned_text = replacetext(mentioned_text,ascii2text(i),"")
								if(mentioned_text in skip_me_txt)
									counter++
									continue
								skip_me_txt.Add(mentioned_text)
								for(var/datum/nanonet_profile/N in server.profiles)
									if(N)
										if(lowertext(N.username) == lowertext(mentioned_text))
											mentioned.Add(lowertext(N.username))
											break
							if(current == "#")
								var/tend = findtext(msg," ",counter,leng+1)
								var/mentioned_text = copytext(msg,counter,tend)
								for(var/i=0, i<=255, i++)
									switch(i)
										// A  .. Z
										if(65 to 90) continue //Uppercase Letters
										// a  .. z
										if(97 to 122) continue //Lowercase Letters
										// 0  .. 9
										if(48 to 57) continue //Numbers
										// _
										if(95) continue // underscore
									mentioned_text = replacetext(mentioned_text,ascii2text(i),"")
								if(mentioned_text in skip_me_txt)
									counter++
									continue
								skip_me_txt.Add(mentioned_text)
							counter++
                        //end mentions
						var/list/skip_me = list()
						displayed_post.comments.Insert(1,"[worldtime2text()] - @[auth.username]</a>: [draft]")
						for(var/obj/item/device/tablet/T in tablets_list)
							var/datum/program/nanonet/N = locate(/datum/program/nanonet) in T.core.programs
							if(N)
								if(N.auth && N.auth == auth) continue
								if(displayed_post.author_profile == N.auth)
									T.alert_self("NanoNet:","@[auth.username] commented on your status: [draft]","nanonet")
								for(var/X in mentioned)
									if(X == lowertext(auth.username)) continue
									if(N.auth && lowertext(N.auth.username) == X)
										if(!(T in skip_me))
											T.alert_self("NanoNet:","@[auth.username] mentioned you in a comment: [draft]","nanonet")
										skip_me.Add(T)
		//profile editing
			if("follow")
				if(istype(displayed_hashtag,/datum/nanonet_hashtag))
					if((auth in displayed_hashtag.followers))
						displayed_hashtag.followers.Remove(auth)
					else if(displayed_hashtag && auth != displayed_hashtag)
						displayed_hashtag.followers.Add(auth)
				else
					if((auth in displayed_profile.followers))
						displayed_profile.followers.Remove(auth)
						for(var/obj/item/device/tablet/T in tablets_list)
							var/datum/program/nanonet/N = locate(/datum/program/nanonet) in T.core.programs
							if(N && N.auth && N.auth == displayed_profile)
								T.alert_self("NanoNet:","@[auth.username] Unfollowed you!","nanonet")
					else if(displayed_profile && auth != displayed_profile)
						displayed_profile.followers.Add(auth)
						for(var/obj/item/device/tablet/T in tablets_list)
							var/datum/program/nanonet/N = locate(/datum/program/nanonet) in T.core.programs
							if(N && N.auth && N.auth == displayed_profile)
								T.alert_self("NanoNet:","@[auth.username] Follows you!","nanonet")

			if("view_profile")
				displayed_profile = locate(href_list["post"])
				displayed_post = null
				displayed_doc = null
				displayed_hashtag = null
			if("view_doc")
				displayed_doc = locate(href_list["post"])
				displayed_post = null
				displayed_profile = null
				displayed_hashtag = null
			if("view_hashtag")
				displayed_doc = null
				displayed_post = null
				displayed_profile = null
				var/tag = href_list["post"]
				var/datum/nanonet_hashtag/found
				for(var/datum/nanonet_hashtag/H in server.hashtags)
					if (lowertext(H.hashtag) == lowertext(tag))
						found = H
				if(found)
					displayed_hashtag = found
				else
					displayed_hashtag = new()
					displayed_hashtag.hashtag = tag
					server.hashtags.Add(displayed_hashtag)

		use_app()
		tablet.attack_self(usr)


	proc/mention2url(var/data, var/obj/machinery/nanonet_server/server)
		//gather mentions
		var/list/mentioned = list()
		var/msg = html_decode(lowertext(data))
		var/leng = lentext(msg)
		var/counter =1
		var/current
		var/list/skip_me_txt = list()
		while(counter<=leng)
			current = copytext(msg, counter , counter+1)
			if(current == "@")
				var/tend = findtext(msg," ",counter,leng+1)
				var/mentioned_text = copytext(msg,counter+1,tend)
				for(var/i=0, i<=255, i++)
					switch(i)
						// A  .. Z
						if(65 to 90) continue //Uppercase Letters
						// a  .. z
						if(97 to 122) continue //Lowercase Letters
						// 0  .. 9
						if(48 to 57) continue //Numbers
						// _
						if(95) continue // underscore
					mentioned_text = replacetext(mentioned_text,ascii2text(i),"")
				if(mentioned_text in skip_me_txt)
					counter++
					continue
				skip_me_txt.Add(mentioned_text)
				var/datum/nanonet_profile/target
				for(var/datum/nanonet_profile/N in server.profiles)
					if(N)
						if(lowertext(N.username) == lowertext(mentioned_text))
							mentioned.Add(lowertext(N.username))
							target = N
							break
				if(target)
					data = replacetext(data, "@[target.username]", "<a href='byond://?src=\ref[src];choice=view_profile;post=\ref[target]'>@[target.username]</a>")
			if(current == "#")
				var/tend = findtext(msg," ",counter,leng+1)
				var/mentioned_text = copytext(msg,counter,tend)
				for(var/i=0, i<=255, i++)
					switch(i)
						// A  .. Z
						if(65 to 90) continue //Uppercase Letters
						// a  .. z
						if(97 to 122) continue //Lowercase Letters
						// 0  .. 9
						if(48 to 57) continue //Numbers
						// _
						if(95) continue // underscore
					mentioned_text = replacetext(mentioned_text,ascii2text(i),"")
				if(mentioned_text in skip_me_txt)
					counter++
					continue
				skip_me_txt.Add(mentioned_text)
				data = replacetext(data, "#[mentioned_text]", "<a href='byond://?src=\ref[src];choice=view_hashtag;post=[mentioned_text]'>#[mentioned_text]</a>")
			counter++
        //end mentions
		return data

//nanonet datums
/datum/nanonet_profile/
	var/username = null
	var/obj/item/weapon/card/id/authentication = null
	var/list/uploaded_photos = list()
	var/post_cooldown
	var/list/followers = list()
	var/likes = 0

/datum/nanonet_hashtag/
	var/hashtag
	var/list/followers = list()

/datum/nanonet_message/
	var/author
	var/datum/nanonet_profile/author_profile
	var/message
	var/timestamp
	var/list/comments = list()
	var/datum/tablet_data/photo/photo
	var/list/liked = list()
	var/list/hashtags = list()