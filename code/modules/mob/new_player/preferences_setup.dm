datum/preferences
	//The mob should have a gender you want before running this proc. Will run fine without H
	proc/random_character(gender_override)
		if(gender_override)
			gender = gender_override
		else
			gender = pick(MALE,FEMALE)
		underwear = random_underwear(gender)
		undershirt = random_undershirt(gender)
		socks = random_socks(gender)
		skin_tone = random_skin_tone()
		hair_style = random_hair_style(gender)
		facial_hair_style = random_facial_hair_style(gender)
		hair_color = random_short_color()
		facial_hair_color = hair_color
		eye_color = random_eye_color()
		backbag = 2
		age = rand(AGE_MIN,AGE_MAX)

	proc/update_preview_icon(var/client/C)
		var/datum/job/previewJob
		//assistant overrides all
		if(job_civilian_low & ASSISTANT)
			previewJob = job_master.GetJob("Assistant")
		//perseus overrides AI
		if(!previewJob && C && assignPerseus.Find(C.ckey))
			if(perseusList[C.ckey] == "Commander")
				previewJob = job_master.GetJob("Perseus Security Commander")
			else
				previewJob = job_master.GetJob("Perseus Security Enforcer")
		//AI overrides all other preferences
		if(!previewJob && job_engsec_high && (C && !assignPerseus.Find(C.ckey)))
			switch(job_engsec_high)
				if(AI)
					preview_icon = icon('icons/mob/AI.dmi', "AI", SOUTH)
					preview_icon.Scale(64, 64)
					return
				if(CYBORG)
					preview_icon = icon('icons/mob/robots.dmi', "robot", SOUTH)
					preview_icon.Scale(64, 64)
					return

		// Set up the dummy for its photoshoot
		var/mob/living/carbon/human/dummy/mannequin = new()
		copy_to(mannequin)
		mannequin.regenerate_icons()

		// Determine what job is marked as 'High' priority, and dress them up as such.
		var/highRankFlag = job_civilian_high | job_medsci_high | job_engsec_high
		if(highRankFlag)
			var/highDeptFlag
			if(job_civilian_high)
				highDeptFlag = CIVILIAN
			else if(job_medsci_high)
				highDeptFlag = MEDSCI
			else if(job_engsec_high)
				highDeptFlag = ENGSEC

			if(!previewJob)
				for(var/datum/job/job in job_master.occupations)
					if(job.flag == highRankFlag && job.department_flag == highDeptFlag)
						previewJob = job
						break

		if(previewJob)
			mannequin.job = previewJob.title
			previewJob.equip(mannequin, TRUE)

		preview_icon = icon('icons/effects/effects.dmi', "nothing")
		preview_icon.Scale(48+32, 16+32)

		mannequin.dir = NORTH
		var/icon/stamp = getFlatIcon(mannequin)
		preview_icon.Blend(stamp, ICON_OVERLAY, 49, 9)

		mannequin.dir = WEST
		stamp = getFlatIcon(mannequin)
		preview_icon.Blend(stamp, ICON_OVERLAY, 25, 9)

		mannequin.dir = SOUTH
		stamp = getFlatIcon(mannequin)
		preview_icon.Blend(stamp, ICON_OVERLAY, 1, 9)

		preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2) // Scaling here to prevent blurring in the browser.
		qdel(mannequin)