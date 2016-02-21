/mob/living/carbon/alien/beepsky/humanoid/emote(var/act)

	var/param = null
	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))
	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	var/m_type = 1
	var/message

	switch(act) //Alphabetical please
		if ("deathgasp")
			message = "<B>[src]</B> lets out a terrible screech, as if a thousand griefers cried out in joy, and then falls silent."
			m_type = 2

		if ("gnarl")
			if (!muzzled)
				message = "<B>[src]</B> beeps menacingly.."
				m_type = 2

		if ("hiss")
			if(!muzzled)
				message = "<B>[src]</B> beeps."
				m_type = 2

		if ("moan")
			message = "<B>[src]</B> buzzes!"
			m_type = 2

		if ("roar")
			if (!muzzled)
				message = "<B>[src]</B> pings loudly."
				m_type = 2

		if ("roll")
			if (!src.restrained())
				message = "<B>[src]</B> rolls."
				m_type = 1

		if ("scratch")
			if (!src.restrained())
				message = "<B>[src]</B> scratches."
				m_type = 1

		if ("scretch")
			if (!muzzled)
				message = "<B>[src]</B> scretches."
				m_type = 2

		if ("shiver")
			message = "<B>[src]</B> vibrates."
			m_type = 2

		if ("sign")
			if (!src.restrained())
				message = text("<B>[src]</B> signs[].", (text2num(param) ? text(" the number []", text2num(param)) : null))
				m_type = 1

		if ("tail")
			message = "<B>[src]</B> waves its baton."
			m_type = 1

		if ("help") //This is an exception
			src << "Help for beepsky emotes. You can use these emotes with say \"*emote\":\n\naflap, airguitar, blink, blink_r, blush, bow, burp, choke, chucke, clap, collapse, cough, dance, deathgasp, drool, flap, frown, gasp, giggle, glare-(none)/mob, gnarl, hiss, jump, laugh, look-atom, me, moan, nod, point-atom, roar, roll, scream, scratch, scretch, shake, shiver, sign-#, sit, smile, sneeze, sniff, snore, stare-(none)/mob, sulk, sway, tail, tremble, twitch, twitch_s, wave, whimper, wink, yawn"

		else
			..(act)

	if ((message && src.stat == 0))
		if(key) log_emote("[name]/[key] : [message]")
		if (act == "roar")
			playsound(src.loc, 'sound/voice/bjustice.ogg', 50, 0)

		if (act == "deathgasp")
			playsound(src.loc, 'sound/voice/bsecureday.ogg', 50, 0)

		if (m_type & 1)
			for(var/mob/O in viewers(src, null))
				O.show_message(message, m_type)
				//Foreach goto(703)
		else
			for(var/mob/O in hearers(src, null))
				O.show_message(message, m_type)
				//Foreach goto(746)
	return