/obj/machinery/oremagcomputer
	name = "scrap magnet console"
	desc = "Used to activate the Scrap Magnet."
	icon = 'icons/obj/computer.dmi'
	var/obj/machinery/oremagpull/oremag = null
	var/area/oremag/scrap/scraparea = null
	var/on = FALSE
	var/haspulled = FALSE
	icon_state = "ore_mag"
	anchored = 1
	density = 1


/obj/machinery/oremagcomputer/attack_hand(mob/user as mob)
	if(on)
		user << "Please wait for the magnet to finish processing."
	if(!oremag)
		user << "No scrap magnet linked. Linking to closest available scrap magnet."
		for(var/obj/machinery/oremagpull/M in world)
			oremag = M
			M.controller_computer = src
		if(oremag)
			user << "Linking complete."
		else
			user << "Error: No Scrap Magnet Detected."
			return
		for(var/area/oremag/scrap/A in world)
			scraparea = A
		if(scraparea)
			return
		else
			user << "No Scrap Magnet Area found. Contact a coder."// there's no scrap magnet area for some reason.
			return
	else
		on = TRUE
		oremag.icon_state = "ore_mag_on"
		user << "Scrap Magnet now pulling."
		sleep(200)

		for(var/turf/space/T in scraparea) // Begin generation of pulled turfs.
			var/turf_chance = rand(1,60)
			switch(turf_chance)
				if(1 to 39)
					T.ChangeTurf(/turf/simulated/mineral/random)
				if(40)
					T.ChangeTurf(/turf/simulated/floor/airless)
				if(41)
					T.ChangeTurf(/turf/simulated/floor/plating/airless)
				if(42)
					T.ChangeTurf(/turf/simulated/floor/plating/airless)
				if(43)
					T.ChangeTurf(/turf/simulated/floor/airless)
				if(44)
					T.ChangeTurf(/turf/simulated/wall/r_wall)
				if(45)
					T.ChangeTurf(/turf/simulated/wall/mineral/gold)
				if(46)
					T.ChangeTurf(/turf/simulated/wall/mineral/diamond)
				if(47)
					T.ChangeTurf(/turf/simulated/wall/mineral/clown)
				if(48)
					T.ChangeTurf(/turf/simulated/wall/mineral/sandstone)
				if(49)
					T.ChangeTurf(/turf/simulated/wall/mineral/plasma)
				if(50)
					T.ChangeTurf(/turf/simulated/wall)
				if(51)
					T.ChangeTurf(/turf/simulated/wall/mineral/silver)
				if(52)
					T.ChangeTurf(/turf/simulated/wall/mineral/uranium)
				if(53 to 60)
					T.ChangeTurf(/turf/simulated/floor/plating/asteroid)

		for(var/turf/simulated/floor/F in scraparea) // Begin generation of pulled objects
			var/obj_chance = rand(1,24)
			switch(obj_chance)
				if(1 to 19)
					continue
				if(20)
					new /obj/structure/closet/crate/secure/loot(F.loc)
				if(21)
					new /obj/item/weapon/reagent_containers/glass/beaker/slime(F.loc)
				if(22)
					for(var/i = 0, i < 10, i++)
						new /obj/item/weapon/ore/diamond(F.loc)
				if(23)
					for(var/i = 0, i < 10, i++)
						new /obj/item/weapon/ore/clown(F.loc)
				if(24)
					for(var/i = 0, i < 10, i++)
						new /obj/item/weapon/ore/plasma(F.loc)

		for(var/turf/simulated/floor/F in scraparea) // Begin generation of pulled mobs
			var/mob_chance = rand(1,84)
			switch(mob_chance)
				if(1 to 79)
					continue
				if(80)
					new /mob/living/simple_animal/hostile/asteroid/basilisk(F.loc)
				if(81)
					new /mob/living/simple_animal/hostile/asteroid/goldgrub(F.loc)
				if(82)
					new /mob/living/simple_animal/hostile/asteroid/hivelord(F.loc)
				if(83)
					new /mob/living/simple_animal/hostile/asteroid/hivelordbrood(F.loc)
				if(84)
					new /mob/living/simple_animal/hostile/asteroid/goliath(F.loc)

		user << "Pull complete."
		on = FALSE
		haspulled = TRUE
		oremag.icon_state = "ore_mag_off"
		return



