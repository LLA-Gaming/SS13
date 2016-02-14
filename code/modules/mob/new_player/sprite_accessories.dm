/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl


	Notice: This all gets automatically compiled in a list in dna.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	!!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/
/proc/init_sprite_accessory_subtypes(prototype, list/L, list/male, list/female)
	if(!istype(L))		L = list()
	if(!istype(male))	male = list()
	if(!istype(female))	female = list()

	for(var/path in typesof(prototype))
		if(path == prototype)	continue
		var/datum/sprite_accessory/D = new path()

		if(D.icon_state)	L[D.name] = D
		else				L += D.name

		switch(D.gender)
			if(MALE)	male += D.name
			if(FEMALE)	female += D.name
			else
				male += D.name
				female += D.name
	return L

/datum/sprite_accessory
	var/icon			//the icon file the accessory is located in
	var/icon_state		//the icon_state of the accessory
	var/name			//the preview name of the accessory
	var/gender = NEUTER	//Determines if the accessory will be skipped or included in random hair generations

//////////////////////
// Hair Definitions //
//////////////////////
/datum/sprite_accessory/hair
	icon = 'icons/mob/human_face.dmi'	  // default icon for all hairs


	//bald hairs
	bald
		name = "Bald"
		icon_state = null
		gender = MALE

	balding
		name = "Balding Hair"
		icon_state = "hair_e"
		gender = MALE

	balding_ii
		name = "Balding Hair Alt"
		icon_state = "hair_balding_ii"
		gender = MALE

	skinhead
		name = "Skinhead"
		icon_state = "hair_skinhead"
		gender = MALE

	waxed
		name = "Waxed"
		icon_state = "hair_waxed"
		gender = MALE

	//short hairs
	short
		name = "Short Hair"	  // try to capatilize the names please~
		icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you
		gender = MALE

	shorthair2
		name = "Short Hair 2"
		icon_state = "hair_shorthair2"
		gender = MALE

	cut
		name = "Cut Hair"
		icon_state = "hair_c"
		gender = MALE

	fade
		name = "Fade"
		icon_state = "hair_fade"
		gender = MALE

	parted
		name = "Parted"
		icon_state = "hair_parted"
		gender = MALE

	side_parted
		name = "Side Part"
		icon_state = "hair_part"
		gender = MALE

	buzz
		name = "Buzzcut"
		icon_state = "hair_buzzcut"
		gender = MALE

	crew
		name = "Crewcut"
		icon_state = "hair_crewcut"
		gender = MALE

	krewcut
		name = "Krewcut"
		icon_state = "hair_krewcut"

	combover
		name = "Combover"
		icon_state = "hair_combover"
		gender = MALE

	devillock
		name = "Devil Lock"
		icon_state = "hair_devilock"
		gender = MALE

	bobcurl
		name = "Bobcurl"
		icon_state = "hair_bobcurl"

	ramona
		name = "Ramona"
		icon_state = "hair_ramona"
		gender = FEMALE

	joestar
		name = "Joestar"
		icon_state = "hair_joestar"
		gender = MALE

	edgeworth
		name = "Edgeworth"
		icon_state = "hair_edgeworth"
		gender = MALE

	objection
		name = "Wright"
		icon_state = "hair_objection!"
		gender = MALE

	dubsman
		name = "Dubsman"
		icon_state = "hair_dubsman"
		gender = MALE

	blackswordsman
		name = "Black Swordsman"
		icon_state = "hair_blackswordsman"
		gender = MALE

	mentalist
		name = "Mentalist"
		icon_state = "hair_mentalist"
		gender = MALE

	cia
		name = "CIA"
		icon_state = "hair_cia"
		gender = MALE

	mulder
		name = "Mulder"
		icon_state = "hair_mulder"
		gender = MALE

	scully
		name = "Scully"
		icon_state = "hair_scully"
		gender = FEMALE

	quiff
		name = "Quiff"
		icon_state = "hair_quiff"
		gender = MALE

	bob
		name = "Bob"
		icon_state = "hair_bobcut"

	bowl
		name = "Bowl"
		icon_state = "hair_bowlcut"
		gender = MALE

	superbowl
		name = "Superbowl"
		icon_state = "hair_superbowl"

	halfbang
		name = "Half-banged Hair"
		icon_state = "hair_halfbang"

	halfbangalt
		name = "Half-banged Hair Alt"
		icon_state = "hair_halfbang_alt"

	fag
		name = "Flow Hair"
		icon_state = "hair_f"
		gender = MALE

	sargeant
		name = "Flat Top"
		icon_state = "hair_sargeant"
		gender = MALE

	hitop
		name = "Hitop"
		icon_state = "hair_hitop"
		gender = MALE

	mohawk
		name = "Mohawk"
		icon_state = "hair_d"
		gender = MALE

	reversemohawk
		name = "Reverse Mohawk"
		icon_state = "hair_reversemohawk"
		gender = MALE

	jensen
		name = "Adam Jensen Hair"
		icon_state = "hair_jensen"
		gender = MALE

	gelled
		name = "Gelled Back"
		icon_state = "hair_gelled"
		gender = MALE

	spiky
		name = "Spiky"
		icon_state = "hair_spikey"
		gender = MALE

	fade_grown
		name = "Fade Grown"
		icon_state = "hair_fade_grown"
		gender = MALE

	short_sweep
		name = "Short Sweep"
		icon_state = "hair_shortsweep"
		gender = MALE

	short_sweep
		name = "Short Spike"
		icon_state = "hair_short_spike"
		gender = MALE

	//kinda mixed long/short
	floof
		name = "Floof"
		icon_state = "hair_floof"

	shortfloof
		name = "Short Floof"
		icon_state = "hair_shortfloof"

	longchoppy
		name = "Long Choppy"
		icon_state = "hair_longchoppy"

	shortchoppy
		name = "Short Choppy"
		icon_state = "hair_shortchoppy"


	//longhairs
	long
		name = "Shoulder-length Hair"
		icon_state = "hair_b"

	longer
		name = "Long Hair"
		icon_state = "hair_vlong"
		gender = FEMALE

	long_over_eye
		name = "Over-eye Long"
		icon_state = "hair_longovereye"
		gender = FEMALE

	short_over_eye
		name = "Over-eye Short"
		icon_state = "hair_shortovereye"

	longest
		name = "Very Long Hair"
		icon_state = "hair_longest"
		gender = FEMALE

	longest2
		name = "Very Long Over Eye"
		icon_state = "hair_longest2"
		gender = FEMALE

	longfringe
		name = "Long Fringe"
		icon_state = "hair_longfringe"
		gender = FEMALE

	longestalt
		name = "Longer Fringe"
		icon_state = "hair_vlongfringe"
		gender = FEMALE

	gentle
		name = "Gentle"
		icon_state = "hair_gentle"
		gender = FEMALE

	dreadlocks
		name = "Dreadlocks"
		icon_state = "hair_dreads"
		gender = MALE

	protagonist
		name = "Slightly long"
		icon_state = "hair_protagonist"

	kusangi
		name = "Kusanagi Hair"
		icon_state = "hair_kusanagi"
		gender = MALE

	himecut
		name = "Hime Cut"
		icon_state = "hair_himecut"
		gender = FEMALE

	antenna
		name = "Ahoge"
		icon_state = "hair_antenna"
		gender = FEMALE

	odango
		name = "Odango"
		icon_state = "hair_odango"
		gender = MALE

	ombre
		name = "Ombre"
		icon_state = "hair_ombre"
		gender = MALE

	updo
		name = "Updo"
		icon_state = "hair_updo"
		gender = FEMALE

	longbangs
		name = "Long Bangs"
		icon_state = "hair_lbangs"
		gender = FEMALE

	emo
		name = "Emo"
		icon_state = "hair_emo"

	longemo
		name = "Long Emo"
		icon_state = "hair_longemo"
		gender = FEMALE

	feather
		name = "Feather"
		icon_state = "hair_feather"

	curls
		name = "Curls"
		icon_state = "hair_curls"
		gender = FEMALE

	sideshaved
		name = "Sideshaved"
		icon_state = "hair_sideshaved"

	rapunzel
		name = "Rapunzel"
		icon_state = "hair_rapunzel"
		gender = FEMALE

	conditioner
		name = "Conditioner"
		icon_state = "hair_conditioner"
		gender = FEMALE

	//ponytails/braids
	ponytail1
		name = "Ponytail 1"
		icon_state = "hair_ponytail"

	ponytail2
		name = "Ponytail 2"
		icon_state = "hair_pa"
		gender = FEMALE

	ponytail3
		name = "Ponytail 3"
		icon_state = "hair_ponytail3"
		gender = FEMALE

	ponytail4
		name = "Ponytail 4"
		icon_state = "hair_ponytail4"
		gender = FEMALE

	side_tail
		name = "Side Pony"
		icon_state = "hair_sidetail"
		gender = FEMALE

	side_tail2
		name = "Side Pony 2"
		icon_state = "hair_sidetail2"
		gender = FEMALE

	side_tail3
		name = "Side Pony 3"
		icon_state = "hair_stail"
		gender = FEMALE

	oneshoulder
		name = "One Shoulder"
		icon_state = "hair_oneshoulder"
		gender = FEMALE

	tressshoulder
		name = "Tress Shoulder"
		icon_state = "hair_tressshoulder"
		gender = FEMALE

	beehive
		name = "Beehive"
		icon_state = "hair_beehive"
		gender = FEMALE

	beehive2
		name = "Beehive 2"
		icon_state = "hair_beehivev2"
		gender = FEMALE

	jen
		name = "Jen"
		icon_state = "hair_jen"
		gender = FEMALE

	jenjen
		name = "Jen Jen"
		icon_state = "hair_jenjen"
		gender = FEMALE

	front_braid
		name = "Braided front"
		icon_state = "hair_braidfront"
		gender = FEMALE

	himeup
		name = "Hime Updo"
		icon_state = "hair_himeup"
		gender = FEMALE

	braided
		name = "Braided"
		icon_state = "hair_braided"
		gender = FEMALE

	bun
		name = "Bun Head"
		icon_state = "hair_bun"
		gender = FEMALE

	bun_ii
		name = "Bun Head 2"
		icon_state = "hair_bun_ii"
		gender = FEMALE

	uniter
		name = "Uniter"
		icon_state = "hair_uniter"

	braidtail
		name = "Braided Tail"
		icon_state = "hair_braidtail"
		gender = FEMALE

	kagami
		name = "Pigtails"
		icon_state = "hair_kagami"
		gender = FEMALE

	pigtail
		name = "Pig tails"
		icon_state = "hair_pigtails"
		gender = FEMALE

	lowbraid
		name = "Low Braid"
		icon_state = "hair_hbraid"
		gender = FEMALE

	not_floorlength_braid
		name = "High Braid"
		icon_state = "hair_braid2"
		gender = FEMALE

	braid
		name = "Floorlength Braid"
		icon_state = "hair_braid"
		gender = FEMALE

	shortbraid
		name = "Short Floorlength Braid"
		icon_state = "hair_shortbraid"
		gender = FEMALE

	twintails
		name = "Twintails"
		icon_state = "hair_twintails"
		gender = FEMALE

	//bedheads/poofys
	bedhead
		name = "Bedhead"
		icon_state = "hair_bedhead"

	bedhead2
		name = "Bedhead 2"
		icon_state = "hair_bedheadv2"

	bedhead3
		name = "Bedhead 3"
		icon_state = "hair_bedheadv3"

	messy
		name = "Messy"
		icon_state = "hair_messy"

	poofy
		name = "Poofy"
		icon_state = "hair_poofy"

	crono
		name = "Chrono"
		icon_state = "hair_toriyama1"
		gender = MALE

	einstein
		name = "Einstein"
		icon_state = "hair_einstein"
		gender = MALE

	//afros
	afro
		name = "Afro"
		icon_state = "hair_afro"
		gender = MALE

	afro2
		name = "Afro 2"
		icon_state = "hair_afro2"
		gender = MALE

	afro_large
		name = "Big Afro"
		icon_state = "hair_bigafro"
		gender = MALE

	//pomps
	pompadour
		name = "Pompadour"
		icon_state = "hair_pompadour"
		gender = MALE

	dandypomp
		name = "Dandy Pompadour"
		icon_state = "hair_dandypompadour"
		gender = MALE

	bigpompadour
		name = "Big Pompadour"
		icon_state = "hair_pomp_iii"
		gender = MALE

	//anime (anything that sounded weebish to me)
	familyman
		name = "Family Man"
		icon_state = "hair_thefamilyman"
		gender = MALE

	drillruru
		name = "Drillruru"
		icon_state = "hair_drillruru"
		gender = FEMALE

	vegeta
		name = "Vegeta Hair"
		icon_state = "hair_toriyama2"
		gender = MALE

	nitori
		name = "Nitori"
		icon_state = "hair_nitori"
		gender = FEMALE

	fujisaki
		name = "Fujisaki"
		icon_state = "hair_fujisaki"
		gender = FEMALE

	schierke
		name = "Schierke"
		icon_state = "hair_schierke"
		gender = FEMALE

	akari
		name = "Akari"
		icon_state = "hair_akari"
		gender = FEMALE

	fujiyabashi
		name = "Fujiyabashi"
		icon_state = "hair_fujiyabashi"
		gender = FEMALE

	nia
		name = "Nia"
		icon_state = "hair_nia"
		gender = FEMALE

	shinobu
		name = "Shinobu"
		icon_state = "hair_shinobu"
		gender = FEMALE

	//wtf
	megaeyebrows
		name = "Mega Eyebrows"
		icon_state = "hair_megaeyebrow"
		gender = MALE


/////////////////////////////
// Facial Hair Definitions //
/////////////////////////////
/datum/sprite_accessory/facial_hair
	icon = 'icons/mob/human_face.dmi'
	gender = MALE

	shaved
		name = "Shaved"
		icon_state = null
		gender = NEUTER

	watson
		name = "Watson Mustache"
		icon_state = "facial_watson"

	handlebars
		name = "Handlebars"
		icon_state = "facial_handlebars"

	hogan
		name = "Hulk Hogan Mustache"
		icon_state = "facial_hogan" //-Neek

	vandyke
		name = "Van Dyke Mustache"
		icon_state = "facial_vandyke"

	chaplin
		name = "Square Mustache"
		icon_state = "facial_chaplin"

	selleck
		name = "Selleck Mustache"
		icon_state = "facial_selleck"

	neckbeard
		name = "Neckbeard"
		icon_state = "facial_neckbeard"

	fullbeard
		name = "Full Beard"
		icon_state = "facial_fullbeard"

	longbeard
		name = "Long Beard"
		icon_state = "facial_longbeard"

	vlongbeard
		name = "Very Long Beard"
		icon_state = "facial_wise"

	elvis
		name = "Elvis Sideburns"
		icon_state = "facial_elvis"

	abe
		name = "Abraham Lincoln Beard"
		icon_state = "facial_abe"

	chinstrap
		name = "Chinstrap"
		icon_state = "facial_chin"

	chinstrap_ii
		name = "Chinstrap 2"
		icon_state = "facial_chinstrap_ii"

	swire
		name = "Swire"
		icon_state = "facial_swire"

	hip
		name = "Hipster Beard"
		icon_state = "facial_hip"

	gt
		name = "Goatee"
		icon_state = "facial_gt"

	stark
		name = "Stark"
		icon_state = "facial_stark"

	jensen
		name = "Adam Jensen Beard"
		icon_state = "facial_jensen"

	dwarf
		name = "Dwarf Beard"
		icon_state = "facial_dwarf"

	fiveoclock
		name = "Five o Clock Shadow"
		icon_state = "facial_fiveoclock"

	fu
		name = "Fu Manchu"
		icon_state = "facial_fumanchu"

///////////////////////////
// Underwear Definitions //
///////////////////////////
/datum/sprite_accessory/underwear
	icon = 'icons/mob/underwear.dmi'

	nude
		name = "Nude"
		icon_state = null
		gender = NEUTER

	male_white
		name = "Mens White"
		icon_state = "male_white"
		gender = MALE

	male_grey
		name = "Mens Grey"
		icon_state = "male_grey"
		gender = MALE

	male_green
		name = "Mens Green"
		icon_state = "male_green"
		gender = MALE

	male_blue
		name = "Mens Blue"
		icon_state = "male_blue"
		gender = MALE

	male_black
		name = "Mens Black"
		icon_state = "male_black"
		gender = MALE

	male_mankini
		name = "Mankini"
		icon_state = "male_mankini"
		gender = MALE

	male_hearts
		name = "Mens Hearts Boxer"
		icon_state = "male_hearts"
		gender = MALE

	male_blackalt
		name = "Mens Black Boxer"
		icon_state = "male_blackalt"
		gender = MALE

	male_greyalt
		name = "Mens Grey Boxer"
		icon_state = "male_greyalt"
		gender = MALE

	male_stripe
		name = "Mens Striped Boxer"
		icon_state = "male_stripe"
		gender = MALE

	male_kinky
		name = "Mens Kinky"
		icon_state = "male_kinky"
		gender = MALE

	male_red
		name = "Mens Red"
		icon_state = "male_red"
		gender = MALE

	female_red
		name = "Ladies Red"
		icon_state = "female_red"
		gender = FEMALE

	female_white
		name = "Ladies White"
		icon_state = "female_white"
		gender = FEMALE

	female_yellow
		name = "Ladies Yellow"
		icon_state = "female_yellow"
		gender = FEMALE

	female_blue
		name = "Ladies Blue"
		icon_state = "female_blue"
		gender = FEMALE

	female_black
		name = "Ladies Black"
		icon_state = "female_black"
		gender = FEMALE

	female_thong
		name = "Ladies Thong"
		icon_state = "female_thong"
		gender = FEMALE

	female_babydoll
		name = "Babydoll"
		icon_state = "female_babydoll"
		gender = FEMALE

	female_babyblue
		name = "Ladies Baby-Blue"
		icon_state = "female_babyblue"
		gender = FEMALE

	female_green
		name = "Ladies Green"
		icon_state = "female_green"
		gender = FEMALE

	female_pink
		name = "Ladies Pink"
		icon_state = "female_pink"
		gender = FEMALE

	female_kinky
		name = "Ladies Kinky"
		icon_state = "female_kinky"
		gender = FEMALE

	female_tankini
		name = "Tankini"
		icon_state = "female_tankini"
		gender = FEMALE

////////////////////////////
// Undershirt Definitions //
////////////////////////////
/datum/sprite_accessory/undershirt
	icon = 'icons/mob/underwear.dmi'

/datum/sprite_accessory/undershirt/nude
	name = "Nude"
	icon_state = null
	gender = NEUTER

/datum/sprite_accessory/undershirt/shirt_white
	name = "White Shirt"
	icon_state = "shirt_white"
	gender = NEUTER

/datum/sprite_accessory/undershirt/shirt_black
	name = "Black Shirt"
	icon_state = "shirt_black"
	gender = NEUTER

/datum/sprite_accessory/undershirt/shirt_grey
	name = "Grey Shirt"
	icon_state = "shirt_grey"
	gender = NEUTER

/datum/sprite_accessory/undershirt/tank_white
	name = "White Tank Top"
	icon_state = "tank_white"
	gender = NEUTER

/datum/sprite_accessory/undershirt/tank_black
	name = "Black Tank Top"
	icon_state = "tank_black"
	gender = NEUTER

/datum/sprite_accessory/undershirt/tank_grey
	name = "Grey Tank Top"
	icon_state = "tank_grey"
	gender = NEUTER

/datum/sprite_accessory/undershirt/female_midriff
	name = "Midriff Tank Top"
	icon_state = "tank_midriff"
	gender = FEMALE

/datum/sprite_accessory/undershirt/lover
	name = "Lover shirt"
	icon_state = "lover"
	gender = NEUTER

/datum/sprite_accessory/undershirt/ian
	name = "Blue Ian Shirt"
	icon_state = "ian"
	gender = NEUTER

/datum/sprite_accessory/undershirt/uk
	name = "UK Shirt"
	icon_state = "uk"
	gender = NEUTER

/datum/sprite_accessory/undershirt/ilovent
	name = "I Love NT Shirt"
	icon_state = "ilovent"
	gender = NEUTER

/datum/sprite_accessory/undershirt/peace
	name = "Peace Shirt"
	icon_state = "peace"
	gender = NEUTER

/datum/sprite_accessory/undershirt/mondmondjaja
	name = "Band Shirt"
	icon_state = "band"
	gender = NEUTER

/datum/sprite_accessory/undershirt/pacman
	name = "Pogoman Shirt"
	icon_state = "pogoman"
	gender = NEUTER

/datum/sprite_accessory/undershirt/matroska
	name = "Matroska Shirt"
	icon_state = "matroska"
	gender = NEUTER

/datum/sprite_accessory/undershirt/whiteshortsleeve
	name = "White Short-sleeved Shirt"
	icon_state = "whiteshortsleeve"
	gender = NEUTER

/datum/sprite_accessory/undershirt/purpleshortsleeve
	name = "Purple Short-sleeved Shirt"
	icon_state = "purpleshortsleeve"
	gender = NEUTER

/datum/sprite_accessory/undershirt/blueshortsleeve
	name = "Blue Short-sleeved Shirt"
	icon_state = "blueshortsleeve"
	gender = NEUTER

/datum/sprite_accessory/undershirt/greenshortsleeve
	name = "Green Short-sleeved Shirt"
	icon_state = "greenshortsleeve"
	gender = NEUTER

/datum/sprite_accessory/undershirt/blackshortsleeve
	name = "Black Short-sleeved Shirt"
	icon_state = "blackshortsleeve"
	gender = NEUTER

/datum/sprite_accessory/undershirt/blueshirt
	name = "Blue T-Shirt"
	icon_state = "blueshirt"
	gender = NEUTER

/datum/sprite_accessory/undershirt/redshirt
	name = "Red T-Shirt"
	icon_state = "redshirt"
	gender = NEUTER

/datum/sprite_accessory/undershirt/yellowshirt
	name = "Yellow T-Shirt"
	icon_state = "yellowshirt"
	gender = NEUTER

/datum/sprite_accessory/undershirt/greenshirt
	name = "Green T-Shirt"
	icon_state = "greenshirt"
	gender = NEUTER

/datum/sprite_accessory/undershirt/bluepolo
	name = "Blue Polo Shirt"
	icon_state = "bluepolo"
	gender = NEUTER

/datum/sprite_accessory/undershirt/redpolo
	name = "Red Polo Shirt"
	icon_state = "redpolo"
	gender = NEUTER

/datum/sprite_accessory/undershirt/whitepolo
	name = "White Polo Shirt"
	icon_state = "whitepolo"
	gender = NEUTER

/datum/sprite_accessory/undershirt/grayyellowpolo
	name = "Gray-Yellow Polo Shirt"
	icon_state = "grayyellowpolo"
	gender = NEUTER

/datum/sprite_accessory/undershirt/redtop
	name = "Red Top"
	icon_state = "redtop"
	gender = FEMALE

/datum/sprite_accessory/undershirt/whitetop
	name = "White Top"
	icon_state = "whitetop"
	gender = FEMALE

/datum/sprite_accessory/undershirt/greenshirtsport
	name = "Green Sports Shirt"
	icon_state = "greenshirtsport"
	gender = NEUTER

/datum/sprite_accessory/undershirt/redshirtsport
	name = "Red Sports Shirt"
	icon_state = "redshirtsport"
	gender = NEUTER

/datum/sprite_accessory/undershirt/blueshirtsport
	name = "Blue Sports Shirt"
	icon_state = "blueshirtsport"
	gender = NEUTER

/datum/sprite_accessory/undershirt/ss13
	name = "SS13 Shirt"
	icon_state = "shirt_ss13"
	gender = NEUTER

/datum/sprite_accessory/undershirt/tankfire
	name = "Fire Tank Top"
	icon_state = "tank_fire"
	gender = NEUTER

/datum/sprite_accessory/undershirt/question
	name = "Question Shirt"
	icon_state = "shirt_question"
	gender = NEUTER

/datum/sprite_accessory/undershirt/skull
	name = "Skull Shirt"
	icon_state = "shirt_skull"
	gender = NEUTER

/datum/sprite_accessory/undershirt/commie
	name = "Commie Shirt"
	icon_state = "shirt_commie"
	gender = NEUTER

/datum/sprite_accessory/undershirt/nano
	name = "Nanotransen Shirt"
	icon_state = "shirt_nano"
	gender = NEUTER

/datum/sprite_accessory/undershirt/stripe
	name = "Striped Shirt"
	icon_state = "shirt_stripes"
	gender = NEUTER

/datum/sprite_accessory/undershirt/blueshirt
	name = "Blue Shirt"
	icon_state = "shirt_blue"
	gender = NEUTER

/datum/sprite_accessory/undershirt/redshirt
	name = "Red Shirt"
	icon_state = "shirt_red"
	gender = NEUTER

/datum/sprite_accessory/undershirt/tank_red
	name = "Red Tank Top"
	icon_state = "tank_red"
	gender = NEUTER

/datum/sprite_accessory/undershirt/greenshirt
	name = "Green Shirt"
	icon_state = "shirt_green"
	gender = NEUTER

/datum/sprite_accessory/undershirt/meat
	name = "Meat Shirt"
	icon_state = "shirt_meat"
	gender = NEUTER

/datum/sprite_accessory/undershirt/tiedye
	name = "Tie-dye Shirt"
	icon_state = "shirt_tiedye"
	gender = NEUTER

/datum/sprite_accessory/undershirt/redjersey
	name = "Red Jersey"
	icon_state = "shirt_redjersey"
	gender = NEUTER

/datum/sprite_accessory/undershirt/bluejersey
	name = "Blue Jersey"
	icon_state = "shirt_bluejersey"
	gender = NEUTER

/datum/sprite_accessory/undershirt/tankstripe
	name = "Striped Tank Top"
	icon_state = "tank_stripes"
	gender = NEUTER

/datum/sprite_accessory/undershirt/clownshirt
	name = "Clown Shirt"
	icon_state = "shirt_clown"
	gender = NEUTER

/datum/sprite_accessory/undershirt/alienshirt
	name = "Alien Shirt"
	icon_state = "shirt_alien"
	gender = NEUTER



///////////////////////
// Socks Definitions //
///////////////////////
/datum/sprite_accessory/socks
	icon = 'icons/mob/underwear.dmi'

/datum/sprite_accessory/socks/nude
	name = "Nude"
	icon_state = null
	gender = NEUTER

/datum/sprite_accessory/socks/white_norm
	name = "Normal White"
	icon_state = "white_norm"
	gender = NEUTER

/datum/sprite_accessory/socks/black_norm
	name = "Normal Black"
	icon_state = "black_norm"
	gender = NEUTER

/datum/sprite_accessory/socks/white_short
	name = "Short White"
	icon_state = "white_short"
	gender = NEUTER

/datum/sprite_accessory/socks/black_short
	name = "Short Black"
	icon_state = "black_short"
	gender = NEUTER

/datum/sprite_accessory/socks/white_knee
	name = "Knee-high White"
	icon_state = "white_knee"
	gender = NEUTER

/datum/sprite_accessory/socks/black_knee
	name = "Knee-high Black"
	icon_state = "black_knee"
	gender = NEUTER

/datum/sprite_accessory/socks/thin_knee
	name = "Knee-high Thin"
	icon_state = "thin_knee"
	gender = FEMALE

/datum/sprite_accessory/socks/striped_knee
	name = "Knee-high Striped"
	icon_state = "striped_knee"
	gender = NEUTER

/datum/sprite_accessory/socks/rainbow_knee
	name = "Knee-high Rainbow"
	icon_state = "rainbow_knee"
	gender = NEUTER

/datum/sprite_accessory/socks/white_thigh
	name = "Thigh-high White"
	icon_state = "white_thigh"
	gender = NEUTER

/datum/sprite_accessory/socks/black_thigh
	name = "Thigh-high Black"
	icon_state = "black_thigh"
	gender = NEUTER

/datum/sprite_accessory/socks/thin_thigh
	name = "Thigh-high Thin"
	icon_state = "thin_thigh"
	gender = FEMALE

/datum/sprite_accessory/socks/striped_thigh
	name = "Thigh-high Striped"
	icon_state = "striped_thigh"
	gender = NEUTER

/datum/sprite_accessory/socks/rainbow_thigh
	name = "Thigh-high Rainbow"
	icon_state = "rainbow_thigh"
	gender = NEUTER

/datum/sprite_accessory/socks/pantyhose
	name = "Pantyhose"
	icon_state = "pantyhose"
	gender = FEMALE
