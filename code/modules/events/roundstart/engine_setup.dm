/datum/round_event/engine_setup
	special_npc_name = "Central Command"
	end_when = -1
	var/area/SMES_area
	var/failed = 0

	Setup()
		SMES_area = locate(/area/engine/engine_smes)
		if(!SMES_area)
			CancelSelf()

	Tick()
		if(IsMultiple(active_for,5))
			var/smes_count = 0
			var/charging_count = 0
			var/total_charge = 0
			var/initial_charge = 0
			for(var/obj/machinery/power/smes/S in area_contents(SMES_area))
				smes_count++
				if(S.charge > 1)
					total_charge += S.charge
					initial_charge += initial(S.charge)
					if(S.inputting)
						charging_count++
			if(total_charge <= initial_charge / 4.5)
				failed = 1
				AbruptEnd()
				return
			if(smes_count && charging_count >= smes_count)
				AbruptEnd()
				return

	End()
		if(failed)
			OnFail()
		else
			OnPass()

	OnPass()
		if (branching_allowed)
			var/datum/event_cycler/E = new /datum/event_cycler/(rand(9000,18000), "Central Command")
			E.events_allowed = EVENT_REWARD
			E.lifetime = 1

	OnFail()
		priority_announce("The Singularity Engine is not fully set up. As a result, the station may experience a blackout soon if the issue is not resolved. Usage of the P.A.C.M.A.N. Generator is highly recommended at this point of setup.", "Imminent Blackout Warning")
		if (branching_allowed)
			var/datum/event_cycler/E = new /datum/event_cycler/(rand(9000,18000), "Central Command")
			E.events_allowed = EVENT_CONSEQUENCE
			E.lifetime = 1




