/obj/machinery/bot/companion
	name = "Companion Bot"
	desc = "Your very own best friend.. your only friend..."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "friendbot"
	layer = 5.0
	density = 0
	anchored = 0
	health = 50
	maxhealth = 50
	req_access =list(access_robotics)
	var/list/botcard_access = list()
	var/movement = 1
	var/talk = 1
	var/turns_per_move = 3
	var/turns_since_move = 0
	var/turns_to_idle = 10
	var/turns_since_action = 0
	var/list/idle_speech = list()
	var/list/command_speech = list()
	var/list/friends = list()
	var/list/speech_buffer = list()
	var/target = null
	var/command = null

	New()
		..()
		src.icon_state = "[initial(icon_state)][src.on]"

		spawn(4)
			src.botcard = new /obj/item/weapon/card/id(src)
			src.botcard.access = src.botcard_access

	speak(var/message)
		if((!src.on) || (!message))
			return
		if (copytext(message, 1, 2) == "*")
			var/emote = copytext(message, 2)
			switch(emote)
				if("ping")
					playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)
				if("beep")
					playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)
				if("buzz")
					playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			return
		for(var/mob/O in hearers(src, null))
			O.show_message("<span class='game say'><span class='name'>[src]</span> beeps, \"[message]\"</span>",2)
		return

	turn_on()
		. = ..()
		src.icon_state = "[initial(icon_state)][src.on]"
		src.updateUsrDialog()

	turn_off()
		..()
		src.icon_state = "[initial(icon_state)][src.on]"
		src.updateUsrDialog()

	attack_hand(mob/user as mob)
		. = ..()
		if(.)
			return
		usr.set_machine(src)
		interact(user)

	interact(mob/user as mob)
		var/dat
		dat += hack(user)
		dat += text({"
	<TT><B>Companion Bot v2.2</B></TT><BR><BR>
	Status: []<BR>
	Idle Movement: []<BR>
	Idle Chit-Chat: []<BR>
	Behaviour controls are [src.locked ? "locked" : "unlocked"]<BR>
	Maintenance panel panel is [src.open ? "opened" : "closed"]"},

	"<A href='?src=\ref[src];power=1'>[src.on ? "On" : "Off"]</A>","<A href='?src=\ref[src];movement=1'>[src.movement ? "On" : "Off"]</A>","<A href='?src=\ref[src];talk=1'>[src.talk ? "On" : "Off"]</A>" )

		user << browse("<HEAD><TITLE>Companion Bot v2.2 controls</TITLE></HEAD>[dat]", "window=autofriend")
		onclose(user, "autosec")
		return

	Topic(href, href_list)
		if(..())
			return
		usr.set_machine(src)
		if((href_list["power"]) && (src.allowed(usr)))
			if (src.on)
				turn_off()
			else
				turn_on()
			return
		if((href_list["movement"]) && (src.allowed(usr)))
			src.movement = !src.movement
			return
		if((href_list["talk"]) && (src.allowed(usr)))
			src.talk = !src.talk
			return

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/tablet))
			if(src.allowed(user) && !open)
				src.locked = !src.locked
				user << "Controls are now [src.locked ? "locked." : "unlocked."]"
			else
				if(open)
					user << "\red Please close the access panel before locking it."
				else
					user << "\red Access denied."
		else
			..()
			if(!istype(W, /obj/item/weapon/screwdriver) && !istype(W, /obj/item/weapon/weldingtool) && (W.force))
				if(prob(25))
					var/message = pick("OW","HELP!","STOP!","HAVE MERCY!","SPARE ME!")
					speak(message)

	explode()
		src.on = 0
		visible_message("<span class='userdanger'>[src] blows apart!</span>", 1)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		qdel(src)
		return

	process()
		set background = BACKGROUND_ENABLED

		if(!src.on)
			return

		//movement
		if(isturf(src.loc))
			turns_since_move++
			if(turns_since_move >= turns_per_move)
				if(!(pulledby) && (src.on) && movement && !target)
					Move(get_step(src,pick(cardinal)))
					turns_since_move = 0

		//Be talked to
		var/to_say
		var/command = null
		if (speech_buffer.len > 0)
			var/who = speech_buffer[1] // Who said it?
			var/phrase = speech_buffer[2] // What did they say?

			//GET OVER HERE!
			if (findtext(phrase, "Come") || findtext(phrase, "Follow") || findtext(phrase, "Get over here"))
				to_say = safepick("*ping")
				command = "follow"

			//Open that door
			else if (findtext(phrase, "Door") || findtext(phrase, "Airlock"))
				to_say = safepick("*ping")
				command = "airlock"

			else if (findtext(phrase, "Stay") || findtext(phrase, "Stop") || findtext(phrase, "Cease"))
				to_say = safepick("*buzz")
				command = "stay"

			else if (findtext(phrase, "Friend"))
				to_say = safepick("*beep")
				command = "friend"

			else if (findtext(phrase, name))
				to_say = safepick(idle_speech)

			else
				for(var/X in command_speech)
					if (findtext(phrase, X))
						to_say = command_speech[X]

			switch(command)
				if("follow")
					var/other_robots = 0
					for(var/obj/machinery/bot/companion/C in oview(7,src.loc))
						other_robots = 1
					if(!other_robots)
						target = who
					else
						if(findtext(phrase, name))
							target = who
				if("airlock")
					var/list/doors = list()
					for(var/obj/machinery/door/airlock/A in oview(5,src.loc))
						doors.Add(A)
					var/obj/machinery/door/airlock/chosen = safepick(doors)
					if(chosen)
						target = chosen
				if("stay")
					target = null
				if("friend")
					var/list/people = list()
					for(var/mob/living/carbon/human/H in oview(7,src.loc))
						if(friends.Find(H)) continue
						var/space = findtext(H.name, " ", 1, 0)
						var/f_name = copytext(H.name, 1, space)
						var/l_name = copytext(H.name, space, length(H.name) + 1)
						if(findtext(phrase, f_name))
							people.Add(H)
							continue
						if(findtext(phrase, l_name))
							people.Add(H)
							continue
					if(people.len)
						var/mob/living/carbon/human/H = safepick(people)
						if(H)
							friends.Add(H)
							speak("Friend registered: [H.name]")
						else
							speak("*buzz")
							speak("error #404: New friend not found")

		//check duplicates
		for(var/obj/machinery/bot/companion/C in oview(7,src.loc))
			if(target == C.target)
				target = null

		//follow target
		if(isturf(src.loc))
			if(!target)
				turns_since_action = 0
				walk_to(src, null, 0,0)
			if(!(target in oview(1,src.loc)))
				turns_since_action = 0
			if(!(target in oview(7,src.loc)))
				target = null
			if(target in oview(1,src.loc))
				if (istype(target, /obj/machinery/door))
					Bump(target)
					target = null
				if (istype(target, /obj/item))
					var/obj/item/I = target
					if(I.w_class <= 3 &&  !I.anchored)
						I.loc = src // get inside me
						src.visible_message("<span class='notice'>[src] consumes \the [I]</span>")
						target = null
						src.speak("*beep")
					else
						src.speak("*buzz")
				turns_since_action++
				if(turns_since_action >= turns_to_idle)
					target = null
			if(target)
				walk_to(src, src.target,1,4)

		//speech
		if(prob(5) && !to_say)
			var/message = safepick(idle_speech)
			if(message && talk)
				src.speak(message)
				return

		src.speak(to_say)
		speech_buffer = list()

	Bump(M as mob|obj) //Leave no door unopened!
		if ((istype(M, /obj/machinery/door)) && (!isnull(src.botcard)))
			var/obj/machinery/door/D = M
			if (istype(D,/obj/machinery/door/poddoor))
				return
			if (!istype(D, /obj/machinery/door/firedoor) && D.check_access(src.botcard))
				D.open()
				if(target == D)
					target = null
			else
				src.speak("*buzz")
		else if ((istype(M, /mob/living/)) && (!src.anchored))
			src.loc = M:loc
		return

/obj/item/weapon/storage/box/attackby(obj/item/weapon/S as obj, mob/user as mob)

	if ((!istype(S, /obj/item/stack/sheet/metal)))
		..()
		return

	if(src.contents.len >= 1)
		user << "<span class='notice'>You need to empty [src] out first.</span>"
		return

	var/obj/item/weapon/companion_assembly/A = new /obj/item/weapon/companion_assembly

	var/obj/item/stack/sheet/metal/R = S
	R.use(1)
	user.put_in_hands(A)
	user << "<span class='notice'>You reinforce the box with metal</span>"
	user.unEquip(src, 1)
	qdel(src)

/obj/item/weapon/companion_assembly/
	name = "metal box assembly"
	desc = "a metal box"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "friendbot_proxy0"
	var/buildstep = 0

	var/created_name = "Companion Bot"
	var/created_desc = "Your best friend"

	var/list/botcard_access = list()
	var/list/idle_speech = list()
	var/list/command_speech = list()

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		..()
		switch(buildstep)
			if(0)
				if (istype(W, /obj/item/stack/sheet/glass))
					buildstep++
					user << "<span class='notice'>You add the [W] to [src], creating a screen for the interface</span>"
					icon_state = "friendbot_proxy[buildstep]"
					name = "metalbox/screen assembly"
					desc = "a metal box with a screen attached"
					var/obj/item/stack/sheet/glass/R = W
					R.use(1)
			if(1)
				if(isprox(W))
					buildstep++
					user << "<span class='notice'>You add the [W] to [src]</span>"
					icon_state = "friendbot_proxy[buildstep]"
					name = "metalbox/screen/signaller assembly"
					desc = "a metal box with a screen and signaller attached"
					qdel(W)
			if(2)
				if (istype(W, /obj/item/robot_parts/l_arm) || (istype(W, /obj/item/robot_parts/r_arm)))
					buildstep++
					user << "<span class='notice'>You add the [W] to [src]</span>"
					icon_state = "friendbot_proxy[buildstep]"
					name = "companion bot assembly"
					desc = "a finished companion bot, just needs programing"
					qdel(W)
			if(3)
				if (istype(W, /obj/item/device/multitool))
					src.Interact(user)

	proc/Interact(mob/user)
		var/t1 = text("Name: <A href='?src=\ref[];Name=1'>[(created_name ? "[created_name]" : "Companion Bot")]</a><br>\n",src)
		t1 += text("Description: <A href='?src=\ref[];Desc=1'>[(created_desc ? "[created_desc]" : "Your best friend")]</a><br>\n",src)
		t1 += text("Door Access: <A href='?src=\ref[];ID=1'>\<SWIPE ID\></a><br>\n",src)
		t1 += "COMMANDS: (Pre-programmed) <br>"
		t1 += "[TAB] COME | FOLLOW | GET OVER HERE -- follow you <br>"
		t1 += "[TAB] DOOR | AIRLOCK -- opens door <br>"
		t1 += "[TAB] STAY | STOP | CEASE -- stop moving/stay put <br>"
		t1 += "[TAB] FRIEND -- add a new friend to friend database<br>"
		t1 += "Idle speech:"
		t1 += text("<A href='?src=\ref[];NewPhrase=1'>New</a><br>\n",src)
		for(var/X in idle_speech)
			t1 += text("[TAB][X] <A href='?src=\ref[];RemovePhrase=1;phrase=[]'>X</a><br>\n",src,X)
		t1 += "Speech and Response:"
		t1 += text("<A href='?src=\ref[];NewCommand=1'>New</a><br>\n",src)
		for(var/X in command_speech)
			t1 += text("[TAB] SPEECH: [X] || RESPONSE: [command_speech[X]] <A href='?src=\ref[];RemoveCommand=1;phrase=[]'>X</a><br>\n",src,X)
		t1 += "<br>"
		t1 += text("<A href='?src=\ref[];Final=1'>Finalize</a><br>\n",src)
		var/datum/browser/popup = new(user, "botdebug", "Companion Bot Programing", 640, 480)
		popup.set_content(t1)
		popup.open()

	Topic(href, href_list)
		if(usr.lying || usr.stat || usr.stunned || !Adjacent(usr))
			return

		var/mob/living/living_user = usr
		var/obj/item/item_in_hand = living_user.get_active_hand()

		if(href_list["ID"])
			if(istype(item_in_hand, /obj/item/weapon/card/id))
				var/obj/item/weapon/card/id/I = item_in_hand
				botcard_access = I.GetAccess()
				living_user << "<span class='notice'>You swipe your ID on \the [src]</span>"
				return
			return


		if(!istype(item_in_hand, /obj/item/device/multitool))
			living_user << "<span class='error'>You need a multitool!</span>"
			return

		if(href_list["Name"])
			var/new_name = stripped_input(usr, "Enter new description. Set to blank to reset to default.", "Companion Bot Programing", src.created_desc)
			if(!in_range(src, usr) && src.loc != usr)
				return
			if(new_name)
				created_name = new_name
			else
				created_name = initial(created_name)

		else if(href_list["Desc"])
			var/new_desc = stripped_input(usr, "Enter new name. Set to blank to reset to default.", "Companion Bot Programing", src.created_desc)
			if(!in_range(src, usr) && src.loc != usr)
				return
			if(new_desc)
				created_desc = new_desc
			else
				created_desc = initial(created_desc)

		else if(href_list["NewPhrase"])
			var/new_phrase = stripped_input(usr, "What would you like the bot to say")
			if(!in_range(src, usr) && src.loc != usr)
				return
			if(new_phrase)
				idle_speech.Add(new_phrase)

		else if(href_list["NewCommand"])
			var/new_phrase = stripped_input(usr, "What would you like the command to be")
			if(!in_range(src, usr) && src.loc != usr)
				return
			if(new_phrase)
				command_speech.Add(new_phrase)
			var/new_response = stripped_input(usr, "What would you like the bot to respond with")
			if(!in_range(src, usr) && src.loc != usr)
				return
			if(new_response)
				command_speech[new_phrase] = new_response

		else if(href_list["RemovePhrase"])
			idle_speech.Remove(href_list["phrase"])
		else if(href_list["RemoveCommand"])
			command_speech.Remove(href_list["phrase"])

		else if(href_list["Final"])
			var/obj/machinery/bot/companion/C = new(get_turf(src))
			C.name = created_name
			C.desc = created_desc
			C.botcard_access = botcard_access
			C.idle_speech = idle_speech
			C.command_speech = command_speech
			if(istype(usr,/mob/living/carbon/human))
				C.friends.Add(usr)
				C.speak("Friend registered: [usr]")
			qdel(src)


		add_fingerprint(usr)
		Interact(usr)
		return

