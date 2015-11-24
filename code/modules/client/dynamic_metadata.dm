/*
* # WIP: Interface only
*/

/proc

	LoadMetadata(var/ckey, var/id)
		return 0

	// Will override previous entries
	SaveMetadata(var/ckey, var/id, var/value)
		return 0

	ModifyMetadata(var/ckey, var/id, var/change = 1)
		return 0

	// Wrapper for ModifyMetadata
	IncrementMetadata(var/ckey, var/id, var/increment = 1)
		return ModifyMetadata(id, abs(increment))

	// Wrapper for ModifyMetadata
	DecrementMetadata(var/ckey, var/id, var/decrement = 1)
		return ModifyMetadata(id, -abs(decrement))
