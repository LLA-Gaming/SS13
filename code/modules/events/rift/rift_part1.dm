/datum/round_event/task/xeno_artifact_research
	task_name = "Xeno Artifact Research"
	task_desc = "todo: desc"

	Setup()
		special_npc_name = "CentComm Commander [pick(last_names)]"
		start_when		= rand(1800,9000)
		alert_when		= start_when
		goals.Add(/obj/item/weapon/disk/research_data)
		..()

	Start()
		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = supply_shuttle.ordernum
		O.object = new /datum/supply_packs/xeno_artifact
		O.orderedby = "Centcomm"
		supply_shuttle.requestlist += O