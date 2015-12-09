var/datum/template_controller/template_controller

/datum/template_controller

	New()
		..()

		world << "\red <b>Placing random structures...</b>"

		spawn(0)
			PlaceTemplates()

	proc/PlaceTemplateAt(var/turf/location, var/name)
		var/datum/dmm_parser/parser = new()
		var/datum/dmm_object_collection/collection = parser.GetCollection(name)
		collection.Place(location)

		return collection

	proc/PlaceTemplates()
		var/list/picked = PickTemplates()

		var/started = world.timeofday

		var/list/space_turfs = list()

		for(var/turf/T in world)
			if(istype(T, /turf/space))
				if(T.z in template_config.zs)
					space_turfs += T

		for(var/template in picked)
			var/category = GetCategoryFromTemplate(template)
			var/list/size = GetTemplateSize("data/templates/[category]/" + template)

			var/x = size[1]
			var/y = size[2]

			var/tries = 20
			var/turf/origin
			do
				if(tries <= 0)
					break

				var/turf/pick = pick(space_turfs)

				if(!(pick.z in template_config.zs))
					continue

				if((pick.x + x) >= (world.maxx - TRANSITIONEDGE))
					continue

				if((pick.y + y) >= (world.maxy - TRANSITIONEDGE))
					continue

				var/list/turfs = block(pick, locate(pick.x + x, pick.y + y, pick.z))

				var/breakout = 0
				for(var/turf/T in turfs)
					if(!(istype(T, /turf/space)))
						breakout = 1
						break

				if(breakout)
					continue

				origin = pick
			while(!origin)

			template_config.placed_templates += PlaceTemplateAt(origin, "data/templates/[category]/" + template)

		message_admins("<font color='green'>Finished after [time2text((world.timeofday - started), "mm:ss")]</font>")

	proc/PickTemplates()
		var/list/picked = list()
		var/iterations = rand(template_config.place_amount_min, template_config.place_amount_max)
		var/category_index = 1
		var/list/categories = GetCategories(1)
		var/max_category_index = length(categories)

		if(!max_category_index)
			return 0

		if(!length(categories))
			return 0

		var/pick_tries = template_config.tries
		while(iterations && pick_tries)
			var/current_category = categories[category_index]
			var/picked_template

			if(category_index >= max_category_index)
				category_index = 1

			if(prob(template_config.chances[current_category]))
				picked_template = safepick(GetTemplatesFromCategory(current_category) - picked)

			if(!picked_template)
				pick_tries--
				category_index++
				continue

			picked += picked_template
			iterations--
			category_index++
			pick_tries = template_config.tries

		return picked
