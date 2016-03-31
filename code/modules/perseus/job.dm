/datum/configuration/var/perseus_legacy_system = 0

/var/const/access_pcommander = 67
/var/const/access_penforcer = 66

var/list/
	perseusList = list() //ckey - rank
	pnumbers = list() //ckey - number
	pmeta = list() //ckey - metarank
	assignPerseus = list() //used for job assigning

#define PERSEUS_WHITELIST_FILE "config/perseuslist.txt"

/proc/loadPerseusList()
	perseusList.Cut()
	pnumbers.Cut()
	pmeta.Cut()

	if(!config.perseus_legacy_system)
		establish_db_connection()
		if(!config.sql_enabled || !dbcon.IsConnected())
			config.perseus_legacy_system = 1
			loadPerseusList()
			return

		var/loadQuery = "SELECT * FROM perseuslist"
		var/DBQuery/query = dbcon.NewQuery(loadQuery)
		query.Execute()
		while(query.NextRow())
			var/ckey = sanitizeSQL(ckey(query.item[2]))
			var/number = sanitizeSQL(query.item[3])
			if(!number)	number = rand(100, 999)
			var/rank = sanitizeSQL(query.item[4])
			var/squad = sanitizeSQL(query.item[5])
			if(ckey && number && rank && squad)
				pnumbers[ckey] = number
				perseusList[ckey] = rank
				pmeta[ckey] = squad
	else
		var/file = file2text(PERSEUS_WHITELIST_FILE)
		if(!file)
			diary << "Unable to load [PERSEUS_WHITELIST_FILE]"
		else
			var/list/lines = splittext(file, "\n")
			for(var/line in lines)
				if(!line)	continue
				if(copytext(line, 1, 2) == ";")	continue

				var/ckeyPos = findtext(line, " - ", 1, 0)
				var/rankPos = findtext(line, " # ", 1, 0)
				var/metaPos = findtext(line, " + ", 1, 0)
				if(ckeyPos)
					var/ckey = copytext(line, 1, ckeyPos)
					var/rank = copytext(line, ckeyPos + 3, rankPos)
					perseusList[ckey] = rank
					var/number = copytext(line, rankPos + 3, metaPos)
					pnumbers[ckey] = number
					var/meta = copytext(line, metaPos + 3, length(line) + 1)
					pmeta[ckey] = meta

#undef PERSEUS_WHITELIST_FILE

/*
 *	Log perseus logins in the database.
 */

/proc/logPerseusLogin(var/mob/living/carbon/human/H, var/rank = "Enforcer")
	if(!H || !H.client)	return
	var/sqltime = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	establish_db_connection()
	if(!dbcon.IsConnected())
		log_game("SQL ERROR during death reporting. Failed to connect.")
	else
		var/DBQuery/query = dbcon.NewQuery("INSERT INTO perseus_login (ckey, datetime, number, rank) VALUES ('[sanitizeSQL(H.ckey)]', '[sqltime]', '[sanitizeSQL(pnumbers[H.ckey])]', '[sanitizeSQL(rank)]')")
		if(!query.Execute())
			var/err = query.ErrorMsg()
			log_game("SQL Error : \[[err]\]\n")

/*
* Jobs
*/

var/const/PERSEUS = (1<<3)

var/const/ENFORCER = (1<<0)
var/const/COMMANDER = (1<<1)

/*
* Enforcer Job
*/

/datum/job/penforcer
	title = "Perseus Security Enforcer"
	faction = "Perseus Military Corporation"
	supervisors = "Perseus Commanders"
	flag = ENFORCER
	department_flag = PERSEUS
	total_positions = 3
	spawn_positions = 3

	equip(var/mob/living/carbon/human/H, visualsOnly = FALSE)
		if(!H)	return 0
		if(!visualsOnly)
			logPerseusLogin(H, "Enforcer")

		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/hos (H), slot_ears)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/space/skinsuit(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/lightarmor(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/voice/perseus_voice(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/pershelmet(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/specops(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/blackpack(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/weapon/tank/perseus(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box(H.back), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/book/manual/spacelaw(H), slot_l_hand)
		if(visualsOnly)
			return
		var/obj/item/weapon/implant/enforcer/implant = new /obj/item/weapon/implant/enforcer(H)
		implant.imp_in = H
		implant.implanted = 1
		var/obj/item/device/tablet/perseus/P = new /obj/item/device/tablet/perseus(H)
		var/obj/item/weapon/card/id/perseus/id = new /obj/item/weapon/card/id/perseus(P)
		id.assignment = title
		id.access = get_access(title)

		var/name = "Perseus Security Enforcer #[pnumbers[H.ckey] ? pnumbers[H.ckey] : rand(100, 999)]-[pmeta[H.ckey] ? pmeta[H.ckey] : ""]"

		id.registered_name = name
		id.name = name
		P.id = id
		P.core.owner = id.registered_name
		P.core.ownjob = id.assignment
		P.core.name = "PDA-[P.core.owner] ([P.core.ownjob])"
		P.update_label()
		H.equip_to_slot_or_del(P, slot_wear_id)

/*
* Commander Job
*/

/datum/job/pcommander
	title = "Perseus Security Commander"
	supervisors = "Nanotrasen Officials."
	faction = "Perseus Military Corporation"
	flag = COMMANDER
	department_flag = PERSEUS
	total_positions = 1
	spawn_positions = 1

	equip(var/mob/living/carbon/human/H, visualsOnly = FALSE)
		if(!H) return 0
		if(!visualsOnly)
			logPerseusLogin(H, "Commander")

		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/hos (H), slot_ears)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/space/skinsuit(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/blackpack(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/weapon/tank/perseus(H.back), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box(H.back), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/voice/perseus_voice(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/persberet(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/specops(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/weapon/book/manual/spacelaw(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/lightarmor(H), slot_wear_suit)
		if(visualsOnly)
			return
		var/obj/item/weapon/implant/commander/implant = new /obj/item/weapon/implant/commander(H)
		implant.imp_in = H
		implant.implanted = 1

		var/obj/item/weapon/implant/enforcer/implant2 = new /obj/item/weapon/implant/enforcer(H)
		implant2.imp_in = H
		implant2.implanted = 1

		var/obj/item/device/tablet/perseus/P = new /obj/item/device/tablet/perseus(H)
		var/obj/item/weapon/card/id/perseus/id = new /obj/item/weapon/card/id/perseus(P)
		id.assignment = title
		id.access = get_access(title)
		id.registered_name ="Perseus Security Commander #[pnumbers[H.ckey] ? pnumbers[H.ckey] : "00[rand(0,9)]"]-[pmeta[H.ckey] ? pmeta[H.ckey] : ""]"
		id.name = id.registered_name

		P.id = id
		P.core.owner = id.registered_name
		P.core.ownjob = id.assignment
		P.core.name = "PDA-[P.core.owner] ([P.core.ownjob])"
		P.update_label()

		H.equip_to_slot_or_del(P, slot_wear_id)

/*
* Hivemind Talk
*/

/mob/living/proc/perseusHivemindSay(var/message)
	if (!message)
		return

	if(key) log_say("[key_name(src)] : [message]")
	message = trim(message)

	var/message_a = say_quote(message)
	var/rendered = "<i><span class='game say'>Hivemind, <span class='name'>[name]</span> <span class='message'>[message_a]</span></span></i>"
	for (var/mob/living/S in world)
		if(!S.stat)
			if(S.check_contents_for(/obj/item/weapon/implant/enforcer))
				S << rendered
				S.send_text_to_tab(rendered, "ic")
