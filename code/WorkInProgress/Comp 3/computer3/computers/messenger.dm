/datum/file/program/messenger
	name = "SpaceMessenger"
	desc = "Used to send messages to and from Crew Members. Able to print and clear messages. However, a fallacy is that it cannot be locked."
	var/messages = null
	var/screen_name = "User"
	var/obj/item/part/computer/networking/radio = perephrial

//To-do: take screen_name from inserted id card??
//Saving log to file datum

/datum/file/program/messenger/interact()
	if(!interactable())
		return

		var/dat += "<a href='byond://?src=\ref[src];quit=1'>Quit</a><br>"

		dat += "<b>SpaceMessenger V3</b><br>"

		dat += "<a href='byond://?src=\ref[src];send_msg=1'>Send Message</a>"
		dat += " | <a href='byond://?src=\ref[src];func_msg=clear'>Clear Messages</a>"
		dat += " | <a href='byond://?src=\ref[src];func_msg=print'>Print Messages</a>"

		dat += " | Name:<a href='byond://?src=\ref[src];set_name=1'>[src.screen_name]</a><hr>"

		dat += messages

		dat += "</center>"

		return dat

/datum/file/program/messenger/Topic(href, href_list)
	if(!interactable())
		return

		if(href_list["send_msg"])
			var/t = input(usr, "Please enter message. Enter no text to cancel.", src.id_tag, null) as text
			t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
			if (!t)
				return
			if(!interactable())
				return

			var/datum/signal/signal = new
			signal.data["type"] = "message"
			signal.data["data"] = t
			signal.data["sender"] = src.screen_name
			src.messages += "<i><b>&rarr; You:</b></i><br>[t]<br>"

			peripheral.post_signal(signal)

		if(href_list["func_msg"])
			switch(href_list["func_msg"])
				if("clear")
					src.messages = null

				if("print")
					var/datum/signal/signal = new
					signal.data["data"] = src.messages
					signal.data["title"] = "Chatlog"
					peripheral_command("print", signal)

				//if("save")
					//TO-DO

		src.computer.add_fingerprint(usr)
		src.computer.updateUsrDialog()
		return

	receive_command(obj/source, command, datum/signal/signal)
		if(command == "radio signal")
			switch(signal.data["type"])
				if("message")
					var/sender = signal.data["sender"]
					if(!sender)
						sender = "Unknown"

					src.messages += "<i><b>&larr; From [sender]:</b></i><br>[signal.data["data"]]<br>"
					if(src.computer.active_program == src)
						playsound(src.computer.loc, 'sound/machines/twobeep.ogg', 50, 1)
						src.computer.updateUsrDialog()

		return
/*
/proc/get_viewable_sm()
	. = list()
	// Returns a list of PDAs which can be viewed from another PDA/message monitor.
	for(var/obj/item/device/pda/P in PDAs)
		if(!P.owner || P.toff || P.hidden) continue
		. += P
	return .*/