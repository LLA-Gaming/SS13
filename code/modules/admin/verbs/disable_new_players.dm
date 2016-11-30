/client/proc/disable_new_players()
	set category = "Server"
	set name = "Toggle Disable New Players"
	if (!config.sql_enabled)
		usr << "<span class='adminnotice'>The Database is not enabled!</span>"
		return

	config.new_players_allowed = (!config.new_players_allowed)

	log_admin("[key_name(usr)] has toggled Disable New Players, it is now [(config.new_players_allowed?"off":"on")]")
	message_admins("[key_name_admin(usr)] has toggled Disable New Players, it is now [(config.new_players_allowed?"off":"on")].")
	if (config.new_players_allowed && (!dbcon || !dbcon.IsConnected()))
		message_admins("The Database is not connected! Disable New Players will not work.")
	feedback_add_details("admin_verb","PANIC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

