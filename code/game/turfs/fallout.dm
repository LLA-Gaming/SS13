/turf/simulated/
	floor/
		fallout/
			icon = 'icons/turf/fallout_floors.dmi'

		airless/fallout
			icon = 'icons/turf/fallout_floors.dmi'

		bluegrid/fallout
			icon = 'icons/turf/fallout_floors_2.dmi'
			icon_state = "bcircuit1"

			New()
				..()
				icon_state = "bcircuit[rand(1, 4)]"

			off/
				icon_state = "bcircuitoff1"

				New()
					..()
					icon_state = "bcircuitoff[rand(1,4)]"

		greengrid/fallout
			icon = 'icons/turf/fallout_floors_2.dmi'
			icon_state = "gcircuit1"

			New()
				..()
				icon_state = "gcircuit[rand(1, 4)]"

			off/
				icon_state = "gcircuitoff1"

				New()
					..()
					icon_state = "gcircuitoff[rand(1,4)]"

		redgrid/
			icon = 'icons/turf/fallout_floors_2.dmi'
			icon_state = "rcircuit1"

			New()
				..()
				icon_state = "rcircuit[rand(1, 4)]"

			off/
				icon_state = "rcircuitoff1"

				New()
					..()
					icon_state = "rcircuitoff[rand(1,4)]"

		yellowgrid/
			icon = 'icons/turf/fallout_floors_2.dmi'
			icon_state = "ycircuit1"

			New()
				..()
				icon_state = "ycircuit[rand(1, 4)]"

			off/
				icon_state = "ycircuitoff1"

				New()
					..()
					icon_state = "ycircuitoff[rand(1,4)]"

		engine/fallout
			icon = 'icons/turf/fallout_floors.dmi'

		grass/fallout
			icon = 'icons/turf/fallout_floors.dmi'

		plating/fallout
			icon = 'icons/turf/fallout_floors.dmi'

	wall/
		cult/fallout
			icon = 'icons/turf/fallout_walls.dmi'

		mineral/
			clown/fallout/
				icon = 'icons/turf/fallout_walls.dmi'
			diamond/fallout/
				icon = 'icons/turf/fallout_walls.dmi'
			gold/fallout/
				icon = 'icons/turf/fallout_walls.dmi'
			plasma/fallout/
				icon = 'icons/turf/fallout_walls.dmi'
			sandstone/fallout/
				icon = 'icons/turf/fallout_walls.dmi'
			silver/fallout/
				icon = 'icons/turf/fallout_walls.dmi'
			uranium/fallout/
				icon = 'icons/turf/fallout_walls.dmi'
			wood/fallout/
				icon = 'icons/turf/fallout_walls.dmi'

		r_wall/fallout
			icon = 'icons/turf/fallout_walls.dmi'

/turf/unsimulated/
	floor/
		bluegrid/fallout
			icon = 'icons/turf/fallout_floors_2.dmi'

		engine/fallout
			icon = 'icons/turf/fallout_floors.dmi'

		plating/fallout
			icon = 'icons/turf/fallout_floors.dmi'
