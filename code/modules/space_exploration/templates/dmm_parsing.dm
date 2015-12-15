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

	proc/Place(var/turf/origin, var/template_name)
		for(var/turf/T in block(origin, locate(origin.x + (x_size - 1), origin.y + (y_size - 1), origin.z)))
			for(var/atom/movable/M in T)
				if(istype(M, /mob))
					var/mob/mob = M
					if(mob.client || mob.key)
						continue
				qdel(M)
			T.ChangeTurf(/turf/space)

		var/area/A = new()
		A.name = template_name
		A.tagbase = "[A.type]_[md5(template_name)]"
		A.lighting_use_dynamic = 0

		for(var/y = 0; y < y_size; y++)
			var/list/row = grid["[y]"]
			var/x = 0
			for(var/datum/dmm_object/object in row)
				object.Instantiate(locate(origin.x + x, origin.y + y, origin.z), ((!object.HasArea()) && (!object.GetSubByType(/turf/space, 1))) ? A : null)
				x++

		A.InitializeLighting()
		A.SetLightLevel(4)

		location = origin

/datum/dmm_object
	var/id
	var/list/sub_objects = list()

	// We want the turf first and area second.
	proc/SortSubObjects()
		var/datum/dmm_sub_object/sub = GetSubByType(/turf)
		if(sub)
			sub_objects.Swap(1, sub_objects.Find(sub))
			sub = null
		sub = GetSubByType(/area)
		if(sub)
			sub_objects.Swap(2, sub_objects.Find(sub))
			sub = null

		listclearnulls(sub_objects)

		return sub_objects

	proc/Instantiate(var/turf/position, var/area/AR)
		for(var/datum/dmm_sub_object/sub in SortSubObjects())
			if(!sub.object_path)
				continue

			var/atom/A = new sub.object_path(position)
			for(var/or in sub.var_overrides)
				A.vars[or] = sub.var_overrides[or]

			if(AR && istype(A, /turf))
				AR.contents.Add(A)

		return position

	proc/GetSubByType(var/path, var/strict = 0)
		for(var/datum/dmm_sub_object/sub in sub_objects)
			if(strict)
				if(istype(sub.object_path, path))
					return sub
			else
				if(sub.object_path == path)
					return sub

		return 0

	// Has area other than space
	proc/HasArea()
		var/datum/dmm_sub_object/sub = GetSubByType(/area)
		return (sub && sub.object_path != /area)

/datum/dmm_sub_object
	var/object_path
	var/list/var_overrides = list()

	proc/SanitizeOverrides()
		for(var/key in var_overrides)
			var/value = var_overrides[key]
			if(istext(value))
				value = replacetext(value, "\"", "")

				if(copytext(value, 1, 9) == "newlist(")
					var/list/split = text2list(copytext(value, 9, findtext(value, ")")), ",")
					var/list/parsed = list()
					for(var/x in split)
						parsed += text2path(x)

					var_overrides[key] = parsed

					continue

			if(text2num(value))
				value = text2num(value)

			var_overrides[key] = value

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

			if(copytext(line, 1, 2) == "\"" && copytext(line, 2, 3) != "}")
				object = new()
				object.id = copytext(line, 2, findtext(line, "\"", 2))
				id_el = length(object.id) - 1

				var/sp_pos = findtext(line, "(") // Starting Parenthesis
				var/lp_pos = findtext(line, ")", length(line) - 1) // Last Parenthesis
				var/inner_text = copytext(line, sp_pos + 1, lp_pos)
				var/comma_pos = findtext(line, ",")

				var/list/path_groups = list()

				var/list/cb_starting_positions = list()
				var/list/cb_ending_positions = list()

				var/cb_start = findtext(line, "{")
				while(cb_start)
					var/cb_end = findtext(line, "}", cb_start)
					cb_starting_positions += cb_start
					cb_ending_positions += cb_end

					cb_start = findtext(line, "{", cb_end + 1)

				// Extract each comma-seperated path out of the text
				if(comma_pos)
					path_groups.Add(copytext(line, sp_pos + 1, comma_pos))
					var/next_comma_pos
					do
						next_comma_pos = findtext(line, ",", comma_pos + 1)

						// Ignore commas in {} blocks
						for(var/c in cb_starting_positions)
							while(next_comma_pos in (c to cb_ending_positions[cb_starting_positions.Find(c)]))
								next_comma_pos = findtext(line, ",", next_comma_pos + 1)

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
						var/obj_path = text2path(copytext(pi, 1, cbs_pos))
						if(length(obj_path) <= 0)
							sub.object_path = obj_path
						else
							sub = null
							continue

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
