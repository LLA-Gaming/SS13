//Harddrive code//

/obj/item/device/thinktronic_parts/core
	name = "Computer Core"
	desc = "A Core Disk for portable ThinkTronic devices."
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

/obj/item/device/thinktronic_parts/core/New()
	cash = rand(2,10)
	cash *= 10
	new  /obj/item/device/thinktronic_parts/program/utility/atmosscan{DRM = 1}(src)
	new  /obj/item/device/thinktronic_parts/program/utility/emergency{DRM = 1}(src)
/obj/item/device/thinktronic_parts/core/plain/New() // Assistants + Any other job without a special cartridge
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/signaller{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/captain/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/pro{favorite = 1 alerts = 1}(src)
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
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec/pro(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/engineering/pro(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/science/pro(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/cargo/pro(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay/pro(src)
	new /obj/item/device/thinktronic_parts/program/sci/researchmonitor{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/eng/enginebuddy(src)
	new /obj/item/device/thinktronic_parts/program/medical/crewmonitor{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/cargo/cargobay(src)
	new /obj/item/device/thinktronic_parts/program/sec/brigcontrol{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/sci/borgmonitor{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

//medical
/obj/item/device/thinktronic_parts/core/cmo/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay/pro{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/medical/crewmonitor{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)
	new /obj/item/device/thinktronic_parts/program/medical/medrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/medical/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/medical/crewmonitor{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/medical/medrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/chemist/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/medical/medrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/reagentscanner(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/genetics/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/medical/crewmonitor{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/medical/medrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)
	new /obj/item/device/thinktronic_parts/program/utility/radscanner(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/virology/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/medical/medrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/medscanner(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

//security
/obj/item/device/thinktronic_parts/core/hos/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/securitron_control{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec/pro{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/brigcontrol{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/security/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/securitron_control{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/brigcontrol{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/warden/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/securitron_control{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec/pro{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/brigcontrol{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/detective/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/lawyer/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/brigcontrol{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 2 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/theoriontrail{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

//engineering
/obj/item/device/thinktronic_parts/core/ce/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/engineering/pro{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/eng/enginebuddy{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/eng/powermonitor{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/engineer/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/engineering{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/eng/enginebuddy{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/eng/powermonitor{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/atmos/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/engineering{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

//research
/obj/item/device/thinktronic_parts/core/rd/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sci/researchmonitor{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sci/borgmonitor{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/science/pro{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/utility/reagentscanner(src)
	new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)
	new /obj/item/device/thinktronic_parts/program/general/signaller{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/science/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sci/researchmonitor{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/science{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/utility/gasscanner(src)
	new /obj/item/device/thinktronic_parts/program/general/signaller{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/roboticist/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sci/borgmonitor{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/science{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

//cargo
/obj/item/device/thinktronic_parts/core/hop/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/cargo/mule_control{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/pro{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/engineering(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/science(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/cargo/pro(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay(src)
	new /obj/item/device/thinktronic_parts/program/cargo/cargobay{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/qm/New()
	..()
	new /obj/item/device/thinktronic_parts/program/cargo/mule_control{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/cargo/pro{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/cargo/cargobay{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/cargo/New()
	..()
	new /obj/item/device/thinktronic_parts/program/cargo/mule_control{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/cargo{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/cargo/cargobay{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/miner/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/cargo{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

//general
/obj/item/device/thinktronic_parts/core/bartender/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/hydro/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/chef/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/janitor/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/custodiallocator{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/library/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/chaplain/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/clown/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1 alerts = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/honk{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/spacebattle(src)
	new /obj/item/device/thinktronic_parts/program/general/theoriontrail(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)

/obj/item/device/thinktronic_parts/core/mime/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)
	ttone = "silence"

/obj/item/device/thinktronic_parts/core/medlaptop/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/medbay/pro{favorite = 1 alerts = 1 DRM = 1 deletable = 0}(src)
	new /obj/item/device/thinktronic_parts/program/medical/crewmonitor{favorite = 1 alerts = 1 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 2 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/medical/medrecords{favorite = 1 deletable = 0 DRM = 1}(src)

/obj/item/device/thinktronic_parts/core/seclaptop/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/securitron_control{favorite = 2 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/sec/pro{favorite = 1 alerts = 1 DRM = 1 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/brigcontrol{favorite = 1 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 2 deletable = 0 DRM = 1}(src)

/obj/item/device/thinktronic_parts/core/englaptop/New()
	..()
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/engineering/pro{favorite = 1 alerts = 1 DRM = 1 deletable = 0}(src)
	new /obj/item/device/thinktronic_parts/program/eng/enginebuddy{favorite = 1 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 2 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/eng/powermonitor{favorite = 1 deletable = 0 DRM = 1}(src)

/obj/item/device/thinktronic_parts/core/scilaptop/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sci/researchmonitor{favorite = 1 alerts = 1 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sci/borgmonitor{favorite = 1 alerts = 1 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/science/pro{favorite = 1 alerts = 1 DRM = 1 deletable = 0}(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/setstatus{favorite = 2 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/signaller{favorite = 2 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1 deletable = 0 DRM = 1}(src)

/obj/item/device/thinktronic_parts/core/cargolaptop/New()
	..()
	new /obj/item/device/thinktronic_parts/program/cargo/mule_control{favorite = 1 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager/cargo/pro{favorite = 1 alerts = 1 DRM = 1 deletable = 0}(src)
	new /obj/item/device/thinktronic_parts/program/cargo/cargobay{favorite = 1 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 2 deletable = 0 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 2 deletable = 0 DRM = 1}(src)

/obj/item/device/thinktronic_parts/core/ai/New()
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 1 DRM = 1 deletable = 0}(src)
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 1 DRM = 1 deletable = 0}(src)
	new /obj/item/device/thinktronic_parts/program/medical/medrecords{favorite = 1 DRM = 1 deletable = 0}(src)
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1 DRM = 1 deletable = 0}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2 DRM = 1 deletable = 0}(src)
	cash = 65530
	toner = 0

/obj/item/device/thinktronic_parts/core/pai/New()
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/taskmanager{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/spacebattle{favorite = 2 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/theoriontrail{favorite = 2 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2 DRM = 1 deletable = 0}(src)
	cash = 0
	toner = 0

/obj/item/device/thinktronic_parts/core/public/New()
	new /obj/item/device/thinktronic_parts/program/general/notekeeper{favorite = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/spacebattle{favorite = 2 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/theoriontrail{favorite = 2 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 1}(src)
	cash = 0
	toner = 0

/obj/item/device/thinktronic_parts/core/syndi/New()
	new /obj/item/device/thinktronic_parts/program/general/hackingtools{favorite = 1 DRM = 1}(src)
	messengeron = 0
	neton = 0
	cash = 0
	toner = 0

/obj/item/device/thinktronic_parts/core/perc/New()
	..()
	new /obj/item/device/thinktronic_parts/program/sec/percblastdoors{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/percimplants{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/percmissions{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/sec/percshuttlelock{favorite = 1 DRM = 1}(src)
	new /obj/item/device/thinktronic_parts/program/general/crewmanifest{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/sec/secrecords{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/sec/brigcontrol{favorite = 2}(src)
	new /obj/item/device/thinktronic_parts/program/general/chatroom{favorite = 2}(src)
	primaryname = "Perc-Tech"
	secondaryname = "Station Equipment"
	messengeron = 0
	implantlocked = /obj/item/weapon/implant/enforcer

/obj/item/device/thinktronic_parts/core/perclaptop/New()
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
