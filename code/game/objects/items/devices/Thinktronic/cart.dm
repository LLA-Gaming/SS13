/obj/item/device/thinktronic_parts/expansioncarts/
	name = "generic cartridge"
	desc = "A data cartridge for portable microcomputers."
	icon = 'icons/obj/pda.dmi'
	icon_state = "cart"
	item_state = "electronic"
	w_class = 1
	var/usedup = 0

	engineering
		name = "\improper Power-ON cartridge"
		icon_state = "cart-e"
		New()
			new /obj/item/device/thinktronic_parts/program/eng/powermonitor(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/engineering(src)
			new /obj/item/device/thinktronic_parts/program/eng/enginebuddy(src)

	atmos
		name = "\improper BreatheDeep cartridge"
		icon_state = "cart-a"
		New()
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/engineering(src)
			new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)

	medical
		name = "\improper Med-U cartridge"
		icon_state = "cart-m"
		New()
			new /obj/item/device/thinktronic_parts/program/medical/medrecords(src)
			new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay(src)
			new /obj/item/device/thinktronic_parts/program/medical/crewmonitor(src)

	chemistry
		name = "\improper ChemWhiz cartridge"
		icon_state = "cart-chem"
		New()
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay(src)
			new /obj/item/device/thinktronic_parts/program/utility/reagentscanner(src)

	security
		name = "\improper R.O.B.U.S.T. cartridge"
		icon_state = "cart-s"
		New()
			new /obj/item/device/thinktronic_parts/program/sec/secrecords(src)
			new /obj/item/device/thinktronic_parts/program/sec/securitron_control(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec(src)
			new /obj/item/device/thinktronic_parts/program/sec/brigcontrol(src)

	detective
		name = "\improper D.E.T.E.C.T. cartridge"
		icon_state = "cart-s"
		New()
			new /obj/item/device/thinktronic_parts/program/general/crewmanifest(src)
			new /obj/item/device/thinktronic_parts/program/sec/secrecords(src)

	janitor
		name = "\improper CustodiPRO cartridge"
		desc = "The ultimate in clean-room design."
		icon_state = "cart-j"
		New()
			new /obj/item/device/thinktronic_parts/program/general/custodiallocator(src)

	lawyer
		name = "\improper P.R.O.V.E. cartridge"
		icon_state = "cart-s"
		New()
			new /obj/item/device/thinktronic_parts/program/general/crewmanifest(src)
			new /obj/item/device/thinktronic_parts/program/sec/secrecords(src)

	clown
		name = "\improper Honkworks 5.0 cartridge"
		icon_state = "cart-clown"
		New()
			new /obj/item/device/thinktronic_parts/program/general/honk(src)
			new /obj/item/device/thinktronic_parts/program/general/spacebattle(src)
			new /obj/item/device/thinktronic_parts/program/general/theoriontrail(src)

	mime
		name = "\improper Gestur-O 1000 cartridge"
		icon_state = "cart-mi"
		New()
			new /obj/item/device/thinktronic_parts/program/general/spacebattle(src)
			new /obj/item/device/thinktronic_parts/program/general/theoriontrail(src)

	signal
		name = "generic signaler cartridge"
		desc = "A data cartridge with an integrated radio signaler module."
		New()
			new /obj/item/device/thinktronic_parts/program/general/signaller(src)

	toxins
		name = "\improper Research-n-Development cartridge"
		desc = "Complete with integrated radio signaler!"
		icon_state = "cart-tox"
		New()
			new /obj/item/device/thinktronic_parts/program/general/signaller(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/science(src)
			new /obj/item/device/thinktronic_parts/program/sci/researchmonitor(src)
			new /obj/item/device/thinktronic_parts/program/sci/borgmonitor(src)

	quartermaster
		name = "space parts & space vendors cartridge"
		desc = "Perfect for the Quartermaster on the go!"
		icon_state = "cart-q"
		New()
			new /obj/item/device/thinktronic_parts/program/cargo/mule_control(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/cargo(src)
			new /obj/item/device/thinktronic_parts/program/cargo/cargobay(src)


	head
		name = "\improper Easy-Record DELUXE cartridge"
		icon_state = "cart-h"
		New()
			new /obj/item/device/thinktronic_parts/program/general/crewmanifest(src)
			new /obj/item/device/thinktronic_parts/program/general/setstatus(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/pro(src)

	hop
		name = "\improper HumanResources9001 cartridge"
		icon_state = "cart-h"
		New()
			new /obj/item/device/thinktronic_parts/program/general/crewmanifest(src)
			new /obj/item/device/thinktronic_parts/program/general/setstatus(src)
			new /obj/item/device/thinktronic_parts/program/sec/secrecords(src)
			new /obj/item/device/thinktronic_parts/program/cargo/mule_control(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/pro(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/engineering(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/science(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/cargo(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay(src)
			new /obj/item/device/thinktronic_parts/program/cargo/cargobay(src)

	hos
		name = "\improper R.O.B.U.S.T. DELUXE cartridge"
		icon_state = "cart-hos"
		New()
			new /obj/item/device/thinktronic_parts/program/general/crewmanifest(src)
			new /obj/item/device/thinktronic_parts/program/general/setstatus(src)
			new /obj/item/device/thinktronic_parts/program/sec/secrecords(src)
			new /obj/item/device/thinktronic_parts/program/sec/securitron_control(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec/pro(src)
			new /obj/item/device/thinktronic_parts/program/sec/brigcontrol(src)

	ce
		name = "\improper Power-On DELUXE cartridge"
		icon_state = "cart-ce"
		New()
			new /obj/item/device/thinktronic_parts/program/general/crewmanifest(src)
			new /obj/item/device/thinktronic_parts/program/general/setstatus(src)
			new /obj/item/device/thinktronic_parts/program/eng/powermonitor(src)
			new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/engineering/pro(src)
			new /obj/item/device/thinktronic_parts/program/eng/enginebuddy(src)

	cmo
		name = "\improper Med-U DELUXE cartridge"
		icon_state = "cart-cmo"
		New()
			new /obj/item/device/thinktronic_parts/program/general/crewmanifest(src)
			new /obj/item/device/thinktronic_parts/program/general/setstatus(src)
			new /obj/item/device/thinktronic_parts/program/medical/medrecords(src)
			new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)
			new /obj/item/device/thinktronic_parts/program/utility/reagentscanner(src)
			new /obj/item/device/thinktronic_parts/program/utility/radscanner(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay/pro(src)
			new /obj/item/device/thinktronic_parts/program/medical/crewmonitor(src)

	rd
		name = "\improper Research-n-Development DELUXE cartridge"
		icon_state = "cart-rd"
		New()
			new /obj/item/device/thinktronic_parts/program/general/crewmanifest(src)
			new /obj/item/device/thinktronic_parts/program/general/setstatus(src)
			new /obj/item/device/thinktronic_parts/program/utility/reagentscanner(src)
			new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)
			new /obj/item/device/thinktronic_parts/program/general/signaller(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/science/pro(src)
			new /obj/item/device/thinktronic_parts/program/sci/researchmonitor(src)
			new /obj/item/device/thinktronic_parts/program/sci/borgmonitor(src)
	captain
		name = "\improper Value-PAK cartridge"
		desc = "Now with 200% more value!"
		icon_state = "cart-c"
		New()
			new /obj/item/device/thinktronic_parts/program/general/crewmanifest(src)
			new /obj/item/device/thinktronic_parts/program/general/setstatus(src)
			new /obj/item/device/thinktronic_parts/program/eng/powermonitor(src)
			new /obj/item/device/thinktronic_parts/program/medical/medrecords(src)
			new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)
			new /obj/item/device/thinktronic_parts/program/sec/secrecords(src)
			new /obj/item/device/thinktronic_parts/program/sec/securitron_control(src)
			new /obj/item/device/thinktronic_parts/program/cargo/mule_control(src)
			new /obj/item/device/thinktronic_parts/program/utility/reagentscanner(src)
			new /obj/item/device/thinktronic_parts/program/utility/radscanner(src)
			new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)
			new /obj/item/device/thinktronic_parts/program/general/signaller(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/pro(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec/pro(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/engineering/pro(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/science/pro(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/cargo/pro(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay/pro(src)
			new /obj/item/device/thinktronic_parts/program/sci/researchmonitor(src)
			new /obj/item/device/thinktronic_parts/program/eng/enginebuddy(src)
			new /obj/item/device/thinktronic_parts/program/medical/crewmonitor(src)
			new /obj/item/device/thinktronic_parts/program/cargo/cargobay(src)
			new /obj/item/device/thinktronic_parts/program/sec/brigcontrol(src)
			new /obj/item/device/thinktronic_parts/program/sci/borgmonitor(src)


	everything
		name = "\improper Super Ultra Value-PAK cartridge"
		desc = "Now with 300% more value!"
		icon_state = "cart-c"
		New()
			new /obj/item/device/thinktronic_parts/program/general/honk(src)
			new /obj/item/device/thinktronic_parts/program/general/crewmanifest(src)
			new /obj/item/device/thinktronic_parts/program/general/setstatus(src)
			new /obj/item/device/thinktronic_parts/program/eng/powermonitor(src)
			new /obj/item/device/thinktronic_parts/program/medical/medrecords(src)
			new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)
			new /obj/item/device/thinktronic_parts/program/sec/secrecords(src)
			new /obj/item/device/thinktronic_parts/program/sec/securitron_control(src)
			new /obj/item/device/thinktronic_parts/program/cargo/mule_control(src)
			new /obj/item/device/thinktronic_parts/program/general/custodiallocator(src)
			new /obj/item/device/thinktronic_parts/program/utility/reagentscanner(src)
			new /obj/item/device/thinktronic_parts/program/utility/radscanner(src)
			new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)
			new /obj/item/device/thinktronic_parts/program/general/signaller(src)
			new /obj/item/device/thinktronic_parts/program/general/notekeeper(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/engineering(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/science(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/cargo(src)
			new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay(src)
			new /obj/item/device/thinktronic_parts/program/general/spacebattle(src)
			new /obj/item/device/thinktronic_parts/program/general/spacebattle/cubanpete(src)
			new /obj/item/device/thinktronic_parts/program/general/theoriontrail(src)
			new /obj/item/device/thinktronic_parts/program/sci/researchmonitor(src)
			new /obj/item/device/thinktronic_parts/program/eng/enginebuddy(src)
			new /obj/item/device/thinktronic_parts/program/medical/crewmonitor(src)
			new /obj/item/device/thinktronic_parts/program/cargo/cargobay(src)
			new /obj/item/device/thinktronic_parts/program/sec/brigcontrol(src)
			new /obj/item/device/thinktronic_parts/program/sci/borgmonitor(src)
			new /obj/item/device/thinktronic_parts/program/general/timer(src)

	syndicate
		name = "\improper SyndiHax cartridge"
		icon_state = "cart"
		New()
			new /obj/item/device/thinktronic_parts/program/general/hackingtools(src)
			new /obj/item/device/thinktronic_parts/program/general/crewmanifest(src)
			new /obj/item/device/thinktronic_parts/program/general/setstatus(src)