/datum/disease/transformation/xenosky

	name = "Xenosky Transformation"
	cure = "Spaceacillin & Glycerol"
	cure_id = list("spaceacillin", "glycerol")
	cure_chance = 5
	agent = "NT Security Nanomachines"
	hidden = list(0, 0)
	stage1	= list("")
	stage2	= list("Your throat feels scratchy.", "\red Kill...")
	stage3	= list("\red Your throat feels very scratchy.", "Your skin feels tight.", "\red You can feel something move...inside.")
	stage4	= list("\red Your skin feels very tight.", "\red Your blood boils!", "\red You can feel... something...inside you.")
	stage5	= list("\red Your skin feels as if it's about to burst off!")
	new_form = /mob/living/carbon/alien/beepsky/humanoid/hunter

/datum/reagent/xenoskymicrobes
	name = "Security Nanobots"
	id = "xenoskymicrobes"
	description = "Nanomachines design to punish criminal scum."
	//reagent_state = LIQUID
	color = "#535E66" // rgb: 83, 94, 102

/datum/reagent/xenosky/microbes/reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
	src = null
	if( (prob(10) && method==TOUCH) || method==INGEST)
		M.contract_disease(new /datum/disease/transformation/xenosky(0),1)