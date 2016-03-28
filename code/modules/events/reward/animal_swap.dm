/datum/round_event_control/animal_swap
	name = "Animal Swap"
	typepath = /datum/round_event/animal_swap
	event_flags = EVENT_REWARD
	weight = 10

/datum/round_event/animal_swap
	var/list/animals = list()
	var/list/animal_types = list(/mob/living/simple_animal/corgi/Ian,/mob/living/simple_animal/corgi/Lisa,/mob/living/simple_animal/alpaca,/mob/living/simple_animal/cat,/mob/living/simple_animal/parrot,/mob/living/simple_animal/hostile/retaliate/goat,/mob/living/simple_animal/pug)
	var/list/new_animals = list(/mob/living/simple_animal/chicken,/mob/living/simple_animal/alpaca,/mob/living/simple_animal/cow)

	Setup()
		for(var/mob/living/simple_animal/S in world)
			for(var/types in (animal_types + new_animals))
				if(istype(S,types))
					animals.Add(S)

	Start()
		while(animals.len)
			if(animals.len == 1)
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(4, 2, get_turf(animals[1]))
				s.start()
				break
			var/mob/living/simple_animal/animal_A = pick_n_take(animals)
			var/mob/living/simple_animal/animal_B = pick_n_take(animals)
			if(!animal_A || !animal_B)
				continue //when the event is running more than one instance this could get tricky
			if(prob(50))
				if(prob(50))
					var/name_B = animal_B.name
					var/turf/loc_B = animal_B.loc
					qdel(animal_B)
					var/new_animal = pick(new_animals)
					animal_B = new new_animal(loc_B)
					animal_B.name = name_B
				if(!animal_A || !animal_B)
					continue //when the event is running more than one instance this could get tricky
				var/turf/loc_A = animal_A.loc
				var/turf/loc_B = animal_B.loc
				animal_A.loc = loc_B
				animal_B.loc = loc_A
			else
				var/name_A = animal_A.name
				var/name_B = animal_B.name
				animal_A.name = name_B
				animal_B.name = name_A
			var/datum/effect/effect/system/spark_spread/s1 = new /datum/effect/effect/system/spark_spread
			s1.set_up(4, 2, get_turf(animal_A))
			s1.start()

			var/datum/effect/effect/system/spark_spread/s2 = new /datum/effect/effect/system/spark_spread
			s2.set_up(4, 2, get_turf(animal_B))
			s2.start()

	Alert()
		priority_announce("Space-time anomalies detected on the station. There is no additional data.", "Woof Woof Woof", 'sound/AI/spanomalies.ogg')
