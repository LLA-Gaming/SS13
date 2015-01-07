//Program code//
/obj/item/device/thinktronic_parts/
	var/sentby = null
	var/datatype = null
	var/app = null
	var/icon/photo = null
	var/document = null
	var/convo = null
	var/photoinfo = null
	var/mlog = null
	var/mlogowner = null
	var/doc = null
	var/doc_links = null
	var/fields = null  //Amount of user created fields
	var/device_ID = null
	var/pro = null
	var/deffont = "Verdana"
	var/signfont = "Times New Roman"
	var/crayonfont = "Comic Sans MS"

/obj/item/device/thinktronic_parts/program/
	name = "default program"
	datatype = "Application"
	app = 1
	var/category = "general_programs"
	var/img = "<img src=pda_blank.png>"
	var/ramreq = 128
	var/favorite = 0
	var/alerts = 0
	var/dat = "Error: Program not loaded"

	var/utility = 0
	var/usealerts = 0
	var/DRM = 0
	var/deletable = 1
	var/network = 0

	var/department = null
	var/obj/item/device/thinktronic_parts/nanonet/server = null
	var/manager = null
	var/banned = null

/obj/item/device/thinktronic_parts/program/general
	name = "Example Program"
	category = "general_programs"
	img = "<img src=pda_blank.png>"

/obj/item/device/thinktronic_parts/program/sec
	name = "Example Program"
	category = "sec_programs"
	img = "<img src=pda_cuffs.png>"

/obj/item/device/thinktronic_parts/program/eng
	name = "Example Program"
	category = "engi_programs"
	img = "<img src=pda_power.png>"

/obj/item/device/thinktronic_parts/program/sci
	name = "Example Program"
	category = "sci_programs"
	img = "<img src=pda_signaler.png>"

/obj/item/device/thinktronic_parts/program/cargo
	name = "Example Program"
	category = "cargo_programs"
	img = "<img src=pda_crate.png>"

/obj/item/device/thinktronic_parts/program/medical
	name = "Example Program"
	category = "med_programs"
	img = "<img src=pda_medical.png>"

/obj/item/device/thinktronic_parts/program/misc
	name = "Example Misc Program"
	category = "misc_programs"
	img = "<img src=pda_bell.png>"

/obj/item/device/thinktronic_parts/program/utility
	name = "Example Utility"
	category = "utilities"
	img = "<img src=pda_atmos.png>"
	utility = 1
	var/togglemode = 0
	var/toggleon = 0

/obj/item/device/thinktronic_parts/program/proc/use_app()
	dat = ""

/obj/item/device/thinktronic_parts/program/proc/network()
	var/obj/item/device/thinktronic_parts/core/D = loc
	var/obj/item/device/thinktronic/PDA = D.loc
	var/turf/T = get_turf(PDA.loc)
	if (D.neton)
		for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
			if(MS.active)
				if(MS.z == T.z)//on the same z-level?
					return 1
					break
				else
					for (var/list/obj/machinery/nanonet_router/router in nanonet_routers)
						if(router.z == T.z)//on the same z-level?
							if(router.active)
								return 1
								break



/obj/item/device/thinktronic_parts/program/Topic(href, href_list)
		//Vital functions, every program needs the code below in there Topic()
	var/obj/item/device/thinktronic_parts/core/D = loc
	var/obj/item/device/thinktronic/PDA = D.loc
	if(PDA.can_use(usr))
		switch(href_list["choice"])
			if("Open")
				D.mode = 3
				D.activeprog = src
				PDA.attack_self(usr)
				return
			if("Favorite")
				switch (favorite)
					if (0)
						favorite = 1
					if (1)
						favorite = 2
					if (2)
						favorite = 0
				PDA.attack_self(usr)
				return
			if("Alerts")
				switch (alerts)
					if (0)
						alerts = 1
					if (1)
						alerts = 0
				PDA.attack_self(usr)
				return

	else
		usr.set_machine(src)
		usr << browse(null, "window=thinktronic")
		return

//USB devices

/obj/item/device/thinktronic_parts/cartridge
	name =  "Generic Cartridge"
	desc = "A data cartridge for ThinkTronic devices."
	icon = 'icons/obj/pda.dmi'
	icon_state = "cart"
	item_state = "electronic"
	datatype = "Cartridge"
	w_class = 1

////Data/////

/obj/item/device/thinktronic_parts/data/convo
	name =  "Conversation Log"

/obj/item/device/thinktronic_parts/data/savedconvo
	name =  "Conversation Log"
	convo = 1
	datatype = "Message Log"

/obj/item/device/thinktronic_parts/data/document
	name =  "Untitled Document"
	document = 1
	datatype = "Document"

/obj/item/device/thinktronic_parts/data/photo
	name =  "Untitled Photo"
	photo = 1
	datatype = "Photo"

/obj/item/device/thinktronic_parts/data/alert
	name =  "alert"
	var/alertmsg = "Alert"

/obj/item/device/thinktronic_parts/data/task
	name =  "task"
	var/taskmsg = "Task"
	var/taskdetail = "Test Detail"
	var/status = "Pending"
	var/assignedby = null
	var/dept = null
	var/request = null

/obj/item/device/thinktronic_parts/data/task/request


