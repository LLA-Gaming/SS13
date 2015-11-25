datum/assignment/passive/sample_item/
	name = "Item Sampling"
	details = "Produce and send a specific item to centcom"
	var/obj/item/target = null

	pre_setup()
		if(target)
			name = ""
			details = ""
			todo.Add("Produce a [target]")
			todo.Add("Deliver [target] to Centcomm via the cargo shuttle")

//
datum/assignment/passive/sample_item/med/pre_setup()
	if(..())
		return 1

datum/assignment/passive/sample_item/bar/pre_setup()
	if(..())
		return 1

datum/assignment/passive/sample_item/kitchen/pre_setup()
	if(..())
		return 1

datum/assignment/passive/sample_item/botany/pre_setup()
	if(..())
		return 1