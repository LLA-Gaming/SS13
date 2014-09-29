/proc/random_blood_type()
	return pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

/proc/random_eye_color()
	switch(pick(20;"brown",20;"hazel",20;"grey",15;"blue",15;"green",1;"amber",1;"albino"))
		if("brown")		return "630"
		if("hazel")		return "542"
		if("grey")		return pick("666","777","888","999","aaa","bbb","ccc")
		if("blue")		return "36c"
		if("green")		return "060"
		if("amber")		return "fc0"
		if("albino")	return pick("c","d","e","f") + pick("0","1","2","3","4","5","6","7","8","9") + pick("0","1","2","3","4","5","6","7","8","9")
		else			return "000"

/proc/random_underwear(gender)
	switch(gender)
		if(MALE)	return pick(underwear_m)
		if(FEMALE)	return pick(underwear_f)
		else		return pick(underwear_all)

/proc/random_undershirt(gender)
	switch(gender)
		if(MALE)	return pick(undershirt_m)
		if(FEMALE)	return pick(undershirt_f)
		else		return pick(undershirt_list)

/proc/random_socks(gender)
	switch(gender)
		if(MALE)	return pick(socks_m)
		if(FEMALE)	return pick(socks_f)
		else		return pick(socks_list)

proc/random_hair_style(gender)
	switch(gender)
		if(MALE)	return pick(hair_styles_male_list)
		if(FEMALE)	return pick(hair_styles_female_list)
		else		return pick(hair_styles_list)

proc/random_facial_hair_style(gender)
	switch(gender)
		if(MALE)	return pick(facial_hair_styles_male_list)
		if(FEMALE)	return pick(facial_hair_styles_female_list)
		else		return pick(facial_hair_styles_list)

proc/random_name(gender, attempts_to_find_unique_name=10)
	for(var/i=1, i<=attempts_to_find_unique_name, i++)
		if(gender==FEMALE)	. = capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else				. = capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))

		if(i != attempts_to_find_unique_name && !findname(.))
			break

proc/random_skin_tone()
	return pick(skin_tones)

var/list/skin_tones = list(
	"albino",
	"caucasian1",
	"caucasian2",
	"caucasian3",
	"latino",
	"mediterranean",
	"asian1",
	"asian2",
	"arab",
	"indian",
	"african1",
	"african2"
	)

var/list/mutant_races = list(
	"human",
	"lizard",
	)

proc/age2agedescription(age)
	switch(age)
		if(0 to 1)			return "infant"
		if(1 to 3)			return "toddler"
		if(3 to 13)			return "child"
		if(13 to 19)		return "teenager"
		if(19 to 30)		return "young adult"
		if(30 to 45)		return "adult"
		if(45 to 60)		return "middle-aged"
		if(60 to 70)		return "aging"
		if(70 to INFINITY)	return "elderly"
		else				return "unknown"

/*
Proc for attack log creation, because really why not
1 argument is the actor
2 argument is the target of action
3 is the description of action(like punched, throwed, or any other verb)
4 should it make adminlog note or not
5 is the tool with which the action was made(usually item)					5 and 6 are very similar(5 have "by " before it, that it) and are separated just to keep things in a bit more in order
6 is additional information, anything that needs to be added
*/

proc/add_logs(mob/user, mob/target, what_done, var/admin=1, var/object=null, var/addition=null)
	if(user && ismob(user))
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has [what_done] [target ? "[target.name][(ismob(target) && target.ckey) ? "([target.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition]</font>")
	if(target && ismob(target))
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been [what_done] by [user ? "[user.name][(ismob(user) && user.ckey) ? "([user.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition]</font>")
	if(admin)
		log_attack("<font color='red'>[user ? "[user.name][(ismob(user) && user.ckey) ? "([user.ckey])" : ""]" : "NON-EXISTANT SUBJECT"] [what_done] [target ? "[target.name][(ismob(target) && target.ckey)? "([target.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition]</font>")