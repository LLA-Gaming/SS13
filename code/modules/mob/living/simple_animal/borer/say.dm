/mob/living/simple_animal/borer/say_understands(var/other)
	if (istype(other, /mob/living/simple_animal/borer))
		return 1
	return ..()

/mob/living/simple_animal/borer/say(var/message)
	if (!message || controlling)
		return

	if (stat == 2)
		message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
		return say_dead(message)

	//Must be concious to speak
	if (stat)
		return

	if (length(message) >= 2)
		if((copytext(message, 1, 2) == ";") || (copytext(message, 1, 2) == ":") || (copytext(message, 1, 2) == "#") || (copytext(message, 1, 2) == "."))
			message = copytext(message, 2)
			message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
			borer_talk(message)
		else if((copytext(message, 1, 2) == "*"))	// borers cant emote
			return
		else if(host)
			src << "<i><span class='name'>You speak to your host:</span> <span class='message'>[message]</span></i>"
			host << "<i><span class='name'>An unknown voice in your head says,</span> <span class='message'>[message]</span></i>"
		else
			return

	else
		return



/mob/living/simple_animal/borer/proc/borer_talk(var/message)

	log_say("[real_name] as [name]/[key] : [message]")
	message = trim(message)

	if (!message)
		return

	var/rendered = "<i><span class='game say'>Hivemind, <span class='name'>[real_name]</span> <span class='message'>[message]</span></span></i>"
	for(var/mob/living/simple_animal/borer/B in player_list)
		if(!B.stat && !controlling)
			B.show_message(rendered, 2)
		if(B.host && B.controlling)
			B.host.show_message(rendered, 2)

	for (var/mob/M in dead_mob_list)
		if(!istype(M,/mob/new_player) && !(istype(M,/mob/living/carbon/brain)))//No meta-evesdropping
			M.show_message(rendered, 2)