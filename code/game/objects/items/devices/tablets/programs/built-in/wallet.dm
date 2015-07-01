/datum/program/builtin/wallet
	name = "Wallet"
	app_id = "wallet"

	use_app()
		dat = {"<br><h3>NanoBank E-Wallet:</h3>"}
		dat += {"Holder: [tablet.core.owner]<br>"}
		dat += {"Space Cash: $[tablet.core.cash]<br>"}
		if(tablet.can_eject)
			dat += {"Withdraw:"}
			if (tablet.core.cash>=10)
				dat += " <a href='?src=\ref[src];choice=Withdraw;amount=10'>$10</a>"
			if (tablet.core.cash>=20)
				dat += " <a href='?src=\ref[src];choice=Withdraw;amount=20'>$20</a>"
			if (tablet.core.cash>=50)
				dat += " <a href='?src=\ref[src];choice=Withdraw;amount=50'>$50</a>"
			if (tablet.core.cash>=100)
				dat += " <a href='?src=\ref[src];choice=Withdraw;amount=100'>$100</a>"
			if (tablet.core.cash>=200)
				dat += " <a href='?src=\ref[src];choice=Withdraw;amount=200'>$200</a>"
			if (tablet.core.cash>=500)
				dat += " <a href='?src=\ref[src];choice=Withdraw;amount=500'>$500</a>"
			if (tablet.core.cash>=1000)
				dat += " <a href='?src=\ref[src];choice=Withdraw;amount=1000'>$1000</a>"

	Topic(href, href_list)
		if (!..()) return
		switch(href_list["choice"])
			if("Withdraw")
				var/cash = href_list["amount"]
				if (cash == "10")
					var/obj/item/weapon/spacecash/dosh = new /obj/item/weapon/spacecash/c10(usr.loc)
					if(usr.put_in_hands(dosh) && tablet.core.cash >= dosh.credits)
						tablet.core.cash -=10
					else
						usr << "<span class='notice'>You couldn't withdraw because your hands are full.</span>"
						qdel(dosh)
				if (cash == "20")
					var/obj/item/weapon/spacecash/dosh = new /obj/item/weapon/spacecash/c20(usr.loc)
					if(usr.put_in_hands(dosh) && tablet.core.cash >= dosh.credits)
						tablet.core.cash -=20
					else
						usr << "<span class='notice'>You couldn't withdraw because your hands are full.</span>"
						qdel(dosh)
				if (cash == "50")
					var/obj/item/weapon/spacecash/dosh = new /obj/item/weapon/spacecash/c50(usr.loc)
					if(usr.put_in_hands(dosh) && tablet.core.cash >= dosh.credits)
						tablet.core.cash -=50
					else
						usr << "<span class='notice'>You couldn't withdraw because your hands are full.</span>"
						qdel(dosh)
				if (cash == "100")
					var/obj/item/weapon/spacecash/dosh = new /obj/item/weapon/spacecash/c100(usr.loc)
					if(usr.put_in_hands(dosh) && tablet.core.cash >= dosh.credits)
						tablet.core.cash -=100
					else
						usr << "<span class='notice'>You couldn't withdraw because your hands are full.</span>"
						qdel(dosh)
				if (cash == "200")
					var/obj/item/weapon/spacecash/dosh = new /obj/item/weapon/spacecash/c200(usr.loc)
					if(usr.put_in_hands(dosh) && tablet.core.cash >= dosh.credits)
						tablet.core.cash -=200
					else
						usr << "<span class='notice'>You couldn't withdraw because your hands are full.</span>"
						qdel(dosh)
				if (cash == "500")
					var/obj/item/weapon/spacecash/dosh = new /obj/item/weapon/spacecash/c500(usr.loc)
					if(usr.put_in_hands(dosh) && tablet.core.cash >= dosh.credits)
						tablet.core.cash -=500
					else
						usr << "<span class='notice'>You couldn't withdraw because your hands are full.</span>"
						qdel(dosh)
				if (cash == "1000")
					var/obj/item/weapon/spacecash/dosh = new /obj/item/weapon/spacecash/c1000(usr.loc)
					if(usr.put_in_hands(dosh) && tablet.core.cash >= dosh.credits)
						tablet.core.cash -=1000
					else
						usr << "<span class='notice'>You couldn't withdraw because your hands are full.</span>"
						qdel(dosh)
		use_app()
		tablet.attack_self(usr)



