// AI EYE
//
// An invisible (no icon) mob that the AI controls to look around the station with.
// It streams chunks as it moves around, which will show it what the AI can and cannot see.

/mob/camera/aiEye
	name = "Inactive AI Eye"

	var/list/visibleCameraChunks = list()
	var/mob/living/silicon/ai/ai = null


// Use this when setting the aiEye's location.
// It will also stream the chunk that the new loc is in.

/mob/camera/aiEye/proc/setLoc(var/T)

	if(ai)
		if(!isturf(ai.loc))
			return
		T = get_turf(T)
		loc = T
		cameranet.visibility(src)
		if(ai.client)
			ai.client.eye = src
		//Holopad
		if(istype(ai.current, /obj/machinery/hologram/holopad))
			var/obj/machinery/hologram/holopad/H = ai.current
			H.move_hologram()

/mob/camera/aiEye/Move()
	return 0


// AI MOVEMENT

// The AI's "eye". Described on the top of the page.

/mob/living/silicon/ai
	var/mob/camera/aiEye/eyeobj = new()
	var/sprint = 10
	var/cooldown = 0


// Intiliaze the eye by assigning it's "ai" variable to us. Then set it's loc to us.
/mob/living/silicon/ai/New()
	..()
	eyeobj.ai = src
	eyeobj.name = "[src.name] (AI Eye)" // Give it a name
	spawn(5)
		eyeobj.loc = src.loc

/mob/living/silicon/ai/Destroy()
	eyeobj.ai = null
	qdel(eyeobj) // No AI, no Eye
	..()

/atom/proc/move_camera_by_click()
	if(istype(usr, /mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = usr
		if(AI.eyeobj && AI.client.eye == AI.eyeobj)
			AI.cameraFollow = null
			AI.eyeobj.setLoc(src)

// This will move the AIEye. It will also cause lights near the eye to light up, if toggled.
// This is handled in the proc below this one.

/client/proc/AIMove(n, direct, var/mob/living/silicon/ai/user)

	var/turf/step = get_turf(get_step(user.eyeobj, direct))
	if(step)
		user.eyeobj.setLoc(step)

	user.cameraFollow = null

	//user.unset_machine() //Uncomment this if it causes problems.
	//user.lightNearbyCamera()


// Return to the Core.

/mob/living/silicon/ai/verb/core()
	set category = "AI Commands"
	set name = "AI Core"

	view_core()


/mob/living/silicon/ai/proc/view_core()

	current = null
	cameraFollow = null
	unset_machine()

	if(src.eyeobj && src.loc)
		src.eyeobj.loc = src.loc
	else
		src << "ERROR: Eyeobj not found. Creating new eye..."
		src.eyeobj = new(src.loc)
		src.eyeobj.ai = src
		src.eyeobj.name = "[src.name] (AI Eye)" // Give it a name

	if(client && client.eye)
		client.eye = src
	for(var/datum/camerachunk/c in eyeobj.visibleCameraChunks)
		c.remove(eyeobj)