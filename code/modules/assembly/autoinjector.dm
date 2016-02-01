/obj/item/device/assembly/autoinjector
	name = "auto-injector"
	desc = "A hastily wired up syringe."
	icon_state = "autoinjector"
	g_amt = 500
	m_amt = 500
	flags = OPENCONTAINER
	var/obj/item/weapon/reagent_containers/syringe/loaded

	New()
		..()
		create_reagents(15)

	attackby(obj/item/I, mob/user)
		if(istype(I, /obj/item/weapon/wirecutters))
			loaded.loc = get_turf(src)
			qdel(src)
		else
			..()

	proc/Inject(var/mob/living/L)
		if(!reagents || reagents.total_volume <= 0)
			return 0

		playsound(get_turf(src), 'sound/effects/refill.ogg', 100, 1)
		L << "<span class='warning'>You feel a tiny prick!</span>"

		var/list/injected = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			injected += R.name

		add_logs(L, null, "auto-injected", object=src.name, addition="([english_list(injected)])")
		reagents.trans_to(L, reagents.total_volume)

	activate()
		if(!holder)
			return 0

		if(istype(holder.loc, /mob/living))
			var/mob/living/L = holder.loc
			Inject(L)

	examine()
		..()

		var/list/contains = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			contains += R.name

		usr << "Contains: [english_list(contains)]"