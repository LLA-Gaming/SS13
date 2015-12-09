var/datum/space_exploration_config/template/template_config

/datum/space_exploration_config/template
	category = "Template"
	var/place_amount_min = 1
	var/place_amount_max = 3
	var/list/placed_templates = list()
	var/list/chances = list()
	var/list/ignore_types = list()
	var/list/zs = list()
	var/tries = 10
