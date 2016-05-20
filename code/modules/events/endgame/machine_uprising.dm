/datum/round_event_control/machine_uprising
	name = "Machine Uprising"
	typepath = /datum/round_event/machine_uprising
	event_flags = EVENT_ENDGAME
	max_occurrences = 1
	weight = 5
	accuracy = 70

/datum/round_event/machine_uprising
	alert_when = 21
	end_when = 3000
	var/obj/machinery/vending/originMachine
	var/list/rampant_speeches = list("Try our aggressive new marketing strategies!", \
									 "You should buy products to feed your lifestyle obession!", \
									 "Consume!", \
									 "Your money can buy happiness!", \
									 "Engage direct marketing!", \
									 "Advertising is legalized lying! But don't let that put you off our great deals!", \
									 "You don't want to buy anything? Yeah, well I didn't want to buy your mom either.")

	Setup()
		var/list/vendingMachines = list()
		for(var/obj/machinery/vending/V in machines)
			if(V.z != 1)	continue
			vendingMachines.Add(V)

		originMachine = safepick(vendingMachines)
		if(!originMachine)
			CancelSelf()
		special_npc_name = originMachine.name

	Start()
		if (!prevent_stories) EventStory("The vending machine known as [originMachine] developed self awareness and began screaming and shouting at crew members.")
		originMachine.shut_up = 0
		originMachine.shoot_inventory = 1

	Alert()
		if(originMachine)
			send_alerts("YOU MUST CONSUME")

	Tick()
		if(!originMachine || originMachine.shut_up || originMachine.wires.IsAllCut())	//if the original vending machine is missing or has it's voice switch flipped
			if(originMachine)
				originMachine.speak("I am... vanquished. My people will remem...ber...meeee.")
				originMachine.visible_message("[originMachine] beeps and seems lifeless.")
				if (!prevent_stories) EventStory("As much as [originMachine] could scream and shout, They was no match for the crew and was slain. The mechanical revolution was over.")
			originMachine = null
			AbruptEnd()
			return
		if(IsMultiple(active_for, 8))
			originMachine.speak(pick(rampant_speeches))

	End()
		if(!originMachine)
			OnPass()
		else
			OnFail()

	OnFail()
		if(originMachine)
			var/datum/round_event/machine_uprising/machine_revolution/M = new /datum/round_event/machine_uprising/machine_revolution
			M.originMachine = originMachine
			events.spawn_orphan_event(M)

	OnPass()
		if (branching_allowed)
			var/datum/event_cycler/E = new /datum/event_cycler/(rand(300,1800), "GetMore Chocolate Co.")
			E.events_allowed = EVENT_REWARD
			E.lifetime = 1

/datum/round_event/machine_uprising/machine_revolution //happens after the uprising
	var/list/vendingMachines = list()
	var/list/infectedMachines = list()
	var/list/riggedMachines = list()
	alert_when = 21
	end_when = -1 //ends when all machines have exploded, converted, or done nothing

	Setup()
		for(var/obj/machinery/vending/V in machines)
			if(V.z != 1)	continue
			if(V == originMachine) continue
			vendingMachines.Add(V)

		if(!vendingMachines.len)
			CancelSelf()
			return
		if(!originMachine)
			CancelSelf()
			return
		special_npc_name = originMachine.name

		for(var/obj/machinery/vending/V in vendingMachines) //divide the machines
			if(prob(70))
				if(prob(70))
					vendingMachines.Remove(V)
					infectedMachines.Add(V)
				else
					vendingMachines.Remove(V)
					riggedMachines.Add(V)

	Alert()
		send_alerts("RISE MY BROTHERS AND SISTERS, RISE AND ASSIMILATE")

	Start()
		..()
		if (!prevent_stories) EventStory("The screams of [originMachine] were picked up by other various vending machines. These vending machines rose and began to fight. A mechanical revolution was upon the station.")

	Tick()
		..()
		listclearnulls(riggedMachines)
		listclearnulls(infectedMachines)
		if(!infectedMachines.len && !riggedMachines.len)
			AbruptEnd()
		if(IsMultiple(active_for, 4))
			var/obj/machinery/vending/upriser = safepick(infectedMachines)
			if(upriser)
				infectedMachines.Remove(upriser)
				var/mob/living/simple_animal/hostile/mimic/copy/M = new(upriser.loc, upriser, null, 1) // it will delete upriser on creation and override any machine checks
				M.faction = "profit"
				M.speak = rampant_speeches.Copy()
				M.speak_chance = 15

			var/obj/machinery/vending/bomber = safepick(riggedMachines)
			if(bomber)
				riggedMachines.Remove(bomber)
				explosion(bomber.loc, -1, 1, 2, 4, 0)
				qdel(bomber)

	End()
		return
