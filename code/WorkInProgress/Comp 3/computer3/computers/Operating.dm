/obj/machinery/computer3/operating
	default_prog = /datum/file/program/op_monitor
	spawn_parts = list(/obj/item/part/computer/storage/hdd,/obj/item/part/computer/networking/prox)
	icon_state = "frame-med"

/datum/file/program/op_monitor
	name = "operating table monitor"
	desc = "Monitors patient status during surgery."
	active_state = "operating"
	var/mob/living/carbon/human/patient = null
	var/obj/structure/optable/table = null


/datum/file/program/op_monitor/interact()
	if(!interactable())
		return
	if(!computer.net)
		computer.Crash(MISSING_PERIPHERAL)
		return
	table = computer.net.connect_to(/obj/structure/optable,table)

	var/dat = ""
	if(table)
		dat += "<B>Patient information:</B><BR>"
		if(table.check_patient())
			patient = table.patient
			dat += {"<B>Patient Status:</B> [patient.stat ? "Non-Responsive" : "Stable"]<BR>
					<B>Blood Type:</B> [patient.b_type]<BR>
					<BR>
					<B>Health:</B> [round(patient.health)]<BR>
					<B>Brute Damage:</B> [round(patient.getBruteLoss())]<BR>
					<B>Toxins Damage:</B> [round(patient.getToxLoss())]<BR>
					<B>Fire Damage:</B> [round(patient.getFireLoss())]<BR>
					<B>Suffocation Damage:</B> [round(patient.getOxyLoss())]<BR>
					"}
			if(patient.surgeries.len)
				dat += "<BR><B>Initiated Procedures:</B><BR>"
				for(var/datum/surgery/procedure in patient.surgeries)
					dat += "[procedure.name]<BR>"
		else
			patient = null
			dat += "<B>No patient detected</B>"
	else
		dat += "<B>Operating table not found.</B>"

	popup.set_content(dat)
	popup.open()
/datum/file/program/op_monitor/Topic()
	if(!interactable())
		return
	..()