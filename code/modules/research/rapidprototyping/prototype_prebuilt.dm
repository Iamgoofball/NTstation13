//DEBUG ITEMS

/obj/item/weapon/rnd/prototype/complete/laser/New()

	..()

	chassis = new /obj/item/weapon/rnd/chassis/large_device(src)
	power = new /obj/item/weapon/rnd/powersource/microbattery(src)
	primer = new /obj/item/weapon/rnd/primer/energy_projector(src)
	trigger = new /obj/item/weapon/rnd/trigger/gun(src)

	components += chassis
	components += power
	components += primer
	components += trigger
	components += new /obj/item/weapon/rnd/lens(src)
	components += new /obj/item/weapon/rnd/booster(src)
	power.capacitor = new /obj/item/weapon/stock_parts/capacitor/super(src)

	for(var/obj/item/weapon/rnd/C in components)
		for(var/flag in list(WELDED,CALIBRATED,WRENCHED,SECURED))
			C.rnd_flags |= flag

	slot_flags = chassis.slot_flags

	update_icon()

/obj/item/weapon/rnd/prototype/complete/vest/New()

	..()

	chassis = new /obj/item/weapon/rnd/chassis/body(src)
	power = new /obj/item/weapon/rnd/powersource/microbattery(src)
	primer = new /obj/item/weapon/rnd/primer/field_projector(src)
	trigger = new /obj/item/weapon/rnd/trigger/impact(src)

	components += chassis
	components += power
	components += primer
	components += trigger

	power.capacitor = new /obj/item/weapon/stock_parts/capacitor/super(src)

	slot_flags = chassis.slot_flags

	for(var/obj/item/weapon/rnd/C in components)
		for(var/flag in list(WELDED,CALIBRATED,WRENCHED,SECURED))
			C.rnd_flags |= flag

	update_icon()

/obj/item/weapon/rnd/prototype/complete/blinkgun/New()

	..()

	chassis = new /obj/item/weapon/rnd/chassis/large_device(src)
	power = new /obj/item/weapon/rnd/powersource/microbattery(src)
	primer = new /obj/item/weapon/rnd/primer/field_projector(src)
	trigger = new /obj/item/weapon/rnd/trigger/gun(src)

	components += chassis
	components += power
	components += primer
	components += trigger

	components += new /obj/item/weapon/rnd/bscrystal(src)

	power.capacitor = new /obj/item/weapon/stock_parts/capacitor/super(src)

	slot_flags = chassis.slot_flags

	for(var/obj/item/weapon/rnd/C in components)
		for(var/flag in list(WELDED,CALIBRATED,WRENCHED,SECURED))
			C.rnd_flags |= flag

	update_icon()

/obj/item/weapon/rnd/prototype/complete/blinkvest/New()

	..()

	chassis = new /obj/item/weapon/rnd/chassis/body(src)
	power = new /obj/item/weapon/rnd/powersource/microbattery(src)
	primer = new /obj/item/weapon/rnd/primer/field_projector(src)
	trigger = new /obj/item/weapon/rnd/trigger/impact(src)

	components += chassis
	components += power
	components += primer
	components += trigger

	components += new /obj/item/weapon/rnd/bscrystal(src)

	power.capacitor = new /obj/item/weapon/stock_parts/capacitor/super(src)

	slot_flags = chassis.slot_flags

	for(var/obj/item/weapon/rnd/C in components)
		for(var/flag in list(WELDED,CALIBRATED,WRENCHED,SECURED))
			C.rnd_flags |= flag

	update_icon()

/obj/item/weapon/rnd/prototype/complete/decloner/New()

	..()

	chassis = new /obj/item/weapon/rnd/chassis/large_device(src)
	power = new /obj/item/weapon/rnd/powersource/microbattery(src)
	primer = new /obj/item/weapon/rnd/primer/field_projector(src)
	trigger = new /obj/item/weapon/rnd/trigger/gun(src)

	components += chassis
	components += power
	components += primer
	components += trigger

	components += new /obj/item/weapon/rnd/defocuser(src)
	components += new /obj/item/weapon/rnd/cloneboost(src)

	power.capacitor = new /obj/item/weapon/stock_parts/capacitor/super(src)

	slot_flags = chassis.slot_flags

	for(var/obj/item/weapon/rnd/C in components)
		for(var/flag in list(WELDED,CALIBRATED,WRENCHED,SECURED))
			C.rnd_flags |= flag

	update_icon()


/obj/item/weapon/rnd/prototype/complete/cooler/New()

	..()

	chassis = new /obj/item/weapon/rnd/chassis/large_device(src)
	power = new /obj/item/weapon/rnd/powersource/microbattery(src)
	primer = new /obj/item/weapon/rnd/primer/field_projector(src)
	trigger = new /obj/item/weapon/rnd/trigger/gun(src)

	components += chassis
	components += power
	components += primer
	components += trigger

	components += new /obj/item/weapon/rnd/cooler(src)
	components += new /obj/item/weapon/rnd/booster(src)

	power.capacitor = new /obj/item/weapon/stock_parts/capacitor/super(src)

	slot_flags = chassis.slot_flags

	for(var/obj/item/weapon/rnd/C in components)
		for(var/flag in list(WELDED,CALIBRATED,WRENCHED,SECURED))
			C.rnd_flags |= flag

	update_icon()

/obj/item/weapon/rnd/prototype/complete/heater/New()

	..()

	chassis = new /obj/item/weapon/rnd/chassis/large_device(src)
	power = new /obj/item/weapon/rnd/powersource/microbattery(src)
	primer = new /obj/item/weapon/rnd/primer/field_projector(src)
	trigger = new /obj/item/weapon/rnd/trigger/gun(src)

	components += chassis
	components += power
	components += primer
	components += trigger

	components += new /obj/item/weapon/rnd/heater(src)
	components += new /obj/item/weapon/rnd/booster(src)

	power.capacitor = new /obj/item/weapon/stock_parts/capacitor/super(src)

	slot_flags = chassis.slot_flags

	for(var/obj/item/weapon/rnd/C in components)
		for(var/flag in list(WELDED,CALIBRATED,WRENCHED,SECURED))
			C.rnd_flags |= flag

	update_icon()