//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
var/list/admin_verbs_default = list(
	/client/proc/toggleadminhelpsound,	/*toggles whether we hear a sound when adminhelps/PMs are used*/
	/client/proc/deadmin_self,			/*destroys our own admin datum so we can play as a regular player*/
	/client/proc/cmd_admin_say,			/*admin-only ooc chat*/
	/client/proc/hide_verbs,			/*hides all our adminverbs*/
	/client/proc/hide_most_verbs,		/*hides all our hideable adminverbs*/
	/client/proc/debug_variables,		/*allows us to -see- the variables of any instance in the game. +VAREDIT needed to modify*/
	/client/proc/admin_memo,			/*admin memo system. show/delete/write. +SERVER needed to delete admin memos of others*/
	/client/proc/dsay,					/*talk in deadchat using our ckey/fakekey*/
	/client/proc/toggleprayers,			/*toggles prayers on/off*/
	/client/proc/toggle_hear_radio,		/*toggles whether we hear the radio*/
	/client/proc/investigate_show,		/*various admintools for investigation. Such as a singulo grief-log*/
	/client/proc/reload_admins,
	/client/proc/cmd_admin_pm_context,	/*right-click adminPM interface*/
	/client/proc/cmd_admin_pm_panel,		/*admin-pm list*/
	/client/proc/toggle_statpanel,
	/client/proc/toggleahelp,
	/client/proc/barewho,
	/client/proc/reloadBadges
	)

var/list/admin_verbs_trial_admin = list(
	/client/proc/admin_ghost,			/*allows us to ghost/reenter body at will*/
	/client/proc/deadchat,				/*toggles deadchat on/off*/
	/client/proc/secrets,
	/client/proc/player_panel,			/*shows an interface for all players, with links to various panels (old style)*/
	/client/proc/player_panel_new,		/*shows an interface for all players, with links to various panels*/
	/datum/admins/proc/toggleooc,		/*toggles ooc on/off for everyone*/
	/datum/admins/proc/toggleoocdead,	/*toggles ooc on/off for everyone who is dead*/
	/client/proc/check_ai_laws,			/*shows AI and borg laws*/
	/client/proc/check_antagonists,		/*shows all antags*/
	/client/proc/Jump,
	/client/proc/jumptokey,				/*allows us to jump to the location of a mob with a certain ckey*/
	/client/proc/jumptomob,				/*allows us to jump to a specific mob*/
	/client/proc/ViewAdminhelps,
	/client/proc/alt_check				/*Check for multi-keying griffons!*/
	)

var/list/admin_verbs_secondary_admin = list(
	/client/proc/cmd_admin_subtle_message,	/*send an message to somebody as a 'voice in their head'*/
	/client/proc/cmd_admin_check_contents,	/*displays the contents of an instance*/
	/client/proc/jumptocoord,			/*we ghost and jump to a coordinate*/
	/client/proc/jumptoturf,			/*allows us to jump to a specific turf*/
	/client/proc/cmd_admin_direct_narrate,	/*send text directly to a player with no padding. Useful for narratives and fluff-text*/
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/cmd_admin_gib_self,
	/datum/admins/proc/view_txt_log,	/*shows the server log (diary) for today*/
	/datum/admins/proc/view_atk_log,	/*shows the server combat-log, doesn't do anything presently*/
	/client/proc/delete_fire,
	/client/proc/reset_atmos,
	/datum/admins/proc/unprison,
	/client/proc/cmd_mentor_say,
	/client/proc/view_pod_logs
	//+BANS
	)

var/list/admin_verbs_admin = list(
	/client/proc/stealth,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/client/proc/game_panel,			/*game panel, allows to change game-mode etc*/
	/datum/admins/proc/access_news_network,	/*allows access of newscasters*/
	/client/proc/Getmob,				/*teleports a mob to our location*/
	/client/proc/Getkey,				/*teleports a mob with a certain ckey to our location*/
	/client/proc/invisimin,				/*allows our mob to go invisible/visible*/
	/datum/admins/proc/toggleenter,		/*toggles whether people can join the current game*/
	/datum/admins/proc/toggleguests,	/*toggles whether guests can join the current game*/
	/datum/admins/proc/show_player_panel,	/*shows an interface for individual players, with various links (links require additional flags*/
	/datum/admins/proc/announce,		/*priority announce something to all clients.*/
	/client/proc/createPerseusMission,
	/proc/Ban_Offline_Player,
	/client/proc/fill_breach,
	/client/proc/reenable_gravity_gen,
	/client/proc/spawncostume,
	/client/proc/stickybanpanel
	//+Sound
	)

var/list/admin_verbs_primary_admin = list(
	/client/proc/admin_call_shuttle,	/*allows us to call the emergency shuttle*/
	/client/proc/admin_cancel_shuttle,	/*allows us to cancel the emergency shuttle, sending it back to centcom*/
	/client/proc/cmd_admin_world_narrate,	/*sends text to all players with no padding*/
	/client/proc/check_words,			/*displays cult-words*/
	/client/proc/one_click_antag,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_add_random_ai_law,
	/datum/admins/proc/immreboot,
	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/toggle_view_range,		/*changes how far we can see*/
	/client/proc/set_ooc,
	/client/proc/cmd_admin_dress,
	/client/proc/respawn_character,
	/datum/admins/proc/event_panel,
	/datum/admins/proc/toggle_vr,
	/client/proc/TemplatePanel
	)

var/list/admin_verbs_senior_admin = list(
	/client/proc/object_talk,
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_debug_del_all,
	/datum/admins/proc/toggleaban,
	/client/proc/getruntimelog,			/*allows us to access runtime logs to somebody*/
	/client/proc/giveruntimelog,		/*allows us to give access to runtime logs to somebody*/
	/client/proc/getserverlog,			/*allows us to fetch server logs (diary) for other days*/
	/client/proc/drop_bomb,
	/client/proc/cinematic,
	/client/proc/send_space_ninja,
	/client/proc/make_sound,
	/client/proc/toggle_random_events,
	/datum/admins/proc/set_admin_notice, /*announcement all clients see when joining the server.*/
	/client/proc/zombie_verb
	)

var/list/admin_verbs_ban = list(
	/client/proc/unban_panel,
	/client/proc/jobbans,
	/client/proc/oocbans,
	/client/proc/unjobban_panel,
	/client/proc/DB_ban_panel
	)

var/list/admin_verbs_sounds = list(
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/stop_sounds
	)

var/list/admin_verbs_spawn = list(
	/datum/admins/proc/spawn_atom,		/*allows us to spawn instances*/
	)

var/list/admin_verbs_debug = list(
	/client/proc/toggle_log_hrefs,
	/client/proc/restart_controller,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/Debug2,
	/client/proc/kill_air,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/debug_controller,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_admin_delete,
	/client/proc/restart_controller,
	/client/proc/enable_debug_verbs,
	/client/proc/becomePAI,
	/client/proc/callproc
	)

var/list/admin_verbs_possess = list(
	/proc/possess,
	/proc/release
	)

var/list/admin_verbs_permissions = list(
	/client/proc/edit_admin_permissions
	)

//verbs which can be hidden
//please keep this up to date
var/list/admin_verbs_hideable = list(
	/client/proc/set_ooc,
	/client/proc/deadmin_self,
	/datum/admins/proc/show_traitor_panel,
	/datum/admins/proc/toggleenter,
	/datum/admins/proc/toggleguests,
	/datum/admins/proc/announce,
	/datum/admins/proc/set_admin_notice,
	/client/proc/toggle_view_range,
	/client/proc/cmd_admin_subtle_message,
	/client/proc/cmd_admin_check_contents,
	/datum/admins/proc/access_news_network,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/cmd_admin_world_narrate,
	/client/proc/check_words,
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/object_talk,
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/cinematic,
	/client/proc/send_space_ninja,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_add_random_ai_law,
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/make_sound,
	/client/proc/toggle_random_events,
	/client/proc/cmd_admin_add_random_ai_law,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/client/proc/toggle_log_hrefs,
	/datum/admins/proc/immreboot,
	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/client/proc/restart_controller,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/callproc,
	/client/proc/Debug2,
	/client/proc/reload_admins,
	/client/proc/kill_air,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/debug_controller,
	/client/proc/startSinglo,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_debug_del_all,
	/client/proc/enable_debug_verbs,
	/client/proc/jumptocoord,
	/client/proc/jumptoturf,
	/client/proc/jumptokey,
	/client/proc/jumptomob,
	/datum/admins/proc/unprison,
	/client/proc/debug_variables,
	/client/proc/cmd_admin_delete,
	/client/proc/Jump,
	/client/proc/Getmob,
	/client/proc/cmd_admin_pm_context,
	/datum/admins/proc/show_player_panel,
	/proc/possess,
	/proc/release,
	/client/proc/becomePAI,
	/client/proc/reloadBadges,
	/datum/admins/proc/spawn_atom,
	/client/proc/stop_sounds,
	/client/proc/TemplatePanel,
	/client/proc/createPerseusMission,
	/client/proc/spawncostume,
	/client/proc/zombie_verb,
	/client/proc/admin_memo,
	/datum/admins/proc/toggleooc,
	/datum/admins/proc/toggle_vr,
	/client/proc/delete_fire,
	/client/proc/reset_atmos,
	/datum/admins/proc/event_panel,
	/client/proc/fill_breach,
	/datum/admins/proc/toggleoocdead,
	/client/proc/togglebuildmodeself,
	/client/proc/reenable_gravity_gen,
	/client/proc/view_pod_logs,
	/client/proc/respawn_character
	)

/client/proc/add_admin_verbs()
	if(holder)
		control_freak = CONTROL_FREAK_SKIN | CONTROL_FREAK_MACROS

		var/rights = holder.rank.rights
		verbs += admin_verbs_default
		if(rights & R_BUILDMODE)		verbs += /client/proc/togglebuildmodeself
		if(rights & R_TRIALADMIN)		verbs += admin_verbs_trial_admin
		if(rights & R_SECONDARYADMIN)	verbs += admin_verbs_secondary_admin
		if(rights & R_ADMIN)			verbs += admin_verbs_admin
		if(rights & R_PRIMARYADMIN)		verbs += admin_verbs_primary_admin
		if(rights & R_SENIORADMIN)		verbs += admin_verbs_senior_admin
		if(rights & R_BAN)				verbs += admin_verbs_ban
		if(rights & R_DEBUG)			verbs += admin_verbs_debug
		if(rights & R_POSSESS)			verbs += admin_verbs_possess
		if(rights & R_PERMISSIONS)		verbs += admin_verbs_permissions
		if(rights & R_SOUNDS)			verbs += admin_verbs_sounds
		if(rights & R_SPAWN)			verbs += admin_verbs_spawn

		for(var/path in holder.rank.adds)
			verbs += path
		for(var/path in holder.rank.subs)
			verbs -= path

/client/proc/remove_admin_verbs()
	verbs.Remove(
		admin_verbs_default,
		/client/proc/togglebuildmodeself,
		admin_verbs_trial_admin,
		admin_verbs_secondary_admin,
		admin_verbs_admin,
		admin_verbs_primary_admin,
		admin_verbs_senior_admin,
		admin_verbs_ban,
		admin_verbs_debug,
		admin_verbs_possess,
		admin_verbs_permissions,
		/client/proc/stealth,
		admin_verbs_sounds,
		admin_verbs_spawn,
		/*Debug verbs added by "show debug verbs"*/
		/client/proc/Cell,
		/client/proc/do_not_use_these,
		/client/proc/camera_view,
		/client/proc/sec_camera_report,
		/client/proc/intercom_view,
		/client/proc/air_status,
		/client/proc/atmosscan,
		/client/proc/powerdebug,
		/client/proc/count_objects_on_z_level,
		/client/proc/count_objects_all,
		/client/proc/cmd_assume_direct_control,
		/client/proc/startSinglo,
		/client/proc/ticklag,
		/client/proc/cmd_admin_grantfullaccess,
		/client/proc/kaboom,
		/client/proc/cmd_admin_areatest,
		/client/proc/readmin
		)
	if(holder)
		verbs.Remove(holder.rank.adds)

/client/proc/hide_most_verbs()//Allows you to keep some functionality while hiding some verbs
	set name = "Adminverbs - Hide Most"
	set category = "Admin"

	verbs.Remove(/client/proc/hide_most_verbs, admin_verbs_hideable)
	verbs += /client/proc/show_verbs

	src << "<span class='interface'>Most of your adminverbs have been hidden.</span>"
	feedback_add_details("admin_verb","HMV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/hide_verbs()
	set name = "Adminverbs - Hide All"
	set category = "Admin"

	remove_admin_verbs()
	verbs += /client/proc/show_verbs

	src << "<span class='interface'>Almost all of your adminverbs have been hidden.</span>"
	feedback_add_details("admin_verb","TAVVH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/show_verbs()
	set name = "Adminverbs - Show"
	set category = "Admin"

	verbs -= /client/proc/show_verbs
	add_admin_verbs()

	src << "<span class='interface'>All of your adminverbs are now visible.</span>"
	feedback_add_details("admin_verb","TAVVS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!




/client/proc/admin_ghost()
	set category = "Admin"
	set name = "Aghost"
	if(!holder)	return
	if(istype(mob,/mob/dead/observer))
		//re-enter
		var/mob/dead/observer/ghost = mob
		ghost.can_reenter_corpse = 1			//just in-case.
		ghost.reenter_corpse()
		feedback_add_details("admin_verb","P") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else if(istype(mob,/mob/new_player))
		src << "<font color='red'>Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first.</font>"
	else
		//ghostize
		var/mob/body = mob
		body.ghostize(1)
		if(body && !body.key)
			body.key = "@[key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus
		feedback_add_details("admin_verb","O") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/invisimin()
	set name = "Invisimin"
	set category = "Admin"
	set desc = "Toggles ghost-like invisibility (Don't abuse this)"
	if(holder && mob)
		if(mob.invisibility == INVISIBILITY_OBSERVER)
			mob.invisibility = initial(mob.invisibility)
			mob << "\red <b>Invisimin off. Invisibility reset.</b>"
		else
			mob.invisibility = INVISIBILITY_OBSERVER
			mob << "\blue <b>Invisimin on. You are now as invisible as a ghost.</b>"


/client/proc/player_panel()
	set name = "Player Panel"
	set category = "Admin"
	if(holder)
		holder.player_panel_old()
	feedback_add_details("admin_verb","PP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/player_panel_new()
	set name = "Player Panel New"
	set category = "Admin"
	if(holder)
		holder.player_panel_new()
	feedback_add_details("admin_verb","PPN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/check_antagonists()
	set name = "Check Antagonists"
	set category = "Admin"
	if(holder)
		holder.check_antagonists()
		log_admin("[key_name(usr)] checked antagonists.")	//for tsar~
	feedback_add_details("admin_verb","CHA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/jobbans()
	set name = "Display Job bans"
	set category = "Admin"
	if(holder)
		if(config.ban_legacy_system)
			holder.Jobbans()
		else
			holder.DB_ban_panel()
	feedback_add_details("admin_verb","VJB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/oocbans()
	set name = "Display OOC bans"
	set category = "Admin"
	if(holder)
		holder.OOCbans()
	feedback_add_details("admin_verb","VJB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/unban_panel()
	set name = "Unban Panel"
	set category = "Admin"
	if(holder)
		if(config.ban_legacy_system)
			holder.unbanpanel()
		else
			holder.DB_ban_panel()
	feedback_add_details("admin_verb","UBP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Admin"
	if(holder)
		holder.Game()
	feedback_add_details("admin_verb","GP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/secrets()
	set name = "Secrets"
	set category = "Admin"
	if (holder)
		holder.Secrets()
	feedback_add_details("admin_verb","S") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/stealth()
	set category = "Admin"
	set name = "Stealth Mode"
	if(holder)
		if(holder.fakekey)
			holder.fakekey = null
		else
			var/new_key = ckeyEx(input("Enter your desired display name.", "Fake Key", key) as text|null)
			if(!new_key)	return
			if(length(new_key) >= 26)
				new_key = copytext(new_key, 1, 26)
			holder.fakekey = new_key
		log_admin("[key_name(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]")
		message_admins("[key_name_admin(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]", 1)
	feedback_add_details("admin_verb","SM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

#define MAX_WARNS 3
#define AUTOBANTIME 10

/client/proc/warn(warned_ckey)
	if(!check_rights(R_ADMIN))	return

	if(!warned_ckey || !istext(warned_ckey))	return
	if(warned_ckey in admin_datums)
		usr << "<font color='red'>Error: warn(): You can't warn admins.</font>"
		return

	var/datum/preferences/D
	var/client/C = directory[warned_ckey]
	if(C)	D = C.prefs
	else	D = preferences_datums[warned_ckey]

	if(!D)
		src << "<font color='red'>Error: warn(): No such ckey found.</font>"
		return

	if(++D.warns >= MAX_WARNS)					//uh ohhhh...you'reee iiiiin trouuuubble O:)
		ban_unban_log_save("[ckey] warned [warned_ckey], resulting in a [AUTOBANTIME] minute autoban.")
		if(C)
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)] resulting in a [AUTOBANTIME] minute ban.")
			C << "<font color='red'><BIG><B>You have been autobanned due to a warning by [ckey].</B></BIG><br>This is a temporary ban, it will be removed in [AUTOBANTIME] minutes."
			del(C)
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] resulting in a [AUTOBANTIME] minute ban.")
		AddBan(warned_ckey, D.last_id, "Autobanning due to too many formal warnings", ckey, 1, AUTOBANTIME)
		feedback_inc("ban_warn",1)
	else
		if(C)
			C << "<font color='red'><BIG><B>You have been formally warned by an administrator.</B></BIG><br>Further warnings will result in an autoban.</font>"
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)]. They have [MAX_WARNS-D.warns] strikes remaining.")
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] (DC). They have [MAX_WARNS-D.warns] strikes remaining.")

	feedback_add_details("admin_verb","WARN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

#undef MAX_WARNS
#undef AUTOBANTIME

/client/proc/drop_bomb()
	set category = "Special Verbs"
	set name = "Drop Bomb"
	set desc = "Cause an explosion of varying strength at your location."

	var/turf/epicenter = mob.loc
	var/list/choices = list("Small Bomb", "Medium Bomb", "Big Bomb", "Custom Bomb")
	var/choice = input("What size explosion would you like to produce?") in choices
	switch(choice)
		if(null)
			return 0
		if("Small Bomb")
			explosion(epicenter, 1, 2, 3, 3)
		if("Medium Bomb")
			explosion(epicenter, 2, 3, 4, 4)
		if("Big Bomb")
			explosion(epicenter, 3, 5, 7, 5)
		if("Custom Bomb")
			var/devastation_range = input("Devastation range (in tiles):") as num
			var/heavy_impact_range = input("Heavy impact range (in tiles):") as num
			var/light_impact_range = input("Light impact range (in tiles):") as num
			var/flash_range = input("Flash range (in tiles):") as num
			explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	message_admins("\blue [ckey] creating an admin explosion at [epicenter.loc].")
	feedback_add_details("admin_verb","DB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/give_spell(mob/T as mob in mob_list)
	set category = "Fun"
	set name = "Give Spell"
	set desc = "Gives a spell to a mob."
	var/obj/effect/proc_holder/spell/S = input("Choose the spell to give to that guy", "ABRAKADABRA") as null|anything in spells
	if(!S)
		return
	feedback_add_details("admin_verb","GS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] gave [key_name(T)] the spell [S].")
	message_admins("\blue [key_name_admin(usr)] gave [key_name(T)] the spell [S].", 1)

	if(T.mind)
		T.mind.spell_list += new S
	else
		T.mob_spell_list += new S
		message_admins("\red Spells given to mindless mobs will not be transferred in mindswap or cloning!", 1)


/client/proc/give_disease(mob/T as mob in mob_list)
	set category = "Fun"
	set name = "Give Disease"
	set desc = "Gives a Disease to a mob."
	var/datum/disease/D = input("Choose the disease to give to that guy", "ACHOO") as null|anything in diseases
	if(!D) return
	T.contract_disease(new D, 1)
	feedback_add_details("admin_verb","GD") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] gave [key_name(T)] the disease [D].")
	message_admins("\blue [key_name_admin(usr)] gave [key_name(T)] the disease [D].", 1)

/client/proc/make_sound(var/obj/O in world)
	set category = "Special Verbs"
	set name = "Make Sound"
	set desc = "Display a message to everyone who can hear the target"
	if(O)
		var/message = input("What do you want the message to be?", "Make Sound") as text|null
		if(!message)
			return
		for (var/mob/V in hearers(O))
			V.show_message(message, 2)
		log_admin("[key_name(usr)] made [O] at [O.x], [O.y], [O.z]. make a sound")
		message_admins("\blue [key_name_admin(usr)] made [O] at [O.x], [O.y], [O.z]. make a sound", 1)
		feedback_add_details("admin_verb","MS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/togglebuildmodeself()
	set name = "Toggle Build Mode Self"
	set category = "Special Verbs"
	if(src.mob)
		togglebuildmode(src.mob)
	feedback_add_details("admin_verb","TBMS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/object_talk(var/msg as text)
	set category = "Special Verbs"
	set name = "oSay"
	set desc = "Display a message to everyone who can hear the target"
	if(mob.control_object)
		if(!msg)
			return
		for (var/mob/V in hearers(mob.control_object))
			V.show_message("<b>[mob.control_object.name]</b> says: \"" + msg + "\"", 2)
	feedback_add_details("admin_verb","OT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/kill_air()
	set category = "Debug"
	set name = "Kill Air"
	set desc = "Toggle Air Processing"
	if(kill_air)
		kill_air = 0
		usr << "<b>Enabled air processing.</b>"
	else
		kill_air = 1
		usr << "<b>Disabled air processing.</b>"
	feedback_add_details("admin_verb","KA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] used 'kill air'.")
	message_admins("\blue [key_name_admin(usr)] used 'kill air'.", 1)

/client/proc/deadmin_self()
	set name = "De-admin self"
	set category = "Admin"

	if(holder)
		if(alert("Confirm self-deadmin for the round? You can't re-admin yourself without someont promoting you.",,"Yes","No") == "Yes")
			log_admin("[src] deadmined themself.")
			message_admins("[src] deadmined themself.", 1)
			deadmin()
			deadmins += ckey
			verbs += /client/proc/readmin
			src << "<span class='interface'>You are now a normal player.</span>"
	feedback_add_details("admin_verb","DAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_log_hrefs()
	set name = "Toggle href logging"
	set category = "Server"
	if(!holder)	return
	if(config)
		if(config.log_hrefs)
			config.log_hrefs = 0
			src << "<b>Stopped logging hrefs</b>"
		else
			config.log_hrefs = 1
			src << "<b>Started logging hrefs</b>"

/client/proc/check_ai_laws()
	set name = "Check AI Laws"
	set category = "Admin"
	if(holder)
		src.holder.output_ai_laws()


/client/proc/readmin()
	set name = "Re-admin self"
	set category = "Admin"
	set desc = "Regain your admin powers."
	var/list/rank_names = list()
	for(var/datum/admin_rank/R in admin_ranks)
		rank_names[R.name] = R
	var/datum/admins/D = admin_datums[ckey]
	var/rank = null
	if(config.admin_legacy_system)
		//load text from file
		var/list/Lines = file2list("config/admins.txt")
		for(var/line in Lines)
			var/next = findtext(line, " = ")
			var/ckey_text = ckeyEx(copytext(line, 1, next))
			if(ckey_text != ckey)
				continue
			rank = ckeyEx(copytext(line, next, 0))
			break
	else
		if(!dbcon.IsConnected())
			message_admins("Warning, mysql database is not connected.")
			src << "Warning, mysql database is not connected."
			return
		var/sql_ckey = sanitizeSQL(ckey)
		var/DBQuery/query = dbcon.NewQuery("SELECT rank FROM admin WHERE ckey = '[sql_ckey]'")
		query.Execute()
		while(query.NextRow())
			rank = ckeyEx(query.item[1])
	if(!D)
		if(rank_names[rank] == null)
			var/error_extra = ""
			if(!config.admin_legacy_system)
				error_extra = " Check mysql DB connection."
			error("Error while re-adminning [src], admin rank ([rank]) does not exist.[error_extra]")
			src << "Error while re-adminning, admin rank ([rank]) does not exist.[error_extra]"
			return
		D = new(rank_names[rank],ckey)
		var/client/C = directory[ckey]
		D.associate(C)
		message_admins("[src] re-adminned themselves.")
		log_admin("[src] re-adminned themselves.")
		deadmins -= ckey
		feedback_add_details("admin_verb","RAS")
		return
	else
		src << "You are already an admin."
		verbs -= /client/proc/readmin
		deadmins -= ckey
		return