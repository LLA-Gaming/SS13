#define GC_COLLECTION_TIMEOUT 300 // deciseconds to wait to let running procs finish before we just say fuck it and force del() the object
#define GC_DEL_CHECK_PER_TICK 100 // number of tests per master controller tick to make sure our GC'd objects are actually GC'd
#define GC_FORCE_DEL_PER_TICK 20  // max force del() calls per master controller tick

var/datum/controller/garbage_collector/garbage = new()


/datum/controller/garbage_collector
	var/dels = 0				// number of del()'s we've done this tick
	var/list/destroyed = list() // list of refID's of things that should be garbage collected
								// refID's are associated with the time at which they time out and need to be manually del()
								// we do this so we aren't constantly locating them and preventing them from being gc'd

/datum/controller/garbage_collector/proc/AddTrash(var/datum/A)
	if(!istype(A) || !isnull(A.gc_destroyed))
		return
//	testing("GC: AddTrash([A.type])")
	A.gc_destroyed = world.time
	destroyed -= "\ref[A]" // Removing any previous references that were GC'd so that the current object will be at the end of the list.
	destroyed["\ref[A]"] = world.time

// Should be treated as a replacement for the 'del' keyword.
// Datums passed to this will be given a chance to clean up references to allow the GC to collect them.
/proc/qdel(var/datum/A)
	if(!A)
		return
	if(!istype(A))
		//warning("qdel() passed object of type [A.type]. qdel() can only handle /datum types.")
		del(A)
		if(garbage)
			garbage.dels++
	else if(isnull(A.gc_destroyed))
		// Let our friend know they're about to get fucked up.
		. = !A.Destroy()
		if(. && A)
			if(garbage && !isturf(A))
				garbage.AddTrash(A)
			else
				del(A)

// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return true if the the GC controller should allow the object to continue existing. (Useful if pooling objects.)
/datum/proc/Destroy()
	del(src)

/datum/var/gc_destroyed //Time when this object was destroyed.

#ifdef TESTING
/client/var/running_find_references

/atom/verb/find_references()
	set category = "Debug"
	set name = "Find References"
	set background = 1
	set src in world

	if(!usr || !usr.client)
		return

	if(usr.client.running_find_references)
		testing("CANCELLED search for references to a [usr.client.running_find_references].")
		usr.client.running_find_references = null
		return

	if(alert("Running this will create a lot of lag until it finishes.  You can cancel it by running it again.  Would you like to begin the search?", "Find References", "Yes", "No") == "No")
		return

	// Remove this object from the list of things to be auto-deleted.
	if(garbage)
		garbage.destroyed -= "\ref[src]"

	usr.client.running_find_references = type
	testing("Beginning search for references to a [type].")
	var/list/things = list()
	for(var/client/thing)
		things += thing
	for(var/datum/thing)
		things += thing
	for(var/atom/thing)
		things += thing
	testing("Collected list of things in search for references to a [type]. ([things.len] Thing\s)")
	for(var/datum/thing in things)
		if(!usr.client.running_find_references) return
		for(var/varname in thing.vars)
			var/variable = thing.vars[varname]
			if(variable == src)
				testing("Found [src.type] \ref[src] in [thing.type]'s [varname] var.")
			else if(islist(variable))
				if(src in variable)
					testing("Found [src.type] \ref[src] in [thing.type]'s [varname] list var.")
	testing("Completed search for references to a [type].")
	usr.client.running_find_references = null

/client/verb/purge_all_destroyed_objects()
	set category = "Debug"
	if(garbage)
		while(garbage.destroyed.len)
			var/datum/o = locate(garbage.destroyed[1])
			if(istype(o) && o.gc_destroyed)
				del(o)
				garbage.dels++
			garbage.destroyed.Cut(1, 2)
#endif
