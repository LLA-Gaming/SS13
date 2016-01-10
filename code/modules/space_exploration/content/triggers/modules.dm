/obj/effect/trigger_modules
	icon = 'icons/effects/space_exploration.dmi'
	invisibility = 100
	layer = 4.1

	trigger_type/
		var/trigger_type

		normal/
			icon_state = "tt_normal"
			trigger_type = TT_NORMAL

		on_completion/
			icon_state = "tt_completion"
			trigger_type = TT_ON_COMPLETION

	conditional/
		var/triggered = 0

		proc/Evaluate()
			return triggered

		// Requires that specific item to be set up to trigger the module
		used_item/
			var/_specific_item = "*INSERT ITEM PATH HERE*"
			var/_trigger_message = "*INSERT TRIGGER MESSAGE HERE*"
			icon_state = "trigger_used_item"

			proc/TriggeredBy(var/obj/item/I, var/mob/living/user)
				if(istype(I, _specific_item))
					triggered = 1

				if(_trigger_message)
					user << _trigger_message

		contains_object/
			icon_state = "trigger_object"
			var/_specific_item = "*INSERT ITEM PATH HERE*"

			Evaluate()
				if(istext(_specific_item))
					_specific_item = text2path(_specific_item)

				for(var/atom/movable/A in get_turf(src))
					if(istype(A, _specific_item))
						return 1

				return 0

		spoken_phrase/
			icon_state = "trigger_phrase"
			var/_phrase = "*INSERT PHRASE HERE*"
			var/_exact = 1

			hear_talk(var/mob/living/M as mob, var/msg)
				if(_exact)
					if(msg == _phrase)
						triggered = 1
					return 0
				else
					if(findtext(msg, _phrase))
						triggered = 1
					return 0

		on_enter/
			icon_state = "trigger_entered"

			Crossed(var/atom/other)
				if(istype(other, /mob/living/carbon) && other:client)
					triggered = 1

				..()

		keycard_trigger/
			icon_state = "trigger_keycard"

	completion/
		proc/OnCompleted()
			return 0

		open_airlock/
			icon_state = "trigger_open_airlock"

			OnCompleted()
				for(var/obj/machinery/door/airlock/A in get_turf(src))
					A.locked = 0
					A.open()
					A.locked = 1

		spawn_object/
			icon_state = "trigger_spawn_object"
			var/_object_to_spawn = "*INSERT PATH HERE*"

			OnCompleted()
				if(_object_to_spawn)
					if(istext(_object_to_spawn))
						_object_to_spawn = text2path(_object_to_spawn)

					new _object_to_spawn(get_turf(src))

		sound/
			var/_soundfile = "*INSERT SOUND FILE HERE*"
			var/_volume = 100
			var/_vary = 0
			var/_extra_range = 0
			var/_falloff = 0
			var/_surround = 1
			icon_state = "trigger_sound"

			OnCompleted()
				playsound(get_turf(src), _soundfile, _volume, _vary, _extra_range, _falloff, _surround)

		spawn_effect/
			var/_effect_type = "*choose from (smoke, spark, lightning, foam, steam)*"
			var/_amount = 5

			icon_state = "trigger_effect"

			OnCompleted()
				var/datum/effect/effect/system/system

				switch(_effect_type)
					if("smoke")
						system = new /datum/effect/effect/system/harmless_smoke_spread()
						system.set_up(_amount, 0, get_turf(src))
						system.start()

					if("spark")
						system = new /datum/effect/effect/system/spark_spread()
						system.set_up(_amount, 0, get_turf(src))
						system.start()

					if("lightning")
						system = new /datum/effect/effect/system/lightning_spread()
						system.set_up(_amount, 0, get_turf(src))
						system.start()

					if("foam")
						system = new /datum/effect/effect/system/foam_spread()
						system.set_up(_amount, get_turf(src))
						system.start()

					if("steam")
						system = new /datum/effect/effect/system/steam_spread()
						system.set_up(get_turf(src))
						system.start()

		replace_turf/
			var/_replace_with = "*INSERT PATH HERE*"

			icon_state = "trigger_replace_turf"

			OnCompleted()
				var/turf/T = get_turf(src)
				if(istext(_replace_with))
					_replace_with = text2path(_replace_with)

				T.ChangeTurf(_replace_with)