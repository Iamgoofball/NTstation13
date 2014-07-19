/obj/machinery/oremagpull
	name = "Scrap Magnet"
	desc = "You pull 16 tons of scrap a day, you get another day older and deeper in scrap."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "ore_mag_off"
	density = 1
	anchored = 1
	var/obj/machinery/oremagcomputer/controller_computer = null

/obj/machinery/oremagpull/attack_hand(mob/user as mob)
	if(controller_computer)
		if(controller_computer.on)
			user << "Please wait for the magnet to finish pulling."
		else
			if(!controller_computer.haspulled)
				user << "There is no scrap to repel!"
				return
			user << "You use the magnet to repel the currently pulled scrap, sending it off into the vast uncharted regions of space."

		for(var/turf/simulated/T in controller_computer.scraparea)
			T.ChangeTurf(/turf/space/)
		for(var/obj/O in controller_computer.scraparea)
			qdel(O)
		for(var/mob/living/carbon/human/poor_fellow in controller_computer.scraparea)
			poor_fellow << "You watch as the scrap you are standing on suddenly jets off. Your body is smashed to smithereens in seconds from the impact, with your last thoughts being 'Oh shi-'"
			qdel(poor_fellow)
		for(var/mob/living/simple_animal/M in controller_computer.scraparea)
			M.Die()

		controller_computer.haspulled = FALSE
		user << "Magnet has finished repelling."
		return