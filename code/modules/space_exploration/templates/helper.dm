var/list/_TempTemplateTurfs = list()

/datum/template_controller

	proc/GetCategories(var/names_only = 0)
		if(!names_only)
			return flist("data/templates/") - "config.txt"
		else
			var/list/categories = flist("data/templates/") - "config.txt"
			for(var/c in categories)
				categories[categories.Find(c)] = replacetext(c, "/", "")
			return categories

	proc/GetAllTemplates()
		var/list/templates
		for(var/c in GetCategories())
			for(var/template in flist("data/templates/[c]/"))
				templates[template] = c

		return templates

	proc/GetCategoryFromTemplate(var/name)
		for(var/category in GetCategories(1))
			if(name in flist("data/templates/[category]/"))
				return category

		return 0

	proc/FlattenArea(var/turf/point1, var/turf/point2, var/replace_with = /turf/space)
		for(var/turf/T in block(point1, point2))
			for(var/atom/movable/M in T)
				if(istype(M, /mob))
					var/mob/mob = M
					if(mob.client || mob.key)
						continue
				qdel(M)
			T.ChangeTurf(replace_with)

	proc/GetTemplatesFromCategory(var/category)
		if(!category)	return 0
		return flist("data/templates/[category]/")

	proc/GetTemplateSize(var/path)
		var/datum/dmm_parser/parser = new()
		var/datum/dmm_object_collection/collection = parser.GetCollection(path)
		return list(collection.x_size, collection.y_size)

