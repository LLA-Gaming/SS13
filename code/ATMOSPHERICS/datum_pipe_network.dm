var/global/list/datum/pipe_network/pipe_networks = list()

datum/pipe_network
	var/list/datum/gas_mixture/gases = list() //All of the gas_mixtures continuously connected in this network

	var/list/obj/machinery/atmospherics/normal_members = list()
	var/list/datum/pipeline/line_members = list()
		//membership roster to go through for updates and what not

	var/update = 1
	var/datum/gas_mixture/air_transient = null

	New()
		air_transient = new()

		..()

	proc/process()
		//Equalize gases amongst pipe if called for
		if(update)
			update = 0
			reconcile_air() //equalize_gases(gases)

		//Give pipelines their process call for pressure checking and what not. Have to remove pressure checks for the time being as pipes dont radiate heat - Mport
		//for(var/datum/pipeline/line_member in line_members)
		//	line_member.process()

	proc/build_network(obj/machinery/atmospherics/start_normal, obj/machinery/atmospherics/reference)
		//Purpose: Generate membership roster
		//Notes: Assuming that members will add themselves to appropriate roster in network_expand()

		if(!start_normal)
			del(src)

		start_normal.network_expand(src, reference)

		update_network_gases()

		if((normal_members.len>0)||(line_members.len>0))
			pipe_networks += src
		else
			del(src)

	proc/merge(datum/pipe_network/giver)
		if(giver==src) return 0

		normal_members -= giver.normal_members
		normal_members += giver.normal_members

		line_members -= giver.line_members
		line_members += giver.line_members

		for(var/obj/machinery/atmospherics/normal_member in giver.normal_members)
			normal_member.reassign_network(giver, src)

		for(var/datum/pipeline/line_member in giver.line_members)
			line_member.network = src

		del(giver)

		update_network_gases()
		return 1

	proc/update_network_gases()
		//Go through membership roster and make sure gases is up to date

		gases = list()

		for(var/obj/machinery/atmospherics/normal_member in normal_members)
			var/result = normal_member.return_network_air(src)
			if(result) gases += result

		for(var/datum/pipeline/line_member in line_members)
			gases += line_member.air

	proc/reconcile_air()
		//Perfectly equalize all gases members instantly

		//Calculate totals from individual components
		var/total_thermal_energy = 0
		var/total_heat_capacity = 0

		air_transient.volume = 0

		air_transient.gasses = list()

		for(var/datum/gas_mixture/gas in gases)
			air_transient.volume += gas.volume
			total_thermal_energy += gas.thermal_energy()
			total_heat_capacity += gas.heat_capacity()

			for(var/G in gas.gasses)
				if(!(G in air_transient.gasses))
					air_transient.gasses[G] = gas.gasses[G]
				else
					air_transient.gasses[G] += gas.gasses[G]

		if(air_transient.volume > 0)

			if(total_heat_capacity > 0)
				air_transient.temperature = total_thermal_energy/total_heat_capacity

				//Allow air mixture to react
				if(air_transient.react())
					update = 1

			else
				air_transient.temperature = 0

			//Update individual gas_mixtures by volume ratio
			for(var/datum/gas_mixture/gas in gases)
				for(var/G in air_transient.gasses)
					gas.gasses[G] = air_transient.gasses[G]*gas.volume/air_transient.volume
				gas.temperature = air_transient.temperature

		return 1

proc/equalize_gases(datum/gas_mixture/list/gases)
	//Perfectly equalize all gases members instantly

	//Calculate totals from individual components
	var/total_volume = 0
	var/total_thermal_energy = 0
	var/total_heat_capacity = 0
	var/list/totalgas = list()

	for(var/datum/gas_mixture/gas in gases)
		total_volume += gas.volume
		total_thermal_energy += gas.thermal_energy()
		total_heat_capacity += gas.heat_capacity()

		for(var/G in gas.gasses)
			if(!(G in totalgas))
				totalgas[G] = gas.gasses[G]
			else
				totalgas[G] += gas.gasses[G]

	if(total_volume > 0)

		//Calculate temperature
		var/temperature = 0

		if(total_heat_capacity > 0)
			temperature = total_thermal_energy/total_heat_capacity

		//Update individual gas_mixtures by volume ratio
		for(var/datum/gas_mixture/gas in gases)
			for(var/G in totalgas)
				gas.gasses[G] = totalgas[G]*gas.volume/total_volume
			gas.temperature = temperature
	return 1
