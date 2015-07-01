/obj/item/device/tablet_carts/
	name = "generic cartridge"
	desc = "A data cartridge for portable computers."
	icon = 'icons/obj/pda.dmi'
	icon_state = "cart"
	item_state = "electronic"
	w_class = 1
	var/usedup = 0
	var/list/programs = list()

	engineering
		name = "\improper Power-ON cartridge"
		icon_state = "cart-e"
		New()
			programs.Add(new /datum/program/powermonitor)
			programs.Add(new /datum/program/enginebuddy)

	atmos
		name = "\improper BreatheDeep cartridge"
		icon_state = "cart-a"
		New()
			programs.Add(new /datum/program/gasscanner)

	medical
		name = "\improper Med-U cartridge"
		icon_state = "cart-m"
		New()
			programs.Add(new /datum/program/medrecords)
			programs.Add(new /datum/program/medicalscanner)
			programs.Add(new /datum/program/crewmonitor)

	chemistry
		name = "\improper ChemWhiz cartridge"
		icon_state = "cart-chem"
		New()
			programs.Add(new /datum/program/reagentscanner)

	security
		name = "\improper R.O.B.U.S.T. cartridge"
		icon_state = "cart-s"
		New()
			programs.Add(new /datum/program/secrecords)
			programs.Add(new /datum/program/securitron_control)
			programs.Add(new /datum/program/brigcontrol)

	detective
		name = "\improper D.E.T.E.C.T. cartridge"
		icon_state = "cart-s"
		New()
			programs.Add(new /datum/program/crewmanifest)
			programs.Add(new /datum/program/secrecords)

	janitor
		name = "\improper CustodiPRO cartridge"
		desc = "The ultimate in clean-room design."
		icon_state = "cart-j"
		New()
			programs.Add(new /datum/program/custodiallocator)

	lawyer
		name = "\improper P.R.O.V.E. cartridge"
		icon_state = "cart-s"
		New()
			programs.Add(new /datum/program/crewmanifest)
			programs.Add(new /datum/program/secrecords)

	clown
		name = "\improper Honkworks 5.0 cartridge"
		icon_state = "cart-clown"
		New()
			programs.Add(new /datum/program/honk)
			programs.Add(new /datum/program/spacebattle)
			programs.Add(new /datum/program/theoriontrail)

	mime
		name = "\improper Gestur-O 1000 cartridge"
		icon_state = "cart-mi"
		New()
			programs.Add(new /datum/program/spacebattle)
			programs.Add(new /datum/program/theoriontrail)

	signal
		name = "generic signaler cartridge"
		desc = "A data cartridge with an integrated radio signaler module."
		New()
			programs.Add(new /datum/program/signaller)

	toxins
		name = "\improper Research-n-Development cartridge"
		desc = "Complete with integrated radio signaler!"
		icon_state = "cart-tox"
		New()
			programs.Add(new /datum/program/signaller)
			programs.Add(new /datum/program/researchmonitor)
			programs.Add(new /datum/program/borgmonitor)

	quartermaster
		name = "space parts & space vendors cartridge"
		desc = "Perfect for the Quartermaster on the go!"
		icon_state = "cart-q"
		New()
			programs.Add(new /datum/program/mule_control)
			programs.Add(new /datum/program/cargobay)


	head
		name = "\improper Easy-Record DELUXE cartridge"
		icon_state = "cart-h"
		New()
			programs.Add(new /datum/program/crewmanifest)
			programs.Add(new /datum/program/setstatus)

	hop
		name = "\improper HumanResources9001 cartridge"
		icon_state = "cart-h"
		New()
			programs.Add(new /datum/program/crewmanifest)
			programs.Add(new /datum/program/setstatus)
			programs.Add(new /datum/program/secrecords)
			programs.Add(new /datum/program/mule_control)
			programs.Add(new /datum/program/cargobay)

	hos
		name = "\improper R.O.B.U.S.T. DELUXE cartridge"
		icon_state = "cart-hos"
		New()
			programs.Add(new /datum/program/crewmanifest)
			programs.Add(new /datum/program/setstatus)
			programs.Add(new /datum/program/secrecords)
			programs.Add(new /datum/program/securitron_control)
			programs.Add(new /datum/program/brigcontrol)

	ce
		name = "\improper Power-On DELUXE cartridge"
		icon_state = "cart-ce"
		New()
			programs.Add(new /datum/program/crewmanifest)
			programs.Add(new /datum/program/setstatus)
			programs.Add(new /datum/program/powermonitor)
			programs.Add(new /datum/program/gasscanner)
			programs.Add(new /datum/program/enginebuddy)

	cmo
		name = "\improper Med-U DELUXE cartridge"
		icon_state = "cart-cmo"
		New()
			programs.Add(new /datum/program/crewmanifest)
			programs.Add(new /datum/program/setstatus)
			programs.Add(new /datum/program/medrecords)
			programs.Add(new /datum/program/medicalscanner)
			programs.Add(new /datum/program/reagentscanner)
			programs.Add(new /datum/program/radscanner)
			programs.Add(new /datum/program/crewmonitor)

	rd
		name = "\improper Research-n-Development DELUXE cartridge"
		icon_state = "cart-rd"
		New()
			programs.Add(new /datum/program/crewmanifest)
			programs.Add(new /datum/program/setstatus)
			programs.Add(new /datum/program/reagentscanner)
			programs.Add(new /datum/program/gasscanner)
			programs.Add(new /datum/program/signaller)
			programs.Add(new /datum/program/researchmonitor)
			programs.Add(new /datum/program/borgmonitor)
	captain
		name = "\improper Value-PAK cartridge"
		desc = "Now with 200% more value!"
		icon_state = "cart-c"
		New()
			programs.Add(new /datum/program/crewmanifest)
			programs.Add(new /datum/program/setstatus)
			programs.Add(new /datum/program/powermonitor)
			programs.Add(new /datum/program/medrecords)
			programs.Add(new /datum/program/medicalscanner)
			programs.Add(new /datum/program/secrecords)
			programs.Add(new /datum/program/securitron_control)
			programs.Add(new /datum/program/mule_control)
			programs.Add(new /datum/program/reagentscanner)
			programs.Add(new /datum/program/radscanner)
			programs.Add(new /datum/program/gasscanner)
			programs.Add(new /datum/program/signaller)
			programs.Add(new /datum/program/researchmonitor)
			programs.Add(new /datum/program/enginebuddy)
			programs.Add(new /datum/program/crewmonitor)
			programs.Add(new /datum/program/cargobay)
			programs.Add(new /datum/program/brigcontrol)
			programs.Add(new /datum/program/borgmonitor)


	everything
		name = "\improper Super Ultra Value-PAK cartridge"
		desc = "Now with 300% more value!"
		icon_state = "cart-c"
		New()
			programs.Add(new /datum/program/honk)
			programs.Add(new /datum/program/crewmanifest)
			programs.Add(new /datum/program/setstatus)
			programs.Add(new /datum/program/powermonitor)
			programs.Add(new /datum/program/medrecords)
			programs.Add(new /datum/program/medicalscanner)
			programs.Add(new /datum/program/secrecords)
			programs.Add(new /datum/program/securitron_control)
			programs.Add(new /datum/program/mule_control)
			programs.Add(new /datum/program/custodiallocator)
			programs.Add(new /datum/program/reagentscanner)
			programs.Add(new /datum/program/radscanner)
			programs.Add(new /datum/program/gasscanner)
			programs.Add(new /datum/program/signaller)
			programs.Add(new /datum/program/notekeeper)
			programs.Add(new /datum/program/spacebattle)
			programs.Add(new /datum/program/spacebattle/cubanpete)
			programs.Add(new /datum/program/theoriontrail)
			programs.Add(new /datum/program/researchmonitor)
			programs.Add(new /datum/program/enginebuddy)
			programs.Add(new /datum/program/crewmonitor)
			programs.Add(new /datum/program/cargobay)
			programs.Add(new /datum/program/brigcontrol)
			programs.Add(new /datum/program/borgmonitor)

	syndicate
		name = "\improper SyndiHax cartridge"
		icon_state = "cart"
		New()
			programs.Add(new /datum/program/hackingtools)
			programs.Add(new /datum/program/crewmanifest)
			programs.Add(new /datum/program/setstatus)

	perseus
		name = "PercTech Cartridge"
		icon_state = "cart-perc"
		New()
			..()
			programs.Add(new /datum/program/percblastdoors)
			programs.Add(new /datum/program/percimplants)
			programs.Add(new /datum/program/percmissions)
			programs.Add(new /datum/program/percshuttlelock)