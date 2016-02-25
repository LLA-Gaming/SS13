/datum/controller/process/lighting/setup()
	name = "lighting"
	schedule_interval = 5 // every .5 second
	lighting_controller.Initialize()

/datum/controller/process/lighting/doWork()
	lighting_controller.lights_workload_max = \
		max(lighting_controller.lights_workload_max, lighting_controller.lights.len)
	var/i = 1
	while(i<=lighting_controller.lights.len)
		var/datum/light_source/L = lighting_controller.lights[i]
		if(L)
			if(L.check())
				lighting_controller.lights.Remove(L)

			scheck()
			i++
			continue
		lighting_controller.lights.changed_turfs.Cut(i,i+1)

	lighting_controller.changed_turfs_workload_max = \
		max(lighting_controller.changed_turfs_workload_max, lighting_controller.changed_turfs.len)
	i = 1
	while(i<=lighting_controller.changed_turfs.len)
		var/turf/T = lighting_controller.changed_turfs[i]
		if(T)
			if(T.lighting_changed)
				T.shift_to_subarea()

			scheck()
			i++
			continue
		lighting_controller.changed_turfs.Cut(i,i+1)

	if(lighting_controller.changed_turfs && lighting_controller.changed_turfs.len)
		lighting_controller.changed_turfs.Cut() // reset the changed list