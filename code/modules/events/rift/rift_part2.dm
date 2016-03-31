/datum/round_event/xeno_artifact_testing
	end_when = -1
	var/passed = 0
	var/ready = 0

	Setup()
		special_npc_name = "CentComm Commander [pick(last_names)]"
		start_when		= world.time + rand(600,1200)

	Start()
		ready = 1
		if (!prevent_stories) EventStory("The crew was then tasked with firing emitters at the artifact to unlock its true potential.")
		priority_announce("Signal from the artifact recieved. Activate the artifact with an array of emitter fire.","NanoTrasen Archeology Department")

		var/datum/round_event_control/rift_bus/rift_bus = locate(/datum/round_event_control/rift_bus) in events.all_events
		if(rift_bus)
			rift_bus.rift_events_exist = 1

	End()
		if(passed)
			OnPass()
		else
			OnFail()

	OnPass()
		if (!prevent_stories) EventStory("The artifact activated.. revealing a signal code for the crew.")
		priority_announce("The artifact is active. Analyze and signal the encrypted frequency.","NanoTrasen Archeology Department")
		events.spawn_orphan_event(/datum/round_event/the_rift)

	OnFail()
		priority_announce("Looks like the artifact exploded, Crew has failed to follow basic instructions. We are not responsible for the damages, over and out.","Woops")
		if (!prevent_stories) EventStory("The crew's incompetence caused the artifact to explode")