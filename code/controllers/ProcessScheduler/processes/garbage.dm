/datum/controller/process/garbage/setup()
	name = "garbage"
	schedule_interval = 20

	if(!garbage)
		garbage = new

/datum/controller/process/garbage/doWork()
	garbage.dels = 0
	var/time_to_kill = world.time - GC_COLLECTION_TIMEOUT // Anything qdel() but not GC'd BEFORE this time needs to be manually del()
	var/checkRemain = GC_DEL_CHECK_PER_TICK
	while(garbage.destroyed.len && --checkRemain >= 0)
		if(garbage.dels > GC_FORCE_DEL_PER_TICK)
//			testing("GC: Reached max force dels per tick [dels] vs [GC_FORCE_DEL_PER_TICK]")
			break // Server's already pretty pounded, everything else can wait 2 seconds
		var/refID = garbage.destroyed[1]
		var/GCd_at_time = garbage.destroyed[refID]
		if(GCd_at_time > time_to_kill)
//			testing("GC: [refID] not old enough, breaking at [world.time] for [GCd_at_time - time_to_kill] deciseconds until [GCd_at_time + GC_COLLECTION_TIMEOUT]")
			break // Everything else is newer, skip them
		var/atom/A = locate(refID)
//		testing("GC: [refID] old enough to test: GCd_at_time: [GCd_at_time] time_to_kill: [time_to_kill] current: [world.time]")
		if(A && A.gc_destroyed == GCd_at_time) // So if something else coincidently gets the same ref, it's not deleted by mistake
			// Something's still referring to the qdel'd object.  Kill it.
			testing("GC: -- \ref[A] | [A.type] was unable to be GC'd and was deleted --")
			del(A)
			garbage.dels++
//		else
//			testing("GC: [refID] properly GC'd at [world.time] with timeout [GCd_at_time]")
		garbage.destroyed.Cut(1, 2)
		scheck()
