/mob/living/simple_animal/hostile/eyehorror
	name = "It That Sees"
	desc = "An abomination from another plane of existence."
	icon_state = "eyehorror"
	icon_living = "eyehorror"
	icon_dead = "eyehorror_dead"
	icon = 'icons/mob/eyehorror.dmi'
	speak_chance = 0
	turns_per_move = 5
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 1
	maxHealth = 240
	health = 240

	harm_intent_damage = 10
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "gazes at"

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "horror"

	var/victims = 0 //Archive the number of victims, used for strength scaling.

/mob/living/simple_animal/hostile/eyehorror/Life()
	.=..()
	//Anyone who can hear this mob will begin to hallucinate. As the number of victims increases, range and strength of the hallucinations do as well.
	if(!.) return 0
	var/victimcount = 0
	for (var/mob/living/M in hearers(7+victims,src))
		if (istype(M,/mob/living/simple_animal/hostile/eyehorror)) continue
		M.hallucination += 4*(1+victims)
		victimcount++
	victims = victimcount

