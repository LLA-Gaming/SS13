/datum/sorting_case

	proc/Evaluate(var/atom/A)
		return 0

	proc/Compare(var/value, var/variable_value, var/operator)
		if(operator == EQUALS)
			if(value == variable_value)
				return 1
		else if(operator == BIGGER_THAN)
			if(value < variable_value)
				return 1
		else if(operator == LESS_THAN)
			if(value > variable_value)
				return 1
		else if(operator == (BIGGER_THAN|EQUALS))
			if(value <= variable_value)
				return 1
		else if(operator == (LESS_THAN|EQUALS))
			if(value >= variable_value)
				return 1

	binary/
		var/varname = 0
		var/operator = 0
		var/value = 0

		New(var/_varname = "varname", var/_operator = BIGGER_THAN|EQUALS, var/_value)
			varname = _varname
			operator = _operator
			value = _value

		Evaluate(var/atom/A)
			if(!hasvar(A, varname))
				return 0

			var/variable_value = A.vars[varname]

			return Compare(value, variable_value, operator)

	multiple/
		var/list/varnames = list()
		var/list/operands = list()
		var/list/values = list()
		var/condition = 0

		New(var/list/_varnames = list("varname"), var/list/_operands = list(), var/list/_values = list(), var/_condition = ALL_TRUE)
			varnames = _varnames
			operands = _operands
			values = _values
			condition = _condition

		Evaluate(var/atom/A)
			var/has_vars = 1
			var/list/variable_values = list()
			for(var/varname in varnames)
				if(!hasvar(A, varname))
					has_vars = 0
				else
					variable_values[varname] = A.vars[varname]

			if(!length(variable_values) || !has_vars)
				return 0

			var/all_true = 1
			var/any_true = 0
			for(var/varname in variable_values)
				var/variable_value = variable_values[varname]
				var/value = values[varnames.Find(varname)]
				var/operator = operands[varnames.Find(varname)]

				var/result = Compare(value, variable_value, operator)
				if(result)
					any_true = 1
				else
					all_true = 0

			if((condition == ANY_TRUE) && any_true)
				return 1

			return all_true

	typeof/
		var/target_type = /obj

		New(var/_target_type)
			target_type = _target_type

		Evaluate(var/atom/A)
			if(istype(A, target_type))
				return 1
			else
				return 0

	listlength/
		var/varname = 0
		var/value = 0
		var/operator = 0
		var/list/restricted_to = list()

		New(var/_varname = "varname", var/_operator, var/_value = 0, var/list/_restricted_to = list())
			varname = _varname
			value = _value
			operator = _operator
			restricted_to = _restricted_to

		Evaluate(var/atom/A)
			var/pass = 0
			for(var/path in restricted_to)
				if(istype(A, path))
					pass = 1
					break

			if(!pass)
				return 0

			var/list_length = 0
			if(hasvar(A, varname))
				var/list/L = A.vars[varname]
				if(L && istype(L, /list))
					list_length = L.len

			return Compare(value, list_length, operator)

	typeof_any/
		var/list/possible_types = list()

		New(var/list/possibilities)
			possible_types = possibilities

		Evaluate(var/atom/A)
			for(var/path in possible_types)
				if(istype(A, path))
					return 1

			return 0