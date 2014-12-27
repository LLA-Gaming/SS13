/obj/item/device/thinktronic_parts/program/general/magic8ball
	name = "Magic Space Ball" // Menu name
	img = "<img src=pda_blank.png>"//Menu Icon
	ramreq = 128 // 128 Tablets, 256 Laptops, 512 AdvLaptops
	favorite = 0 // Is it favorited?
	alerts = 0 // Alerts are on or off for this app
	utility = 0 // this is 0 by default, but if your making a utility be sure to tick this
	usealerts = 1 //Turn this on so the user can turn on/off the alerts via settings
	DRM = 0 // 1 = has DRM
	deletable = 1 // Can it be deleted?
	network = 1 // as of right now this has no function but it might so just set it to 1 if it uses the network

	use_app() //Put all the HTML here

		dat = ""//Youl want to start dat off blank or youl just keep duplicating every click.
		dat += "<div class='statusDisplay'>"//use this div class if you want things to displaying in a status box
		dat += "<center>Magic Space Ball</center>"
		dat += "</div'>"// close up the div
		if (network())//Checks the network proc and if it returns 1 your good
			dat += "<center>(connected to server)</center>"
			dat += "<center>Press the button below to recieve a magic space ball alert</center>"
			dat += "<center><b><a href='byond://?src=\ref[src];choice=8ball'>Shake 8 Ball</a></b></center>"
		else//if it does not return 1, no connection
			dat += "<center>(no connection found)</center>"


	Topic(href, href_list) // This is here

		..()////THIS IS NEEDED FOR THE TOPIC TO FUNCTION AT ALL, ALWAYS INCLUDE ..()
		var/obj/item/device/thinktronic_parts/HDD/hdd = loc // variable for interactin with the HDD
		var/obj/item/device/thinktronic/PDA = hdd.loc // variable for interacting with the Device itself
		switch(href_list["choice"])//Now we switch based on choice.
			if ("8ball")
				if (network())//quick network check to make sure everything is online
					for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
						MS.SendAlert("The Ball... says... no",/obj/item/device/thinktronic_parts/program/general/magic8ball)
				PDA.attack_self(usr) // Refreshs the page after you click an option, put this in every href_list you make.
