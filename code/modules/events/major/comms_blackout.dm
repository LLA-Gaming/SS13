/datum/round_event_control/communications_blackout
	name = "Communications Blackout"
	typepath = /datum/round_event/communications_blackout
	event_flags = EVENT_MAJOR
	max_occurrences = 2
	weight = 5
	accuracy = 100

/datum/round_event/communications_blackout
	Alert()
		var/alert = pick(	"Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you*%fj00)`5vc-BZZT", \
							"Ionospheric anomalies detected. Temporary telecommunication failu*3mga;b4;'1v�-BZZZT", \
							"Ionospheric anomalies detected. Temporary telec#MCi46:5.;@63-BZZZZT", \
							"Ionospheric anomalies dete'fZ\\kg5_0-BZZZZZT", \
							"Ionospheri:%� MCayj^j<.3-BZZZZZZT", \
							"#4nd%;f4y6,>�%-BZZZZZZZT")

		for(var/mob/living/silicon/ai/A in player_list)	//AIs are always aware of communication blackouts.
			A << "<br>"
			A << "<span class='warning'><b>[alert]</b></span>"
			A << "<br>"

		if(prob(30))	//most of the time, we don't want an announcement, so as to allow AIs to fake blackouts.
			priority_announce(alert)


	Start()
		for(var/obj/machinery/telecomms/T in telecomms_list)
			T.emp_act(1)
		for(var/obj/machinery/nanonet_server/N in nanonet_servers)
			N.emp_act(1)