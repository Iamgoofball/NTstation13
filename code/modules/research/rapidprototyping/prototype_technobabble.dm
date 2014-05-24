//TODO: EXPAND ALL OF THESE.
var/global/list/technobabble_adjectives = list(
	"reverse-phase",
	"polarity-induced",
	"three-core",
	"hyperwave",
	"phoron-core",
	"subspace-aligned",
	"chrome-plated",
	"HDMI",
	"RST",
	"PEBCAK",
	"dual-rail",
	"hypervelocity",
	"metaergonomic",
	"electromagnetic",
	"hyperspectrum",
	"homeothermic-inhibited",
	"metathaumatic",
	"hyperenergetic",
	"blackbox",
	"reticulated"
	)

var/global/list/technobabble_device_nouns = list(
	"field-projector chassis",
	"systematic inverter",
	"particle decryptor",
	"proton radiator",
	"neutronium alchemist",
	"solid state recompiler"
	)

var/global/list/technobabble_component_nouns = list(
	"chassis",
	"power core",
	"phase shifter",
	"grip",
	"barrel",
	"plating",
	"DRM",
	"spline module",
	"patterning node",
	)

var/global/list/technobabble_competitors = list(
	"Integrated Systems, Ltd",
	"Competitor Company #243"
	)

/obj/item/weapon/rnd/prototype/vendor_trash
	name = "reclaimed technology"

/obj/item/weapon/rnd/prototype/vendor_trash/New()
	..()

	//Generate and break random components.
	var/new_type = pick(typesof(/obj/item/weapon/rnd/primer/) - /obj/item/weapon/rnd/primer/)
	primer = new new_type(src)

	new_type = pick(typesof(/obj/item/weapon/rnd/trigger/) - /obj/item/weapon/rnd/trigger/)
	trigger = new new_type(src)

	new_type = pick(typesof(/obj/item/weapon/rnd/powersource/) - /obj/item/weapon/rnd/powersource/)
	power = new new_type(src)

	new_type = pick(typesof(/obj/item/weapon/rnd/chassis/) - /obj/item/weapon/rnd/chassis/)
	chassis = new new_type(src)

	components += chassis
	components += primer
	components += trigger
	components += power

	var/modifier_components = list(
		/obj/item/weapon/rnd/bscrystal,
		/obj/item/weapon/rnd/defocuser,
		/obj/item/weapon/rnd/lens,
		/obj/item/weapon/rnd/medassist,
		/obj/item/weapon/rnd/flasher,
		/obj/item/weapon/rnd/toxboost,
		/obj/item/weapon/rnd/oxyboost,
		/obj/item/weapon/rnd/cloneboost,
		/obj/item/weapon/rnd/brainboost,
		/obj/item/weapon/rnd/booster,
		/obj/item/weapon/rnd/cooler,
		/obj/item/weapon/rnd/heater
		)

	for(var/i=1;i<=3;i++)
		new_type = pick(modifier_components)
		var/obj/item/weapon/rnd/NC = new new_type(src)
		NC.randomize_strings()
		components += NC

	//Generate a random tech level (possibly strike it big with a massive boost to global research levels).
	//TODO: Link this to existing research levels.
	var/research_index = rand(1,9)


	for(var/obj/item/weapon/rnd/C in components)
		C.broken = 1

	update_icon()

	name = "[pick(technobabble_adjectives)] [pick(technobabble_device_nouns)]"
	var/obj/item/weapon/rnd/example_component = components[5]
	desc = "It looks like something from [pick(technobabble_competitors)]. It even has their patented [example_component.name] technology!"

/obj/item/weapon/rnd/proc/randomize_strings()
	name = "[pick(technobabble_adjectives)] [pick(technobabble_component_nouns)]"