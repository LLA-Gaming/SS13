/datum/assignment/passive/passive = 1

/datum/assignment/passive/nuke_disk
	tier_needed = -1
	name = "Secure the Nuclear Authentication Disk"
	details = "Centcomm recently recieved a report of a plot to destroy one of our stations in your area. We believe the Nuclear Authentication Disc that is standard issue aboard your vessel may be a target. We recommend removal of this object, and it's storage in a safe environment. As this may cause panic among the crew, all efforts should be made to keep this information a secret from all but the most trusted crew-members."
	heads = list("Captain")

	setup()
		todo.Add("Secure the Nuclear Authentication Disk")
		todo.Add("Return the disk to Central Command at the end of the shift")
		return 1

	check_complete()
		if(emergency_shuttle && emergency_shuttle.location == 2) //only pass/fail if the shuttle is at centcom
			var/disk_rescued = 1
			for(var/obj/item/weapon/disk/nuclear/D in world)
				var/disk_area = get_area(D)
				if(!is_type_in_list(disk_area, centcom_areas))
					disk_rescued = 0
					break
			if(disk_rescued)
				complete()
			else
				fail()

/datum/assignment/passive/custom/
	centcomm = 0
	tier_needed = -1
	name = null
	details = null