/datum/borer_upgrade
	var/name = "Prototype Upgrade"
	var/desc = "" // Fluff
	var/helptext = "" // Details
	var/chem_cost // How much chems it cost to evolve it
	var/list/requirements // If the upgrade requires other upgrades
	var/evil = 0 // Is it only available to evil borers?
	var/good = 0 // Is it only available to good borers?

/datum/borer_upgrade/proc/on_purchase(var/mob/user)
	return

/datum/borer_upgrade/adv_detach
	name = "Advanced Seperation"
	desc = "We learn how to detach ourselves from our host faster."
	helptext = "Makes you detach from your host five times faster."
	chem_cost = 50

/datum/borer_upgrade/adv_detach/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.detach_speed = 30
	return

/datum/borer_upgrade/adv_attach
	name = "Advanced Invasion"
	desc = "We learn how to attach ourselves to a suitable host faster."
	helptext = "Makes you attach to a suitable host much times faster."
	chem_cost = 75
	requirements = list("Advanced Seperation")

/datum/borer_upgrade/adv_attach/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.attach_speed = 20
	return

/datum/borer_upgrade/lesser_assume
	name = "Lesser Mind Control"
	desc = "We evolve the ability to control lesser minds."
	helptext = "Gives you the ability to control mindless monkeys."
	chem_cost = 125
	good = 1

/datum/borer_upgrade/lesser_assume/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.attached += /mob/living/simple_animal/borer/proc/lesser_assume
	if(B.host)
		B.verbs |= B.attached
		B << "<span class='notice'>You may need to leave your host before you can use this ability.</span>"
	return

/datum/borer_upgrade/adv_control
	name = "Advanced Control"
	desc = "We learn how to control weak minds more efficiently."
	helptext = "You do not use chemicals while controlling a mindless host."
	chem_cost = 125
	evil = 1

/datum/borer_upgrade/adv_control/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.adv_control = 1
	return

/datum/borer_upgrade/armor
	name = "Chitin Plates"
	desc = "We evolve some chitin plates to make ourselves more resilent."
	helptext = "Triples your health."
	chem_cost = 100

/datum/borer_upgrade/armor/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.maxHealth = 15
	B.health += 10
	return

/datum/borer_upgrade/hard_armor
	name = "Hardened Chitin Plates"
	desc = "We evolve some hardened chitin plates to make ourselves more resilent."
	helptext = "Makes you immune to stomps and raises your health a bit."
	chem_cost = 150
	requirements = list("Chitin Plates")

/datum/borer_upgrade/hard_armor/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.maxHealth = 20
	B.health += 5
	B.armored = 1
	B.icon_state = "armoredbrainslug"
	B.icon_living = "armoredbrainslug"
	B.icon_dead = "armoredbrainslug_dead"
	return

/datum/borer_upgrade/r_armor
	name = "Reinforced Chitin Plates"
	desc = "We evolve some reinforced chitin plates to make ourselves more resilent."
	helptext = "Raises your health a bit."
	chem_cost = 200
	requirements = list("Hardened Chitin Plates")

/datum/borer_upgrade/r_armor/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.maxHealth = 25
	B.health += 5
	return

/datum/borer_upgrade/retaliate
	name = "Defensive Cloud"
	desc = "We evolve the ability to release a toxic cloud when in danger."
	helptext = "You release a slightly toxic cloud when stomped on."
	chem_cost = 100

/datum/borer_upgrade/retaliate/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.retaliate = 1
	return

/datum/borer_upgrade/retaliate_acid
	name = "Acidic Cloud"
	desc = "We evolve the ability to release a acidic cloud when in danger."
	helptext = "You release a slightly acidic cloud when stomped on."
	chem_cost = 200
	requirements = list("Defensive Cloud")
	evil = 1

/datum/borer_upgrade/retaliate_acid/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.retaliate = 2
	return

/datum/borer_upgrade/heal
	name = "Regenerate"
	desc = "Gives us the ability to heal ourselves."
	helptext = "Completely heals you when used."
	chem_cost = 50

/datum/borer_upgrade/heal/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.upgrade_verbs += /mob/living/simple_animal/borer/proc/heal
	B.verbs |= B.upgrade_verbs
	if(B.host)
		B << "<span class='notice'>You may need to leave your host before you can use this ability.</span>"
	return

/datum/borer_upgrade/blood_clot
	name = "Coagulation Agent"
	desc = "We evolve the ability to secrete a blood clotting agent into our hosts bloodstream."
	helptext = "Closes bleeding wounds of your host."
	chem_cost = 80

/datum/borer_upgrade/blood_clot/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.attached += /mob/living/simple_animal/borer/proc/blood_clot
	if(B.host)
		B.verbs |= B.attached
		B << "<span class='notice'>You may need to leave your host before you can use this ability.</span>"
	return

/datum/borer_upgrade/hear
	name = "Resonance Augment"
	desc = "We develop the ability to convert vibrations on the air into information about our surroundings."
	helptext = "You gain the ability to hear while outside of a host."
	chem_cost = 75

/datum/borer_upgrade/hear/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.hear_augment = 1
	return

/datum/borer_upgrade/telepathic
	name = "Telepathic Projection"
	desc = "We develop a telepathic power that allows us to send information to other beings."
	helptext = "You gain the ability to speak to a single individual."
	chem_cost = 50

/datum/borer_upgrade/telepathic/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.upgrade_verbs += /mob/living/simple_animal/borer/proc/telepathic
	B.verbs |= B.upgrade_verbs
	if(B.host)
		B << "<span class='notice'>You may need to leave your host before you can use this ability.</span>"
	return

/datum/borer_upgrade/universal
	name = "Babelslug"
	desc = "We develop the ability to link ourselves to the language region of the brains of nearby lifeforms."
	helptext = "You gain the ability to understand all lifeforms."
	requirements = list("Resonance Augment","Telepathic Projection")
	chem_cost = 75

/datum/borer_upgrade/universal/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.universal_speak = 1
	return

/datum/borer_upgrade/chem_storage
	name = "Upgraded Chemical Storage"
	desc = "We evolve a larger chemical gland."
	helptext = "Allows you to store 300 chemicals instead of 200."
	chem_cost = 150

/datum/borer_upgrade/chem_storage/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.maxChems = 300
	return

/datum/borer_upgrade/chem_inaprov
	name = "Inaprovaline"
	desc = "Unlocks Inaprovaline."
	helptext = "Allows you to synthesize Inaprovaline."
	chem_cost = 25

/datum/borer_upgrade/chem_inaprov/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.chems -= list("Cancel")
	B.chems += list("Inaprovaline","Cancel")
	return

/datum/borer_upgrade/chem_tricord
	name = "Tricordrazine"
	desc = "Unlocks Tricordrazine."
	helptext = "Allows you to synthesize Tricordrazine."
	chem_cost = 75

/datum/borer_upgrade/chem_tricord/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.chems -= list("Cancel")
	B.chems += list("Tricordrazine","Cancel")
	return

/datum/borer_upgrade/chem_doctors
	name = "Doctors Delight"
	desc = "Unlocks Doctors Delight."
	helptext = "Allows you to synthesize Doctors Delight."
	chem_cost = 125
	requirements = list("Tricordrazine")

/datum/borer_upgrade/chem_doctors/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.chems -= list("Tricordrazine","Cancel")
	B.chems += list("The Doctor's Delight","Cancel")
	return

/datum/borer_upgrade/chem_dexalin
	name = "Dexalin"
	desc = "Unlocks Dexalin."
	helptext = "Allows you to synthesize Dexalin."
	chem_cost = 100

/datum/borer_upgrade/chem_dexalin/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.chems -= list("Cancel")
	B.chems += list("Dexalin","Cancel")
	return

/datum/borer_upgrade/chem_dexalinp
	name = "Dexalin Plus"
	desc = "Unlocks Dexalin Plus."
	helptext = "Allows you to synthesize Dexalin Plus."
	chem_cost = 200
	requirements = list("Dexalin")

/datum/borer_upgrade/chem_dexalinp/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.chems -= list("Dexalin","Cancel")
	B.chems += list("Dexalin Plus","Cancel")
	return

/datum/borer_upgrade/enviro_immunity
	name = "Environmental Immunity"
	desc = "Makes us immune to the harshest conditions."
	helptext = "Become immune to pressure, temperature and gas."
	chem_cost = 300
	requirements = list("Hardened Chitin Plates","Dexalin Plus","Upgraded Chemical Storage")

/datum/borer_upgrade/enviro_immunity/on_purchase(var/mob/user)
	..()
	var/mob/living/simple_animal/borer/B = user
	B.min_oxy = 0
	B.minbodytemp = 0
	B.maxbodytemp = 1500
	return