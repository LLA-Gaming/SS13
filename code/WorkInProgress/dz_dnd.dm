//all of my additions to the d&d themed update. -zombie

proc/blankcsheet(Location)
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( Location )
	P.name = "paper- 'Character Sheet'"
	P.info = "<B>Name:</B> <br>"
	P.info += "<B>Race:</B> <br>"
	P.info += "<B>Class:</B> <br>"
	P.info += "<B>Level:</B> <br>"
	P.info += "<B>HP:</B> <br>"
	P.info += "<B>Stats:</B> <br>"
	P.info += "<i>STR:</i> <br>"
	P.info += "<i>DEX:</i> <br>"
	P.info += "<i>MIN:</i> <br>"
	P.info += "<B>Skills:</B> <br>"
	P.info += "<i>Physical:</i> <br>"
	P.info += "<i>Subterfuge:</i> <br>"
	P.info += "<i>Knowledge:</i> <br>"
	P.info += "<i>Communication:</i> <br>"
	P.info += "<B>Weapon:</B> <br>"
	P.info += ""
	P.info += "<B>Armor:</B> <br>"
	P.info += ""
	P.info += "<B>Magi/Divine Spells:</B> <br>"
	P.info += ""
	P.info += "<B>Items:</B> <br>"



proc/csheet(Location)
	//establish the variables
	var/name = ""
	var/race = ""
	var/class = ""
	var/level = pick(4,5,5,5,6) //code doesnt support above 9 at the moment.
	var/hp = 0
	var/str = roll(3,6)+roll(1,3) //didnt feel like doing 4d6 drop lowest
	var/strmod = 0
	var/dex = roll(3,6)+roll(1,3) //this should be fine till later
	var/dexmod = 0
	var/min = roll(3,6)+roll(1,3)
	var/minmod = 0
	var/phys = 0
	var/subt = 0
	var/know = 0
	var/comm = 0
	var/gold = 0
	var/weapon = ""
	var/bonusd = 0
	var/armor = ""
	var/spells = ""
	var/items = ""
	//gobba pick the race
	race = pick("Human","Elf","Dwarf","Halfling")

	//now to pick a name, class and give bonuses
	if (race == "Human")
		phys += 1
		subt += 1
		know += 1
		comm += 1
		name += pick("Merek ","Carac ","Uric ","Tybalt ","Borin ","Sadon ","Terrowin ","Rowan ","Forthwind ","Althalos ","Fendrel ","Brom ","Hadrian ","Arabella ","Elizabeth ","Hildegard ","Brunhild ","Adelaide ","Alice ","Beatrix ","Cristiana ","Eleanor ","Emeline ","Isabel ","Juliana ","Margaret ","Matilda ","Mirabelle ","Rose ")
		name += pick("Mac","De","Hark","Der","Mow","Corn","Cart","Arn","Asb","Art","Kenn","Knox","Kill","Rome","Vale","Lehm","Devi","Bent","Brand")
		name += pick("stein","burg","miller","er","en","ella","dez","nal","ley","man","ton","son","kett","es","dy","","","","","","","","")
		class = pick("Fighter","Rogue","Magi","Cleric")
	else if (race == "Elf")
		min += 2
		name += pick("Aermhar ","Baerithryn ","Chozzaster ","Deldrach ","Iahalae ","Glarald ","Halafarin ","Illianaro ","Jhaan ","Aurae ","Lyklor ","Mhaenal ","Velatha ","Ohmbryn ","Pirphal ","Darshee ","Siirist ","Thurdan ","Nanalethalee ","Tarathiel ")
		name += pick("Sha","Mory","Seld","Vian","Taka","Raej","Yaer","Dath","Ciliv","Arnarra","Bhura","Holo","Esy")
		name += pick("indril","ardra","hara","luth","amtora","ruthiia","ralya","raesel","theal","tale","dris","ruthiia","daruil","","")
		class = pick("Fighter","Fighter","Rogue","Rogue","Magi","Magi","Magi","Cleric")
	else if (race == "Dwarf")
		str += 2
		name += pick("Urist ","Urist ","Urist ","Bolgin ","Dwri ","Runzad ","Gruni ","Nalbur ","Barin ","Ketdria ","Throla ","Klona ","Groin ","Naltil ","Klzad ","Ovunn ")
		name += pick("Blebfim","Gromthin","Morgom","Gombul","Odorgar","Dwtek","Brunbo")
		name += pick("dor","dur","mek","dor","dor","dal","malk","marr","","","","")
		class = pick("Fighter","Fighter","Fighter","Rogue","Magi","Cleric")
	else //halfling
		dex += 2
		name += pick("Milo ","Beau ","Sancho ","Ponto ","Osborn ","Ronald ","Eldon ","May ","Ruby ","Malva ","Lily ","Pearl ","Verna ","Violet ","Daisy ","Cora ")
		name += pick("Brown","Good","Under","Bull","Tea","Weather","Brush","Ash","Cotton","Thorn","Tigh","Short","Green","Banda","Mill","Leag")
		name += pick("cobble","field","hill","girdle","bee","midas","burrows","wax","gather","wick","toe","bottle","tan","wich","")
		class = pick("Fighter","Fighter","Rogue","Rogue","Rogue","Magi","Magi","Cleric")

	//apply class bonus and dosh plus class focused level advancement (goes to level 9)... and tacked on is spell lvels
	if (class == "Fighter")
		phys += 3
		bonusd += 1
		gold = 150
		if (level >= 3)
			str += 1
		else if (level >= 5)
			bonusd += 1
		else if (level >= 6)
			str += 2
		else if (level >= 9)
			str += 3
	else if (class == "Rogue")
		subt += 3
		gold = 125
		if (level >= 3)
			dex += 1
		else if (level >= 6)
			dex += 2
		else if (level >= 9)
			dex += 3
	else if (class == "Magi")
		know += 3
		gold = 75
		if (level >= 3)
			min += 1
		else if (level >= 6)
			min += 2
		else if (level >= 9)
			min += 3
		spells = "Arcane L-[Ceiling(level/2)]"
	else //cleric
		comm += 3
		gold = 120
		if (level >= 3)
			min += 1
		else if (level >= 6)
			min += 2
		else if (level >= 9)
			min += 3
		spells = "Divine L-[Ceiling(level/2)]"

	//gotta calculate the statbonus at the end here so all the modifiers are included
	strmod = str-10
	strmod = strmod/2
	strmod = Floor(strmod)

	dexmod = dex-10
	dexmod = dexmod/2
	dexmod = Floor(dexmod)

	minmod = min-10
	minmod = minmod/2
	minmod = Floor(minmod)

	//hp calculation
	hp = round(str+roll(1,6)/level)

	//skilling up to level
	phys += level
	subt += level
	know += level
	comm += level

	//put it all together
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( Location )
	P.name = "paper- '[name] [race]-[class] Sheet'"
	P.info = "<B>Name:</B> [name]<br>"
	P.info += "<B>Race:</B> [race]<br>"
	P.info += "<B>Class:</B> [class]<br>"
	P.info += "<B>Level:</B> [level]<br>"
	P.info += "<B>HP:</B> [hp]<br>"
	P.info += "<B>Stats:</B> <br>"
	P.info += "<i>STR:</i> [str]([strmod])<br>"
	P.info += "<i>DEX:</i> [dex]([dexmod])<br>"
	P.info += "<i>MIN:</i> [min]([minmod])<br>"
	P.info += "<B>Skills:</B> <br>"
	P.info += "<i>Physical:</i> [phys]<br>"
	P.info += "<i>Subterfuge:</i> [subt]<br>"
	P.info += "<i>Knowledge:</i> [know]<br>"
	P.info += "<i>Communication:</i> [comm]<br>"
	P.info += "<B>Gold:</B> [gold]<br>"
	P.info += "<B>Weapon:</B> <br>"
	P.info += "[weapon]"
	P.info += "<B>Armor:</B> <br>"
	P.info += "[armor]"
	P.info += "<B>Items:</B> <br>"
	P.info += "[items]"
	P.info += "<B>Magi/Divine Spells:</B> [spells]<br>"
//obj/item/weapon/folder/syndicate/red/New()
//	..()
//	new /obj/item/documents/syndicate/red(src)
//	update_icon()



//the actual GM case
//I had to duplicate this because I couldnt think of a way to stop the old papers from spawning in the case
/obj/item/weapon/storage/gmbriefcase
	name = "GameMaster Case"
	desc = "It's made of AUTHENTIC faux-leather and has orange snack stains on it. Its owner must be a real pro."
	icon_state = "briefcase"
	flags = CONDUCT
	force = 8.0
	throw_speed = 2
	throw_range = 4
	w_class = 4.0
	max_w_class = 3
	max_combined_w_class = 21
//whats inside #2manyComments
/obj/item/weapon/storage/gmbriefcase/New()
	..()
	blankcsheet(src)
	csheet(src)
	csheet(src)
	csheet(src)
	csheet(src)
	csheet(src)
	new /obj/item/weapon/pen(src)