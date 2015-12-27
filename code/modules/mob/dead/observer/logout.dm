/mob/dead/observer/Logout()
	if (client)
		client.images -= ghost_darkness_images
	following = null
	loc = get_turf(src)
	..()
	spawn(0)
		if(src && !key)	//we've transferred to another mob. This ghost should be deleted.
			qdel(src)
