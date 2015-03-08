/client/proc/cmd_admin_say(msg as text)
	set category = "Special Verbs"
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = 1
	if(!check_rights(0))	return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)	return

	log_admin("[key_name(src)] : [msg]")

	var/msg_to_send = ""

	if(check_rights(R_TRIALADMIN,0))
		msg_to_send = "<span class='admin'><span class='prefix'>ADMIN:</span> <EM>[key_name(usr, 1)]</EM> (<a href='?_src_=holder;adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>"
	else
		msg_to_send = "<span class='adminobserver'><span class='prefix'>ADMIN:</span> <EM>[key_name(usr, 1)]:</EM> <span class='message'>[msg]</span></span>"

	for(var/client/admin in admins)
		admin << msg_to_send
		admin.send_text_to_tab(msg_to_send, "asay")

	feedback_add_details("admin_verb","M") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

