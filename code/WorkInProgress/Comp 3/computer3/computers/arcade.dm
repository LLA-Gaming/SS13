/obj/machinery/computer3/arcade
	default_prog	= /datum/file/program/arcade
	spawn_parts		= list(/obj/item/part/computer/toybox) //NO HDD - the game is loaded on the circuitboard's OS slot

/obj/item/part/computer/toybox
	name = "Toybox"
	desc = "There's toys... somewhere... in here. Maybe if you put it into a computer it'll poop out prizes."
	icon_state = "toybox"
	var/list/prizes = list(	/obj/item/weapon/storage/box/snappops			= 2,
							/obj/item/toy/blink								= 2,
							/obj/item/clothing/under/syndicate/tacticool	= 2,
							/obj/item/toy/sword								= 2,
							/obj/item/toy/gun								= 2,
							/obj/item/toy/crossbow							= 2,
							/obj/item/weapon/storage/fancy/crayons			= 2
							)
	proc/dispense()
		if(computer && !computer.stat)
			var/prizeselect = pickweight(prizes)
			new prizeselect(computer.loc)
			if(istype(prizeselect, /obj/item/toy/gun)) //Ammo comes with the gun
				new /obj/item/toy/ammo/gun(computer.loc)
			feedback_inc("arcade_win_normal")
			computer.use_power(500)


/datum/file/program/arcade
	name = "Space Fantasy II"
	desc = "The best arcade game ever produced by NanoTrasen's short-lived entertainment divison, originally released on the NTES. Arguably better then L.M. and Hyperman 128."
	//headcanon: they also ported E.T. for the atari 2600, superman 64, and basically every other movie tie-in game ever

	active_state = "generic"

	var/turtle = 0
	var/enemy_name = "Space Villian"
	var/temp = "Winners Don't Use Spacedrugs" //Temporary message, for attack messages, etc
	var/player_hp = 30 //Player health/attack points
	var/player_mp = 10
	var/enemy_hp = 45 //Enemy health/attack points
	var/enemy_mp = 20
	var/gameover = 0
	var/blocked = 0 //Player cannot attack/heal while set

/datum/file/program/arcade/New()
	..()
	var/name_part1
	var/name_part2

	name_part1 = pick("Automatic ", "Farmer ", "Lord ", "Professor ", "Cuban ", "Evil ", "Dread King ", "Jungle ", "Lord ", "Great ", "Duke ", "General ")
	name_part2 = pick("Melonoid", "Murdertron", "Sorcerer", "Ruin", "Jeff", "Ectoplasm", "Crushulon", "Uhangoid", "Vhakoid", "Peteoid", "Slime", "Griefer", "Lewder", "Lizardman", "Unicorn", "Hyperman")

	enemy_name = name_part1 + name_part2

/datum/file/program/arcade/interact()
	if(!interactable())
		return
	var/dat// = topic_link(src,"close","Close")
	dat = "<center><h4>[enemy_name]</h4></center>"

	dat += "<br><center><h3>[temp]</h3></center>"
	dat += "<br><center>Health: [player_hp] | Magic: [player_mp] | Enemy Health: [enemy_hp] | Enemy Magic: [enemy_mp]</center>"

	if (gameover)
		dat += "<center><b>[topic_link(src,"newgame","New Game")]"
	else
		dat += "<center><b>[topic_link(src,"attack","Attack")] | [topic_link(src,"heal","Heal")] | [topic_link(src,"charge","Recharge Power")]"

	dat += "</b></center>"

	popup.set_content(dat)
	popup.open()

/datum/file/program/arcade/Topic(href, list/href_list)
	if(!interactable() || ..(href,href_list))
		return
	if (!blocked && !gameover)
		if ("attack" in href_list)
			blocked = 1
			var/attackamt = rand(2,6)
			temp = "You attack for [attackamt] damage!"
			computer.updateUsrDialog()
			if(turtle > 0)
				turtle--

			sleep(10)
			enemy_hp -= attackamt
			arcade_action()

		else if ("heal" in href_list)
			blocked = 1
			var/pointamt = rand(1,3)
			var/healamt = rand(6,8)
			temp = "You use [pointamt] magic to heal for [healamt] damage!"
			computer.updateUsrDialog()
			turtle++

			sleep(10)
			player_mp -= pointamt
			player_hp += healamt
			blocked = 1
			computer.updateUsrDialog()
			arcade_action()

		else if ("charge" in href_list)
			blocked = 1
			var/chargeamt = rand(4,7)
			temp = "You regain [chargeamt] points"
			player_mp += chargeamt
			if(turtle > 0)
				turtle--

			computer.updateUsrDialog()
			sleep(10)
			arcade_action()

	if ("newgame" in href_list) //Reset everything
		temp = "New Round"
		player_hp = 30
		player_mp = 10
		enemy_hp = 45
		enemy_mp = 20
		gameover = 0
		turtle = 0
		computer.updateUsrDialog()


/datum/file/program/arcade/proc/arcade_action()
	if ((enemy_mp <= 0) || (enemy_hp <= 0))
		if(!gameover)
			gameover = 1
			temp = "[enemy_name] has fallen! Rejoice!"
			if(computer.toybox)
				computer.toybox.dispense()

	else if ((enemy_mp <= 9) && (prob(70)))
		var/stealamt = rand(3,4)
		temp = "[enemy_name] steals [stealamt] of your power!"
		player_mp -= stealamt

		if (player_mp <= 0)
			gameover = 1
			sleep(10)
			temp = "You have been drained! GAME OVER"
			feedback_inc("arcade_loss_mana_normal")

	else if ((enemy_hp <= 10) && (enemy_mp > 4))
		temp = "[enemy_name] heals for 4 health!"
		enemy_hp += 4
		enemy_mp -= rand(4,5)

	else
		var/attackamt = rand(3,6)
		temp = "[enemy_name] attacks for [attackamt] damage!"
		player_hp -= attackamt

	if ((player_mp <= 0) || (player_hp <= 0))
		gameover = 1
		temp = "You have been crushed! GAME OVER"
		feedback_inc("arcade_loss_hp_normal")

	if(interactable())
		computer.updateUsrDialog()
	blocked = 0
	return