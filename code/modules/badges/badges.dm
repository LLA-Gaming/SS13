var/const/BADGEFILE = "config/badges.txt"
var/list/badges_by_ckey = list()

/proc/load_badges()
	var/text = file2text(BADGEFILE)
	if (!text)
		diary << "Failed to load [BADGEFILE]\n"
	else
		var/list/lines = splittext(text, "\n")
		for(var/line in lines)
			if (!line)
				continue

			if (copytext(line, 1, 2) == "#")
				continue

			var/seperator_pos = findtext(line, "-", 1, null)
			if (seperator_pos)
				var/player_key = ckey(copytext(line, 1, seperator_pos))
				var/badge = trim_left(copytext(line, seperator_pos + 1))
				badges_by_ckey[player_key] = badge

#undef DONATORFILE

/proc/getBadge(var/_ckey)
	if(_ckey in badges_by_ckey)
		return image('icons/misc/badges.dmi', badges_by_ckey[_ckey])
	else
		return 0

/client/proc/reloadBadges()
	set name = "Reload Badges"
	set category = "Debug"

	badges_by_ckey = list()
	load_badges()

//