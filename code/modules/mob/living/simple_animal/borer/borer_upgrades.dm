/datum/borer_upgrade
	var/name = "Prototype Upgrade"
	var/desc = "" // Fluff
	var/helptext = "" // Details
	var/chem_cost

/datum/borer_upgrade/proc/on_purchase(var/mob/user)
	return

/datum/borer_upgrade/armor
	name = "Chitin Plates"
	desc = "Evolve some chitin plates to make ourselves more resilent."
	helptext = "Triples our health."
	chem_cost = 100

/datum/borer_upgrade/armor/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.maxHealth = 15
	B.health += 10
	return

/datum/borer_upgrade/heal
	name = "Heal"
	desc = "Gives us the ability to heal ourselves."
	helptext = "Gives us the ability to heal ourselves."
	chem_cost = 50

/datum/borer_upgrade/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.verbs += /mob/living/simple_animal/borer/proc/heal
	return