#define SOUND_CHANNEL_ADMIN 777
var/sound/admin_sound

/client/proc/play_sound()
	set category = "Fun"
	set name = "Play Global Sound"

    //if(Debug2)
	if(!src.holder)
		src << "Only administrators may use this command."
		return

	var/sound/S = 0 //I don't like using null.
    //Selecting a pre-uploaded sound, or a new one.
	var/response = input("Select the sound you wish to play:","Play Global Sound") as null|anything in (flist("data/sound/") + "Upload New Sound" + "Delete Sound")
	if(!response)
		return 0
	if(response == "Upload New Sound")
		S = input("Select a sound to upload","Upload Sound") as sound|null
		if(S)
			var/name = input("Select a name for this sound (Include the extension)","Name","Sound [length(flist("data/sound/"))]") as text
			if(!name)	return
			if(!copytext(name, findtext(name, ".")) in list(".mid", ".midi", ".mod", ".it", ".s3m", ".xm", ".oxm", ".wav", ".ogg", ".raw", ".wma", ".aiff"))
				alert("You have to enter a valid extension.", "Error")
				return
			fcopy(S, "data/sound/[name]")
		return 0
	else if(response == "Delete Sound")
		var/todel = input("Select a sound to delete","Delete Sound") as null|anything in flist("data/sound/")
		fdel("data/sound/[todel]")
		return 0
	else
		S = file("data/sound/[response]")

	var/volume = input("How loud do you want the file to be? Number between 1-100", "Volume") as num
	volume = max(min(round(volume), 100), 1)

	var/sound/uploaded_sound = sound(S,0,1,0, volume)
	uploaded_sound.channel = 777
	uploaded_sound.priority = 254
	uploaded_sound.wait = 1

	log_admin("[key_name(src)] played sound [S] with volume: [volume]")
	message_admins("[key_name_admin(src)] played sound [S] with volume: [volume]", 1)
	for(var/mob/M in world)
		if(M.client)
			if(M.client.prefs.toggles & SOUND_MIDI)
				M << uploaded_sound



/client/proc/play_local_sound(S as sound)
	set category = "Fun"
	set name = "Play Local Sound"
	if(!check_rights(R_SOUNDS))	return

	log_admin("[key_name(src)] played a local sound [S]")
	message_admins("[key_name_admin(src)] played a local sound [S]", 1)
	playsound(get_turf(src.mob), S, 50, 0, 0)
	feedback_add_details("admin_verb","PLS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/stop_sounds()
	set category = "Debug"
	set name = "Stop Sounds"
	if((check_rights(R_SOUNDS)) || (check_rights(R_DEBUG)))

		log_admin("[key_name(src)] stopped all currently playing sounds.")
		message_admins("[key_name_admin(src)] stopped all currently playing sounds.")
		for(var/mob/M in player_list)
			if(M.client)
				M << sound(null)
		feedback_add_details("admin_verb","SS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	else
		return
#undef SOUND_CHANNEL_ADMIN