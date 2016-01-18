/mob/living/silicon/robot/say_understands(var/other)
	if (istype(other, /mob/living/silicon/ai))
		return 1
	if (istype(other, /mob/living/silicon/decoy))
		return 1
	if (istype(other, /mob/living/carbon/human))
		return 1
	if (istype(other, /mob/living/carbon/brain))
		return 1
	if (istype(other, /mob/living/silicon/pai))
		return 1
//	if (istype(other, /mob/living/silicon/hivebot))
//		return 1
	return ..()

/mob/living/silicon/robot/say_quote(var/text)
	var/ending = copytext(text, length(text))

	if (ending == "?")
		return "queries, \"<span class = 'robot'>[text]</span>\"";
	else if (copytext(text, length(text) - 1) == "!!")
		return "yells, \"<span class = 'yell'><span class = 'robot'>[text]</span></span>\""
	else if (ending == "!")
		return "declares, \"<span class = 'robot'>[text]</span>\"";

	return "states, \"<span class = 'robot'>[text]</span>\"";

/mob/living/silicon/robot/IsVocal()
	return !config.silent_borg