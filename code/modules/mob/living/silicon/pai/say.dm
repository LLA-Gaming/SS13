/mob/living/silicon/pai/say_understands(var/other)
	if (istype(other, /mob/living/carbon/human))
		return 1
	if (istype(other, /mob/living/silicon/robot))
		return 1
	if (istype(other, /mob/living/silicon/pai))
		return 1
	if (istype(other, /mob/living/silicon/ai))
		return 1
	if (istype(other, /mob/living/silicon/decoy))
		return 1
	if (istype(other, /mob/living/carbon/brain))
		return 1
	return ..()

/mob/living/silicon/pai/say_quote(var/text)
	var/ending = copytext(text, length(text))

	if (ending == "?")
		return "[src.speakQuery], \"<span class = 'robot'>[text]</span>\"";
	else if (copytext(text, length(text) - 1) == "!!")
		return "yells, \"<span class = 'yell'><span class = 'robot'>[text]</span></span>\""
	else if (ending == "!")
		return "[src.speakExclamation], \"<span class = 'robot'>[text]</span>\"";

	return "[src.speakStatement], \"<span class = 'robot'>[text]</span>\"";

/mob/living/silicon/pai/say(var/msg)
	if(silence_time)
		src << "<span class='warning'>Communication circuits remain unitialized.</span>"
	else
		..(msg)