/client/proc/alt_check()
	set category = "Admin"
	set name = "Player Analysis Panel"

	var/dat = {"<B>Just to be sure you should try to also look up computer IDs/IPs on the server logs for a second opinion.</B>
				<br>Additionally make an attempt to introduce new players to the server
				<HR>"}
	for(var/client/C in clients)
		if(!prefs.knownplayer)
			dat += "Unknown Players (Click to tag):<br>"
			break
	for(var/client/C in clients)
		if(!prefs.knownplayer)
			dat += "<A href='?_src_=holder;knownedit=\ref[C.mob]'>[C.ckey]</a><br>"

	dat += "<br><br>Player Data:"
	for(var/client/C in clients)
		dat += "<p>[C.ckey] <A href='?_src_=holder;notes=show;ckey=[C.ckey]'>(Notes)</A> (Player Age: <font color = 'red'>[C.player_age]</font>) - <b>[C.computer_id]</b> / <b>[C.address]</b><br>"
		if(C.alt_count >= 2)
			dat += "--Accounts associated with CID: <b>[C.related_accounts_cid]</b><br>"
			dat += "--Accounts associated with IP: <b>[C.related_accounts_ip]</b><br>"
		if(C.prefs.knownplayer)
			dat += "--Known Details: <b>[C.prefs.knownplayer]</b> <A href='?_src_=holder;knownedit=\ref[C.mob]'>Edit</a><br>"
	usr << browse(dat, "window=alt_panel;size=640x480")
	return

