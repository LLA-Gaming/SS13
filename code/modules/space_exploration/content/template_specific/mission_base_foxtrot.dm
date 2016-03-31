/obj/effect/landmark/paper_code
	var/_id

/obj/effect/landmark/trigger_landmark
	var/_id

	phrase/

/proc/PlaceCodedPapers(var/title, var/pre_text, var/code_length, var/amount, var/landmark_id)
	var/list/papers = list()

	if(code_length % amount != 0)
		CRASH("'code_length' must be a multiple of 'amount'")
		return 0

	var/char_index = 1
	var/list/code = list()
	for(var/i in (1 to amount))
		code[num2text(i)] = list()

	for(var/i in (1 to code_length))
		var/picked = pick(alphabet + list("1", "2", "3", "4", "5", "6", "7", "8", "9", "0"))
		var/rand_num = rand(1, amount)

		code[num2text(rand_num)][num2text(char_index)] = picked

		char_index++

	var/list/complete_code = list()
	for(var/x in (1 to code_length))
		complete_code += "-"

	for(var/i in (1 to amount))
		var/obj/item/weapon/paper/generated = new()
		generated.name = title
		generated.info = pre_text

		var/list/formatted = list()
		for(var/x in (1 to code_length))
			formatted += "-"

		for(var/index in code[num2text(i)])
			var/char = code[num2text(i)][index]
			formatted[text2num(index)] = char
			complete_code[text2num(index)] = char

		generated.info += jointext(formatted,"")

		papers += generated

	for(var/obj/effect/landmark/paper_code/lm in landmarks_list)
		if(lm._id == landmark_id)
			var/obj/item/weapon/paper/selected = pick_n_take(papers)
			if(selected)
				selected.loc = get_turf(lm)

	return jointext(complete_code,"")

// Called dynamically
/datum/template_setups/proc/setup_mission_base_foxtrot()
	var/code = PlaceCodedPapers("SEALED PACKAGE SNIPPET", "Commander Reyes, the code to the vault is: ", 20, 4, "mb_foxtrot")

	for(var/obj/effect/landmark/trigger_landmark/phrase/pl in landmarks_list)
		if(pl._id == "mb_foxtrot_code")
			var/obj/effect/trigger_modules/conditional/spoken_phrase/phrase = locate() in get_turf(pl)
			if(phrase)
				phrase._phrase = code
				break