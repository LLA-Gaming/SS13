/datum/round_event_control/template_coords
	name = "Template Coords"
	typepath = /datum/round_event/template_coords
	event_flags = EVENT_REWARD
	max_occurrences = -1
	weight = 5
	accuracy = 100
	var/list/templates = list()

/datum/round_event/template_coords
	Setup()
		if(!control)
			CancelSelf()
			return
		if(!control:templates.len)
			if(template_controller.placed_templates.len)
				control:templates = template_controller.placed_templates
		if(!control:templates.len)
			control.max_occurrences = 0
			CancelSelf()

	Alert()
		if(!false_alarm)
			var/datum/dmm_object_collection/template = pick_n_take(control:templates)
			send_alerts("Unknown Structure located at {[template.location.x], [template.location.y], [template.location.z]}")