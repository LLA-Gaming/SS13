/obj/item/device/thinktronic_parts/program/general/chatroom
	name = "Nanotrasen Relay Chat"
	var/chat_channel = "#station" //name of our current NTRC channel
	var/nick = "" //our NTRC nick
	var/list/ntrclog = list() //NTRC message log
	var/helptext = 0
	var/spamcheck = 0
	usealerts = 1
	alerts = 0

	use_app()
		dat = ""
		if(network())
			var/obj/item/device/thinktronic_parts/core/hdd = loc // variable for interactin with the HDD
			if(!nick) //first time join
				nick = copytext(sanitize(hdd.owner), 1, 12)
				var/datum/chatroom/C = chatchannels[chat_channel]
				C.parse_msg(src, nick, "/join [chat_channel]")
			dat += "<h4>Nanotrasen Relay Chat Network</h4>"

			dat += "<a href='byond://?src=\ref[src];choice=Set Nick'>Nickname:[nick]</a> <br> "
			dat += "<a href='byond://?src=\ref[src];choice=Set Channel'>Channel: [chat_channel]</a> <br> "
			dat += "<a href='byond://?src=\ref[src];choice=NTRC Message'>Write message</a> <br> "
			dat += "<a href='byond://?src=\ref[src];choice=NTRC Help'>Help</a><br>"
			if(helptext)
				dat += "<div class='statusDisplay'>/join #channel<br>/register<br>/log amountoflines</div>"
			if(chat_channel)
				dat += "<div class='statusDisplay'>"
				dat += ntrclog[chat_channel]
				dat += "</div>"
		else
			dat = "ERROR: No connection to the server"


	Topic(href, href_list) // This is here
		..()
		var/obj/item/device/thinktronic_parts/core/hdd = loc // variable for interactin with the HDD
		var/obj/item/device/thinktronic/PDA = hdd.loc // variable for interacting with the Device itself
		switch(href_list["choice"])
			if("Set Nick")
				if(!network())
					PDA.attack_self(usr)
					return
				if(spamcheck)
					return
				spamcheck = 1
				var/t = stripped_input(usr, "Please enter nickname", name, null) as text
				spamcheck = 0
				nick = copytext(sanitize(t), 1, 12)
				PDA.attack_self(usr)
			if("Set Channel")
				if(!network())
					PDA.attack_self(usr)
					return
				if(spamcheck)
					return
				spamcheck = 1
				var/t = stripped_input(usr, "Please enter channel", name, (chat_channel)) as text
				spamcheck = 0
				if(t)
					var/datum/chatroom/C = chatchannels[chat_channel]
					var/ret = C.parse_msg(src, nick, "/join [t]")
					if((ret in chatchannels) && (ret != chat_channel))
						ntrclog[chat_channel] = "<hr>" + ntrclog[chat_channel]
						chat_channel = ret
				PDA.attack_self(usr)
			if("NTRC Message")
				if(!network())
					PDA.attack_self(usr)
					return
				if(spamcheck)
					return
				spamcheck = 1
				var/t = input(usr, "Please enter message", name, null) as text
				t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
				spamcheck = 0
				var/datum/chatroom/C = chatchannels[chat_channel]
				if(C)
					var/ret = C.parse_msg(src,nick,t)
					if(findtextEx(ret,"BAD_",1,5))
						ntrclog[chat_channel] = "[ret]<br>" + ntrclog[chat_channel]
					else if(ret in chatchannels)
						chat_channel = ret
				PDA.attack_self(usr)
			if("NTRC Help")
				helptext = !helptext
				PDA.attack_self(usr)
//NTRC code

var/datum/chatroom/default_ntrc_chatroom = new()
var/list/chatchannels = list(default_ntrc_chatroom.name = default_ntrc_chatroom)

//procs that can be used directly:
//channel.parse_msg

/datum/chatroom
	var/name = "#station"
	var/list/logs = list() // chat logs
	var/list/auth = list() // authenticated clients
	var/list/authed = list() //authenticated users
	var/datum/events/events = new ()
	var/list/datum/event/evlist = list()

//parse_msg() is the exposed interface chat
//clients should interact with parse_msg() and parse_msg() only

/datum/chatroom/proc/parse_msg(client,nick,message)
	for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
		if(!MS)
			return "BAD_TCOM"
		if(!get_auth(client,nick) || !nick || length(nick) > 12)
			return "BAD_NICK"


		var/list/cmd=text2list(message, " ")
		switch(cmd[1])
			if("/register")
				return register_auth(client,nick)
			if("/join")
				if(cmd[2])	return channel_join(client,nick,cmd[2])
			if("/log")
				if(cmd[2])	return get_log(client,nick,cmd[2])

		return send_message(client,nick,message)

//the following are helper procs, FOR INTERNAL USE ONLY

/datum/chatroom/proc/check_server(client)
	var/atom/C = client
	var/turf/CT = get_turf(C)
	if(message_servers)
		for (var/obj/machinery/message_server/MS in message_servers)
			var/turf/T = get_turf(MS)
			if(MS.active && (T.z == CT.z))
				return MS
	return null

/datum/chatroom/proc/send_message(client,nick,message) //standard message
	if(!message)
		return 0
	logs.Insert(1,"[strip_html(nick)]> [strip_html(message)]")
	log_pda("[usr]/([usr.ckey]) as [nick] sent to [name]: [message]")
	events.fireEvent("msg_chat",name,nick,message)
	for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
		MS.SendAlert("[name]: [nick] - [message]","Nanotrasen Relay Chat")
	return 1

/datum/chatroom/proc/get_auth(client,nick) //check auth
	if((!(nick in authed)) || (auth[client] == nick))
		return 1
	return 0

//chat commands go here, FOR INTERNAL USE ONLY
/datum/chatroom/proc/register_auth(client,nick) //register
	if(!get_auth(client,nick))
		return "BAD_REGS"
	auth[client] = nick
	authed += nick
	return 1

/datum/chatroom/proc/channel_join(client,nick,channel) //join
	if(!findtext(channel,"#",1,2))
		channel = "#" + channel
	if(channel == name) //join this channel
		if(!(client in evlist))
			evlist[client] = events.addEvent("msg_chat",client,"msg_chat")
		return name

	else //leave this channel, join another one
		if(client in evlist)
			events.clearEvent("msg_chat",evlist[client])
			evlist -= client
		if(!(channel in chatchannels))
			var/datum/chatroom/NC = new /datum/chatroom()
			NC.name = channel
			chatchannels[channel] = NC
		var/datum/chatroom/C = chatchannels[channel]
		return C.parse_msg(client,nick,"/join [channel]")

/datum/chatroom/proc/get_log(client,nick,lines) //log
	lines = text2num(lines)
	lines = min(lines, logs.len)
	for(var/i=0;i<lines;i++)
		call(client,"msg_chat")(name,"NTbot","LOG[i]: [logs[(logs.len)-i]]")
	return 1

//ntrc handler proc
/obj/item/device/thinktronic_parts/program/general/chatroom/proc/msg_chat(channel as text, sender as text, message as text)
	var/msg = "{[worldtime2text()]}<b>[strip_html(sender)]</b>| [strip_html(message)]<br>"
	if(!channel)
		for(var/C in ntrclog)
			ntrclog[C] = msg + ntrclog[C]
	else
		ntrclog[channel] = msg + ntrclog[channel]