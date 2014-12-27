//Harddrive code//

/obj/item/device/thinktronic_parts/HDD
	name = "Hard Drive"
	desc = "A Hard Drive Disk for portable microcomputers."
	icon = 'icons/obj/module.dmi'
	icon_state = "mainboard"
	w_class = 1

	//User data
	var/owner = null // String name of owner
	var/ownjob = null //related to above
	var/usergroup = "None"
	var/list/documents = list() // save your notes and photos
	var/primaryname = "Primary Applications"
	var/secondaryname = "Secondary Applications"
	var/cash = 20
	var/neton = 1 // Check if network settings are on
	var/ttone = "beep"
	var/messengeron = 1 //Is the messenger on?
	var/obj/item/device/thinktronic_parts/data/convo/activechat = null
	var/toner = 30
	var/volume = 1

	//Programloading
	var/obj/item/device/thinktronic_parts/program/activeprog = null
	var/mode = 0


//All harddrives
/obj/item/device/thinktronic_parts/HDD/debug/New() // Assistants + Any other job without a special cartridge
	cash = rand(2,10)
	cash *= 10
	new /obj/item/device/thinktronic_parts/program/utility/atmosscan(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest(src)
	new /obj/item/device/thinktronic_parts/program/general/magic8ball(src)
	new /obj/item/device/thinktronic_parts/program/medical/medrecords(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper(src)
	new /obj/item/device/thinktronic_parts/program/general/theoriontrail(src)
	new /obj/item/device/thinktronic_parts/program/eng/powermonitor(src)
	new /obj/item/device/thinktronic_parts/program/sec/secrecords(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus(src)
	new /obj/item/device/thinktronic_parts/program/general/spacebattle(src)
	new /obj/item/device/thinktronic_parts/program/general/signaller(src)
	new /obj/item/device/thinktronic_parts/program/general/custodiallocator(src)
	new /obj/item/device/thinktronic_parts/program/general/honk(src)
	new /obj/item/device/thinktronic_parts/program/cargo/mule_control(src)
	new /obj/item/device/thinktronic_parts/program/sec/securitron_control(src)
	new /obj/item/device/thinktronic_parts/program/cargo/supplyrecords(src)
	new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)
	new /obj/item/device/thinktronic_parts/program/utility/radscanner(src)
	new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)
	new /obj/item/device/thinktronic_parts/program/utility/reagentscanner(src)

/obj/item/device/thinktronic_parts/HDD/New() // Assistants + Any other job without a special cartridge
	cash = rand(2,10)
	cash *= 10
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/utility/atmosscan(src)

/obj/item/device/thinktronic_parts/HDD/medical/New()
	..()
	new /obj/item/device/thinktronic_parts/program/medical/medrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)
/obj/item/device/thinktronic_parts/HDD/virology/New()
	..()
	new /obj/item/device/thinktronic_parts/program/medical/medrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)
/obj/item/device/thinktronic_parts/HDD/security/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/captain/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/medical/medrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/eng/powermonitor{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)
	new /obj/item/device/thinktronic_parts/program/utility/radscanner(src)
	new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)
	new /obj/item/device/thinktronic_parts/program/utility/reagentscanner(src)
/obj/item/device/thinktronic_parts/HDD/chaplain/New()
	..()
/obj/item/device/thinktronic_parts/HDD/clown/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/honk{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/engineer/New()
	..()
/obj/item/device/thinktronic_parts/HDD/janitor/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/custodiallocator{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/science/New()
	..()
/obj/item/device/thinktronic_parts/HDD/qm/New()
	..()
	new /obj/item/device/thinktronic_parts/program/cargo/supplyrecords{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/mime/New()
	..()
/obj/item/device/thinktronic_parts/HDD/hop/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/ce/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/eng/powermonitor{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/utility/radscanner(src)
	new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)
/obj/item/device/thinktronic_parts/HDD/cmo/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/medical/medrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)
	new /obj/item/device/thinktronic_parts/program/utility/radscanner(src)
	new /obj/item/device/thinktronic_parts/program/utility/reagentscanner(src)
/obj/item/device/thinktronic_parts/HDD/rd/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/utility/radscanner(src)
	new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)
	new /obj/item/device/thinktronic_parts/program/utility/reagentscanner(src)
/obj/item/device/thinktronic_parts/HDD/hos/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/sec/securitron_control{favorite = 2}(src)
/obj/item/device/thinktronic_parts/HDD/lawyer/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/hydro/New()
	..()
/obj/item/device/thinktronic_parts/HDD/roboticist/New()
	..()
/obj/item/device/thinktronic_parts/HDD/miner/New()
	..()
/obj/item/device/thinktronic_parts/HDD/library/New()
	..()
/obj/item/device/thinktronic_parts/HDD/atmos/New()
	..()
/obj/item/device/thinktronic_parts/HDD/genetics/New()
	..()
/obj/item/device/thinktronic_parts/HDD/chemist/New()
	..()
/obj/item/device/thinktronic_parts/HDD/warden/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/bartender/New()
	..()
/obj/item/device/thinktronic_parts/HDD/cargo/New()
	..()
	new /obj/item/device/thinktronic_parts/program/cargo/supplyrecords{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/chef/New()
	..()
/obj/item/device/thinktronic_parts/HDD/detective/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/ai/New()
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/medical/medrecords{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1 DRM = 1}(src)
	cash = 65530
	toner = 0


