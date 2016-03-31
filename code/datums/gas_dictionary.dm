//gas type bitflags

#define GTOXIC 1
#define GFLAMMABLE 2
#define GREAGENT 4

var/global/datum/dictionary/gas/gas_dictionary = new

/datum/dictionary/gas
	//Global stats and data holder for all gasses and gas types.
	var/list/gastypes = list()



/datum/dictionary/gas/New()
	gas_dictionary = src

	for(var/T in typesof(/datum/gas_type/normal))
		if (T == /datum/gas_type/normal) continue
		var/datum/gas_type/normal/G = new T
		gastypes[G.name] = G

/datum/dictionary/gas/Destroy()
	if(!gas_dictionary) //look, you REALLY don't want there to not be a gas dictionary, so it's extremely redundant about making sure there's one.
		gas_dictionary = new
	..()

//Checks for illegal modifications
/datum/dictionary/gas/proc/handle_unknown_gas(var/gname)

	if(gname in list("O2","N2","N2O","Plasma","CO2"))
		switch (gname)
			if("O2")
				gastypes["O2"] = new /datum/gas_type/normal/oxygen
			if("N2")
				gastypes["N2"] = new /datum/gas_type/normal/nitrogen
			if("N2O")
				gastypes["N2O"] = new /datum/gas_type/normal/nitrous_oxide
			if("Plasma")
				gastypes["Plasma"] = new /datum/gas_type/normal/plasma
			if("CO2")
				gastypes["CO2"] = new /datum/gas_type/normal/carbon_dioxide
		return 0
	else
		gas_dictionary.create_gas(gname,"reagent")
		return 1

//Handle generation of new gas types. Defaults to reagent because that is the primary source of new gasses.
/datum/dictionary/gas/proc/create_gas(var/gname, var/template = "reagent")
	if (gname in gastypes) return 1
	if (template == "reagent")
		var/datum/gas_type/template/reagent/R = new
		R.name = gname
		R.specific_heat += rand(-10, 240)
		gastypes[gname] = R
		return 1
	else
		return create_gas(gname) //unknown template specified, force to default

//Lookup procs
/datum/dictionary/gas/proc/lookup_specific_heat(var/gname)
	if(gname in gastypes)
		var/datum/gas_type/G = gastypes[gname]
		return G.specific_heat
	else
		handle_unknown_gas(gname)
		return lookup_specific_heat(gname)

/datum/dictionary/gas/proc/lookup_typeflag(var/gname)
	if(gname in gastypes)
		var/datum/gas_type/G = gastypes[gname]
		return G.typeflag
	else
		handle_unknown_gas(gname)
		return lookup_typeflag(gname)

/datum/dictionary/gas/proc/lookup(var/gname) //lightweight lookup to ensure existence
	if(gname in gastypes)
		return
	else
		handle_unknown_gas(gname)
		return lookup(gname)

//Gas Type Definitions
/datum/gas_type
	var/specific_heat = 1
	var/name = "DEFAULT"
	var/typeflag = 0

//Normal gasses are those generated into the dictionary at roundstart
/datum/gas_type/normal/oxygen
	name = "O2"
	specific_heat = 20

/datum/gas_type/normal/nitrogen
	name = "N2"
	specific_heat = 20

/datum/gas_type/normal/nitrous_oxide
	name = "N20"
	specific_heat = 40

/datum/gas_type/normal/carbon_dioxide
	name = "CO2"
	specific_heat = 30

/datum/gas_type/normal/plasma
	name = "Plasma"
	specific_heat = 200

//Template gasses are those generated as needed during runtime

/datum/gas_type/template/reagent
	name = "REAGENT_TEMPLATE"
	specific_heat = 20
	typeflag = GREAGENT

