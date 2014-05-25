// Each prototype device stores one of these and modifies it based on installed components.

#define EFFECT_RADIATION 1       // Deals radiation damage.
#define EFFECT_BURNLOSS 2        // Deals burnloss.
#define EFFECT_BRUTELOSS 4       // Deals bruteloss.
#define EFFECT_TOXLOSS 8         // Deals toxloss.
#define EFFECT_OXYLOSS 16        // Deals oxyloss.
#define EFFECT_CLONELOSS 32      // Deals cloneloss.
#define EFFECT_BRAINLOSS 64      // Deals brainloss.
#define EFFECT_BLUESPACE 128     // Effect uses bluespace modifiers.
#define EFFECT_INVERT_DEGREE 256 // Set this for healing guns or antirad fields.
#define EFFECT_RCD 512           // Effect creates walls.
#define EFFECT_SCANNER 1024      // Effect collects data.
#define EFFECT_RAISES_TEMP 2048   // Effect raises temp of target's turf.
#define EFFECT_LOWERS_TEMP 4096   // Effect lowers temp of target's turf.
#define EFFECT_STUN 8192         // Effect does stamina at range, stuns when adjacent.
#define EFFECT_FLASH 16384       // Effect flashes everyone in visible range.

// Notes on types:
// 0 - applies all flagged damage types
// 1 - applies all flagged damage types.
// 2 - applies brute, burn, tox, oxy, brainloss damage types.

/datum/prototype/effect
	var/etype = 0          // 0 - projectile, 1 - field, 2 - melee.
	var/degree = 0        // Severity of effect. Modified by overall rating of device.
	var/size = 0          // AoE. Independant from degree.
	var/base              // Ammunition, material or projectile type.
	var/flags = 0         // See EFFECT_* defines at top of file.
	var/list/dam = list() // Types of damage the device modifies.

/obj/item/weapon/rnd/prototype/proc/update_effect()

	if(!effect) effect = new(src)

	effect.flags = 0
	effect.degree = get_rating()
	effect.base = null

	var/list/other = components

 	//This is horrible. Abstract this shit out.

	if(primer)
		other -= primer
		effect.base = primer.base_projectile_type

		if(istype(primer,/obj/item/weapon/rnd/primer/energy_projector) || istype(primer,/obj/item/weapon/rnd/primer/firing_mechanism))
			effect.etype = 0
		else if(istype(primer,/obj/item/weapon/rnd/primer/field_projector))
			effect.etype = 1
		else if(istype(primer,/obj/item/weapon/rnd/primer/multireader))
			effect.etype = 2
			effect.flags |= EFFECT_SCANNER

	for(var/obj/item/weapon/rnd/C in components)
		if(istype(C,/obj/item/weapon/rnd/bscrystal))
			effect.flags |= EFFECT_BLUESPACE
			effect.degree -= 3
		else if(istype(C,/obj/item/weapon/rnd/defocuser))
			effect.flags |= EFFECT_RADIATION
			effect.flags &= ~EFFECT_BURNLOSS
			effect.flags &= ~EFFECT_BRUTELOSS
			effect.degree -= 3
		else if(istype(C,/obj/item/weapon/rnd/lens))
			effect.flags |= EFFECT_BURNLOSS
			effect.flags |= EFFECT_BRUTELOSS
			effect.degree += 5
		else if(istype(C,/obj/item/weapon/rnd/medassist))
			effect.flags |= EFFECT_INVERT_DEGREE
			effect.degree -= 5
		else if(istype(C,/obj/item/weapon/rnd/flasher))
			effect.flags |= EFFECT_FLASH
			effect.degree -= 1
		else if(istype(C,/obj/item/weapon/rnd/toxboost))
			effect.flags |= EFFECT_TOXLOSS
		else if(istype(C,/obj/item/weapon/rnd/oxyboost))
			effect.flags |= EFFECT_OXYLOSS
		else if(istype(C,/obj/item/weapon/rnd/cloneboost))
			effect.flags |= EFFECT_CLONELOSS
		else if(istype(C,/obj/item/weapon/rnd/brainboost))
			effect.flags |= EFFECT_BRAINLOSS
		else if(istype(C,/obj/item/weapon/rnd/stunner))
			effect.flags |= EFFECT_STUN
		else if(istype(C,/obj/item/weapon/rnd/booster))
			effect.degree += 3
		else if(istype(C,/obj/item/weapon/rnd/cooler))
			effect.flags |= EFFECT_LOWERS_TEMP
		else if(istype(C,/obj/item/weapon/rnd/heater))
			effect.flags |= EFFECT_RAISES_TEMP

	var/split = 0
	for(var/dam in list(EFFECT_RADIATION,EFFECT_BURNLOSS,EFFECT_BRUTELOSS,EFFECT_TOXLOSS,EFFECT_OXYLOSS,EFFECT_CLONELOSS,EFFECT_BRAINLOSS))
		if(effect.flags & dam)
			split += 1

	if(split > 1)
		effect.degree = max(1,effect.degree/split)

	need_update_effect = 0

/obj/item/weapon/rnd/prototype/proc/apply_effect(var/atom/target,var/recursive)

	// Projectiles call apply_effect of the firing device when they hit a valid target.
	// Fields will call apply_effect on everything within their range.
	// Melee will call apply_effect on its target.

	if(effect.flags & EFFECT_SCANNER && !recursive)

		var/mob/M
		var/turf/T

		if(istype(target,/mob))
			M = target
		else
			T = target

		if(M)
			src.loc << "Scanning mob!"
			// Collect mob data.
			apply_effect(target,1)
		else if (T)
			src.loc << "Scanning turf!"
			// Collect turf data.
			apply_effect(target,1)
		else
			return

	else if(effect.flags & EFFECT_RCD && !recursive)
		var/turf/T = target
		if(!istype(T)) return //attack() will handle melee damage from an RCD.

		//Create appropriate turf of appropriate type on T.
		apply_effect(target,1)
		return
	else
		if(istype(target,/mob/living))

			target.visible_message("\red [target] is surrounded by a crackling glow!")

			var/degree = effect.degree * get_rating()
			degree = (effect.flags & EFFECT_INVERT_DEGREE ? -(degree) : degree)

			var/mob/living/M = target

			if(effect.flags & EFFECT_STUN)
				var/turf/T = get_turf(src)
				if(T.Adjacent(target))
					M.SetStunned(degree)
				else
					M.staminaloss += degree
			if(istype(target, /mob/living/carbon/human))
				var/mob/living/carbon/human/T = target
				if(effect.flags & EFFECT_FLASH)
					if(!T.blinded)
						flick("flash", T:flash)
						T.eye_stat += rand(0, 2)
						T.Weaken(degree)
					playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)

			//Apply damage here.
			if(effect.flags & EFFECT_BRAINLOSS)
				M.adjustBrainLoss(degree)
			if(effect.flags & EFFECT_BRUTELOSS)
				M.adjustBruteLoss(degree)
			if(effect.flags & EFFECT_BURNLOSS)
				M.adjustFireLoss(degree)
			if(effect.flags & EFFECT_TOXLOSS)
				M.adjustToxLoss(degree)
			if(effect.flags & EFFECT_OXYLOSS)
				M.adjustOxyLoss(degree)

			//Temperature modification.
			if(effect.flags & EFFECT_LOWERS_TEMP)
				M.bodytemperature -= abs(effect.degree)
			if(effect.flags & EFFECT_RAISES_TEMP)
				M.bodytemperature += abs(effect.degree)

			//Bluespace, hooray.
			if(effect.flags & EFFECT_BLUESPACE)
				var/list/randomturfs = list()
				for(var/turf/simulated/floor/T in orange(M, degree))
					randomturfs.Add(T)
				if(randomturfs.len > 0)
					M << "\red Your surroundings shift vertiginously!"

				if (M.buckled)
					M.buckled.unbuckle()

				//Zap!
				var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, get_turf(M))
				sparks.start()

				//Now we teleport the target mob...
				M.loc = pick(randomturfs)

				//...and zap again.
				sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, get_turf(M))
				sparks.start()

			if(effect.etype < 2)
				if(effect.flags & EFFECT_CLONELOSS)
					M.adjustCloneLoss(degree)
				if(effect.flags & EFFECT_RADIATION)
					M.radiation += degree

			return

		else if(istype(target,/obj))

			var/obj/O = target
			O << "Targeted by an effect."
			//Call appropriate damage/rad/whatever procs.
			return

		else if(istype(target,/turf))
			//Temp modifier.
			var/turf/simulated/L = target
			if(istype(L))
				var/datum/gas_mixture/env = L.return_air()
				if(effect.flags & EFFECT_LOWERS_TEMP)
					env.temperature -= abs(effect.degree)
				if(effect.flags & EFFECT_RAISES_TEMP)
					env.temperature += abs(effect.degree)
			//Damaging fields are scary.
			var/turf/T = target
			for(var/mob/M in T)
				apply_effect(M)
			for(var/obj/O in T)
				apply_effect(O)
			return

		else
			return

//Prototype device laser shot.
/obj/item/projectile/energy/prototype
	name = "energy burst"

/obj/item/projectile/energy/prototype/on_hit(var/atom/target, var/blocked = 0)
	if(blocked >= 2)
		return 0

	var/mob/living/L = target
	var/obj/item/weapon/rnd/prototype/P = shot_from
	if(istype(P)) P.apply_effect(L)
	return 1