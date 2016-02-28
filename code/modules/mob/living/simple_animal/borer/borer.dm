/mob/living/simple_animal/borer
	name = "Cortical Borer"
	real_name = ""
	desc = "A small, quivering sluglike creature."
	icon = 'icons/mob/animal.dmi'
	icon_state = "brainslug"
	icon_living = "brainslug"
	icon_dead = "brainslug_dead"
	maxHealth = 5
	health = 5
	universal_speak = 0
	response_help  = "pokes"
	response_disarm = "prods"
	response_harm   = "stomps on"
	density = 0
	ventcrawler = 2
	max_co2 = 0
	max_tox = 0
	stop_automated_movement = 1
	pass_flags = PASSTABLE
	status_flags = CANWEAKEN

	var/attach_speed = 50
	var/detach_speed = 150
	var/evil = 0
	var/chemicals = 50
	var/maxChems = 200
	var/mob/living/carbon/human/host
	var/docile = 0
	var/controlling = 0
	var/adv_control = 0
	var/adv_control_active = 0
	var/suction_cooldown = 0
	var/can_lay = 0
	var/egg_timer
	var/armored = 0
	var/retaliate = 0
	var/hear_augment = 0
	var/blood_clotting = 0
	var/list/upgrades = list()
	var/list/purchasedupgrades = list()
	var/list/detached = list()
	var/list/attached = list()
	var/list/chems = list()
	var/list/upgrade_verbs = list(/mob/living/simple_animal/borer/proc/upgrade_menu)

/mob/living/simple_animal/borer/New()
	..()
	init_subtypes(/datum/borer_upgrade, upgrades)
	real_name = "[pick("Pai","Bai","Zai","Dai")]'[pick("Luxar","Vorir","Kotar","Ranir")] [rand(1000,9999)]"
	if(prob(5))
		evil = 1
	initialize_lists()
	egg_timer = world.time + 3000
	verbs += upgrade_verbs
	verbs += detached

/mob/living/simple_animal/borer/Life()
	..()
	if(!stat)
		if(!can_lay && egg_timer < world.time)
			can_lay = 1
			src << "<span class='notice'>You can lay an egg.</span>"
	if(host)
		if(!ishuman(host) && !ismonkey(host))
			detach()
		if(!stat && !host.stat)
			src.sight = host.sight
			src.see_in_dark = host.see_in_dark
			src.see_invisible = host.see_invisible
			if(host.reagents.has_reagent("sugar"))
				if(!docile)
					docile = 1
					if(!controlling)
						src << "\blue You feel the soporific flow of sugar in your host's blood, lulling you into docility."
					else
						host << "\blue You feel the soporific flow of sugar in your host's blood, lulling you into docility."
			else
				if(docile)
					src << "\blue You shake off your lethargy as the sugar leaves your host's blood."
					docile = 0
//			if(!ismonkey(host))
			host.nutrition -= HUNGER_FACTOR
			if(chemicals < maxChems && !controlling)
				chemicals++
			if(ishuman(host) && blood_clotting)
				if(chemicals < 10)
					blood_clotting = 0
				chemicals -= 5
				var/list/bleeding = host.get_damaged_organs(0,0,1)
				var/obj/item/organ/limb/L = pick(bleeding)
				L.bleedstate--
				if(!L.bleedstate)
					L.bleeding = 0
					bleeding -= L
				if(!bleeding.len)
					blood_clotting = 0

		if(controlling)
			if(docile || chemicals <= 0)
				host << "<span class='notice'>Your control over your host's body fades away.</span>"
				return_control()
			if(!adv_control_active)
				chemicals--

	if(client)
		handle_regular_hud_updates()

	update_canmove()

/mob/living/simple_animal/borer/Stat()
	statpanel("Status")
	stat("Borer Information")
	stat(null) // this is to have empty lines in the panel for cleaner formatting.
	..()

	if (client && client.statpanel == "Status")
		stat("Chemicals", chemicals)

		if(host)
			stat(null)
			stat("Host Information")
			stat(null)
			stat("Health", "[host.health - host.getBloodLoss()]%")
			stat("Brute damage: [host.getBruteLoss()]")
			stat("Burn damage: [host.getFireLoss()]")
			stat("Toxin damage: [host.getToxLoss()]")
			stat(null)
			stat("Intent:", "[host.a_intent]")
			stat("Move Mode:", "[host.m_intent]")

			if(ishuman(host))
				if (host.internal)
					if (!host.internal.air_contents)
						qdel(host.internal)
					else
						stat(null)
						stat("Internal Atmosphere Info", host.internal.name)
						stat("Tank Pressure", host.internal.air_contents.return_pressure())
						stat("Distribution Pressure", host.internal.distribute_pressure)

				if ((istype(host.wear_suit, /obj/item/clothing/suit/space/space_ninja)&&host.wear_suit:s_initialized) || (istype(host.wear_suit, /obj/item/clothing/suit/space/powersuit)&&host.wear_suit:powered))
					stat(null)
					stat("Suit Energy Charge", round(host.wear_suit:cell:charge/100)) // This seems like a horrible way to do but ok
				if(istype(host.loc, /obj/pod))
					var/obj/pod/pod = host.loc
					if(pod.pilot == host)
						stat(null)
						stat("Pod Integrity: ", "[round((pod.health / pod.max_health) * 100)]%")
						if(pod.power_source)
							stat("Pod Charge: ", "[pod.power_source.charge]/[pod.power_source.maxcharge] ([pod.power_source.percent()]%)")
						var/obj/item/weapon/pod_attachment/sensor/sensor = pod.GetAttachmentOnHardpoint(16)
						if(sensor && istype(sensor, /obj/item/weapon/pod_attachment/sensor/gps))
							stat("Pod Position: ", "([pod.x], [pod.y], [pod.z])")
				stat(null)
				if(ticker && ticker.mode && ticker.mode.name == "AI malfunction")
					if(ticker.mode:malf_mode_declared)
						stat("Station Override", "Time left: [max(ticker.mode:AI_win_timeleft/(ticker.mode:apcs/3), 0)]")
				if(emergency_shuttle)
					if(emergency_shuttle.online && emergency_shuttle.location < 2)
						var/timeleft = emergency_shuttle.timeleft()
						if (timeleft)
							stat("Emergency Shuttle","ETA-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")

/mob/living/simple_animal/borer/UnarmedAttack(var/atom/A)
	if(host) return
	else return ..()

/mob/living/simple_animal/borer/attack_hand(mob/living/carbon/human/M as mob)
	if(retaliate)
		switch(M.a_intent)
			if("harm", "disarm")
				var/datum/effect/effect/system/chem_smoke_spread/S = new
				var/datum/reagents/R = new/datum/reagents(25)
				var/location = get_turf(src)
				var/cloud
				if(retaliate == 1)
					cloud = "spore"
				else if(retaliate == 2)
					cloud = "sacid"
				R.my_atom = src
				R.add_reagent(cloud, 25)
				S.attach(location)
				S.set_up(R, 1, 1, location, 15, 1)
				S.start()
				R.delete()

				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message("\red [src] releases a cloud!")

	if(armored)
		switch(M.a_intent)
			if("harm", "disarm")
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message("\red [M] [response_harm] [src] in vain!")
				return
	..()

/mob/living/simple_animal/borer/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/reagent_containers/food/condiment/saltshaker))
		var/obj/item/weapon/reagent_containers/food/condiment/saltshaker/shaker = O
		if(shaker.reagents.has_reagent("sodiumchloride"))
			shaker.reagents.remove_reagent("sodiumchloride", 1)
			src.Weaken(5)
			src.visible_message("<span class='danger'>[src] has been sprinkled with salt by [user]!</span>")
			add_logs(user, src, "weakened", object="saltshaker")
			return
	..()

/mob/living/simple_animal/borer/update_canmove()
	if(weakened) canmove = 0
	else canmove = 1
	return canmove

/mob/living/simple_animal/borer/proc/handle_regular_hud_updates()
	if(hud_used)
		for(var/image/hud in client.images)
			if(copytext(hud.icon_state,1,4) == "hud")
				client.images.Remove(hud)

		hud_used.lingchemdisplay.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'> <font color='#dd66dd'>[chemicals]</font></div>"

		if(!host)
			if(healths)
				healths.icon_state = null
			if(staminas)
				staminas.icon_state = null
			if(nutrition_icon)
				nutrition_icon.icon_state = null

		if(host)
			if(healths)
				switch(host.health - (host.getBloodLoss() * host.health / 100))
					if(100 to INFINITY)		healths.icon_state = "health0"
					if(80 to 100)			healths.icon_state = "health1"
					if(60 to 80)			healths.icon_state = "health2"
					if(40 to 60)			healths.icon_state = "health3"
					if(20 to 40)			healths.icon_state = "health4"
					if(0 to 20)				healths.icon_state = "health5"
					else					healths.icon_state = "health6"
				if(ishuman(host) && host.blood.total_volume <= BLOODLOSS_CRIT)
					healths.icon_state = "health6"

			if(staminas)
				if (host.stat != 2)
					var/threshold = Clamp((host.health - host.getBloodLoss()),1,100)
					var/display = 100 - round((Clamp(host.staminaloss,0,threshold) / threshold * 100))
					switch(display)
						if(99 to 100)		staminas.icon_state = "stamina0"
						if(75 to 98)			staminas.icon_state = "stamina1"
						if(50 to 74)			staminas.icon_state = "stamina2"
						if(25 to 49)			staminas.icon_state = "stamina3"
						if(6 to 24)				staminas.icon_state = "stamina4"
						if(-INFINITY to 5)		staminas.icon_state = "stamina5"
						else					staminas.icon_state = "stamina5"

			if(nutrition_icon)
				switch(host.nutrition)
					if(450 to INFINITY)				nutrition_icon.icon_state = "nutrition0"
					if(350 to 450)					nutrition_icon.icon_state = "nutrition1"
					if(250 to 350)					nutrition_icon.icon_state = "nutrition2"
					if(150 to 250)					nutrition_icon.icon_state = "nutrition3"
					else

/mob/living/simple_animal/borer/proc/make_special()
	var/datum/mind/Mind = src.mind
	Mind.special_role = "Special Borer"
	ticker.mode.traitors |= Mind

	var/datum/objective/protect/P = new
	P.owner = Mind
	P.find_target()
	Mind.objectives += P

	var/datum/objective/survive/S = new
	S.owner = Mind
	Mind.objectives += S

	var/obj_count = 1
	src << "\blue Your current objectives:"
	for(var/datum/objective/objective in Mind.objectives)
		src << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++
