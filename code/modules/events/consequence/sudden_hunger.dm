/datum/round_event_control/sudden_hunger
	name = "Sudden Hunger"
	typepath = /datum/round_event/sudden_hunger
	event_flags = EVENT_CONSEQUENCE
	max_occurrences = -1
	weight = 15
	accuracy = 100

/datum/round_event/sudden_hunger
	Start()
		for(var/mob/living/carbon/human/H in living_mob_list)
			H.nutrition -= 150
			events.AddAwards("eventmedal_hunger",list("[H.key]"))