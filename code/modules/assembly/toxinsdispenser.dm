/obj/machinery/canistermaker
	name = "Canister Maker"
	desc = "It's for training in toxins."
	icon = 'icons/obj/machines/heavy_lathe.dmi'
	icon_state = "h_lathe_leave"
	density = 1
	anchored = 1
	var/list/canistertypes = list()
	var/on = FALSE

/obj/machinery/canistermaker/New()
	..()
	updatecans()

/obj/machinery/canistermaker/proc/updatecans()
	for(var/U in canistertypes)
		canistertypes.Remove(U)
	for(var/U in typesof(/obj/machinery/portable_atmospherics/canister))
		var/obj/machinery/portable_atmospherics/canister/V = new U
		src.canistertypes += V
	return

/obj/machinery/canistermaker/attack_hand(mob/user as mob)
	on = TRUE
	var/obj/machinery/portable_atmospherics/canister/C
	C = input("Select canister to make.", "Toxins", C) in canistertypes
	if(!C)
		return
		on = FALSE
	else
		user << "You dispense [C]."
		C.loc = src.loc
		playsound(loc, 'sound/machines/ding.ogg', 50, 1)
		updatecans()
		on = FALSE
		return
