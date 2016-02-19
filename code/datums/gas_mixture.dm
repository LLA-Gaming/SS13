 /*
What are the archived variables for?
	Calculations are done using the archived variables with the results merged into the regular variables.
	This prevents race conditions that arise based on the order of tile processing.
*/

#define SPECIFIC_HEAT_TOXIN		200
#define SPECIFIC_HEAT_AIR		20
#define SPECIFIC_HEAT_CDO		30

#define HEAT_CAPACITY_CALCULATION(oxygen,carbon_dioxide,nitrogen,toxins) \
	(carbon_dioxide*SPECIFIC_HEAT_CDO + (oxygen+nitrogen)*SPECIFIC_HEAT_AIR + toxins*SPECIFIC_HEAT_TOXIN)

#define MINIMUM_HEAT_CAPACITY	0.0003
#define QUANTIZE(variable)		(round(variable,0.0001))


/datum/gas_mixture

	//replacement lists for moles vars
	var/list/gasses = list(OXYGEN = 0,CARBONDIOXIDE = 0, NITROGEN = 0,PLASMA = 0,NITROUS = 0)
	var/tmp/list/gasses_archived = list(OXYGEN = 0,CARBONDIOXIDE = 0, NITROGEN = 0,PLASMA = 0,NITROUS = 0)

	var/volume = CELL_VOLUME

	var/temperature = 0 //in Kelvin, use calculate_temperature() to modify

	var/last_share

	var/graphic

	var/tmp/temperature_archived

	var/tmp/graphic_archived
	var/tmp/fuel_burnt = 0

	//PV=nRT - related procedures
	proc/heat_capacity()
		var/heat_capacity = 0
		for(var/G in gasses)
			heat_capacity += gasses[G] * gas_dictionary.lookup_specific_heat(G)
		return heat_capacity


	proc/heat_capacity_archived()
		var/heat_capacity_archived = 0
		for(var/G in gasses_archived)
			heat_capacity_archived += gasses_archived[G] * gas_dictionary.lookup_specific_heat(G)
		return heat_capacity_archived


	proc/total_moles()
		var/moles = 0
		for (var/G in gasses)
			moles += gasses[G]
		return moles


	proc/return_pressure()
		if(volume>0)
			return total_moles()*R_IDEAL_GAS_EQUATION*temperature/volume
		return 0


	proc/return_temperature()
		return temperature


	proc/return_volume()
		return max(0, volume)


	proc/thermal_energy()
		return temperature*heat_capacity()

	proc/add_gas(var/gname, var/amount) //technically this will allow adding and removal.
		if(gname in gasses)
			gasses[gname] = Clamp(amount+gasses[gname], 0, INFINITY)
			return
		else
			if(!(gname in gas_dictionary.gastypes))
				gas_dictionary.lookup(gname)
			gasses[gname] = amount
			return

	proc/force_exist(var/datum/gas_mixture/A, var/datum/gas_mixture/B)
		//Updates the gas mixture's list of gasses to ensure all of each participant's list exists in the other's
		//add_gas is used because this proc also takes care of ensuring the gas_dictionary has been updated.
		if((!B) || (!A)) return 0 //This is pointless without both
		var/list/diff = A.gasses ^ B.gasses

		if(diff.len)
			for(var/G in (diff))
				if (!(G in A.gasses)) A.add_gas(G, 0)
				if (!(G in A.gasses_archived)) A.gasses_archived[G] = 0
				if (!(G in B.gasses)) B.add_gas(G, 0)
				if (!(G in B.gasses_archived)) B.gasses_archived[G] = 0



	//Procedures used for very specific events
	proc/check_tile_graphic()
		//returns 1 if graphic changed
		graphic = null
		if((PLASMA in gasses) && gasses[PLASMA] > MOLES_PLASMA_VISIBLE)
			graphic = "plasma"
		else
			if((NITROUS in gasses) && (gasses[NITROUS] > 1))
				graphic = "sleeping_agent"
			else
				graphic = null

		return graphic != graphic_archived

	proc/react(atom/dump_location)
	//REVISIT this
		var/reacting = 0 //set to 1 if a notable reaction occured (used by pipe_network)

		fuel_burnt = 0
		if(temperature > FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
			//world << "pre [temperature], [oxygen], [toxins]"
			if(fire() > 0)
				reacting = 1
			//world << "post [temperature], [oxygen], [toxins]"

		return reacting

	proc/fire()
		var/energy_released = 0
		var/old_heat_capacity = heat_capacity()
		if(!(OXYGEN in gasses))
			gasses[OXYGEN] = 0
		if(!(PLASMA in gasses))
			gasses[PLASMA] = 0
		if(!(CARBONDIOXIDE in gasses))
			gasses[CARBONDIOXIDE] = 0

		//Handle plasma burning
		if(gasses[PLASMA] > MINIMUM_HEAT_CAPACITY)
			var/plasma_burn_rate = 0
			var/oxygen_burn_rate = 0
			//more plasma released at higher temperatures
			var/temperature_scale
			if(temperature > PLASMA_UPPER_TEMPERATURE)
				temperature_scale = 1
			else
				temperature_scale = (temperature-PLASMA_MINIMUM_BURN_TEMPERATURE)/(PLASMA_UPPER_TEMPERATURE-PLASMA_MINIMUM_BURN_TEMPERATURE)
			if(temperature_scale > 0)
				oxygen_burn_rate = 1.4 - temperature_scale
				if(gasses[OXYGEN] > gasses[PLASMA]*PLASMA_OXYGEN_FULLBURN)
					plasma_burn_rate = (gasses[PLASMA]*temperature_scale)/4
				else
					plasma_burn_rate = (temperature_scale*(gasses[OXYGEN]/PLASMA_OXYGEN_FULLBURN))/4
				if(plasma_burn_rate > MINIMUM_HEAT_CAPACITY)
					gasses[PLASMA] -= plasma_burn_rate
					gasses[OXYGEN] -= plasma_burn_rate*oxygen_burn_rate
					gasses[CARBONDIOXIDE] += plasma_burn_rate

					energy_released += FIRE_PLASMA_ENERGY_RELEASED * (plasma_burn_rate)

					fuel_burnt += (plasma_burn_rate)*(1+oxygen_burn_rate)

		if(energy_released > 0)
			var/new_heat_capacity = heat_capacity()
			if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
				temperature = (temperature*old_heat_capacity + energy_released)/new_heat_capacity

		return fuel_burnt

	proc/archive()
		//Update archived versions of variables
		//Returns: 1 in all cases

	proc/merge(datum/gas_mixture/giver)
			//Merges all air from giver into self. Deletes giver.
			//Returns: 1 on success (no failure cases yet)

	proc/check_then_merge(datum/gas_mixture/giver)
			//Similar to merge(...) but first checks to see if the amount of air assumed is small enough
			//	that group processing is still accurate for source (aborts if not)
			//Returns: 1 on successful merge, 0 if the check failed

	proc/remove(amount)
			//Proportionally removes amount of gas from the gas_mixture
			//Returns: gas_mixture with the gases removed

	proc/remove_ratio(ratio)
			//Proportionally removes amount of gas from the gas_mixture
			//Returns: gas_mixture with the gases removed

	proc/subtract(datum/gas_mixture/right_side)
			//Subtracts right_side from air_mixture. Used to help turfs mingle

	proc/check_then_remove(amount)
			//Similar to remove(...) but first checks to see if the amount of air removed is small enough
			//	that group processing is still accurate for source (aborts if not)
			//Returns: gas_mixture with the gases removed or null

	proc/copy_from(datum/gas_mixture/sample)
			//Copies variables from sample

	proc/share(datum/gas_mixture/sharer)
			//Performs air sharing calculations between two gas_mixtures assuming only 1 boundary length
			//Return: amount of gas exchanged (+ if sharer received)

	proc/mimic(turf/model)
			//Similar to share(...), except the model is not modified
			//Return: amount of gas exchanged

	proc/check_gas_mixture(datum/gas_mixture/sharer)
			//Returns: 0 if the self-check failed then -1 if sharer-check failed then 1 if both checks pass

	proc/check_turf(turf/model)
			//Returns: 0 if self-check failed or 1 if check passes

	//	check_me_then_share(datum/gas_mixture/sharer)
			//Similar to share(...) but first checks to see if amount of air moved is small enough
			//	that group processing is still accurate for source (aborts if not)
			//Returns: 1 on successful share, 0 if the check failed

	//	check_me_then_mimic(turf/model)
			//Similar to mimic(...) but first checks to see if amount of air moved is small enough
			//	that group processing is still accurate (aborts if not)
			//Returns: 1 on successful mimic, 0 if the check failed

	//	check_both_then_share(datum/gas_mixture/sharer)
			//Similar to check_me_then_share(...) but also checks to see if amount of air moved is small enough
			//	that group processing is still accurate for the sharer (aborts if not)
			//Returns: 0 if the self-check failed then -1 if sharer-check failed then 1 if successful share


	proc/temperature_mimic(turf/model, conduction_coefficient)

	proc/temperature_share(datum/gas_mixture/sharer, conduction_coefficient)

	proc/temperature_turf_share(turf/simulated/sharer, conduction_coefficient)


	proc/check_me_then_temperature_mimic(turf/model, conduction_coefficient)

	proc/check_me_then_temperature_share(datum/gas_mixture/sharer, conduction_coefficient)

	proc/check_both_then_temperature_share(datum/gas_mixture/sharer, conduction_coefficient)

	proc/check_me_then_temperature_turf_share(turf/simulated/sharer, conduction_coefficient)

	proc/compare(datum/gas_mixture/sample)
			//Compares sample to self to see if within acceptable ranges that group processing may be enabled

	archive()
		for(var/tmp/G in gasses)
			if(!(G in gasses_archived))
				gasses_archived[G] = 0
			gasses_archived[G] = gasses[G]

		temperature_archived = temperature

		graphic_archived = graphic

		return 1

	check_then_merge(datum/gas_mixture/giver)
		if(!giver)
			return 0
		force_exist(src, giver)

		for (var/G in giver.gasses)
			if((giver.gasses[G] > MINIMUM_AIR_TO_SUSPEND) && (giver.gasses[G] >= gasses[G]*MINIMUM_AIR_RATIO_TO_SUSPEND))
				return 0
		if(abs(giver.temperature - temperature) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND)
			return 0

		return merge(giver)

	merge(datum/gas_mixture/giver)
		if(!giver)
			return 0
		force_exist(src, giver)

		if(abs(temperature-giver.temperature)>MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
			var/self_heat_capacity = heat_capacity()
			var/giver_heat_capacity = giver.heat_capacity()
			var/combined_heat_capacity = giver_heat_capacity + self_heat_capacity
			if(combined_heat_capacity != 0)
				temperature = (giver.temperature*giver_heat_capacity + temperature*self_heat_capacity)/combined_heat_capacity

		for (var/G in giver.gasses)
			add_gas(G, giver.gasses[G])

		return 1

	remove(amount)

		var/sum = total_moles()
		amount = min(amount,sum) //Can not take more air than tile has!
		if(amount <= 0)
			return null

		var/datum/gas_mixture/removed = new

		for (var/G in gasses)
			var/spec_amount = QUANTIZE((gasses[G]/sum)*amount)
			removed.add_gas(G, spec_amount)
			src.add_gas(G, (-1*spec_amount))

		removed.temperature = temperature

		return removed

	remove_ratio(ratio)

		if(ratio <= 0)
			return null

		ratio = min(ratio, 1)

		var/datum/gas_mixture/removed = new

		for(var/G in gasses)
			var/spec_amount = QUANTIZE(gasses[G]*ratio)
			removed.add_gas(G, spec_amount)
			src.add_gas(G, (-1*spec_amount))

		removed.temperature = temperature

		return removed

	check_then_remove(amount)

		//Since it is all proportional, the check may be done on the gas as a whole
		var/sum = total_moles()
		amount = min(amount,sum) //Can not take more air than tile has!

		if((amount > MINIMUM_AIR_RATIO_TO_SUSPEND) && (amount > sum*MINIMUM_AIR_RATIO_TO_SUSPEND))
			return 0

		return remove(amount)

	copy_from(datum/gas_mixture/sample)

		src.gasses.Cut()
		src.gasses = sample.gasses.Copy()

		temperature = sample.temperature

		return 1

	subtract(datum/gas_mixture/right_side)

		for (var/G in right_side.gasses)
			add_gas(G, (-1*right_side.gasses[G]))
		return 1

	check_gas_mixture(datum/gas_mixture/sharer)
		if(!sharer)	return 0
		force_exist(src, sharer)

		var/list/delta = list()

		for (var/G in sharer.gasses_archived)
			delta[G] = (gasses_archived[G] - sharer.gasses_archived[G])/5

		var/delta_temperature = (temperature_archived - sharer.temperature_archived)

		for(var/G in delta)
			if((abs(delta[G]) > MINIMUM_AIR_TO_SUSPEND) && (abs(delta[G] >= gasses_archived[G]*MINIMUM_AIR_RATIO_TO_SUSPEND)))
				return 0

		if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND)
			return 0

		for(var/G in delta)
			if((abs(delta[G]) > MINIMUM_AIR_TO_SUSPEND) && (abs(delta[G] >= sharer.gasses_archived[G]*MINIMUM_AIR_RATIO_TO_SUSPEND)))
				return -1

		return 1

	check_turf(turf/model)
		var/list/delta = list()
		for (var/G in model.gasses)
			if (!(G in gasses_archived)) gasses_archived[G] = 0
			delta[G] = (gasses_archived[G] - model.gasses[G])/5

		var/delta_temperature = (temperature_archived - model.temperature)

		for (var/G in delta)
			if (((abs(delta[G]) > MINIMUM_AIR_TO_SUSPEND) && (abs(delta[G]) >= gasses_archived[G]*MINIMUM_AIR_RATIO_TO_SUSPEND)))
				return 0

		if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND)
			return 0

		return 1

	share(datum/gas_mixture/sharer, var/atmos_adjacent_turfs = 4)
		if(!sharer)	return 0
		var/tmp/list/delta = list()
		var/tmp/list/sharedgas_archive = sharer.gasses_archived

		for (var/tmp/G in sharedgas_archive)
			delta[G] = QUANTIZE((gasses_archived[G] - sharer.gasses_archived[G])/(atmos_adjacent_turfs+1))

		var/tmp/delta_temperature = (temperature_archived - sharer.temperature_archived)

		var/tmp/old_self_heat_capacity = 0
		var/tmp/old_sharer_heat_capacity = 0

		var/tmp/heat_capacity_self_to_sharer = 0
		var/tmp/heat_capacity_sharer_to_self = 0

		if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)

			for(var/tmp/G in delta)
				if(delta[G])
					//var/gas_heat_capacity = gas_dictionary.lookup_specific_heat(G)
					if(!(G in gas_dictionary.gastypes))
						gas_dictionary.lookup(G)
					var/tmp/datum/gas_type/GT = gas_dictionary.gastypes[G]
					if(delta[G] > 0)
						heat_capacity_self_to_sharer += GT.specific_heat * delta[G]
					else
						heat_capacity_sharer_to_self -= GT.specific_heat * delta[G]

			old_self_heat_capacity = heat_capacity()
			old_sharer_heat_capacity = sharer.heat_capacity()

		var/tmp/moved_moles = 0
		last_share = 0
		for(var/tmp/G in delta)
			src.gasses[G] -= delta[G]
			sharer.gasses[G] += delta[G]
			moved_moles += delta[G]
			last_share += abs(delta[G])

		if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
			var/tmp/new_self_heat_capacity = old_self_heat_capacity + heat_capacity_sharer_to_self - heat_capacity_self_to_sharer
			var/tmp/new_sharer_heat_capacity = old_sharer_heat_capacity + heat_capacity_self_to_sharer - heat_capacity_sharer_to_self

			if(new_self_heat_capacity > MINIMUM_HEAT_CAPACITY)
				temperature = (old_self_heat_capacity*temperature - heat_capacity_self_to_sharer*temperature_archived + heat_capacity_sharer_to_self*sharer.temperature_archived)/new_self_heat_capacity

			if(new_sharer_heat_capacity > MINIMUM_HEAT_CAPACITY)
				sharer.temperature = (old_sharer_heat_capacity*sharer.temperature-heat_capacity_sharer_to_self*sharer.temperature_archived + heat_capacity_self_to_sharer*temperature_archived)/new_sharer_heat_capacity

				if(abs(old_sharer_heat_capacity) > MINIMUM_HEAT_CAPACITY)
					if(abs(new_sharer_heat_capacity/old_sharer_heat_capacity - 1) < 0.10) // <10% change in sharer heat capacity
						temperature_share(sharer, OPEN_HEAT_TRANSFER_COEFFICIENT)

		if((delta_temperature > MINIMUM_TEMPERATURE_TO_MOVE) || abs(moved_moles) > MINIMUM_MOLES_DELTA_TO_MOVE)
			var/tmp/delta_pressure = temperature_archived*(total_moles() + moved_moles) - sharer.temperature_archived*(sharer.total_moles() - moved_moles)
			return delta_pressure*R_IDEAL_GAS_EQUATION/volume

	mimic(turf/model, border_multiplier, var/tmp/atmos_adjacent_turfs = 4)
		for(var/G in model.gasses)
			if(!(G in src.gasses))
				src.gasses[G] = 0
			if(!(G in src.gasses_archived))
				src.gasses_archived[G] = 0

		var/list/delta = list()

		for (var/G in model.gasses)
			delta[G] = QUANTIZE((gasses_archived[G] - model.gasses[G])/(atmos_adjacent_turfs+1))

		var/delta_temperature = (temperature_archived - model.temperature)

		var/heat_transferred = 0
		var/old_self_heat_capacity = 0
		var/heat_capacity_transferred = 0

		if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)

			for(var/G in delta)
				if(delta[G])
					var/gas_heat_capacity = gas_dictionary.lookup_specific_heat(G)*delta[G]
					heat_transferred -= gas_heat_capacity*model.temperature
					heat_capacity_transferred -= gas_heat_capacity

			old_self_heat_capacity = heat_capacity()

		if(border_multiplier)
			for(var/G in delta)
				gasses[G] -= delta[G]*border_multiplier
		else
			for(var/G in delta)
				gasses[G] -= delta[G]

		var/moved_moles = 0
		last_share = 0
		for (var/G in delta)
			moved_moles += delta[G]
			last_share += abs(delta[G])

		if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
			var/new_self_heat_capacity = old_self_heat_capacity - heat_capacity_transferred
			if(new_self_heat_capacity > MINIMUM_HEAT_CAPACITY)
				if(border_multiplier)
					temperature = (old_self_heat_capacity*temperature - heat_capacity_transferred*border_multiplier*temperature_archived)/new_self_heat_capacity
				else
					temperature = (old_self_heat_capacity*temperature - heat_capacity_transferred*border_multiplier*temperature_archived)/new_self_heat_capacity

			temperature_mimic(model, model.thermal_conductivity, border_multiplier)

		if((delta_temperature > MINIMUM_TEMPERATURE_TO_MOVE) || abs(moved_moles) > MINIMUM_MOLES_DELTA_TO_MOVE)
			var/model_moles = 0
			for (var/G in model.gasses)
				model_moles += model.gasses[G]
			var/delta_pressure = temperature_archived*(total_moles() + moved_moles) - model.temperature*model_moles
			return delta_pressure*R_IDEAL_GAS_EQUATION/volume
		else
			return 0

	check_both_then_temperature_share(datum/gas_mixture/sharer, conduction_coefficient)

		force_exist(src, sharer)

		var/delta_temperature = (temperature_archived - sharer.temperature_archived)

		var/self_heat_capacity = heat_capacity_archived()
		var/sharer_heat_capacity = sharer.heat_capacity_archived()

		var/self_temperature_delta = 0
		var/sharer_temperature_delta = 0

		if((sharer_heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
			var/heat = conduction_coefficient*delta_temperature* \
				(self_heat_capacity*sharer_heat_capacity/(self_heat_capacity+sharer_heat_capacity))

			self_temperature_delta = -heat/(self_heat_capacity)
			sharer_temperature_delta = heat/(sharer_heat_capacity)
		else
			return 1

		if((abs(self_temperature_delta) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) \
			&& (abs(self_temperature_delta) > MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND*temperature_archived))
			return 0

		if((abs(sharer_temperature_delta) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) \
			&& (abs(sharer_temperature_delta) > MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND*sharer.temperature_archived))
			return -1

		temperature += self_temperature_delta
		sharer.temperature += sharer_temperature_delta

		return 1
		//Logic integrated from: temperature_share(sharer, conduction_coefficient) for efficiency

	check_me_then_temperature_share(datum/gas_mixture/sharer, conduction_coefficient)
		var/delta_temperature = (temperature_archived - sharer.temperature_archived)

		var/self_heat_capacity = heat_capacity_archived()
		var/sharer_heat_capacity = sharer.heat_capacity_archived()

		var/self_temperature_delta = 0
		var/sharer_temperature_delta = 0

		if((sharer_heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
			var/heat = conduction_coefficient*delta_temperature* \
				(self_heat_capacity*sharer_heat_capacity/(self_heat_capacity+sharer_heat_capacity))

			self_temperature_delta = -heat/self_heat_capacity
			sharer_temperature_delta = heat/sharer_heat_capacity
		else
			return 1

		if((abs(self_temperature_delta) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) \
			&& (abs(self_temperature_delta) > MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND*temperature_archived))
			return 0

		temperature += self_temperature_delta
		sharer.temperature += sharer_temperature_delta

		return 1
		//Logic integrated from: temperature_share(sharer, conduction_coefficient) for efficiency

	check_me_then_temperature_turf_share(turf/simulated/sharer, conduction_coefficient)
		var/delta_temperature = (temperature_archived - sharer.temperature)

		var/self_temperature_delta = 0
		var/sharer_temperature_delta = 0

		if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
			var/self_heat_capacity = heat_capacity_archived()

			if((sharer.heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
				var/heat = conduction_coefficient*delta_temperature* \
					(self_heat_capacity*sharer.heat_capacity/(self_heat_capacity+sharer.heat_capacity))

				self_temperature_delta = -heat/self_heat_capacity
				sharer_temperature_delta = heat/sharer.heat_capacity
		else
			return 1

		if((abs(self_temperature_delta) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) \
			&& (abs(self_temperature_delta) > MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND*temperature_archived))
			return 0

		temperature += self_temperature_delta
		sharer.temperature += sharer_temperature_delta

		return 1
		//Logic integrated from: temperature_turf_share(sharer, conduction_coefficient) for efficiency

	check_me_then_temperature_mimic(turf/model, conduction_coefficient)
		var/delta_temperature = (temperature_archived - model.temperature)
		var/self_temperature_delta = 0

		if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
			var/self_heat_capacity = heat_capacity_archived()

			if((model.heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
				var/heat = conduction_coefficient*delta_temperature* \
					(self_heat_capacity*model.heat_capacity/(self_heat_capacity+model.heat_capacity))

				self_temperature_delta = -heat/self_heat_capacity

		if((abs(self_temperature_delta) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) \
			&& (abs(self_temperature_delta) > MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND*temperature_archived))
			return 0

		temperature += self_temperature_delta

		return 1
		//Logic integrated from: temperature_mimic(model, conduction_coefficient) for efficiency

	temperature_share(datum/gas_mixture/sharer, conduction_coefficient)

		var/delta_temperature = (temperature_archived - sharer.temperature_archived)
		if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
			var/self_heat_capacity = heat_capacity_archived()
			var/sharer_heat_capacity = sharer.heat_capacity_archived()

			if((sharer_heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
				var/heat = conduction_coefficient*delta_temperature* \
					(self_heat_capacity*sharer_heat_capacity/(self_heat_capacity+sharer_heat_capacity))

				temperature -= heat/self_heat_capacity
				sharer.temperature += heat/sharer_heat_capacity

	temperature_mimic(turf/model, conduction_coefficient, border_multiplier)
		var/delta_temperature = (temperature - model.temperature)
		if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
			var/self_heat_capacity = heat_capacity()//_archived()

			if((model.heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
				var/heat = conduction_coefficient*delta_temperature* \
					(self_heat_capacity*model.heat_capacity/(self_heat_capacity+model.heat_capacity))

				if(border_multiplier)
					temperature -= heat*border_multiplier/self_heat_capacity
				else
					temperature -= heat/self_heat_capacity

	temperature_turf_share(turf/simulated/sharer, conduction_coefficient)
		var/delta_temperature = (temperature_archived - sharer.temperature)
		if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
			var/self_heat_capacity = heat_capacity()

			if((sharer.heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
				var/heat = conduction_coefficient*delta_temperature* \
					(self_heat_capacity*sharer.heat_capacity/(self_heat_capacity+sharer.heat_capacity))

				temperature -= heat/self_heat_capacity
				sharer.temperature += heat/sharer.heat_capacity

	compare(datum/gas_mixture/sample)
		force_exist(src, sample)

		for (var/G in sample.gasses)
			if((abs(gasses[G]-sample.gasses[G]) > MINIMUM_AIR_TO_SUSPEND) && ((gasses[G] < (1-MINIMUM_AIR_RATIO_TO_SUSPEND)*sample.gasses[G]) || (gasses[G] > (1+MINIMUM_AIR_RATIO_TO_SUSPEND)*sample.gasses[G])))
				return 0

		if(total_moles() > MINIMUM_AIR_TO_SUSPEND)
			if((abs(temperature-sample.temperature) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) && \
				((temperature < (1-MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND)*sample.temperature) || (temperature > (1+MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND)*sample.temperature)))
				//world << "temp fail [temperature] & [sample.temperature]"
				return 0
		return 1
