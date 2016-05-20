/datum/round_event_control/minor_meteorwave
	name = "Minor Meteor Wave"
	typepath = /datum/round_event/minor_meteorwave/
	event_flags = EVENT_CONSEQUENCE
	max_occurrences = -1
	weight = 15
	accuracy = 100

/datum/round_event/minor_meteorwave/
	end_when = -1 //ends on its own schedule
	var/meteors = 5

	Start()
		meteors = rand(1,5)

	Tick()
		if(prob(50))
			spawn_meteors(5, meteorsA)
			meteors -= 1
		if(meteors <= 0)
			spawn(100)
				send_alerts("The station was hit with a couple meteors. Recommend station engineers repair any breaches")
			AbruptEnd()