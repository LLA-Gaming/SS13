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
	access_maint_tunnels, access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting, access_heads, access_hos, access_gateway,
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
					<li><a href='#2'>Arrests and Evidence</a></li>
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
				1. Perseus Personel should make contact with the heads of the the Celestial Complex in question as soon as possible, and make make Perseus services available. Perseus Personnel should NOT move to board a Celestial Complex without a request for assistance from an acting Head of Staff via radio communication, or if none are available anyone on the Complex's local security scans (radio channel) If Security doesn't respond, send a request to the AI. If no one responds, use your judgment.

				<a name='2'><H4>Arrests and Evidence</H4>
				2. Before you prison a suspect, gather the evidence that proves they are a traitor, syndicate, Etc. Prison procedure: Handcuff a prisoner to the shuttle chair. Strip them of all belongings. Once docked with our shuttle, flash them and take them to the prisoner clothing closet. Outfit them in their jump suits and take them to their cell. Once inside. Flash them and then leave. Do be polite through the proceeding. If other personnel bring you a prisoner, have them drop the evidence in the shuttle and cuff the prisoner to one of the chairs. Then tell them to leave the shuttle and call the shuttle to you. Then, once ascertaining that the shuttle is clear of all but the prisoner, get aboard and follow the above steps.

				<a name='3'><H4>Priorities</H4>
				3. Our first priority is the guarding of our ship. Keep the ship safe before protecting the client.

				<a name='4'><H4>Backup</H4>
				4. Perseus Personnel should NEVER (at risk of life and limb) enter a Celestial Complex or hostile situation outside of the ship ALONE. Always work together in groups or have nearby back up that can assist you. Security can sometimes fulfill this role, but remember that they cannot be fully trusted. (use say:":a")

				<a name='5'><H4>Downtime</H4>
				5. During downtime or awaiting request to enter a Celestial Complex, Perseus Personnel should remain on the ship, OR may participate in live fire exercises in approved training areas.

				<a name='6'><H4>Xenomorphs</H4>
				6. Xenomorphs should always hunted down and destroyed. This goes above the wishes of the client. All Xenomorphs that are not contained must be destroyed.

				<a name='7'><H4>Interactions</H4>
				7. All interactions between Perseus Personnel and other all personnel, even prisoners, should be calm, professional, and considerate.

				<a name='8'><H4>Impersonations</H4>
				8. Impersonation of a fellow Perseus employee is grounds for termination. Do not EVER wear the dog tags of another perseus employee for any reason.

				<a name='9'><H4>Caution on Calls</H4>
				9.Beware of false calls. When a head sends a prisoner to the station have them buckle them to the chair and send the shuttle. Do not allow any personnel other than prisoners and Perseus units on the shuttle.

				<a name='10'><H4>Levels of force</H4>
				10. For the level of force alowed for a close range engagement ALWAYS consult the FIVE levels of combativeness: REMEMBER. YOU ARE ALLOWED TO MAKE ONE JUMP UP ON LEVELS OF FORCE THAN YOUR SUBJECT.

				<li>Level 1: Compliant (Cooperative). The subject responds and complies to verbal commands. Close combat techniques do not apply.</li>
				<li>Level 2: Resistant (Passive). The subject resists verbal commands but complies immediately to any contact controls. Close combat techniques do not apply.</li>
				<li>Level 3: Resistant (Active). The subject initially demonstrates physical resistance. Use compliance techniques to control the situation. Level three incorporates close combat techniques to physically force a subject to comply. Techniques include: Disarm intent, Stun Baton, Flash, Flashbang, Restraints and more verbal commands. </li>
				<li>Level 4: Assaultive (Bodily Harm). The subject may physically attack, but does not use a weapon. Use defensive tactics to neutralize the threat. Defensive tactics include using your P90 or flash, disarm, and any other non-lethal option.</li>
				<li>Level 5: Assaultive (Lethal Force). The subject usually has a weapon and will either kill or injure someone if he/she is not stopped immediately and brought under control. The subject must be controlled by the use of deadly force with or without a firearm.</li>

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
		src.air_contents.oxygen = (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)

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
	name = "Stimpack"
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
* PDA & Cartridge
*/

/obj/item/weapon/cartridge/
	var/access_perseus = 0
	var/locked = ""

	perseus/
		perseus
		name = "PercTech Cartridge"
		icon_state = "cart-perc"
		access_manifest = 1
		access_perseus = 1
		access_security = 1
		locked = /obj/item/weapon/implant/enforcer

/obj/item/device/pda/perseus
	default_cartridge = /obj/item/weapon/cartridge/perseus
	icon_state = "pda-perc"
	toff = 1


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
* Prisoner Transfer Proceedures
*/

/obj/structure/perseusreminder
	name = "Prisoner Transfer Proceedures"
	desc = "This notice has been installed at the prisoner transfer shuttle dock to remind security staff of the only acceptable way to transfer a prisoner into Perseus Custody."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "preminder"
	density = 0
	anchored = 1

/obj/structure/perseusreminder/attack_hand(user as mob)
	var/dat = "<B>Prisoner Transfer Procedures:</B><BR>"

	dat += {"<html>THIS DOCUMENT WILL DESCRIBE THE PROPER AND MOST EFFICIENT METHOD OF TRANSFERRING AND PROCESSING OF PRISONERS BETWEEN THE STATION AND THE MYCENAE III.</p>
<p style="padding-left:30px;"><span style="text-decoration:underline;"><strong>SECURING</strong></span>: FIRSTLY YOU MUST ENSURE THE PRISONER IS SECURE, AND OTHERWISE UNABLE TO INFLICT HARM ON THE TRANSFERRING OFFICER YOU MUST;<br />            </p>
<p style="padding-left:60px;"><strong>A</strong>: ENSURE THE PRISONER IS HANDCUFFED AND IN YOUR GRIP BEFORE BEGINNING TRANSFER.</p>
<p style="padding-left:60px;"><strong>B</strong>: THERE ARE NO EXTERIOR THREATS IN THE PROXIMITY, THIS INCLUDES PERSONS WHOM MAY ATTEMPT TO RETRIEVE THE PRISONER FROM YOUR CUSTODY.</p>
<p style="padding-left:60px;"><strong>C</strong>: BE WARY OF FREEDOM IMPLANTS, THE SYNDICATE MAY PROVIDE ONE OF THEIR AGENTS WITH A DEVICE KNOWN AS A "FREEDOM IMPLANT" THIS ALLOWS THE AGENT TO ESCAPE FROM HANDCUFFS BY PERFORMING A MOTION SUCH AS A "WINK" OR A "SHRUG".</p>
<p>           </p>
<p style="padding-left:30px;"><span style="text-decoration:underline;"><strong>TRANSFER</strong></span>: MOVEMENT OF THE PRISONER BETWEEN THE STATION AND THE MYCENAE WILL BE PERFORMED AS FOLLOWING;</p>
<p>           </p>
<p style="padding-left:60px;"><strong>A</strong>: REMOVE INCRIMINATING OBJECTS FROM THE PRISONER AND PLACE THEM IN A SECURE CONTAINER ABOARD THE TRANSFER SHUTTLE.</p>
<p style="padding-left:60px;"><strong>B</strong>: PLACE THE PRISONER ON BOARD THE TRANSFER SHUTTLE, ENSURE THEY ARE BUCKLED TO THE CHAIR OF THE SHUTTLE.</p>
<p style="padding-left:60px;"><strong>C</strong>: STEP OFF THE TRANSFER SHUTTLE AND ACTIVATE THE CONSOLE THAT YOU WILL FIND TO THE LEFT OF THIS PAGE, THIS WILL SIGNAL THE SHUTTLE TO MOVE TOWARDS THE MYCENAE III.</p>
<p style="padding-left:60px;"><strong>D</strong>: NOTIFY ACTIVE PERSEUS ENFORCERS OF THE TRANSFER, IF YOU DO NOT RECEIVE A RESPONSE RETURN THE SHUTTLE AND PLACE THE PRISONER IN THE STATION-BOARD PRISON UNTIL AN ACTIVE ENFORCER CAN ASSIST YOU.</p>
<p> </p>
<p>THIS WILL ENSURE NO PRISONERS CAN ATTEMPT ESCAPING CUSTODY, AND WILL ALLOW PERSEUS PERSONNEL TO EFFICIENTLY SECURE DANGEROUS PERSONS.</p>
<br clear="both" /><br clear="both" />"}

	user << browse("<HEAD><TITLE>Notices</TITLE></HEAD>[dat]","window=percboard")
	onclose(user, "percboard")
