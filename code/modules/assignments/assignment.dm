/datum/assignment
	var/name = "assignment"
	var/list/assigned_to = list()
	var/assigned_by = "Centcomm" //format is "name (rank)"
	var/details = "None"
	var/tier_needed = 1
	var/passive = 0 //does not tick if non-zero
	var/hidden = 0 //does not display in tablets if non-zero
	var/centcomm = 1 //non-zero for admin/centcom assigned tasks
	var/canceled = 0 //canceled
	var/success = 0 //passed
	var/failed = 0 //failed
	var/complete = 0 //completed, failed or not
	var/repeat = 0 // 0, no repeat. 1, can be repeated if canceled but can only be completed once, 2 can be repeated at any time
	var/list/dept = list() //required departments
	var/list/heads = list() //required heads
	var/list/todo = list()

	var/activeFor = 0


	proc/pre_setup()
		return 1

	proc/setup()
		//if this does not return 1 the assignment is voided
		return 1

	proc/start()
		//starts the event.
		return 1

	proc/tick()
		// Runs every tick
		// Keep this as not expensive as possible
		activeFor++
		return 1

	proc/check_complete()
		//ran at the end of the round or during tick() depending
		complete()
		return 1

	proc/fail()
		assignments.complete.Add(src)
		assignments.active.Remove(src)
		assignments.update_assignments()
		name = "FAILED: [initial(name)]"
		failed = 1
		return 1

	proc/complete()
		success = 1
		complete = 1
		assignments.complete.Add(src)
		assignments.active.Remove(src)
		assignments.update_assignments()
		name = "SUCCESSFUL: [initial(name)]"
		if(!hidden && assigned_by && !centcomm && emergency_shuttle.location != 2)
			for(var/obj/item/device/tablet/T in tablets_list)
				var/auth = "[T.owner] ([T.ownjob])"
				if(auth == assigned_by)
					T.alert_self("Assignment Complete!","[src.name]","assignments")
		return 1

	//proc optimized by raptorblaze
	proc/can_view(var/obj/item/device/tablet/T)
		if(hidden)
			return 0
		if(T.ownjob == "Captain")
			return 1
		if(T.ownjob in heads)
			return 1
		var/viewing = "[T.owner] ([T.ownjob])"
		if(viewing in assigned_to)
			return 1
		if(assigned_by == viewing && assigned_by != "Centcomm")
			return 1

	proc/tier_up()
		if(tier_needed < 0)
			return
		assignments.tier = assignments.tier + 1
		assignments.tier = Clamp(assignments.tier,0,tier_needed+1)

	Topic(href, href_list)
		//handled from assignment app in tablet
		var/datum/program/assignments/A = locate(href_list["app"])
		if(!A)
			return
		if(!A.tablet)
			return
		if(!A.tablet.core)
			return
		if(!A.tablet.can_use(usr))
			return
		switch(href_list["choice"])
			if("name")
				var/t = copytext(sanitize(input("Name", "Name", null, null)  as text),1,MAX_MESSAGE_LEN)
				name = t
			if("details")
				var/t = copytext(sanitize(input("Details", "Details", null, null)  as text),1,MAX_MESSAGE_LEN)
				details = t
			if("step")
				var/t = copytext(sanitize(input("Step", "Step", null, null)  as text),1,MAX_MESSAGE_LEN)
				todo.Add(t)
			if("cancel")
				if(canceled || success || failed || complete)
					A.use_app()
					A.tablet.attack_self(usr)
					return
				A.temp = "Assignment canceled"
				A.use_app()
				A.tablet.attack_self(usr)
				if(repeat || istype(src,/datum/assignment/passive/custom))
					assignments.passive.Remove(src)
					assignments.active.Remove(src)
					assignments.complete.Remove(src)
					assignments.update_assignments()
					qdel(src)
					return
				else
					assignments.passive.Remove(src)
					assignments.active.Remove(src)
					assignments.complete.Add(src)
					assignments.update_assignments()
					name = "CANCELED: [initial(name)]"
					canceled = 1
					return
			if("users")
				var/list/D = list()
				D["Cancel"] = "Cancel"
				for(var/obj/item/device/tablet/T in A.gather_assignees(src))
					if(!T.core) continue
					if(!T.network()) continue
					if(!("[T.owner] ([T.ownjob])" in assigned_to))
						D["[T.owner] ([T.ownjob])"] = T
				var/t = input(usr, "Add who?") as null|anything in D
				if(t && t != "Cancel")
					var/obj/item/device/tablet/chosen = D[t]
					var/chosen_text = "[chosen.owner] ([chosen.ownjob])"
					if(!(chosen_text in assigned_to))
						assigned_to.Add(chosen_text)
			if("report_complete")
				assignments.complete.Add(src)
				src.complete()
				assignments.passive.Remove(src)
				assignments.update_assignments()
		A.use_app()
		A.tablet.attack_self(usr)
