var/datum/space_exploration_config/pod/pod_config

/datum/space_exploration_config/pod
	category = "Pod"

	var/damage_overlay_threshold
	var/ex_act_damage
	var/blob_act_damage
	var/emp_act_attachment_toggle_chance
	var/fire_damage
	var/fire_damage_cooldown
	var/damage_notice_cooldown
	var/fire_oxygen_consumption_percent
	var/fire_damage_oygen_cutoff
	var/emp_act_power_absorb_percent
	var/pod_pullout_delay
	var/list/drivable = list()
	var/metal_repair_threshold_percent
	var/welding_repair_amount
	var/metal_repair_amount