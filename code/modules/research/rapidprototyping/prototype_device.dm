//ROOT OBJECT DEFINES

/obj/item/weapon/rnd/prototype

	name = "prototype device"
	desc = "It's a science thing. You wouldn't understand."
	icon_state = "base_icon"
	icon = 'icons/obj/prototyping.dmi'

	var/obj/item/weapon/rnd/primer/primer
	var/obj/item/weapon/rnd/trigger/trigger
	var/obj/item/weapon/rnd/powersource/power
	var/obj/item/weapon/rnd/chassis/chassis
	var/stored_charge = 0
	var/need_update_effect = 1
	var/datum/prototype/effect/effect

//PROTOTYPE PROCS

/obj/item/weapon/rnd/prototype/New()
	..()
	effect = new(src)

/obj/item/weapon/rnd/prototype/update_icon()

	overlays.Cut()

	for(var/obj/item/weapon/rnd/C in list(trigger,chassis,power,primer))

		if(!C) continue

		var/tmp_color = "#ACACAC"

		if(C.basecolor)
			tmp_color = C.basecolor

		if(C.base_icon)
			var/image/base = new(icon,"[C.base_icon]")
			base.color = tmp_color
			overlays += base

		if(C.detail_icon)
			var/image/detail = new(icon,"[C.detail_icon]")
			overlays += detail

	//Handle components after this point.

/obj/item/weapon/rnd/prototype/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)

	if(primer && istype(primer,/obj/item/weapon/rnd/primer/firing_mechanism) && istype(O, /obj/item/ammo_box))
		var/obj/item/weapon/rnd/primer/firing_mechanism/FM = primer
		if(FM.load_method != MAGAZINE && istype(O,/obj/item/ammo_box/magazine))
			user << "\The [src] does not accept magazines."
			return

		if(FM.magazine)
			user << "\The [src] already has a magazine loaded."
			return

		var/obj/item/ammo_box/AM = O
		if(!AM.stored_ammo.len) return
		var/obj/item/ammo_casing/B = AM.stored_ammo[1]
		if(B.caliber == FM.caliber)
			user.drop_item()
			FM.magazine = AM
			FM.magazine.loc = FM
			user << "\blue You slot [AM] into \the [src]."
			need_update_effect = 1
		else
			user << "\The [src] does not use that calibre of ammunition."
		return
		O.update_icon()
		update_icon()

	if(istype(O,/obj/item/weapon/rnd/chassis))
		if(chassis)
			user << "How are you going to install one chassis inside another, idiot?"
			return
		else
			user << "Somehow, \the [src] is lacking a chassis. You install [O] and don't ask any more questions."
			user.drop_item()
			chassis = O
			src.components += O
			O.loc = src
			var/obj/item/weapon/rnd/C = O
			C.reset_flags()
			need_update_effect = 1
		update_icon()

	else if(istype(O,/obj/item/weapon/rnd))

		var/obj/item/weapon/rnd/C = O
		if(!(C.check_status()))
			user << "\The [O] is not ready for installation."
			return

		if(istype(O,/obj/item/weapon/rnd/primer))
			if(primer)
				user << "\The [src] already has a primary module installed."
				return
			else
				primer = O
		else if(istype(O,/obj/item/weapon/rnd/trigger))
			if(trigger)
				user << "\The [src] already has an interface installed."
				return
			else
				trigger = O
		else if(istype(O,/obj/item/weapon/rnd/powersource))
			if(power)
				user << "\The [src] already has a power supply installed."
				return
			else
				power = O
		else
			if(components.len > 6)
				user << "There is no more room in \the [src] for \the [O]."
				return

		user << "You install \the [O] into \the [src]."
		need_update_effect = 1
		user.drop_item()
		O.loc = src
		C.reset_flags()
		n_listinsert(src.components,1,O)
		update_icon()
		return
	else if(istype(O,/obj/item/weapon/wrench))
		toggle_component(user,NEEDS_WRENCH,"bolt down","unbolt")
		return
	else if(istype(O,/obj/item/weapon/screwdriver))
		toggle_component(user,NEEDS_SECURING,"secure","unsecure")
		return
	else if(istype(O,/obj/item/device/multitool))
		toggle_component(user,NEEDS_CALIBRATION,"calibrate and initialize","uninitialize")
		return
	else if(istype(O,/obj/item/weapon/weldingtool))
		toggle_component(user,NEEDS_WELDER,"securely weld","carefully unweld")
		return
	else if(istype(O,/obj/item/weapon/crowbar))
		if(power && power.needs_fuel && power.has_fuel())
			power.eject_fuel()
		else
			remove_component(user)
			update_icon()
	else if(istype(O,/obj/item/weapon/stock_parts/cell))
		if(power && istype(power,/obj/item/weapon/rnd/powersource/cell_mount))
			var/obj/item/weapon/rnd/powersource/cell_mount/P = power
			if(P.cell)
				user << "\The [src] already has a power cell installed."
			else
				user.drop_item()
				P.cell = O
				O.loc = P
				P.components += P.cell
				user << "You jack \the [O] into \the [src]'s [P]."
				need_update_effect = 1
			return
	else if (istype(O,/obj/item/stack/sheet/mineral) && power && istype(power,/obj/item/weapon/rnd/powersource/fuel_cell))
		var/obj/item/weapon/rnd/powersource/fuel_cell/PS = power
		if(PS.fuel_type && istype(O,PS.fuel_type))
			if(PS.fuel_storage)

				var/capacity = (10*PS.fuel_storage.rating)

				for(var/obj/item/stack/sheet/mineral/F in PS.fuel_storage.contents)

					if(istype(F,PS.fuel_type))
						if(capacity >= F.amount)
							capacity -= F.amount
						else
							capacity = 0
							break

				if(capacity <= 0)
					user << "There is no room in [src] for more fuel."
					return

				var/obj/item/stack/sheet/mineral/F = O
				var/obj/item/stack/sheet/mineral/fuel = new F.type(PS.fuel_storage)
				F.use(capacity)
				fuel.amount = capacity
				user << "You feed [num2text(capacity)] sheets into \the [src]."
				return
			else
				user << "There is nowhere in \the [src] to store [O]."
				return
		else
			user << "\The [src] cannot process that type of fuel."
			return
	..()

/obj/item/weapon/rnd/prototype/proc/toggle_component(var/mob/user, var/flag, var/response_on, var/response_off)

	for(var/obj/item/weapon/rnd/C in components)

		if(C.rnd_flags & flag)
			if(components.Find(C) == 1) //Component needs to be on top to be reachable.
				C.rnd_flags ^= (flag*2)
				user << "You reach into [src] and [(C.rnd_flags & (flag*2)) ? "[response_on]" : "[response_off]"] \the [C]."
			else
				user << "\red You cannot reach \the [C]; other components are in the way."
			return

	user << "You cannot see a way to modify anything within [src] with that tool."
	return 0

/obj/item/weapon/rnd/prototype/proc/remove_component(var/mob/user as mob)

	var/obj/item/weapon/rnd/C = components[1]

	if(components.len <= 2)
		user << "You completely dismantle \the [src]."
		C.loc = get_turf(src)
		chassis.loc = get_turf(src)
		del(src)
	else if(components.len > 1)
		for(var/flag in list(NEEDS_WELDER,NEEDS_WRENCH,NEEDS_SECURING))
			if( (C.rnd_flags & flag) && (C.rnd_flags & (flag*2)) )
				user << "\The [C] is still firmly secured inside [src] and won't budge."
				return

		user << "You painstakingly remove \the [C] from \the [src]."
		components -= C
		C.loc = get_turf(src)

		if(istype(C,/obj/item/weapon/rnd/powersource))
			var/obj/item/weapon/rnd/powersource/PS = C
			if(PS.has_fuel()) PS.eject_fuel()

		if(power && power.loc != src) power = null
		if(trigger && trigger.loc != src) trigger = null
		if(primer && primer.loc != src) primer = null

	else
		user << "You realize with a sense of creeping dread that \the [src] exists without chassis or internal components. How spooky."
		return

/obj/item/weapon/rnd/prototype/check_status()

	if(!power || !primer || !trigger)
		return 0 // Device is incomplete.

	for(var/obj/item/weapon/rnd/C in components)
		for(var/flag in list(NEEDS_WELDER,NEEDS_CALIBRATION,NEEDS_WRENCH,NEEDS_SECURING))
			if(C.broken || ((C.rnd_flags & flag) && !(C.rnd_flags & (flag*2)))) // If the component needs something and hasn't got it...
				return 0 // Nope.
	return 1 //All systems go, captain.

/obj/item/weapon/rnd/prototype/proc/powered()

	if(!check_status() || !(power.capacitor)) return

	var/cost = get_rating()*25

	if(stored_charge < cost)
		return 0
	else
		expend_charge(cost)
		return 1

/obj/item/weapon/rnd/prototype/proc/expend_charge(var/output)

	if(!power || !(power.capacitor))
		stored_charge = 0
		return

	if(output == "all")
		stored_charge = 0
	else
		stored_charge -= output
		if(stored_charge<0) stored_charge = 0

/obj/item/weapon/rnd/prototype/proc/charge(var/input)

	if(!power || !(power.capacitor))
		stored_charge = 0
		return

	stored_charge += input
	if(stored_charge > (power.capacitor.rating*1000)) stored_charge = (power.capacitor.rating*1000)

/obj/item/weapon/rnd/prototype/proc/trigger_device(mob/user as mob,atom/target as mob|obj|turf|area,var/melee)

	if(need_update_effect)
		update_effect()

	if(!primer.ready_to_fire()) return

	var/turf/curloc = get_turf(user)
	var/turf/targloc = get_turf(target)

	if (!istype(targloc) || !istype(curloc))
		return

	if(check_status())
		if(powered())

			user.next_move = world.time + 4

			if(primer.recoil)
				spawn()
					shake_camera(user, primer.recoil + 1, primer.recoil)

			playsound(user, primer.fire_sound, 50, 1)

			if(melee && target.Adjacent(user))
				apply_effect(target)
				return
			else
				user.visible_message("<span class='warning'>[user] [primer.base_projectile_type ? "fires" : "engages"] [src]!</span>", \
				"<span class='warning'>You [primer.base_projectile_type ? "fire" : "engage"] [src]!</span>", \
				"You hear a device firing!")

			if(user == target || src == target || src.loc == target) //Device is targeting the holder or itself.

				apply_effect(get_turf(src))

			else if(primer.base_projectile_type) //Device is projectile-based.

				if(istype(primer,/obj/item/weapon/rnd/primer/firing_mechanism))
					var/obj/item/weapon/rnd/primer/firing_mechanism/F = primer
					F.use_ammo()

				//Mostly stolen from gun code.
				var/obj/item/projectile/B = new primer.base_projectile_type(get_turf(src))
				B.original = target
				B.starting = loc
				B.shot_from = src
				B.current = curloc
				B.yo = targloc.y - curloc.y
				B.xo = targloc.x - curloc.x

				spawn()
					if(B)
						B.process()
				sleep(1)
				B = null

			else //Device is field-based.

				target.visible_message("<span class='warning'>A shimmering field surrounds [target]!</span>")
				for(var/turf/TT in range(get_turf(target),effect.degree/4))
					apply_effect(TT)

		else
			user << "\red [src] is unpowered!"
	else
		user << "\red [src] is incomplete!"

//PROTOTYPE ACTIVATION PROCS

/obj/item/weapon/rnd/prototype/attack_ai(mob/user as mob)
	..()
	if(trigger && trigger.trigger_type == TRIGGER_SYNTHETIC)
		trigger_device(user,src)

/obj/item/weapon/rnd/prototype/attack_self(var/mob/user as mob)
	..()
	if(trigger && trigger.trigger_type == TRIGGER_SWITCH)
		trigger_device(user,user)

/obj/item/weapon/rnd/prototype/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
	if(trigger && trigger.trigger_type == TRIGGER_CLICK)

		if(flag)
			return

		trigger_device(user,target)

//COMPLETED DEVICE PROCS

/obj/item/weapon/rnd/prototype/complete/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)
	if(istype(O,/obj/item/weapon/crowbar) || istype(O,/obj/item/weapon/wrench) || istype(O,/obj/item/weapon/screwdriver) || istype(O,/obj/item/device/multitool) || istype(O,/obj/item/weapon/weldingtool))
		user << "\red \The [src] is protected by sophisticated Fabrication Rights Management technology - you cannot alter it."
		return

//CHASSIS PROCS

/obj/item/weapon/rnd/chassis/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)

	if(istype(O,/obj/item/weapon/rnd))

		var/obj/item/weapon/rnd/C = O

		if(!(C.check_status()))
			user << "\The [O] is not ready for installation."
			return

		user << "You install \the [O] into \the [src]."

		user.drop_item()

		var/obj/item/weapon/rnd/prototype/P = new(get_turf(src))

		if(istype(O,/obj/item/weapon/rnd/primer))
			P.primer = O
		else if(istype(O,/obj/item/weapon/rnd/trigger))
			P.trigger = O
		else if(istype(O,/obj/item/weapon/rnd/powersource))
			P.power = O

		P.name = "prototype [src.name]"
		P.slot_flags = src.slot_flags
		P.chassis = src
		P.components += O
		P.components += src
		src.loc = P
		O.loc = P
		C.reset_flags()
		P.update_icon()
		return

	..()