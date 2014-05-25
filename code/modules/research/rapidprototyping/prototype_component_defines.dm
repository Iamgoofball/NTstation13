//COMPONENT DEFINE
#define MAGAZINE 1
/obj/item/weapon/rnd
	name = "research component"
	desc = "You have no idea what it is, but it sure looks sciency."
	icon = 'icons/obj/prototyping.dmi'
	icon_state = "base_icon"

	var/rnd_flags = 0
	var/broken
	var/prototype = 1
	var/rating = 1 //General degree of quality.

	var/list/research_values = list()
	var/list/components = list()
	var/list/required_components //Null so later procs don't bother with loops if it no reqs are set.

	var/basecolor = "#ACACAC" //ack ack ack ack ack
	var/base_icon = "addon"
	var/detail_icon

// PRIMARY MODULE DEFINES.

/obj/item/weapon/rnd/New()
	..()
	update_icon()

/obj/item/weapon/rnd/update_icon()

	overlays.Cut()
	if(!basecolor)
		basecolor = "#[pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))]"

	if(base_icon)
		var/image/base = new(icon,"[base_icon]")
		base.color = basecolor
		overlays += base

	if(detail_icon)
		var/image/detail = new(icon,"[detail_icon]")
		overlays += detail

/obj/item/weapon/rnd/primer
	name = "prototype module"
	base_icon = "generic_primer"

	rnd_flags = NEEDS_WELDER | NEEDS_WRENCH | NEEDS_SECURING
	var/base_projectile_type
	var/fire_sound
	var/recoil

/obj/item/weapon/rnd/primer/proc/ready_to_fire()
	return 1

/obj/item/weapon/rnd/primer/proc/handle_ai()

	if(!istype(src.loc,/obj/item/weapon/rnd/prototype))
		return

	var/turf/T = get_turf(src)
	T.visible_message("\blue \The [src.loc] beeps happily at everything in front of it.")
	return

/obj/item/weapon/rnd/primer/firing_mechanism //Standard ballistic.
	name = "firing mechanism"
	required_components = list(/obj/item/weapon/stock_parts/manipulator)
	base_projectile_type = "/obj/item/projectile/bullet/midbullet"
	fire_sound = 'sound/weapons/Gunshot.ogg'
	recoil = 1

	var/obj/item/ammo_box/magazine //Ammunition storage object.
	var/caliber = "9mm"                 //Type of ammo.
	var/load_method = MAGAZINE          //Type of load object.

/obj/item/weapon/rnd/primer/firing_mechanism/ready_to_fire()
	//Check for loaded ammunition.
	if(!magazine) return 0
	if(!magazine.stored_ammo.len) return 0
	return 1

/obj/item/weapon/rnd/primer/firing_mechanism/proc/use_ammo()
	..()
	if(!magazine || !magazine.stored_ammo.len) return
	var/obj/item/ammo_casing/AC = magazine.stored_ammo[1]
	magazine.stored_ammo -= AC
	AC.loc = get_turf(src)


/obj/item/weapon/rnd/primer/energy_projector //Egun.
	name = "energy projector"
	rnd_flags = NEEDS_CALIBRATION | NEEDS_SECURING
	required_components = list(/obj/item/weapon/stock_parts/capacitor,/obj/item/weapon/stock_parts/manipulator)
	base_projectile_type = "/obj/item/projectile/energy/prototype"
	fire_sound = 'sound/weapons/Laser.ogg'

	base_icon = "energyprojector"
	detail_icon	= "energyprojector_detail"

/obj/item/weapon/rnd/primer/field_projector  //AoE.
	name = "field projector"
	rnd_flags = NEEDS_CALIBRATION | NEEDS_SECURING
	required_components = list(/obj/item/weapon/stock_parts/capacitor,/obj/item/weapon/stock_parts/manipulator)

	base_icon = "fieldprojector"
	detail_icon	= "fieldprojector_detail"

/obj/item/weapon/rnd/primer/multireader      //Scanning device.
	name = "multireader module"
	rnd_flags = NEEDS_CALIBRATION | NEEDS_SECURING | NEEDS_WRENCH
	required_components = list(/obj/item/weapon/stock_parts/scanning_module)

// TRIGGER DEFINES.

/obj/item/weapon/rnd/trigger
	name = "prototype interface"
	rnd_flags = NEEDS_CALIBRATION | NEEDS_SECURING
	base_icon = "generic_trigger"

	var/trigger_type
/*
/obj/item/weapon/rnd/trigger/movement
	name = "somatic trigger array"
	trigger_type = TRIGGER_MOVE_SELF
	required_components = list(/obj/item/weapon/stock_parts/scanning_module)

/obj/item/weapon/rnd/trigger/proxy
	name = "proximity trigger array"
	trigger_type = TRIGGER_MOVE_OTHER
	required_components = list(/obj/item/weapon/stock_parts/scanning_module)
*/
/obj/item/weapon/rnd/trigger/impact
	name = "impact trigger array"
	trigger_type = TRIGGER_HOLDER_DAMAGE
	required_components = list(/obj/item/weapon/stock_parts/manipulator)

/obj/item/weapon/rnd/trigger/synthetic
	name = "heuristic interface"
	trigger_type = TRIGGER_SYNTHETIC
	required_components = list(/obj/item/weapon/stock_parts/scanning_module)

/obj/item/weapon/rnd/trigger/gun
	name = "manual trigger"
	trigger_type = TRIGGER_CLICK
	required_components = list(/obj/item/weapon/stock_parts/manipulator)
	base_icon = "manualtrigger"

/obj/item/weapon/rnd/trigger/config
	name = "switch panel"
	trigger_type = TRIGGER_SWITCH
	required_components = list(/obj/item/weapon/stock_parts/manipulator)

//POWER SUPPLY DEFINES

/obj/item/weapon/rnd/powersource
	name = "prototype power source"
	rnd_flags = NEEDS_CALIBRATION | NEEDS_WELDER | NEEDS_SECURING
	required_components = list(/obj/item/weapon/stock_parts/capacitor)
	base_icon = "generic_power"

	var/obj/item/weapon/stock_parts/capacitor/capacitor //Rating of capacitor determines max stored charge
	var/obj/item/weapon/stock_parts/matter_bin/fuel_storage //Fuel storage. Rating equals capacity.
	var/charge_multiplier = 1
	var/needs_fuel = 0

//Process() is used to ensure power supplies charge properly.
/obj/item/weapon/rnd/powersource/New()
		..()
		processing_objects.Add(src)

/obj/item/weapon/rnd/powersource/Del()
		processing_objects.Remove(src)
		..()

/obj/item/weapon/rnd/powersource/microbattery
	name = "microbattery"
	base_icon = "microbattery"
	detail_icon = "microbattery_detail"
	needs_fuel = 0

/obj/item/weapon/rnd/powersource/cell_mount
	name = "cell mount"
	base_icon = "cellmount"
	detail_icon = "cellmount_detail"
	var/obj/item/weapon/stock_parts/cell/cell
	charge_multiplier = 15

/obj/item/weapon/rnd/powersource/fuel_cell
	name = "fuel cell"
	required_components = list(/obj/item/weapon/stock_parts/capacitor,/obj/item/weapon/stock_parts/matter_bin)

	var/fuel_type = null

/obj/item/weapon/rnd/powersource/fuel_cell/uranium_converter
	name = "fission battery"
	fuel_type = /obj/item/stack/sheet/mineral/uranium
	charge_multiplier = 20
	base_icon = "fissionbattery"
	detail_icon = "fissionbattery_detail"

/obj/item/weapon/rnd/powersource/fuel_cell/plasma_converter
	name = "plasma converter"
	fuel_type = /obj/item/stack/sheet/mineral/plasma
	charge_multiplier = 30
	base_icon = "thoronconverter"
	detail_icon = "thoronconverter_detail"

// CHASSIS DEFINES

/obj/item/weapon/rnd/chassis
	name = "prototype chassis"
	desc = "An empty shell, much like your life."
	icon_state = "signaller"
	var/list/permitted_modules
	slot_flags = 0

/obj/item/weapon/rnd/chassis/small_device
	name = "small device chassis"
	desc = "A chassis suitable for a handheld scanner or weapon."
	slot_flags = SLOT_POCKET | SLOT_BELT | SLOT_BACK

	base_icon = "smalldevice"

/obj/item/weapon/rnd/chassis/large_device
	name = "large device chassis"
	desc = "A chassis suitable for a two-handed device, such as a gun."
	slot_flags = SLOT_BELT | SLOT_BACK

	base_icon = "largedevice"

/obj/item/weapon/rnd/chassis/helmet
	name = "helmet chassis"
	desc = "A chassis suitable for headgear."
	slot_flags = SLOT_HEAD

	base_icon = "helmet"

/obj/item/weapon/rnd/chassis/body
	name = "body chassis"
	desc = "A chassis suitable for body armour."
	slot_flags = SLOT_OCLOTHING

	base_icon = "body"

/obj/item/weapon/rnd/chassis/hand_strap
	name = "hand strap"
	desc = "A strap suitable for hand-mounted devices."
	slot_flags = SLOT_GLOVES

	base_icon = "handstrap"

/obj/item/weapon/rnd/chassis/boot_strap
	name = "boot strap"
	desc = "A strap suitable for foot-mounted devices."
	slot_flags = SLOT_FEET

	base_icon = "bootstrap"


// MODIFIER COMPONENTS
/obj/item/weapon/rnd/bscrystal
	name = "prototype bluespace crystal"
	desc = "A strange blue crystal."

/obj/item/weapon/rnd/flasher
	name = "flasher"
	desc = "A flasher to stun criminals."

/obj/item/weapon/rnd/stunner
	name = "electrical output booster"
	desc = "An addon to stun criminals with electricity."

/obj/item/weapon/rnd/defocuser
	name = "energy defocuser"
	desc = "A defocusing device that converts heat into hard radiation."

/obj/item/weapon/rnd/lens
	name = "laser focusing lens"
	desc = "A general purpose laser focuser."

/obj/item/weapon/rnd/medassist
	name = "medical assist module"
	desc = "A device that converts harmful output into ~~healing energy~~."

/obj/item/weapon/rnd/toxboost
	name = "metastasis invoker"
	desc = "A device useful for altering toxin levels."

/obj/item/weapon/rnd/oxyboost
	name = "haemoglobin inhibitor"
	desc = "A device useful for altering oxygen uptake."

/obj/item/weapon/rnd/cloneboost
	name = "genetic scrambler"
	desc = "A device useful for reprogramming genomes."

/obj/item/weapon/rnd/brainboost
	name = "concussive deharmonizer"
	desc = "A device useful for reprogramming brains."

/obj/item/weapon/rnd/booster
	name = "enhancement buffer"
	desc = "A general purpose projector enhancement."

/obj/item/weapon/rnd/cooler
	name = "photocryogenic suite"
	desc = "A module that causes the target of the device to become supercooled."

/obj/item/weapon/rnd/heater
	name = "particle excitation array"
	desc = "A module that causes the target of the device to become superheated."

// COMPONENT PROCS

/obj/item/weapon/rnd/examine()
	..()
	if(components.len && get_dist(src, usr) <= 1)
		usr << "It has the following components installed: "
		for(var/obj/item/C in components)
			usr << "- [C]"
	if(required_components && required_components.len != components.len)
		usr << "It requires the following components: "
		for(var/CM in required_components)
			var/found
			for(var/obj/item/C in components)
				if(istype(C,CM))
					found = 1
					break
			if(!found)
				usr << "- [CM]"
	if(istype(src,/obj/item/weapon/rnd/prototype))
		var/obj/item/weapon/rnd/prototype/P = src
		if(P.power)
			if(P.power.capacitor && P.stored_charge)
				usr << "[P.stored_charge]/[P.power.capacitor.rating*1000] units of charge are stored in \the [P.power.capacitor]."
			var/msg = P.power.display_fuel()
			if(msg) usr << "[msg]"

/obj/item/weapon/rnd/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)

	if(istype(O,/obj/item/weapon/stock_parts))

		if(!required_components)
			user << "\The [src] does not require that component."
			return

		var/found
		for(var/CM in required_components)
			if(istype(O,CM))
				found = 1
				break
		if(!found)
			user << "\The [src] does not require that component."
			return

		var/already_installed
		for(var/obj/item/C in components)
			if(istype(O,C.type))
				already_installed = 1
				break

		if(already_installed)
			user << "\The [src] already has [O] installed."
			return
		else
			user.drop_item()
			O.loc = src
			components += O
			user << "You install \the [O] into \the [src]."

			//Helper variables.
			if(istype(src,/obj/item/weapon/rnd/powersource))
				var/obj/item/weapon/rnd/powersource/P = src

				if(istype(O,/obj/item/weapon/stock_parts/capacitor))
					P.capacitor = O

				if(istype(O,/obj/item/weapon/stock_parts/matter_bin))
					P.fuel_storage = O

				if(istype(src,/obj/item/weapon/rnd/powersource/cell_mount))
					var/obj/item/weapon/rnd/powersource/cell_mount/CM = src
					CM.cell = 0


		return
	else if(istype(O,/obj/item/weapon/screwdriver))
		if(components.len == 0)
			user << "\The [src] does not have anything installed."
		else
			var/obj/item/C = components[1]
			user << "You pop \the [C] out of \the [src] with \the [O]."
			components -= C
			C.loc = get_turf(src)

			if(istype(C,/obj/item/weapon/stock_parts/matter_bin))
				for(var/obj/item/T in C.contents)
					T.loc = get_turf(src)

			if(istype(src,/obj/item/weapon/rnd/powersource))
				var/obj/item/weapon/rnd/powersource/P = src

				if(istype(C,/obj/item/weapon/stock_parts/capacitor))
					P.capacitor = null

				if(istype(C,/obj/item/weapon/stock_parts/matter_bin))
					P.fuel_storage = null

		return
	else
		..()
/obj/item/weapon/rnd/proc/get_rating()
	var/total = rating
	if(components.len)
		for(var/obj/item/weapon/rnd/C in components)
			total += C.get_rating()

	return total

/obj/item/weapon/rnd/proc/fail()
	if(broken)
		return
	broken = 1

/obj/item/weapon/rnd/proc/used()
	return

/obj/item/weapon/rnd/proc/check_status()

	if(!required_components)
		return 1

	for(var/RC in required_components)
		var/found
		for(var/obj/item/C in components)
			if(istype(C,RC))
				found = 1
		if(!found)
			return 0

	return 1

/obj/item/weapon/rnd/proc/reset_flags()
	for(var/flag in list(WELDED,CALIBRATED,WRENCHED,SECURED))
		rnd_flags &= ~flag