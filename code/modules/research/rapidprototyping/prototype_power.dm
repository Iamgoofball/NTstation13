//POWER SUPPLY PROCS

/obj/item/weapon/rnd/powersource/proc/has_fuel()
	return 1

/obj/item/weapon/rnd/powersource/proc/use_fuel()
	return

/obj/item/weapon/rnd/powersource/proc/eject_fuel()
	return

/obj/item/weapon/rnd/powersource/proc/display_fuel()
	return 0

/obj/item/weapon/rnd/powersource/process()

	if(world.time % (10-rating) != 0) //Better power supplies will charge more often.
		return

	if(!istype(loc,/obj/item/weapon/rnd/prototype))
		return

	var/obj/item/weapon/rnd/prototype/container = loc

	if(!container || !capacitor) //No capacitor, no power.
		return

	if(has_fuel())
		use_fuel()
		container.charge(rating*charge_multiplier)

/obj/item/weapon/rnd/powersource/microbattery/process()
	return //Microbatteries act like old-style tasers, charged from wall mounts; charging is handled elsewhere.


// CELL MOUNT PROCS

/obj/item/weapon/rnd/powersource/cell_mount/display_fuel()
	return "[cell ? "[cell.charge]/[cell.maxcharge] units of charge remain in \the [cell]." : "No cell has been inserted."]"

/obj/item/weapon/rnd/powersource/cell_mount/has_fuel()

	if(!cell || cell.charge <= 0)
		return 0

	return 1

/obj/item/weapon/rnd/powersource/cell_mount/use_fuel()
	if(!cell) return
	cell.charge -= 50/src.rating
	if(cell.charge < 0) cell.charge = 0

/obj/item/weapon/rnd/powersource/cell_mount/eject_fuel()
	if(!cell) return
	components -= cell
	cell.loc = get_turf(src)
	cell = null

// END CELL MOUNT PROCS//

//FUEL CELL PROCS

/obj/item/weapon/rnd/powersource/fuel_cell/display_fuel()
	if(has_fuel())
		var/amount = 0

		for(var/obj/item/stack/sheet/mineral/F in fuel_storage.contents)
			if(istype(F,fuel_type))
				amount += F.amount

		return "[amount] units of fuel remain."
	else
		return "There is no fuel stored."

/obj/item/weapon/rnd/powersource/fuel_cell/has_fuel()

	if(!fuel_type) return
	if(!fuel_storage) return

	for(var/obj/item/F in fuel_storage.contents)
		if(istype(F,fuel_type))
			return 1
	return 0

/obj/item/weapon/rnd/powersource/fuel_cell/use_fuel()

	var/fuel_req = 1

	for(var/obj/item/stack/sheet/mineral/F in fuel_storage.contents)
		if(istype(F,fuel_type) && fuel_req > 0)
			if(F.amount >= fuel_req)
				F.use(fuel_req)
				fuel_req = 0
			else
				fuel_req -= F.amount
				F.use(F.amount)
		return

/obj/item/weapon/rnd/powersource/fuel_cell/eject_fuel()

	if(!fuel_type) return
	if(!fuel_storage) return

	for(var/obj/item/stack/sheet/mineral/F in fuel_storage.contents)
		if(istype(F,fuel_type))
			F.loc = get_turf(src)
			break
	return

// END FUEL CELL PROCS //