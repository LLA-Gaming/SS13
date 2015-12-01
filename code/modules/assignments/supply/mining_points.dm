/datum/assignment/mining_points
	name = "Gathering Minerals"
	details = "Mine until you reach the goal of 500 points"
	dept = list("Supply")
	heads = list("Head of Personnel","Quartermaster")
	var/goal = 500

	pre_setup()
		todo.Add("Gather various minerals from the asteroid")
		todo.Add("Smelt the minerals until you have achieved [goal] mining points")

	setup()
		if(!ticker)
			return
		goal = goal + ticker.mining_points
		return 1

	tick()
		..()
		if(IsMultiple(activeFor,10))
			check_complete()

	check_complete()
		if(!ticker)
			fail()
			return
		if(ticker.mining_points >= goal)
			complete()
			return
		return