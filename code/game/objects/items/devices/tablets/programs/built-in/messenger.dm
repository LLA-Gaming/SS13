/datum/program/builtin/messenger
	name = "Messenger"
	app_id = "messenger"
	usesalerts = 1
	var/datum/tablet_data/conversation/active_chat = null
	var/spamcheck

	use_app()
		dat = "<h2>Network Messenger</h2>"
		if(!tablet.messengeron)
			dat += "<a href='byond://?src=\ref[src];choice=ToggleMessenger'>[tablet.messengeron ? "Messenger: On" : "Messenger: Off"]</a>"
			dat += " <a href='byond://?src=\ref[src];choice=Ringtone'>Ringtone</a><br>"
			return
		if(!tablet.network())
			dat += "ERROR: No connection found"
			return
		var/obj/machinery/nanonet_server/server
		for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
			if(MS.active)
				server = MS
		if(server)
			var/list/users_online = list()
			dat += "<a href='byond://?src=\ref[src];choice=ToggleMessenger'>[tablet.messengeron ? "Messenger: On" : "Messenger: Off"]</a>"
			dat += " <a href='byond://?src=\ref[src];choice=Ringtone'>Ringtone</a><br>"
			if(active_chat)
				dat += "<h3><a href='byond://?src=\ref[src];choice=Change Title'>[active_chat.name]</a> - [active_chat.users.len] users in this chat</h3>"
				dat += "<a href='byond://?src=\ref[src];choice=Message'>Message</a> "
				dat += "<a href='byond://?src=\ref[src];choice=Add Users'>Add User to Chat</a> "
				dat += "<a href='byond://?src=\ref[src];choice=Send File'>Send File</a> "
				dat += "<a href='byond://?src=\ref[src];choice=Minimize Chat'>Minimize Chat</a> "
				dat += "<a href='byond://?src=\ref[src];choice=Leave Chat'>Leave</a>"
				dat += "<div class='statusDisplay'>"
				dat += "[active_chat.log]"
				dat += "</div>"
				return
			dat += "<h3>Active Conversations</h3>"
			for(var/datum/tablet_data/conversation/C in server.convos)
				if(C.users.Find(tablet))
					dat += "<div class='statusDisplay'>"
					dat += "[C.name]<br>"
					dat += "Last Message: [C.lastmsg]<br>"
					dat += "<a href='byond://?src=\ref[src];choice=Open Chat;target=\ref[C]'>Open</a><br>"
					dat += "</div>"
			for(var/obj/item/device/tablet/T in sortAtom(tablets_list))
				if(T == tablet) continue
				if(T.network() && T.core && T.core.owner && T.messengeron)
					users_online.Add(T)
			dat += "<h3>Users Online</h3>"
			dat += "<div class='statusDisplay'>"
			for(var/obj/item/device/tablet/T in users_online)
				dat += "[T.owner] ([T.ownjob]) - <a href='byond://?src=\ref[src];choice=Start Chat;target=\ref[T]'>Chat</a><br>"
			dat += "</div>"

	Topic(href, href_list)
		if (!..()) return
		switch(href_list["choice"])
			if("Start Chat")
				var/obj/machinery/nanonet_server/server
				for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
					if(MS.active)
						server = MS
				if(server)
					var/obj/item/device/tablet/T = locate(href_list["target"])
					if(T.messengeron)
						//existing chat search
						for(var/datum/tablet_data/conversation/C in server.convos)
							if(C.users.Find(tablet) && C.users.Find(T) && C.users.len <= 2)
								active_chat = C
						if(!active_chat)
							var/datum/tablet_data/conversation/C = new /datum/tablet_data/conversation/(src)
							server.convos.Add(C)
							active_chat = C
							active_chat.name = "[tablet.owner]/[T.owner]"
							active_chat.users.Add(tablet)
							active_chat.users.Add(T)
							active_chat.host = tablet
							active_chat.log += "--Conversation opened by [tablet.owner] ([tablet.ownjob])<br>"
							active_chat.log += "--[T.owner] ([T.ownjob]) added to the conversation<br>"
							active_chat.raw_log += "--Conversation opened by [tablet.owner] ([tablet.ownjob])<br>"
							active_chat.raw_log += "--[T.owner] ([T.ownjob]) added to the conversation<br>"
							active_chat.host = tablet
			if("Open Chat")
				var/obj/machinery/nanonet_server/server
				for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
					if(MS.active)
						server = MS
				if(server)
					var/datum/tablet_data/conversation/C = locate(href_list["target"])
					active_chat = C
			if("Minimize Chat")
				active_chat = null
			if("Add Users")
				if(!spamcheck)
					spamcheck = 1
					var/list/D = list()
					D["Cancel"] = "Cancel"
					for(var/obj/item/device/tablet/T in tablets_list)
						if(T == tablet) continue
						if(active_chat.users.Find(T)) continue
						if(active_chat.leftchat.Find(T)) continue
						if(T.network() && T.core && T.core.owner && T.messengeron)
							D["[T.owner] ([T.ownjob])"] = T

					var/t = input(usr, "Add who?") as null|anything in D
					spamcheck = 0
					if(t && t != "Cancel")
						active_chat.users.Add(D[t])
						active_chat.log += "--[t] has been added to the conversation<br>"
						active_chat.raw_log += "--[t] has been added to the conversation<br>"
						if(!active_chat.renamed)
							active_chat.name = "Group Chat"
							active_chat.renamed = 1
						log_pda("[usr.key] (tablet: [tablet.owner]) added \"[t]\" to the chat: [active_chat.name]")
						for(var/obj/item/device/tablet/T in active_chat.users)
							if(T == tablet) continue
							if(!T.messengeron) continue
							T.alert_self("Messenger:","<b>[tablet.owner] ([tablet.ownjob]) added [t] to \"[active_chat.name]\"","messenger")
			if("Send File")
				if(!spamcheck)
					spamcheck = 1
					var/list/D = list()
					D["Cancel"] = "Cancel"
					for(var/datum/program/app in tablet.core.programs)
						if(app.built_in) continue
						if(app.drm) continue
						D["Program: [app.name]"] = app
					for(var/datum/tablet_data/data in tablet.core.files)
						D["Data: [data.name]"] = data
					var/t = input(usr, "Send file") as null|anything in D
					spamcheck = 0
					if(t)
						var/datum/program/builtin/messenger/M = null
						for(var/obj/item/device/tablet/T in active_chat.users)
							if(T == tablet) continue
							if(!T.messengeron) continue
							T.alert_self("Messenger:","<b>Download from [active_chat.name], </b>\"[t]\"","messenger")
							for(var/datum/program/builtin/messenger/msgner in T.core.programs)
								M = msgner
								break
						if(istype(D[t],/datum/program/))
							var/datum/program/sent = D[t]
							active_chat.log += "--[tablet.owner] has sent \"[t]\" <a href='byond://?src=\ref[M];choice=Download File;target=\ref[sent]'>Download</a><br>"
							active_chat.raw_log += "--[tablet.owner] has sent \"[t]\" <br>"
							active_chat.lastmsg += "--[tablet.owner] has sent \"[t]\""
							log_pda("[usr.key] (tablet: [tablet.owner]) sent a file \"[sent.name]\" in chat: [active_chat.name]")
						if(istype(D[t],/datum/tablet_data/))
							var/datum/tablet_data/sent = D[t]
							active_chat.log += "--[tablet.owner] has sent \"[t]\" <a href='byond://?src=\ref[M];choice=Download File;target=\ref[sent]'>Download</a><br>"
							active_chat.raw_log += "--[tablet.owner] has sent \"[t]\" <br>"
							active_chat.lastmsg += "--[tablet.owner] has sent \"[t]\""
							log_pda("[usr.key] (tablet: [tablet.owner]) sent a file \"[sent.name]\" in chat: [active_chat.name]")
			if("Download File")
				if(istype(locate(href_list["target"]),/datum/tablet_data/))
					var/datum/tablet_data/data = locate(href_list["target"])
					tablet.core.files.Add(new data.type)
					usr << "<span class='notice'>[data.name] downloaded!</span>"
				if(istype(locate(href_list["target"]),/datum/program/))
					var/datum/program/P = locate(href_list["target"])
					var/duplicate = 0
					for(var/datum/program/dup in tablet.core.programs)
						if(dup.app_id == P.app_id)
							duplicate = 1
					if(!duplicate)
						tablet.core.programs.Add(new P.type)
						usr << "<span class='notice'>[P.name] downloaded and installed!</span>"
					else
						usr << "ERROR: You already own [P.name]"

			if("Leave Chat")
				active_chat.users.Remove(tablet)
				active_chat.leftchat.Add(tablet)
				active_chat.log += "--[tablet.owner] ([tablet.ownjob]) has left the conversation<br>"
				active_chat.raw_log += "--[tablet.owner] ([tablet.ownjob]) has left the conversation<br>"
				for(var/obj/item/device/tablet/T in active_chat.users)
					if(T == tablet) continue
					if(!T.messengeron) continue
					T.alert_self("Messenger:","<b>[tablet.owner] ([tablet.ownjob]) has left \"[active_chat.name]\"","messenger")
				log_pda("[usr.key] (tablet: [tablet.owner]) left chat: \"[active_chat.name]\"")
				if(!active_chat.users.len)
					qdel(active_chat)
				active_chat = null
			if("Change Title")
				if(!spamcheck)
					if(active_chat.host == tablet)
						spamcheck = 1
						var/lastname = active_chat.name
						var/t = copytext(sanitize(input("Rename Chat", "Rename", null, null)  as text),1,MAX_MESSAGE_LEN)
						if(t)
							active_chat.name = t
							active_chat.renamed = 1
							log_pda("[usr.key] (tablet: [tablet.owner]) renamed chat: \"[lastname]\" to \"[active_chat.name]\"")
							for(var/obj/item/device/tablet/T in active_chat.users)
								if(!T.messengeron) continue
								T.alert_self("Chat Renamed:","<b>[lastname] to [active_chat.name]</b>","messenger")
						spamcheck = 0
			if("Message")
				if(!spamcheck)
					var/datum/tablet_data/conversation/chat = null
					var/quick_reply = 0
					spamcheck = 1
					if(locate(href_list["target"]))
						chat = locate(href_list["target"])
						quick_reply = 1
					else
						chat = active_chat
					if(!chat.users.Find(tablet))
						return
					var/t = copytext(sanitize(input("Message", "Message", null, null)  as text),1,MAX_MESSAGE_LEN)
					if(t)
						chat.log += "[tablet.owner] ([tablet.ownjob]): [t]<br>"
						chat.raw_log += "[tablet.owner] ([tablet.ownjob]): [t]<br>"
						chat.lastmsg = "[tablet.owner] ([tablet.ownjob]): [t]"
						log_pda("[usr.key] (tablet: [tablet.owner]) messaged \"[t]\" in chat: [chat.name]")
						if(chat.users.len > 2)
							for(var/obj/item/device/tablet/T in chat.users)
								if(T == tablet) continue
								if(!T.messengeron) continue
								for(var/datum/program/builtin/messenger/M in T.core.programs)
									T.alert_self("Messenger:","<b>Message in [chat.name] by [tablet.owner], </b>\"[t]\" <a href='byond://?src=\ref[M];choice=Message;target=\ref[chat]'>Reply</a>","messenger")
									break
						else
							for(var/obj/item/device/tablet/T in chat.users)
								if(T == tablet) continue
								if(!T.messengeron) continue
								for(var/datum/program/builtin/messenger/M in T.core.programs)
									T.alert_self("Messenger:","<b>Message from [tablet.owner], </b>\"[t]\" <a href='byond://?src=\ref[M];choice=Message;target=\ref[chat]'>Reply</a>","messenger")
									break

						//send messages to ghosts
						for(var/mob/M in player_list)
							if(isobserver(M) && M.client && (M.client.prefs.toggles & GHOST_MESSENGER))
								M.show_message("<span class='game say'>Tablet Message - \[<span class='name'>[chat.name]</span>\] <span class='name'>[tablet.owner]</span>: <span class='message'>[t]</span></span>")

					spamcheck = 0
					if(quick_reply)
						return
			if("ToggleMessenger")
				tablet.messengeron = !tablet.messengeron
			if("Ringtone")
				var/t = stripped_input(usr, "Please enter message", name, null) as text
				if (t)
					if(tablet.hidden_uplink && tablet.hidden_uplink.check_trigger(usr, trim(lowertext(t)), trim(lowertext(tablet.lock_code))))
						usr << "The tablet flashes red."
						tablet.core.loaded = null
						tablet.popup.close()
						usr.unset_machine()
					else
						t = copytext(sanitize(t), 1, 20)
						tablet.core.ttone = t
		use_app()
		tablet.attack_self(usr)