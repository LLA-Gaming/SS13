/datum/dmm_object_collection
	var/list/objects = list()
	var/list/grid = list()
	var/x_size
	var/y_size
	var/turf/location // Filled after collection is placed

	proc/GetObjectFromId(var/id)
		for(var/datum/dmm_object/obj in objects)
			if(obj.id == id)
				return obj
		return 0

	proc/Place(var/turf/origin)
		for(var/turf/T in block(origin, locate(origin.x + (x_size - 1), origin.y + (y_size - 1), origin.z)))
			for(var/atom/movable/M in T)
				if(istype(M, /mob))
					var/mob/mob = M
					if(mob.client || mob.key)
						continue
				qdel(M)
			T.ChangeTurf(/turf/space)

		for(var/y = 0; y < y_size; y++)
			var/list/row = grid["[y]"]
			var/x = 0
			for(var/datum/dmm_object/object in row)
				object.Instantiate(locate(origin.x + x, origin.y + y, origin.z))
				x++
		location = origin

/datum/dmm_object
	var/id
	var/list/sub_objects = list()

	proc/Instantiate(var/turf/position)
		for(var/datum/dmm_sub_object/sub in sub_objects)
			var/atom/A = new sub.object_path(position)
			for(var/or in sub.var_overrides)
				var/formatted = sub.var_overrides[or]
				if(text2num(formatted))
					formatted = text2num(formatted)

				A.vars[or] = formatted

/datum/dmm_sub_object
	var/object_path
	var/list/var_overrides = list()

	proc/SanitizeOverrides()
		for(var/key in var_overrides)
			var/value = var_overrides[key]

			var_overrides[key] = replacetext(value, "\"", "")

/datum/dmm_parser

	proc/GetCollection(var/filename)
		var/list/lines = file2list(filename)
		var/datum/dmm_object_collection/collection = new()

		var/mb = 0// Map block
		var/mb_row = 1
		var/id_el = 0 // id extra-length (e.g. "a" extra length is 0, "aa" extra length is 1)

		var/row_count = 0
		for(var/line in lines)
			if(copytext(line, 1, 2) == "(")
				mb = 1
				continue
			if(copytext(line, 1) == "\"}")
				mb = 0
				continue
			if(mb)
				row_count++
				continue

		mb = 0

		var/datum/dmm_object/object
		for(var/line in lines)
			if(!line || !length(line))
				continue
			if(copytext(line, 1, 2) == "\"")
				object = new()
				object.id = copytext(line, 2, findtext(line, "\"", 2))
				id_el = length(object.id) - 1

				var/sp_pos = findtext(line, "(") // Starting Parenthesis
				var/lp_pos = findtext(line, ")") // Last Parenthesis
				var/inner_text = copytext(line, sp_pos + 1, lp_pos)
				var/comma_pos = findtext(line, ",")

				var/list/path_groups = list()

				// Extract each comma-seperated path out of the text
				if(comma_pos)
					path_groups.Add(copytext(line, sp_pos + 1, comma_pos))
					var/next_comma_pos
					do
						next_comma_pos = findtext(line, ",", comma_pos + 1)
						if(next_comma_pos)
							path_groups.Add(copytext(line, comma_pos + 1, next_comma_pos))
							comma_pos = next_comma_pos
						else
							path_groups.Add(copytext(line, comma_pos + 1, lp_pos))
					while(next_comma_pos)
				else
					path_groups.Add(inner_text)

				var/datum/dmm_sub_object/sub
				for(var/pi in path_groups)
					sub = new()

					var/cbs_pos = findtext(pi, "{") // Curly-brace starting position
					var/cbe_pos = findtext(pi, "}") // Curly-brace ending position

					if(cbs_pos)
						sub.object_path = text2path(copytext(pi, 1, cbs_pos))
						var/string = copytext(pi, cbs_pos + 1, cbe_pos)

						// Start hack. Why? Because byond.
						var/list/string_list = text2list(string, ";")
						var/list/space_removal_list = list()
						var/list/space_removal_pass2 = list()

						for(var/s in string_list)
							if(copytext(s, 1, 2) == " ")
								space_removal_list += copytext(s, 2)
								continue
							space_removal_list += s

						for(var/s in space_removal_list)
							var/equal_pos = findtext(s, "=")
							space_removal_pass2 += "[copytext(s, 1, equal_pos - 1)]=[copytext(s, equal_pos + 2)]"

						string = list2text(space_removal_pass2, ";")
						// End hack.

						sub.var_overrides = params2list(string)
					else
						sub.object_path = text2path(pi)

					sub.SanitizeOverrides()
					object.sub_objects += sub

				collection.objects += object

			if(copytext(line, 1, 2) == "(") // Starting map block
				mb = 1
				continue

			else if(copytext(line, 1) == "\"}") // Ending map block
				mb = 0
				continue

			if(mb)
				var/list/row_list = list()
				for(var/i = 0; i < length(line); i += (id_el + 1))
					row_list += collection.GetObjectFromId(copytext(line, i + 1, i + 2 + id_el))
				collection.grid["[(row_count - mb_row)]"] = row_list
				mb_row++

		collection.y_size = length(collection.grid)
		collection.x_size = (length(collection.grid["1"]) * (id_el + 1))

		return collection
