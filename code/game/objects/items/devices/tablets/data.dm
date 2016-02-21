/datum/tablet_data
	var/name = "Untitled Data"
	var/sentby = null
	var/icon/photo = null
	var/data_type = "Data"

	New()
		..()
		name = "[initial(name)] #[rand(0,65536)]"

/datum/tablet_data/document
	name = "Untitled Document"
	data_type = "Document"
	var/doc = null
	var/doc_links = null
	var/fields = null  //Amount of user created fields
	var/numofpages = null
	var/page = null
	var/deffont = "Verdana"
	var/signfont = "Times New Roman"
	var/crayonfont = "Comic Sans MS"
	var/uploaded_by = null //nanonet

/datum/tablet_data/program
	name = "Untitled Program"
	data_type = "Program"
	var/photo_info
	var/datum/program/program = null

/datum/tablet_data/photo
	name = "Untitled Photo"
	data_type = "Photo"
	var/photoinfo = null

/datum/tablet_data/chatlog
	name = "Untitled Chat log"
	data_type = "Chat Log"
	var/log = ""

/datum/tablet_data/conversation
	name = "Untitled Chat"
	data_type = "Conversation"
	var/host = null
	var/renamed = 0
	var/list/users = list()
	var/list/leftchat = list() // "PLEASE STOP READDING ME" - Every annoyed crewmember ever
	var/log = ""
	var/raw_log = "" // For viewing or printing.
	var/lastmsg = ""