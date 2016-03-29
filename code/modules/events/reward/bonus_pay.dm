/datum/round_event_control/bonus_pay
	name = "Bonus Pay"
	typepath = /datum/round_event/bonus_pay
	event_flags = EVENT_REWARD
	max_occurrences = -1
	weight = 20
	accuracy = 100
/datum/round_event/bonus_pay
	Start()
		for(var/obj/item/device/tablet/T in tablets_list)
			if(T.network() && T.core && T.can_eject)
				var/payment = rand(0,5000)
				var/first_name = copytext(T.owner, 1, findtext(T.owner, " ", 1, 0)) //gets the first name
				T.alert_self("Payment Received from \<CentComm\>", "Wow [first_name]! great moves, keep it up, proud of you <font color = 'green'><b>\[+$[payment]\]</b></font>", "wallet")
				T.core.cash += payment