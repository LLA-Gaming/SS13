//Alpaca
/mob/living/simple_animal/alpaca
	name = "\improper alpaca"
	real_name = "alpaca"
	desc = "It's an alpaca."
	icon_state = "alpaca"
	icon_living = "alpaca"
	icon_dead = "alpaca_dead"
	speak = list("mmmm", "eeee", "merrr", "hmm")
	speak_emote = list("hums")
	emote_hear = list("hums")
	emote_see = list("shakes its neck","shivers","spits")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	meat_amount = 6
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicks"
	health = 50