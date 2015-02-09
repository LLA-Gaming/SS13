/*
* Leave VR verb
*/

/mob/proc/LeaveVRVerb()
	set name = "Leave Virtual Reality"
	set category = "Virtual Reality"

	var/obj/item/clothing/glasses/virtual/V = vr_controller.GetGogglesFromClient(client)
	if(V)
		V.LeaveVR()
	else
		message_admins("\red VR: [key_name(src, 1)] broke the 'Leave Virtual Reality' verb.")
		log_game("VR: [key_name(src)] broke the 'Leave Virtual Reality' verb.")


/*
* VR Headset
*/

/obj/item/device/radio/headset/virtual
	name = "virtual headset"

	prison_radio = 1