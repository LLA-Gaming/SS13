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
	var/banned = 0
	var/implantlocked = 0

	//Programloading
	var/obj/item/device/thinktronic_parts/program/activeprog = null
	var/mode = 0

//All harddrives

/obj/item/device/thinktronic_parts/HDD/New()
	cash = rand(2,10)
	cash *= 10
	new  /obj/item/device/thinktronic_parts/program/utility/atmosscan{DRM = 1}(src)
/obj/item/device/thinktronic_parts/HDD/plain/New() // Assistants + Any other job without a special cartridge
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/signaller{favorite = 2}(src)

/obj/item/device/thinktronic_parts/HDD/captain/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/eng/powermonitor(src)
	new /obj/item/device/thinktronic_parts/program/medical/medrecords(src)
	new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/sec/securitron_control{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/cargo/mule_control(src)
	new /obj/item/device/thinktronic_parts/program/utility/reagentscanner(src)
	new /obj/item/device/thinktronic_parts/program/utility/radscanner(src)
	new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)
	new /obj/item/device/thinktronic_parts/program/general/signaller(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/engineering(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/science(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/cargo(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay(src)
	new /obj/item/device/thinktronic_parts/program/sci/researchmonitor{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/eng/enginebuddy(src)
	new /obj/item/device/thinktronic_parts/program/sci/crewmonitor{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/cargo/cargobay(src)
	new /obj/item/device/thinktronic_parts/program/sec/brigcontrol{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/sci/borgmonitor{favorite = 2}(src)

//medical
/obj/item/device/thinktronic_parts/HDD/cmo/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sci/crewmonitor{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 2}(src)
/obj/item/device/thinktronic_parts/HDD/medical/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sci/crewmonitor{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/medical/medrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)
/obj/item/device/thinktronic_parts/HDD/chemist/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/medical/medrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/reagentscanner(src)
/obj/item/device/thinktronic_parts/HDD/genetics/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sci/crewmonitor{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/medical/medrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)
	new /obj/item/device/thinktronic_parts/program/utility/radscanner(src)
/obj/item/device/thinktronic_parts/HDD/virology/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/medical/medrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)

//security
/obj/item/device/thinktronic_parts/HDD/hos/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/securitron_control{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/brigcontrol{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 2}(src)
/obj/item/device/thinktronic_parts/HDD/security/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/securitron_control{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/brigcontrol{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/warden/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/securitron_control{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/brigcontrol{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/detective/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/lawyer/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/theoriontrail{favorite = 2}(src)
//engineering
/obj/item/device/thinktronic_parts/HDD/ce/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/engineering{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/eng/enginebuddy{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/eng/powermonitor{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)
/obj/item/device/thinktronic_parts/HDD/engineer/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/engineering{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/eng/enginebuddy{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/eng/powermonitor{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/atmos/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/engineering{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)
//research
/obj/item/device/thinktronic_parts/HDD/rd/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sci/researchmonitor{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sci/borgmonitor{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/science{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/utility/reagentscanner(src)
	new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)
	new /obj/item/device/thinktronic_parts/program/general/signaller{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/science/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sci/researchmonitor{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/science{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)
	new /obj/item/device/thinktronic_parts/program/general/signaller{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/roboticist/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sci/borgmonitor{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/science{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
//cargo
/obj/item/device/thinktronic_parts/HDD/hop/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/cargo/mule_control{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/engineering(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/science(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/cargo(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay(src)
	new /obj/item/device/thinktronic_parts/program/cargo/cargobay{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/qm/New()
	..()
	new /obj/item/device/thinktronic_parts/program/cargo/mule_control{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/cargo{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/cargo/cargobay{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 2}(src)
/obj/item/device/thinktronic_parts/HDD/cargo/New()
	..()
	new /obj/item/device/thinktronic_parts/program/cargo/mule_control{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/cargo{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/cargo/cargobay{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 2}(src)
/obj/item/device/thinktronic_parts/HDD/miner/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/cargo{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
//general
/obj/item/device/thinktronic_parts/HDD/bartender/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/hydro/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/chef/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/janitor/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/custodiallocator{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/library/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/chaplain/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
/obj/item/device/thinktronic_parts/HDD/clown/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/honk{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/spacebattle(src)
	new /obj/item/device/thinktronic_parts/program/general/theoriontrail(src)
/obj/item/device/thinktronic_parts/HDD/mime/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)


/obj/item/device/thinktronic_parts/HDD/ai/New()
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/medical/medrecords{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1 DRM = 1}(src)
	cash = 65530
	toner = 0

/obj/item/device/thinktronic_parts/HDD/pai/New()
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/spacebattle{favorite = 2 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/theoriontrail{favorite = 2 DRM = 1}(src)
	cash = 0
	toner = 0

/obj/item/device/thinktronic_parts/HDD/public/New()
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/spacebattle{favorite = 2 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/theoriontrail{favorite = 2 DRM = 1}(src)
	cash = 0
	toner = 0

/obj/item/device/thinktronic_parts/HDD/syndi/New()
	new /obj/item/device/thinktronic_parts/program/general/hackingtools{favorite = 1 DRM = 1}(src)
	messengeron = 0
	neton = 0
	cash = 0
	toner = 0

/obj/item/device/thinktronic_parts/HDD/perc/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/percblastdoors{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/percimplants{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/percmissions{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/percshuttlelock{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/sec/brigcontrol{favorite = 2}(src)
	primaryname = "Perc-Tech"
	secondaryname = "Station Equipment"
	messengeron = 0
	implantlocked = /obj/item/weapon/implant/enforcer

/obj/item/device/thinktronic_parts/HDD/perclaptop/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/percblastdoors{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/percimplants{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/percmissions{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/percshuttlelock{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/sec/brigcontrol{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/spacebattle{favorite = 2 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/theoriontrail{favorite = 2 DRM = 1}(src)
	primaryname = "Perc-Tech"
	secondaryname = "Station Equipment"
	messengeron = 0
	implantlocked = /obj/item/weapon/implant/enforcer