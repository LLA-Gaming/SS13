var/datum/controller/lighting/lighting_controller = new ()

/datum/controller/lighting
	var/processing = 0

	var/processing_interval = 5	//setting this too low will probably kill the server. Don't be silly with it!
	var/process_cost = 0
	var/iteration = 0
	var/max_cpu_use = 98		//this is just to prevent it queueing up when the server is dying. Not a solution, just damage control while I rethink a lot of this and try out ideas.

	var/lighting_states = 6

	var/list/lights = list()
	var/lights_workload_max = 0

//	var/list/changed_lights()		//TODO: possibly implement this to reduce on overheads? Also, Look into static-lights idea.

	var/list/changed_turfs = list()
	var/changed_turfs_workload_max = 0

	New()
		..()

		lighting_controller = src
		create_lighting_overlays()

/datum/controller/lighting/proc/process()
	processing = 1
	spawn(0)
		set background = BACKGROUND_ENABLED
		while(1)
			if(processing && (world.cpu <= max_cpu_use))
				iteration++
				var/started = world.timeofday
				var/list/lighting_update_lights_old = lighting_update_lights //We use a different list so any additions to the update lists during a delay from scheck() don't cause things to be cut from the list without being updated.

				lighting_update_lights = null //Nulling it first because of http://www.byond.com/forum/?post=1854520
				lighting_update_lights = list()

				for(var/datum/light_source/L in lighting_update_lights_old)
					if(L.destroyed || L.check() || L.force_update)
						L.remove_lum()
						if(!L.destroyed)
							L.apply_lum()

						else if(L.vis_update)	//We smartly update only tiles that became (in) visible to use.
							L.smart_vis_update()

					L.vis_update = 0
					L.force_update = 0
					L.needs_update = 0

				var/list/lighting_update_overlays_old = lighting_update_overlays //Same as above.
				lighting_update_overlays = null //Same as above
				lighting_update_overlays = list()

				for(var/atom/movable/lighting_overlay/O in lighting_update_overlays_old)
					O.update_overlay()
					O.needs_update = 0

				process_cost = (world.timeofday - started)

			sleep(processing_interval)