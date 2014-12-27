/obj/item/device/thinktronic_parts/program/cargo/cargomanagement
	name = "CargoBay Management"
	department = "Cargo Bay"
	obj/item/device/thinktronic_parts/nanonet/server = null
	manager = 0
	banned = 0

	use_app() //Put all the HTML here
		var/obj/item/device/thinktronic_parts/HDD/hdd = loc // variable for interactin with the HDD
		var/obj/item/device/thinktronic/PDA = hdd.loc // variable for interacting with the Device itself
		dat = "<h2>CargoBay Management</h2>"

		if(PDA.network())
			if(!server)
				for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
					for (/obj/item/device/thinktronic_parts/nanonet/managerserver/S in MS)
						if(S.department = department)
							server = S
							usr << "ERROR: Server not found, contact a System Administrator"
							break
			else
				if(!banned)
					//Management Section
					dat += {"
							<div class='statusDisplay'>
							<center>
							[name]<br>
							"}
					if(manager)
					//manager only buttons
						dat += {"
								Insert Buttons Here
								"}
						dat += {"<br>"}
					//anyone buttons
					dat += {"
							Insert Buttons Here
							"}
					dat += {"</center></div>"}
					//Content
					dat += {"
							<div class='statusDisplay'>
							<center>
							[server.memo]
							"}
				else
					dat += "You have been banned by the [department] Manager."
			else
				dat += "No Connection Found"

	Topic(href, href_list) // This is here
		..()
		var/obj/item/device/thinktronic_parts/HDD/hdd = loc // variable for interactin with the HDD
		var/obj/item/device/thinktronic/PDA = hdd.loc // variable for interacting with the Device itself
		switch(href_list["choice"])
/*			if("Medical Records")
				active1 = find_record("id", href_list["target"], data_core.general)
				if(active1)
					active2 = find_record("id", href_list["target"], data_core.medical)
				mode = 2
				if(!active2)
					active1 = null
				PDA.attack_self(usr)
			if("CloseRecord")
				active1 = null
				active2 = null
				mode = 1
				PDA.attack_self(usr)
*/

//server//
/obj/item/device/thinktronic_parts/nanonet/managerserver
	name = "Management Server"
	var/department = "Cargo Bay"
	var/list/users = list()
	var/list/memo = list()

