/obj/item/weapon/pod_attachment

	GetAvailableKeybinds()
		return list(P_ATTACHMENT_KEYBIND_SINGLE, P_ATTACHMENT_KEYBIND_SHIFT, P_ATTACHMENT_KEYBIND_CTRL, P_ATTACHMENT_KEYBIND_ALT,
					P_ATTACHMENT_KEYBIND_MIDDLE, P_ATTACHMENT_KEYBIND_CTRLSHIFT)

	primary/
		name = "primary attachment"
		hardpoint_slot = P_HARDPOINT_PRIMARY_ATTACHMENT
		keybind = P_ATTACHMENT_KEYBIND_SINGLE

		GetOverlay(var/list/size = list())
			. = ..()
			if(attached_to && istype(attached_to.GetAttachmentOnHardpoint(P_HARDPOINT_SECONDARY_ATTACHMENT), /obj/item/weapon/pod_attachment/secondary/gimbal))
				return 0

		projectile/
			var/projectile = /obj/item/projectile
			var/dual_projectile = 1

			Use(var/atom/target, var/mob/user, var/flags = P_ATTACHMENT_PLAYSOUND)
				if(!..(target, user, flags))
					return 0

				if(projectile)
					var/gimbal = istype(attached_to.GetAttachmentOnHardpoint(P_HARDPOINT_SECONDARY_ATTACHMENT), /obj/item/weapon/pod_attachment/secondary/gimbal)

					if(dual_projectile)
						if(!HasPower(power_usage))
							attached_to.PrintSystemAlert("Insufficient energy.")
							return 0

						UsePower(power_usage)

					var/turf/pod_turf = get_turf(attached_to)

					var/list/start_points = list()
					var/list/targets = list()
					if(gimbal)
						var/direction = get_dir(pod_turf, get_turf(target))
						var/angle = dir2angle(direction)
						if((angle % 90) != 0)
							direction = angle2dir((angle == 45) ? (angle + 45) : (angle - 45))
						start_points = attached_to.GetDirectionalTurfs(direction)
						for(var/i = 1 to length(start_points))
							targets.Add(target)
					else
						start_points = attached_to.GetDirectionalTurfs(attached_to.dir)
						var/step_direction = get_dir(pod_turf, start_points[1])
						for(var/i = 1 to length(start_points))
							targets.Add(get_step(start_points[i], step_direction))

					for(var/turf/T in start_points)
						var/obj/item/projectile/P = new projectile(T)
						var/index = start_points.Find(T)
						P.firer = attached_to.pilot
						var/turf/target_turf = get_turf(targets[index])
						P.original = targets[index]
						P.current = start_points[index]
						P.yo = target_turf.y - T.y
						P.xo = target_turf.x - T.x
						P.process()

					var/list/additions[length(targets)]
					for(var/atom/A in targets)
						additions[targets.Find(A)] = "(DIR: [dir2text(get_dir(pod_turf, A))])[isliving(A) ? " (MOB-TARGET: [key_name(A)])" : ""]"

					attached_to.pod_log.LogUsage(user, src, targets, additions)

				return 1