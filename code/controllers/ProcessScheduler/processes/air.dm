var/global/air_processing_killed = 0

/datum/controller/process/air/setup()
	name = "air"
	schedule_interval = 20

	if(!air_master)
		air_master = new

	air_master.setup()

/datum/controller/process/air/doWork()
	if(air_processing_killed) return
	process_air(air_master)

/datum/controller/process/air/proc/process_air(var/datum/controller/air_system/controller)
	controller.current_cycle++
	var/timer = world.timeofday
	process_active_turfs(controller)
	controller.air_turfs = (world.timeofday - timer) / 10

	timer = world.timeofday
	process_excited_groups(controller)
	controller.air_groups = (world.timeofday - timer) / 10

	timer = world.timeofday
	process_high_pressure_delta(controller)
	controller.air_highpressure = (world.timeofday - timer) / 10

	timer = world.timeofday
	process_hotspots(controller)
	controller.air_hotspots = (world.timeofday - timer) / 10

	timer = world.timeofday
	process_super_conductivity(controller)
	controller.air_superconductivity = (world.timeofday - timer) / 10

/datum/controller/process/air/proc/process_hotspots(var/datum/controller/air_system/controller)
	var/i=1
	while(i<=controller.hotspots.len)
		var/obj/effect/hotspot/H = controller.hotspots[i]
		if(H && hascall(H,"process"))
			setLastTask("process()", "hotspots")
			H.process()
			scheck()
			i++
			continue
		controller.hotspots.Cut(i,i+1)

/datum/controller/process/air/proc/process_super_conductivity(var/datum/controller/air_system/controller)
	var/i = 1
	while(i<=controller.active_super_conductivity.len)
		var/turf/simulated/T = controller.active_super_conductivity[i]
		if(T && hascall(T,"super_conduct"))
			setLastTask("process()", "super_conduct")
			T.super_conduct()
			scheck()
			i++
			continue
		controller.active_super_conductivity.Cut(i,i+1)

/datum/controller/process/air/proc/process_high_pressure_delta(var/datum/controller/air_system/controller)
	var/i = 1
	while(i<=controller.high_pressure_delta.len)
		var/turf/T = controller.high_pressure_delta[i]
		if(T && hascall(T,"high_pressure_movements"))
			setLastTask("process()", "high_pressure_movements")
			T.high_pressure_movements()
			scheck()
			T.pressure_difference = 0
			i++
			continue
		controller.high_pressure_delta.Cut(i,i+1)
	controller.high_pressure_delta.len = 0

/datum/controller/process/air/proc/process_active_turfs(var/datum/controller/air_system/controller)
	var/i = 1
	while(i<=controller.active_turfs.len)
		var/turf/simulated/T = controller.active_turfs[i]
		if(T && hascall(T,"process_cell"))
			setLastTask("process()", "active_turfs")
			T.process_cell()
			scheck()
			i++
			continue
		controller.active_turfs.Cut(i,i+1)

/datum/controller/process/air/proc/process_excited_groups(var/datum/controller/air_system/controller)
	var/i = 1
	while(i<=controller.excited_groups.len)
		var/datum/excited_group/EG = controller.excited_groups[i]
		if(EG)
			EG.breakdown_cooldown ++
			if(EG.breakdown_cooldown == 10)
				setLastTask("process()", "excited_groups")
				EG.self_breakdown()
				scheck()
				return
			setLastTask("process()", "excited_groups")
			if(EG.breakdown_cooldown > 20)
				EG.dismantle()
			scheck()
			i++
			continue
		controller.excited_groups.Cut(i,i+1)