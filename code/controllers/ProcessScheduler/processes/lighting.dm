/datum/controller/process/lighting/setup()
	name = "lighting"
	schedule_interval = 5 // every .5 second
	lighting_controller.Initialize()

/datum/controller/process/lighting/doWork()
	lighting_controller.lights_workload_max = \
		max(lighting_controller.lights_workload_max, lighting_controller.lights.len)
	var/i1 = 1
	while(i1<=lighting_controller.lights.len)
		var/datum/light_source/L = lighting_controller.lights[i1]
		if(L && L.check())
			lighting_controller.lights.Remove(L)

		scheck()
		i1++

	lighting_controller.changed_turfs_workload_max = \
		max(lighting_controller.changed_turfs_workload_max, lighting_controller.changed_turfs.len)
	var/i2 = 1
	while(i2<=lighting_controller.changed_turfs.len)
		var/turf/T = lighting_controller.changed_turfs[i2]
		if(T && T.lighting_changed)
			T.shift_to_subarea()

		scheck()
		i2++

	if(lighting_controller.changed_turfs && lighting_controller.changed_turfs.len)
		lighting_controller.changed_turfs.Cut() // reset the changed list