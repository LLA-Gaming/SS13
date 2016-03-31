/datum/round_event/xeno_artifact_research
	var/passed = 0
	end_when = -1

	Setup()
		if(!supply_shuttle)
			CancelSelf()
		special_npc_name = "CentComm Commander [pick(last_names)]"
		start_when		= world.time + rand(600,1200)

	Start()
		if (!prevent_stories) EventStory("The station was shipped an experimental xeno artifact for researching.")
		supply_shuttle.tasks.Add(src)
		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = supply_shuttle.ordernum
		O.object = new /datum/supply_packs/xeno_artifact
		O.object.name = "xeno artifact crate"
		O.orderedby = "Centcomm"
		O.perfect = 1
		supply_shuttle.shoppinglist += O
		priority_announce("Our scientists have analyzed that data you shipped to us. [station_name()] is now authorized for experimental research. Instructions, along with the excavated artifact, have been added to the supply order list. Send the supply shuttle to the station to begin.","NanoTrasen Archeology Department")

		var/datum/round_event_control/rift_bus/rift_bus = locate(/datum/round_event_control/rift_bus) in events.all_events
		if(rift_bus)
			rift_bus.rift_events_exist = 1

	End()
		if(passed)
			OnPass()
		else
			OnFail()

	OnPass()
		if (!prevent_stories) EventStory("The crew managed to research the workings of the xeno artifact. Data was picked up by signal at central command.")
		priority_announce("Excellent work. Keep the artifact secure while we analyze the data and prepare the next step.","NanoTrasen Archeology Department")
		events.spawn_orphan_event(/datum/round_event/xeno_artifact_testing)

	OnFail()
		priority_announce("Looks like the artifact exploded, Crew has failed to follow basic instructions. We are not responsible for the damages, over and out.","Woops")
		if (!prevent_stories) EventStory("The crew's incompetence caused the artifact to explode")