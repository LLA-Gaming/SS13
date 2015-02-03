//Categories used to filter reactions for the manuals.
#define FOOD 1 //Should be obvious
#define DRINK 2 //Should be obvious
#define MED 3 //Anything medical you'd expect to get from Chemistry
#define EFFECT 4 //Anything that will leave no result, such as explosions and smoke
#define XENO 5 //All the slime reactions
#define OTHER 6 //Non-medical chems made in chemistry, also the default
#define SECRET 7 //Anything that needs to be hidden (such as blood mixing with virus food)


/obj/item/weapon/book/manual/chembook
	name = "The Complete Guide to Reactions"
	icon_state ="chemistry" //taken from bay12
	author = "Dr. J. Rose"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "The Complete Guide to Reactions"
	window_size = "970x710"
	var/list/allowed_categories = list(MED,EFFECT,OTHER)
	dat = ""
	var/tablecolor = "#33CCFF"
	var/introduction = {"<h1><span><a name='top'>The Complete Guide to Reactions</span></h1>
	<p>This guide will provide the budding chemistry student with access to all the documented and approved reactions for Nanotrasen standard laboratory facilities.</p>
	<br>
	<br>
	<p><h2>Definitions</h2>
	<ul>
		<li>Catalyst: A chemical required by the reaction, but not consumed by it. The amount listed is the minimum needed for this reaction to take place.</li>
		<li>Resulting Amount: The amount of reagent produced by that reaction. If N/A, the reaction will not remain contained in the beaker.</li>
	</ul>
	</p>
	<p><h2>The Recipes</h2>
	Each recipe is organized into a bulleted list. Sub bullets of a reagent listed are the recipe for the parent bullet. Example Below. Some recipes may contain several levels deep of these reactions.
	<ul>
		<li>Reagent A</li>
		<ul>
			<li>Reagent to make A</li>
			<li>Reagent to make A</li>
		</ul>
		<li>Reagent B</li>
		<li>Reagent C</li>
	</ul>
	</p>"}

/obj/item/weapon/book/manual/chembook/proc/list_intermediates(var/id, var/list/reactions)
	//world << "DEBUG: LIST_INTERMEDIATES CALLED"
	for (var/datum/chemical_reaction/C in reactions)
		//world << "DEBUG: [C.id] == [id]"
		if (C.id == id)
			//world << "DEBUG: MATCH FOUND, WRITING RECIPE"
			dat += {"<ul>"}
			//dat += {"<li>DEBUG: INTERMEDIATE FOR [id]</li>"}
			src.list_reagents(id, reactions)
			dat += {"</ul>"}
			break
	return

/obj/item/weapon/book/manual/chembook/proc/list_reagents(var/id, var/list/reactions)
	//world << "DEBUG: LIST_REAGENTS CALLED"
	for (var/datum/chemical_reaction/C in reactions)
		if (C.id == id)
			//world << "DEBUG: WRITING [C.id]"
			var/list/reagents = C.required_reagents
			var/list/catalysts = C.required_catalysts
			for (var/x in reagents)
				dat += {"<li>[reagents[x]] parts [id_to_name(x)]</li>"}
				src.list_intermediates(x, reactions)
			for (var/x in catalysts)
				dat += {"<li>Catalyst: [catalysts[x]] units of [id_to_name(x)]</li>"}
				src.list_intermediates(x, reactions)

/obj/item/weapon/book/manual/chembook/proc/id_to_name(var/id)
	var/datum/reagent/C
	for (var/R in typesof(/datum/reagent/))
		C = new R(src)
		if (C.id == id)
			return C.name
		else qdel(C)
	return "ERROR: NO MATCH"

/obj/item/weapon/book/manual/chembook/proc/alphasort(list/datum/chemical_reaction/L)
//Creating this because the already made procs in this source were failing to return any data.
//Replace it with something more efficient or one of those procs if you can get it working.

	var/sorted = 0
	var/datum/chemical_reaction/reaction1
	var/datum/chemical_reaction/reaction2
	while (!sorted)
		sorted = 1 //Assume sorted until proven otherwise
		for (var/i = 2; i <= L.len; i++)
			reaction1 = L[i]
			reaction2 = L[i-1]
			if (reaction1.name < reaction2.name)
				sorted = 0 //LIES!
				L.Swap(i,i-1)
				continue
			else
				continue
	return L




/obj/item/weapon/book/manual/chembook/New()
	var/list/reactions = list()

	//Populate reactions
	for (var/C in typesof(/datum/chemical_reaction/))
		var/datum/chemical_reaction/R = new C(src)
		if (!(R.category in allowed_categories)) continue
		if (!R.id || R.required_container)
			qdel(R)
			continue

		reactions.Add(R)

	reactions = src.alphasort(reactions)

	//We now have a list of all reactions, on to the formatting!

	dat = {"<html>
					<head>
					<style>
					h1 {font-size: 18px; margin: 15px 0px 5px;}
					h2 {font-size: 15px; margin: 15px 0px 5px;}
					li {margin: 2px 0px 2px 15px;}
					ul {margin: 5px; padding: 0px;}
					ol {margin: 5px; padding: 0px 15px;}
					table, th, td {border: 1px solid black; }
					td {background-color: [tablecolor];}
					a, a:link, a:visited, a:active, a:hover { color: #000000; }img {border-style:none;}
					</style>
					</head>
					<body>
					"}

		//Contents

	dat += introduction

	dat += {"<table border = "1" style="width:100%">
			<tr>
				<th>Name</th>
				<th>Recipe</th>
				<th>Resulting Amount</th>
			</tr>"}

	for (var/datum/chemical_reaction/C in reactions)
		dat += {"<tr><td><center>[C.name]</center></td>"}
		dat += {"<td>"}
		src.list_intermediates(C.id, reactions)
		dat += {"</td>"}
		if (C.result && C.result_amount)
			dat += {"<td><center>[C.result_amount]</center></td>"}
		else
			dat += {"<td><center>N/A</center></td>"}
		dat += {"</tr>"}


	for (var/G in reactions)
		qdel(G) // Bye bye!
	return

//bar needs love too ~Flavo
/obj/item/weapon/book/manual/chembook/barman_recipes
	name = "Barman Recipes"
	icon_state = "barbook"
	author = "Sir John Rose"
	title = "Barman Recipes"
	allowed_categories = list(DRINK)
	dat = ""
	tablecolor = "#6cf988"
	introduction = {"<h1><span><a name='top'>Drinks for dummies</span></h1>
				Heres a guide for some basic drinks.
				<br>
				<p><h2>Definitions</h2>
				<ul>
					<li>Catalyst: A chemical required by the reaction, but not consumed by it. The amount listed is the minimum needed for the drink to mix.</li>
					<li>Resulting Amount: The amount of drink produced by that mix.</li>
				</ul>
				</p>
				<p><h2>The Recipes</h2>
				Each recipe is organized into a bulleted list. Sub bullets of a drink listed are the recipe for the parent bullet. Example Below. Some recipes may contain several levels deep of these mixs.
				<ul>
					<li>Drink A</li>
					<ul>
						<li>Mix to make A</li>
						<li>Mix to make A</li>
					</ul>
					<li>Drink B</li>
					<li>Drink C</li>
				</ul>
				</p>
				"}


//Cleaning up
#undef FOOD
#undef DRINK
#undef MED
#undef EFFECT
#undef XENO
#undef OTHER
#undef SECRET