/*NOTES:
These are general powers. Specific powers are stored under the appropriate alien creature type.
*/

/*Alien spit now works like a taser shot. It won't home in on the target but will act the same once it does hit.
Doesn't work on other aliens/AI.*/


/mob/living/carbon/alien/beepsky/powerc(X, Y)//Y is optional, checks for weed planting. X can be null.
	if(stat)
		src << "\green You must be conscious to do this."
		return 0
	else if(X && getPlasma() < X)
		src << "\green Not enough energy stored."
		return 0
	else if(Y && (!isturf(src.loc) || istype(src.loc, /turf/space)))
		src << "\green Bad place for a garden!"
		return 0
	else	return 1

/mob/living/carbon/alien/beepsky/humanoid/verb/plant()
	set name = "Plant Weeds (50)"
	set desc = "Plants some electronic weeds"
	set category = "Xenosky"

	if(powerc(50,1))
		adjustToxLoss(-50)
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\green <B>[src] has planted some electronic weeds!</B>"), 1)
		new /obj/structure/alien/weeds/beepsky/node(loc)
	return

/*
/mob/living/carbon/alien/beepsky/humanoid/verb/ActivateHuggers()
	set name = "Activate facehuggers (5)"
	set desc = "Makes all nearby facehuggers activate"
	set category = "Alien"

	if(powerc(5))
		adjustToxLoss(-5)
		for(var/obj/item/clothing/mask/facehugger/F in range(8,src))
			F.GoActive()
		emote("roar")
	return
*/
/mob/living/carbon/alien/beepsky/humanoid/verb/whisp(mob/M as mob in oview())
	set name = "Whisper (10)"
	set desc = "Whisper to someone"
	set category = "Xenosky"

	if(powerc(10))
		adjustToxLoss(-10)
		var/msg = sanitize(input("Message:", "Alien Whisper") as text|null)
		if(msg)
			if(key) log_say("AlienWhisper: [key_name(src)]->[M.key] : [msg]")
			M << "\green You hear a strange, electronic voice in your head... \italic [msg]"
			src << {"\green You said: "[msg]" to [M]"}
	return

/mob/living/carbon/alien/beepsky/humanoid/verb/transfer_plasma(mob/living/carbon/alien/beepsky/M as mob in oview())
	set name = "Transfer Energy"
	set desc = "Transfer Energy to another beepsky"
	set category = "Xenosky"

	if(isalien(M))
		var/amount = input("Amount:", "Transfer Energy to [M]") as num
		if (amount)
			amount = abs(round(amount))
			if(powerc(amount))
				if (get_dist(src,M) <= 1)
					M.adjustToxLoss(amount)
					adjustToxLoss(-amount)
					M << "\green [src] has transfered [amount] energy to you."
					src << {"\green You have trasferred [amount] energy to [M]"}
				else
					src << "\green You need to be closer."
	return


/mob/living/carbon/alien/beepsky/humanoid/proc/corrosive_acid(O as obj|turf in oview(1)) //If they right click to corrode, an error will flash if its an invalid target./N
	set name = "Corrossive Acid (200)"
	set desc = "Drench an object in acid, destroying it over time."
	set category = "Xenosky"

	if(powerc(200))
		if(O in oview(1))
			// OBJ CHECK
			if(isobj(O))
				var/obj/I = O
				if(I.unacidable)	//So the aliens don't destroy energy fields/singularies/other aliens/etc with their acid.
					src << "\green You cannot dissolve this object."
					return
			// TURF CHECK
			else if(istype(O, /turf/simulated))
				var/turf/T = O
				// R WALL
				if(istype(T, /turf/simulated/wall/r_wall))
					src << "\green You cannot dissolve this object."
					return
				// R FLOOR
				if(istype(T, /turf/simulated/floor/engine))
					src << "\green You cannot dissolve this object."
					return
			else// Not a type we can acid.
				return

			adjustToxLoss(-200)
			new /obj/effect/acid(get_turf(O), O)
			visible_message("\green <B>[src] vomits globs of vile stuff all over [O]. It begins to sizzle and melt under the bubbling mess of acid!</B>")
		else
			src << "\green Target is too far away."
	return


/mob/living/carbon/alien/beepsky/humanoid/proc/neurotoxin() // ok
	set name = "Fire Tazer (50)"
	set desc = "Fires your tazer at someone, paralyzing them for a short time."
	set category = "Xenosky"

	if(powerc(50))
		adjustToxLoss(-50)
		src.visible_message("\red [src] fires a tazer!", "\green You fire the tazer.")

		var/turf/T = loc
		var/turf/U = get_step(src, dir) // Get the tile infront of the move, based on their direction
		if(!isturf(U) || !isturf(T))
			return

		var/obj/item/projectile/energy/electrode/A = new /obj/item/projectile/energy/electrode(usr.loc)
		A.current = U
		A.yo = U.y - T.y
		A.xo = U.x - T.x
		A.process()
	return

/mob/living/carbon/alien/beepsky/humanoid/proc/resin()
	set name = "Secrete Resin (75)"
	set desc = "Secrete tough malleable resin."
	set category = "Xenosky"

	if(powerc(75))
		var/choice = input("Choose what you wish to shape.","Resin building") as null|anything in list("resin door","resin wall","resin membrane","resin nest") //would do it through typesof but then the player choice would have the type path and we don't want the internal workings to be exposed ICly - Urist
		if(!choice || !powerc(75))	return
		adjustToxLoss(-75)
		src << "\green You shape a [choice]."
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\red <B>[src] vomits up a thick gray substance and begins to shape it!</B>"), 1)
		switch(choice)
			if("resin door")
				new /obj/structure/mineral_door/resin/beepsky(loc)
			if("resin wall")
				new /obj/structure/alien/resin/wall/beepsky(loc)
			if("resin membrane")
				new /obj/structure/alien/resin/membrane/beepsky(loc)
			if("resin nest")
				new /obj/structure/stool/bed/nest/beepsky(loc)
	return

/mob/living/carbon/alien/beepsky/humanoid/verb/regurgitate()
	set name = "Regurgitate"
	set desc = "Empties the contents of your stomach"
	set category = "Xenosky"

	if(powerc() && stomach_contents.len)
		for(var/atom/movable/A in stomach_contents)
			if(A in stomach_contents)
				stomach_contents.Remove(A)
				A.loc = loc
				//Paralyse(10)
		src.visible_message("\green <B>[src] hurls out the contents of their stomach!</B>")
	return

/mob/living/carbon/alien/beepsky/humanoid/verb/halt()
	set category = "Xenosky"
	set name = "HALT"
	set desc = "Intimidate the criminals"
	if(src.stat) return

	var/phrase = 0	//selects which phrase to use
	var/phrase_text = null
	var/phrase_sound = null


	if(hailercooldown < world.time - 35) // A cooldown, to stop people being jerks
		phrase = rand(12,18)	// user has broke the restrictor, it will now only play shitcurity phrases
		switch(phrase)	//sets the properties of the chosen phrase
			if(12)				// LA-PD
				phrase_text = "Stop or I'll bash you."
				phrase_sound = "bash"
			if(13)
				phrase_text = "Go ahead, make my day."
				phrase_sound = "harry"
			if(14)
				phrase_text = "Stop breaking the law, ass hole."
				phrase_sound = "asshole"
			if(15)
				phrase_text = "You have the right to shut the fuck up."
				phrase_sound = "stfu"
			if(16)
				phrase_text = "Shut up crime!"
				phrase_sound = "shutup"
			if(17)
				phrase_text = "Face the wrath of the golden bolt."
				phrase_sound = "super"
			if(18)
				phrase_text = "I am, the LAW!"
				phrase_sound = "dredd"

		usr.visible_message("[usr]: <font color='red' size='4'><b>[phrase_text]</b></font>")
		playsound(src.loc, "sound/voice/complionator/[phrase_sound].ogg", 100, 0, 4)
		hailercooldown = world.time
