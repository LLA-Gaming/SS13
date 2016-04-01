/datum/round_event_control/april_fools
	name = "April Fools"
	holidayID = "April Fool's Day"
	typepath = /datum/round_event/april_fools
	event_flags = EVENT_SPECIAL
	max_occurrences = 1
	weight = 10


/datum/round_event/april_fools
	alert_when = 300
	end_when = -1
	var/joke_when = 0
	var/list/puns = list("Two cannibals are eating a clown, one says to the other \"does this taste funny to you?\"","I'd tell you a chemistry joke but I know I wouldn't get a reaction.","I wasn't originally going to get a brain transplant, but then I changed my mind.","Did you hear about the guy who got hit in the head with a can of star kist? He was lucky it was a soft drink.","The chef backed up into the meat grinder and got a little behind in his work.","The other day I held an airlock open for a clown. I thought it was a nice jester.","Einstein developed a theory about space, and it was about time too.","never knew the price of a space pod was so astronomical!","Felt a little dim when I forgot about the replacement lightbulbs","Perseus' stun knife technology is really cutting edge.")
	var/fake_names = list("energy gun","energy sword","C4","med-kit","highly illegal item")

	Start()
		if (!prevent_stories) EventStory("Happy April Fool's Day!")
		if(holiday == "April Fool's Day")//prevents bus
			for(var/mob/living/carbon/human/L in player_list)
				events.AddAwards("eventmedal_aprilfooled",list("[L.key]"))

	Tick()
		if(joke_when <= world.time)
			joke_when = world.time + rand(3000,6000)
			var/mob/living/victim
			var/mob/living/other_victim
			for(var/mob/living/L in shuffle(player_list))
				L << "<b>...Wanna hear a joke?...</b>"
				L << "<b>...[pick(puns)]...</b>"
				if(!L.stat && !victim)
					victim = L
					continue
				if(!L.stat && !other_victim)
					other_victim = L
					continue
			if(victim)
				var/obj/item/item
				for(var/obj/item/I in shuffle(victim.contents))
					if(istype(I,/obj/item/device/tablet)) continue
					if(istype(I,/obj/item/weapon/card/id)) continue
					item= I
					break
				var/picked_name = pick(fake_names)
				var/old_name = item.name
				item.name = picked_name
				item.desc = "wait.. this doesn't seem right"
				victim << "<b>...Your [old_name] is now a [picked_name]...</b>"
			if(other_victim)
				other_victim.slip(8, 5, src, GALOSHES_DONT_HELP)
				other_victim << "<b>...Wow, way to <font color = 'red'>SLIP</font> up...</b>"