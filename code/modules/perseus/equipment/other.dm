/*
* Everything else goes here. (implants, barriers, etc)
*/


/*
* Implants
*/

/obj/item/weapon/implant/var/access = list()

/obj/item/weapon/implant
	GetAccess()
		return access

/obj/item/weapon/implant/enforcer
	name = "perseus enforcer implant"
	access = list(access_penforcer, access_brig,access_sec_doors, access_court, access_maint_tunnels, access_morgue, access_medical, access_construction, access_mailsorting,
	access_engine, access_research, access_security)


/obj/item/weapon/implant/commander
	name = "perseus commander implant"
	access = list(access_pcommander,access_penforcer, access_security, access_sec_doors, access_brig, access_armory, access_court, access_forensics_lockers, access_morgue,
	access_maint_tunnels, access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting, access_heads, access_hos,
	access_heads)


/*
* Dogtag
*/

/obj/item/weapon/card/id/perseus
	icon_state = "perseus"

/*
* SOP Book
*/

/obj/item/weapon/book/manual/sop
	name = "Perseus Standing Operations Procedures"
	desc = "A book detailing the standard rules and procedures for Perseus."
	icon_state = "bookSoP"
	author = "Perseus CEO; Theodore Blackwell"
	title = "Perseus Standing Operations Procedures Manual"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>

				<H3>PERSEUS STANDING OPERATIONS PROCEDURE</H3>
				<I>as created by Perseus CEO; Theodore Blackwell<BR><BR>
				These are the active Perseus Protocols, and should be followed as closely as possible on pain of termination.

				<ol>
					<li><a href='#1'>When to enter the station</a></li>
					<li><a href='#2'>Arrests and Evidence</a><br>
					<a href='#2a'>2a. Prison Procedure</a></li>
					<li><a href='#3'>Priorities</a></li>
					<li><a href='#4'>Backup</a></li>
					<li><a href='#5'>Downtime</a></li>
					<li><a href='#6'>Xenomorphs</a></li>
					<li><a href='#7'>Interactions</a></li>
					<li><a href='#8'>Impersonations</a></li>
					<li><a href='#9'>Caution on Calls</a></li>
					<li><a href='#10'>Levels of force</a></li>
				</ol>

				<a name='1'><H4>When to enter the station</H4>
				1. Perseus Personnel should make contact with the heads of the Celestial Complex in question as soon as possible, and make Perseus services available. Perseus Personnel should NOT move to board a Celestial Complex without a request for assistance from an acting Head of Staff via radio communication, or if none are available anyone on the Complex's local security scans (radio channel) If Security doesn't respond, send a request to the AI. If no one responds, use your judgment. Enforcers should board only in situations which pose a serious threat to life and/or station.

				<a name='2'><H4>Arrests and Evidence</H4>
				2. Suspects should not be imprisoned on the Mycenae without the explicit permission of the highest Security authority present on the station. If no security is present, available, or is otherwise disabled, the Enforcer should use their best judgment. Mycenae imprisonment is appropriate only for those proven guilty of a Capital Crime under Space Law. Suspects guilty of lesser crimes should be held by station security. Before you prison a suspect, gather the evidence that proves they are a traitor, syndicate, Etc.

				<a name='2a'><H4>Prison procedure:</H4>
				2a. Buckle a handcuffed prisoner to the shuttle chair. Once docked with the Mycenae, flash/stun them and take them to the prisoner gear closets. Strip them of their gear at either of the two prisoner gear closets. Outfit them in prison jumpsuits and take them to their cell. Once inside, flash/stun them and then leave. Do be polite through the proceeding. If other personnel bring you a prisoner, have them drop the evidence in the shuttle and cuff the prisoner to one of the chairs. Then tell them to leave the shuttle and call the shuttle to you. Then, once ascertaining that the shuttle is clear of all but the prisoner, get aboard and follow the above steps.

				<a name='3'><H4>Priorities</H4>
				3. Our first priority is the guarding of our ship. Keep the ship safe before protecting the client.

				<a name='4'><H4>Backup</H4>
				4. Perseus Personnel should NEVER (at risk of life and limb) enter a Celestial Complex or hostile situation outside of the ship ALONE. Always work together in groups or have nearby back up that can assist you. Security can sometimes fulfill this role, but remember that they cannot be fully trusted. (Use say:":a")

				<a name='5'><H4>Downtime</H4>
				5. During downtime or awaiting request to enter a Celestial Complex, Perseus Personnel should remain on the ship, OR may participate in live fire exercises in approved training areas.

				<a name='6'><H4>Xenomorphs</H4>
				6. Xenomorphs should always be hunted down and destroyed. This goes above the wishes of the client. “Xenomorph” is a proper noun that refers to a specific alien species, despite its root words being appropriately interpreted as 'Alien form.' The following species are not denoted by the term “Xenomorph”: Slimes, Carp, or Hivebots. In the event that Xenomorphs are discovered and not contained within the secure holding facility in Xenobiology, Perseus will board with the intent to destroy them.

				<a name='7'><H4>Interactions</H4>
				7. All interactions between Perseus Personnel and other all personnel, even prisoners, should be calm, professional, and considerate. Directions from Heads of Staff loyal to Nanotrasen should be followed, except where there are grounds to believe the order is dangerous, inappropriate, would interfere with your assigned mission, or would otherwise conflict with the SOP.

				<a name='8'><H4>Impersonations</H4>
				8. Never wear the dog tags of another enforcer, impersonate, or otherwise take any action that could confuse the identification of yourself or any other enforcer.

				<a name='9'><H4>Caution on Calls</H4>
				9. Beware of false calls. When a head sends a prisoner to the station have them buckle them to the chair and send the shuttle. Do not allow any personnel other than prisoners and Perseus units on the shuttle.

				<a name='10'><H4>Levels of force</H4>
				10. For the level of force allowed for a close range engagement ALWAYS consult the SIX levels of combativeness: REMEMBER. YOU ARE ALLOWED TO JUMP ONE LEVEL OF FORCE HIGHER THAN THE SUBJECT, IF NECESSARY.

				<li>Level 1: Compliant (Cooperative). The subject responds and complies with verbal commands. Close combat techniques do not apply.</li>
				<li>Level 2: Resistant (Passive). The subject resists verbal commands but complies immediately with any contact controls. Close combat techniques do not apply.</li>
				<li>Level 3: Resistant (Active). The subject initially demonstrates physical resistance. Use compliance techniques to control the situation. Level three incorporates close combat techniques to physically force a subject to comply. Techniques include: Disarm intent, Stun Baton, Flash, Flashbang, Restraints and more verbal commands.</li>
				<li>Level 4: Assaultive (Bodily Harm). The subject may physically attack, but does not use a weapon or show lethal intent. Use defensive tactics to neutralize the threat. Defensive tactics include using your P90 or flash, disarm, and any other non-lethal option.</li>
				<li>Level 5: Assaultive (Disabling). The subject possesses a stunning weapon and shows clear intent to disable and harm the Enforcer. Defensive tactics include using your P90 or flash, disarm, and any other non-lethal option. The subject should be detained and handed to station security if they are available, responsive, or cooperative.</li>
				<li>Level 6: Assaultive (Lethal Force). The subject usually has a weapon and will either kill or injure someone if he/she is not stopped immediately and brought under control. The subject must be controlled by any means necessary with or without a firearm.</li>
				<br><br>
				Enforcers are expected to constantly evaluate and are encouraged to respond to the level of force the Subject is using at any given moment in accordance with the Levels of Force continuum. The ultimate purpose of this use of force policy is to encourage Enforcers to use the least amount of force they reasonably believe will accomplish their objectives. If an Enforcer applies an unreasonable amount of force in a given situation, he or she may be subject to disciplinary action.
				Enforcers are not obligated to follow this use of force policy during an active break in; lethal force is authorized against any not restrained person who attempts to break into or out of a Perseus vessel. Be careful with regard to identity and impersonations.
				Use of lethal force is authorized against an unrestrained detainee if an Enforcer reasonably believes a crisis situation, such as complete loss of control of the interior of his vessel, is imminent and or that the detainee intends to seize an immediately present and clearly describable opportunity to escape and cause further death, great bodily harm, or serious property damage of an interest or patron of Perseus.
				Enforcers are invited to warn subjects when lethal force is considered an option. They are not obligated to, particularly when it would be tactically unwise.
				Upon completion of a mission, Enforcers are expected to immediately depart the celestial complex.


				<H4>Hivemind</H4>
				11. Information contained in Hive-mind, Perseus Chat, and the Commander Chat is not to be shared with anyone not in those chats without the express permission of the Head Perseus Commander.

				<H4>Skype</H4>
				12. Participating, when possible, in the Perseus Skype Chat and commenting on new enforcer applications (even if only on application content) is an expectation of continued Perseus membership.

				<p>Good luck and stay safe.



				</body>
				</html>
				"}

/*
* Oxygen Tank
*/

/obj/item/weapon/tank/perseus
	name = "PercTech branded emergency oxygen tank"
	desc = "PercTech brand emergency oxygen tank. For all your oxygen needs."
	icon_state = "perseus"
	volume = 3
	w_class = 2.0
	slot_flags = SLOT_BELT
	item_state = "emergency"
	distribute_pressure = 16.0

	New()
		..()
		src.air_contents.gasses[OXYGEN] = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

/*
* Jet harness
*/

/obj/item/weapon/tank/jetpack/oxygen/perctech
	name = "PercTech jet harness (oxygen)"
	desc = "A lightweight tactical harness, used by those who don't want to be weighed down by traditional jetpacks and adapted by Perseus Quartermasters for PMC use."
	icon_state = "perc-jet"
	item_state = "perc-jet"
	volume = 35
	throw_range = 7
	w_class = 3

/*
* Stimpack
*/

/obj/item/weapon/stimpack
	desc = "A single use rapid injection unit containing various chemicals."
	name = "stim tank"
	icon = 'icons/obj/items.dmi'
	icon_state = "stimpack_1"
	slot_flags = SLOT_BELT
	w_class = 1.0
	m_amt = 60

	New()
		..()

		var/datum/reagents/R = new/datum/reagents(20)
		reagents = R
		R.my_atom = src

	attack(mob/M as mob, mob/user as mob)
		if (!(istype(M, /mob)))
			return
		if (reagents.total_volume)
			for(var/mob/O in viewers(M, null))
				O.show_message("\blue [M] has been stabbed with [src] by [user].", 1)
			if(M.reagents) reagents.trans_to(M, reagents.total_volume)
			icon_state = "stimpack_0"
			desc += " This one is used."
		return

	perseus/
		name = "PercTech Stimpack"
		desc = "A small disposable PercTech stimpack auto-injector, for all your basic emergency medical needs."

		New()
			..()
			reagents.add_reagent("inaprovaline", 5)
			reagents.add_reagent("hyperzine", 5)
			reagents.add_reagent("tricordrazine", 10)

/*
* Stimpack Tank
*/

/obj/structure/stimtank/perseus
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "stimtank"
	desc = "A refill tank for standard stimpacks."
	density = 1
	anchored = 1

	New()
		..()
		reagents = new /datum/reagents(2000)
		reagents.my_atom = src
		reagents.add_reagent("inaprovaline", 500)
		reagents.add_reagent("hyperzine", 500)
		reagents.add_reagent("tricordrazine", 1000)

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/stimpack) && (!W.reagents.total_volume))
			var/obj/item/weapon/stimpack/S = W
			reagents.trans_to(S, 15)
			user << "\blue You refill the stimpack!"
			playsound(src, 'sound/effects/refill.ogg', 50, 0, null)
			W.icon_state = "stimpack_1"
			W.desc = "A small disposable PercTech stimpack auto-injector, for all your basic emergency medical needs."
			return
		else
			return ..()

/*
* Breach Charge
*/

/obj/item/weapon/plastique/breach
	name = "breaching charge"
	desc = "Deploys a controlled explosion to breach walls and doors."
	icon_state = "breachcharge"
	explosion_size = list(-1, -1, -1, -1)

	New()
		..()
		image_overlay = image('icons/obj/assemblies.dmi', "breachcharge_ticking")


/*
* Emergency Case
*/

/obj/structure/displaycase/perseus
	name = "EMERGENCY ONLY Case"
	icon_state = "pglassbox1"
	spawnPath = /obj/item/weapon/gun/projectile/automatic/fiveseven
	density = 0

	update_icon()
		icon_state = "pglassbox[destroyed ? "b" : ""][occupied]"


/*
* Prisoner Transfer Procedures
*/

/obj/structure/perseusreminder
	name = "Prisoner Transfer Procedures"
	desc = "This notice has been installed at the prisoner transfer shuttle dock to remind security staff of the only acceptable way to transfer a prisoner into Perseus Custody."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "preminder"
	density = 0
	anchored = 1

/obj/structure/perseusreminder/attack_hand(user as mob)
	var/dat = "<B>PRISONER TRANSFER PROCEDURES</B><BR>"

	dat += {"<html>THIS DOCUMENT WILL DESCRIBE THE PROPER AND MOST EFFICIENT METHOD OF TRANSFERRING AND PROCESSING OF PRISONERS BETWEEN THE STATION AND THE MYCENAE III.</p>
<p style="padding-left:30px;"><span style="text-decoration:underline;"><strong>SECURING</strong></span>: FIRSTLY YOU MUST ENSURE THE PRISONER IS SECURE. TO ENSURE THE PRISONER IS OTHERWISE UNABLE TO INFLICT HARM ON THE TRANSFERRING OFFICER YOU MUST;<br />            </p>
<p style="padding-left:60px;"><strong>A</strong>: ENSURE THE PRISONER IS HANDCUFFED AND IN YOUR GRIP BEFORE BEGINNING TRANSFER.</p>
<p style="padding-left:60px;"><strong>B</strong>: THERE ARE NO EXTERIOR THREATS IN THE PROXIMITY, THIS INCLUDES PERSONS WHOM MAY ATTEMPT TO RETRIEVE THE PRISONER FROM YOUR CUSTODY.</p>
<p style="padding-left:60px;"><strong>C</strong>: BE WARY OF FREEDOM IMPLANTS, THE SYNDICATE MAY PROVIDE ONE OF THEIR AGENTS WITH A DEVICE KNOWN AS A "FREEDOM IMPLANT" THIS ALLOWS THE AGENT TO ESCAPE FROM HANDCUFFS BY PERFORMING A MOTION SUCH AS A "WINK" OR A "SHRUG".</p>
<p>           </p>
<p style="padding-left:30px;"><span style="text-decoration:underline;"><strong>TRANSFER</strong></span>: MOVEMENT OF THE PRISONER BETWEEN THE STATION AND THE MYCENAE WILL BE PERFORMED AS FOLLOWING;</p>
<p>           </p>
<p style="padding-left:60px;"><strong>A</strong>: REMOVE INCRIMINATING OBJECTS FROM THE PRISONER AND PLACE THEM IN A CONTAINER ABOARD THE TRANSFER SHUTTLE.</p>
<p style="padding-left:60px;"><strong>B</strong>: PLACE THE PRISONER ON BOARD THE TRANSFER SHUTTLE, ENSURE THEY ARE BUCKLED TO THE CHAIR OF THE SHUTTLE.</p>
<p style="padding-left:60px;"><strong>C</strong>: STEP OFF THE TRANSFER SHUTTLE AND ACTIVATE THE CONSOLE THAT YOU WILL FIND TO THE LEFT OF THIS PAGE, THIS WILL SIGNAL THE SHUTTLE TO MOVE TOWARDS THE MYCENAE III.</p>
<p style="padding-left:60px;"><strong>D</strong>: NOTIFY ACTIVE PERSEUS ENFORCERS OF THE TRANSFER, IF YOU DO NOT RECEIVE A RESPONSE RETURN THE SHUTTLE AND PLACE THE PRISONER IN THE STATION-BOARD PRISON UNTIL AN ACTIVE ENFORCER CAN ASSIST YOU.</p>
<p style="padding-left:60px;"><strong>ADDENDUM</strong>: IN EVENT OF A HULL BREACH ABOARD THE PRISON SHUTTLE, ENSURE THE PRISONER IS EQUIPPED WITH A BREATHING APPARATUS AND AN OXYGEN TANK </p>
<p> </p>
<p>THIS WILL ENSURE NO PRISONERS CAN ATTEMPT TO ESCAPE CUSTODY, AND WILL ALLOW PERSEUS PERSONNEL TO EFFICIENTLY SECURE DANGEROUS PERSONS.</p>
"}

	user << browse("<HEAD><TITLE>Notices</TITLE></HEAD>[dat]","window=percboard")
	onclose(user, "percboard")

/*
* Telescience Disruptor
*/

/obj/machinery/tdisruptor
	name = "telescience disruptor"
	icon_state = "disruptor_off_powered"

	power_channel = EQUIP
	active_power_usage = 500
	idle_power_usage = 10

	var/area/protected = 0
	var/on = 0
	var/starting = 0

	process()
		update()

	update_icon()
		if(stat & (BROKEN|NOPOWER))
			icon_state = "disruptor_off_unpowered"
		else if(!on)
			icon_state = "disruptor_off_powered"
		else if(on)
			if(starting)
				flick("disruptor_startup", src)
				starting = 0
			icon_state = "disruptor_idle"

	proc/update()
		if(stat & (BROKEN|NOPOWER))
			on = 0

		if(on)
			var/area/A = get_area(src)
			if(!A)	return
			protected = A
			anchored = 1
		else
			protected = 0
			anchored = 0

		update_icon()

	attack_hand(var/mob/living/L)
		if(!istype(L, /mob/living/carbon/human))
			return 0

		var/mob/living/carbon/human/H = L

		var/obj/item/weapon/card/id/id
		if(H.wear_id)
			if(istype(H.wear_id, /obj/item/weapon/card/id))
				id = H.wear_id
			else if(istype(H.wear_id, /obj/item/device/tablet))
				var/obj/item/device/tablet/tablet = H.wear_id
				if(tablet.id)
					id = tablet.id
		else if(istype(H.get_active_hand(), /obj/item/weapon/card/id))
			id = H.get_active_hand()

		if(!id || !check_access(id))
			var/implant_access = 0
			for(var/obj/item/weapon/implant/I in H)
				if(check_access(I))
					implant_access = 1
					break

			if(!implant_access)
				H << "<span class='warning'>Access denied.</span>"
				return 0

		on = !on
		if(on)
			starting = 1

		H << "<div class='alert'>You turn the [src] [on ? "on" : "off"].</div>"

	emp_act(var/level = 0)
		if(level <= 2)
			if(prob(75))
				stat ^= BROKEN
				var/turf/T = get_turf(src)
				T.visible_message("<div class='warning'>[src] shuts down.</div>", 1)

	ex_act(var/level = 0)
		if(level <= 2)
			if(prob(75))
				stat ^= BROKEN
			else
				qdel(src)

	examine()
		..()
		usr << "The [src] is [on ? "running" : "offline"]."

	default_unfasten_wrench(mob/user, obj/item/weapon/wrench/W, time = 20)
		return 0

/proc/isDisruptedArea(area/A)
	for(var/obj/machinery/tdisruptor/T in A)
		if(T)
			if(T.on && T.protected == A)
				return 1
	return 0
