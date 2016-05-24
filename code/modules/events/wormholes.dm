/datum/round_event_control/wormholes
	name = "Wormholes"
	typepath = /datum/round_event/wormholes
	event_flags = EVENT_STANDARD
	max_occurrences = 3
	weight = 2


/datum/round_event/wormholes
	alert_when = 100
	end_when = 600

	var/list/pick_turfs = list()
	var/list/wormholes = list()
	var/shift_frequency = 3
	var/number_of_wormholes = 400

/datum/round_event/wormholes/

	SetTimers()
		alert_when = rand(0, 200)
		end_when = rand(400, 800)

	Start()
		if (!prevent_stories) EventStory("Wormholes started appearing suddenly around the station.")
		for(var/turf/simulated/floor/T in world)
			if(T.z == 1)
				pick_turfs += T

		for(var/i = 1, i <= number_of_wormholes, i++)
			var/turf/T = pick(pick_turfs)
			wormholes += new /obj/effect/portal/wormhole(T, null, null, -1)

	Alert()
		priority_announce("Space-time anomalies detected on the station. There is no additional data.", "Anomaly Alert", 'sound/AI/spanomalies.ogg')

	Tick()
		if(active_for % shift_frequency == 0)
			for(var/obj/effect/portal/wormhole/O in wormholes)
				var/turf/T = pick(pick_turfs)
				if(T)	O.loc = T

	End()
		portals.Remove(wormholes)
		for(var/obj/effect/portal/wormhole/O in wormholes)
			O.loc = null
		wormholes.Cut()


/obj/effect/portal/wormhole
	name = "wormhole"
	desc = "It looks highly unstable; It could close at any moment."
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"
/obj/effect/portal/wormhole/attack_hand(mob/user)
	teleport(user)
/obj/effect/portal/wormhole/attackby(obj/item/I, mob/user)
	teleport(user)
/obj/effect/portal/wormhole/teleport(atom/movable/M)
	if(istype(M, /obj/effect))	//sparks don't teleport
		return
	if(M.anchored && istype(M, /obj/mecha))
		return
	if(istype(M, /atom/movable))
		var/turf/target
		if(portals.len)
			var/obj/effect/portal/wormhole/P = locate() in shuffle(portals)
			if(P && isturf(P.loc))
				target = get_turf(P)
		if(!target)	return
		do_teleport(M, target, 1, 1, 0, 0) ///You will appear adjacent to the beacon