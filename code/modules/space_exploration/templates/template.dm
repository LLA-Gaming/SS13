var/datum/template_controller/template_controller

/datum/template_controller
	var/list/placed_templates = list()
	var/datum/dmm_parser/parser

	New()
		..()
		world << "\red <b>Placing random structures...</b>"

		parser = new()
		PlaceTemplates()

	proc/PlaceTemplateAt(var/turf/location, var/path, var/name)
		var/datum/dmm_object_collection/collection = parser.GetCollection(path)
		collection.Place(location, name)

		return collection

	proc/PlaceTemplates()
		set background = 1

		var/list/picked = PickTemplates()
		var/started = world.timeofday

		for(var/template in picked)
			var/category = GetCategoryFromTemplate(template)

			var/list/size = GetTemplateSize(template)
			var/x = size[1]
			var/y = size[2]

			var/tries = 20
			var/turf/origin
			do
				var/turf/pick = locate(rand(1, world.maxx), rand(1, world.maxy), text2num(pick(template_config.zs)))

				// Keep a buffer of TRANSITIONEDGE+10 between the edges of the map
				if(((pick.x + x) >= (world.maxx - TRANSITIONEDGE - 10)) || (pick.x < (TRANSITIONEDGE + 10)))
					continue

				if(((pick.y + y) >= (world.maxy - TRANSITIONEDGE - 10)) || (pick.y < (TRANSITIONEDGE + 10)))
					continue

				var/list/turfs = block(pick, locate(pick.x + x, pick.y + y, pick.z))

				var/breakout = 0
				for(var/turf/T in turfs)
					if(!(istype(T, /turf/space)))
						breakout = 1
						break

				tries--

				if(breakout)
					continue

				origin = pick
			while(!origin && tries > 0)

			var/datum/dmm_object_collection/collection = PlaceTemplateAt(origin, template, category)
			placed_templates += collection

		log_game("Finished placing templates after [time2text((world.timeofday - started), "mm:ss")]")
		world << "\red <b>Finished placing random structures...</b>"

	// TODO: Implement new algorithm
	proc/PickTemplates()
		var/list/picked = list()

		template_config.place_amount_min = min(template_config.place_amount_min, GetTemplateCount())
		template_config.place_amount_max = min(template_config.place_amount_max, GetTemplateCount())

		var/pick_num = rand(template_config.place_amount_min, template_config.place_amount_max)

		log_game("TEMPL: Picking [pick_num] template(s).")

		if(!length(template_config.chances))
			log_game("TEMPL: Aborting PickTemplates: no chances configured.")
			return 0

		while(pick_num > length(picked))
			// Pick a category
			var/max_tries = template_config.tries
			var/picked_category
			do
				for(var/c in template_config.chances)
					if(!(c in GetCategories(1)))
						log_game("TEMPL: Configured folder '[c]' not found.")
						return list()
					if(prob(text2num(template_config.chances[c])))
						picked_category = c
				max_tries--
			while(!picked_category && max_tries > 0)

			var/list/category_templates = GetTemplatesFromCategory(picked_category)

			if(length(category_templates) <= 0)
				continue

			// Pick a template from that category
			var/picked_template = category_templates[rand(1, length(category_templates))]

			if(!picked_template)
				continue

			log_game("TEMPL: Picked template: [picked_template]")

			picked += "[template_config.directory]/[picked_category]/[picked_template]"

			pick_num--

		return picked
