/obj/structure/girder
	icon_state = "girder"
	anchored = 1
	density = 1
	layer = 2
	var/state = 0

	attackby(obj/item/W as obj, mob/user as mob)
		add_fingerprint(user)
		if(istype(W, /obj/item/weapon/wrench) && state == 0)
			var/turf/Tsrc = get_turf(src)
			if (!istype(Tsrc, /turf/simulated/floor))
				user << "<span class='warning'>This cant be bolted without a floor!</span>"
				return
			if(anchored && !istype(src,/obj/structure/girder/displaced))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
				user << "<span class='notice'>Now disassembling the girder...</span>"
				if(do_after(user,40))
					if(!src) return
					user << "<span class='notice'>You dissasembled the girder!</span>"
					new /obj/item/stack/sheet/metal(get_turf(src))
					qdel(src)
			else if(!anchored)
				playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
				user << "<span class='notice'>Now securing the girder...</span>"
				if(get_turf(user, 40))
					user << "<span class='notice'>You secured the girder!</span>"
					var/obj/structure/girder/G = new (loc)
					transfer_fingerprints_to(G)
					qdel(src)

		else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
			user << "<span class='notice'>Now slicing apart the girder...</span>"
			if(do_after(user,30))
				if(!src) return
				user << "<span class='notice'>You slice apart the girder!</span>"
				new /obj/item/stack/sheet/metal(get_turf(src))
				qdel(src)

		else if(istype(W, /obj/item/weapon/pickaxe/diamonddrill))
			user << "<span class='notice'>You drill through the girder!</span>"
			new /obj/item/stack/sheet/metal(get_turf(src))
			qdel(src)

		else if(istype(W, /obj/item/weapon/screwdriver) && state == 2 && istype(src,/obj/structure/girder/reinforced))
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			user << "<span class='notice'>Now unsecuring support struts...</span>"
			if(do_after(user,40))
				if(!src) return
				user << "<span class='notice'>You unsecured the support struts!</span>"
				state = 1

		else if(istype(W, /obj/item/weapon/wirecutters) && istype(src,/obj/structure/girder/reinforced) && state == 1)
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
			user << "<span class='notice'>Now removing support struts...</span>"
			if(do_after(user,40))
				if(!src) return
				user << "<span class='notice'>You removed the support struts!</span>"
				var/obj/structure/girder/G = new (loc)
				transfer_fingerprints_to(G)
				qdel(src)

		else if(istype(W, /obj/item/weapon/crowbar) && state == 0 && anchored )
			playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
			user << "<span class='notice'>Now dislodging the girder...</span>"
			if(do_after(user, 40))
				if(!src) return
				user << "<span class='notice'>You dislodged the girder!</span>"
				var/obj/structure/girder/displaced/D = new (loc)
				transfer_fingerprints_to(D)
				qdel(src)

		else if(istype(W, /obj/item/stack/sheet))

			var/obj/item/stack/sheet/S = W
			switch(S.type)

				if(/obj/item/stack/sheet/metal, /obj/item/stack/sheet/metal/cyborg)
					if(!anchored)
						if(S.amount < 2)
							user << "<span class='warning'>You need at least two sheets to create a false wall.</span>"
							return
						var/turf/Tsrc = get_turf(src)
						if (!istype(Tsrc, /turf/simulated/floor))
							user << "<span class='warning'>This cant be created without a floor!</span>"
							return
						S.use(2)
						user << "<span class='notice'>You create a false wall! Push on it to open or close the passage.</span>"
						var/obj/structure/falsewall/F = new (loc)
						transfer_fingerprints_to(F)
						qdel(src)
					else
						if(S.amount < 2) return ..()
						user << "<span class='notice'>Now adding plating...</span>"
						if (do_after(user,40))
							if(!src || !S || S.amount < 2) return
							S.use(2)
							user << "<span class='notice'>You added the plating!</span>"
							var/turf/Tsrc = get_turf(src)
							Tsrc.ChangeTurf(/turf/simulated/wall)
							for(var/turf/simulated/wall/X in Tsrc.loc)
								if(X)	transfer_fingerprints_to(X)
							qdel(src)
						return

				if(/obj/item/stack/sheet/plasteel)
					if(!anchored)
						if(S.amount < 2)
							user << "<span class='warning'>You need at least two sheets to create a false wall.</span>"
							return
						var/turf/Tsrc = get_turf(src)
						if (!istype(Tsrc, /turf/simulated/floor))
							user << "<span class='warning'>This cant be created without a floor!</span>"
							return
						S.use(2)
						user << "<span class='notice'>You create a false wall! Push on it to open or close the passage.</span>"
						var/obj/structure/falsewall/reinforced/FW = new (loc)
						transfer_fingerprints_to(FW)
						qdel(src)
					else
						if (src.icon_state == "reinforced") //I cant believe someone would actually write this line of code...
							if(S.amount < 1) return ..()
							user << "<span class='notice'>Now finalising reinforced wall...</span>"
							if(do_after(user, 50))
								if(!src || !S || S.amount < 1) return
								S.use(1)
								user << "<span class='notice'>Wall fully reinforced!</span>"
								var/turf/Tsrc = get_turf(src)
								Tsrc.ChangeTurf(/turf/simulated/wall/r_wall)
								for(var/turf/simulated/wall/r_wall/X in Tsrc.loc)
									if(X)	transfer_fingerprints_to(X)
								qdel(src)
							return
						else
							if(S.amount < 1) return ..()
							user << "<span class='notice'>Now reinforcing girders...</span>"
							if (do_after(user,60))
								if(!src || !S || S.amount < 1) return
								S.use(1)
								user << "<span class='notice'>Girders reinforced!</span>"
								var/obj/structure/girder/reinforced/R = new (loc)
								transfer_fingerprints_to(R)
								qdel(src)
							return

			if(S.sheettype)
				var/M = S.sheettype
				if(!anchored)
					if(S.amount < 2)
						user << "<span class='warning'>You need at least two sheets to create a false wall.</span>"
						return
					S.use(2)
					user << "<span class='notice'>You create a false wall! Push on it to open or close the passage.</span>"
					var/F = text2path("/obj/structure/falsewall/[M]")
					var/obj/structure/FW = new F (loc)
					transfer_fingerprints_to(FW)
					qdel(src)
				else
					if(S.amount < 2) return ..()
					user << "<span class='notice'>Now adding plating...</span>"
					if (do_after(user,40))
						if(!src || !S || S.amount < 2) return
						S.use(2)
						user << "<span class='notice'>You added the plating!</span>"
						var/turf/Tsrc = get_turf(src)
						Tsrc.ChangeTurf(text2path("/turf/simulated/wall/mineral/[M]"))
						for(var/turf/simulated/wall/mineral/X in Tsrc.loc)
							if(X)	transfer_fingerprints_to(X)
						qdel(src)
					return

			add_hiddenprint(usr)

		else if(istype(W, /obj/item/pipe))
			var/obj/item/pipe/P = W
			if (P.pipe_type in list(0, 1, 5))	//simple pipes, simple bends, and simple manifolds.
				user.drop_item()
				P.loc = src.loc
				user << "<span class='notice'>You fit the pipe into the [src]!</span>"
		else
			..()


	blob_act()
		if(prob(40))
			qdel(src)


	ex_act(severity)
		switch(severity)
			if(1.0)
				qdel(src)
				return
			if(2.0)
				if (prob(30))
					var/remains = pick(/obj/item/stack/rods,/obj/item/stack/sheet/metal)
					new remains(loc)
					qdel(src)
				return
			if(3.0)
				if (prob(5))
					var/remains = pick(/obj/item/stack/rods,/obj/item/stack/sheet/metal)
					new remains(loc)
					qdel(src)
				return
			else
		return

	attack_animal(var/mob/living/simple_animal/M)
		M.changeNext_move(8)
		M.do_attack_animation(src, 1)
		if(M.environment_smash >= 2)
			if(istype(src, /obj/structure/girder/reinforced))
				if(M.environment_smash == 3)
					var/remains = pick(/obj/item/stack/rods,/obj/item/stack/sheet/metal)
					new remains(loc)
					qdel(src)
					playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
					M << "<span class='notice'>You smash through the girder.</span>"
				else
					M << "<span class='warning'>This girder is far too strong for you to destroy.</span>"
			else
				playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
				M << "<span class='notice'>You smash through the girder.</span>"
				var/remains = pick(/obj/item/stack/rods,/obj/item/stack/sheet/metal)
				new remains(loc)
				qdel(src)
				return

/obj/structure/girder/displaced
	icon_state = "displaced"
	anchored = 0

/obj/structure/girder/reinforced
	icon_state = "reinforced"
	state = 2

/obj/structure/cultgirder
	icon= 'icons/obj/cult.dmi'
	icon_state= "cultgirder"
	anchored = 1
	density = 1
	layer = 2

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/wrench))
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			user << "<span class='notice'>Now disassembling the girder...</span>"
			if(do_after(user,40))
				user << "<span class='notice'>You dissasembled the girder!</span>"
				var/obj/effect/decal/remains/human/R = new (get_turf(src))
				transfer_fingerprints_to(R)
				qdel(src)

		else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
			user << "<span class='notice'>Now slicing apart the girder...</span>"
			if(do_after(user,30))
				user << "<span class='notice'>You slice apart the girder!</span>"
				var/obj/effect/decal/remains/human/R = new (get_turf(src))
				transfer_fingerprints_to(R)
				qdel(src)

		else if(istype(W, /obj/item/weapon/pickaxe/diamonddrill))
			user << "<span class='notice'>You drill through the girder!</span>"
			if(do_after(user, 5))
				var/obj/effect/decal/remains/human/R = new (get_turf(src))
				transfer_fingerprints_to(R)
				qdel(src)

	blob_act()
		if(prob(40))
			qdel(src)


	ex_act(severity)
		switch(severity)
			if(1.0)
				qdel(src)
				return
			if(2.0)
				if (prob(30))
					new /obj/effect/decal/remains/human(loc)
					qdel(src)
				return
			if(3.0)
				if (prob(5))
					new /obj/effect/decal/remains/human(loc)
					qdel(src)
				return
			else
		return