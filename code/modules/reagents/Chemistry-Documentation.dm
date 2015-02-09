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
	var/static/list/reactions = list()
	var/static/list/reagent_dependencies = list()
	var/list/allowed_categories = list(MED,EFFECT,OTHER)
	var/content = ""
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

	var/static/base_case = 0
	var/static/recursive_case = 0
	var/static/lookup_case = 0

//Calculate the reactions list, or return it if already calculated (saves time).
/obj/item/weapon/book/manual/chembook/proc/get_reactions()
	if (!reactions.len)
		var/paths = typesof(/datum/chemical_reaction) - /datum/chemical_reaction
		for(var/path in paths)
			var/datum/chemical_reaction/reaction = new path()
			reactions[reaction.id] = reaction
	return reactions

//As chembook may be spawned before /datum/reagents, make sure the global list is instantiated.
/obj/item/weapon/book/manual/chembook/proc/get_reagents()
	if (!chemical_reagents_list)
		//This instantiates the global reagents list. See source for reasoning.
		new /datum/reagents
	return chemical_reagents_list

/obj/item/weapon/book/manual/chembook/proc/add_reaction(var/datum/chemical_reaction/reaction)
	if(!reaction.category in allowed_categories)
		return 0
	content += {"
		<tr><td><center>[reaction.name]</center></td>
		<td>
		[get_reagent_entry(reaction.id, toplevel=1)]
	  	</td>
	  	<td><center>[(reaction.result && reaction.result_amount)? reaction.result_amount : "N/A"]</center></td>
		</tr>
	"}

/obj/item/weapon/book/manual/chembook/proc/get_reagent_entry(var/id, var/quantity=1, var/toplevel=0)
	var/datum/chemical_reaction/reaction = reactions[id]
	//No reaction, we're a base element.
	if (!reaction)
		base_case += 1
		return "<li>[quantity] parts [id_to_name(id)]</li>\n"

	var/reagent_entry = ""
	if (!toplevel)
		reagent_entry += "<li>[quantity] parts [id_to_name(id)] - 1 part is made by: </li>\n"
	var/dependencies_entry = reagent_dependencies[id]
	if (!dependencies_entry)
		recursive_case += 1
		dependencies_entry = "<ul>\n"
		var/list/dependencies = (reaction.required_reagents + reaction.required_catalysts) - id
		for(var/reagent in dependencies)
			dependencies_entry += get_reagent_entry(reagent, dependencies[reagent])
		dependencies_entry += "</ul>\n"
	else
		lookup_case += 1
	reagent_dependencies[id] = dependencies_entry
	return reagent_entry + dependencies_entry

/obj/item/weapon/book/manual/chembook/proc/id_to_name(var/id)
	var/list/datum/reagent/reagents = get_reagents()
	var/datum/reagent/reagent = reagents[id]
	if (reagent)
		return reagent.name
	return 0

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
	var/list/reactions = get_reactions()

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

	world.log << "Length of reactions: [reactions.len]"
	var/time = world.timeofday
	for (var/id in reactions)
		//world.log << "Generating reaction [id]"
		add_reaction(reactions[id])
	world.log << "TIme taken to add reactions is [world.timeofday - time] deciseconds."
	world.log << "Base: [base_case] Recursive: [recursive_case] Lookup: [lookup_case]"

	dat += content

	//for (var/id in reagent_dependencies)
	//	var/info = reagent_dependencies[id]
	//	world.log << "This shit. [id] is \n [info]"

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