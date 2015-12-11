var/datum/space_exploration_config/template/template_config

/datum/space_exploration_config/template
	category = "Template"
	var/place_amount_min = 1
	var/place_amount_max = 3

	var/list/chances = list()
	var/list/ignore_types = list()
	var/list/zs = list()
	var/tries = 10
	var/directory

	PostInit()
		if(istype(chances, /list) && length(chances))
			var/list/parsed_chances = list()

			for(var/chance in chances)
				var/list/parsed = params2list(chance)
				parsed_chances[parsed[1]] = text2num(parsed[parsed[1]])

			chances = parsed_chances
		else
			chances = params2list(chances)


