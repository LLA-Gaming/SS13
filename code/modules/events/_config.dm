#define EVENT_CONFIG_FILE "config/event_config.txt"

/datum/controller/event/proc/SetupConfigs()
	var/list/lines = splittext(file2text(EVENT_CONFIG_FILE), "\n")
	for(var/line in lines)
		if(!line)
			continue
		if(copytext(line, 1, 2) == "#")
			continue //skip comments
		var/current_line_pos = findtext(line, " - ", 1, 0)
		var/current_line = copytext(line, 1, current_line_pos)
		var/current_value = copytext(line, current_line_pos + 3, length(line) + 1)
		var/current_path = text2path("/datum/round_event_control/[current_line]")
		var/datum/round_event_control/current_event = locate(current_path) in events.all_events

		if(current_event)
			current_event.weight = text2num(current_value)


#undef EVENT_EXPLORATION_CONFIG_FILE