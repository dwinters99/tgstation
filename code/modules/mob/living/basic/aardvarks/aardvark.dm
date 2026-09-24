/mob/living/basic/aardvark // Big sniffers. Little tubed teeth. Earth pigs. Big thanks to @Ben10Omintrix for their work on stoats.
	name = "aardvark"
	desc = "Eats ants and excavates earth. Not that dissimilar to a " + JOB_SHAFT_MINER + "."
	icon_state = "aardvark"
	icon_living = "aardvark"
	icon_dead = "aardvark_dead"
	base_icon_state = "aardvark"
	icon = 'icons/mob/simple/pets.dmi'
	butcher_results = list(/obj/item/food/meat/slab = 1)
	mob_biotypes = MOB_ORGANIC | MOB_BEAST
	health = 40
	maxHealth = 40
	melee_damage_lower = 1 // Those claws are better for digging
	melee_damage_upper = 3
	response_help_continuous = "pets"
	response_help_simple = "pet"
	verb_say = "grunts"
	verb_ask = "grunts curiously"
	verb_exclaim = "grunts loudly"
	verb_yell = "bleats" // They do make vocalizations called 'bleating' when frightened or alarmed.
	speed = -0.25 // They can move as fast as Usain Bolt. The fastest human in history is 3 KM/H faster than an aardvark.
	faction = list(FACTION_NEUTRAL)
	ai_controller = /datum/ai_controller/basic_controller/aardvark

	var/static/list/pet_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/move,
		/datum/pet_command/free,
		/datum/pet_command/follow,
//		/datum/pet_command/sniff, // TODO: write a pet command for sneefing
	)
	//can this mob breed?
	var/can_breed = TRUE
#warn REVISIT LINE 37
/mob/living/basic/aardvark/Initialize(mapload)
	. = ..()
	var/static/list/eatable_food = list(
		/obj/item/food/ant_candy,
		/obj/item/food/pizzaslice/ants,
	)
	AddComponent(/datum/component/tameable, food_types = eatable_food, tame_chance = 70, bonus_tame_chance = 0)
	ai_controller.set_blackboard_key(BB_BASIC_FOODS, typecacheof(eatable_food))
	AddElement(/datum/element/wears_collar)
	AddElement(/datum/element/can_be_held) // TODO: make these THINGS 2-handed when held
	AddComponent(/datum/component/obeys_commands, pet_commands)
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_AARDVARK, CELL_VIRUS_TABLE_GENERIC_MOB, 1, 5)
	if(can_breed)
		add_breeding_component()

	var/static/list/display_emote = list(
		BB_EMOTE_SAY = list("Chirp chirp chirp!"),
		BB_EMOTE_SEE = list("sweeps its tail!", "jumps around!", "licks its fur!"),
		BB_SPEAK_CHANCE = 2,
//		BB_EMOTE_SOUND = list('sound/mobs/non-humanoids/aardvark/aardvark_sounds.ogg'), // TODO: get aardvark grunts
	)
	ai_controller.set_blackboard_key(BB_BASIC_MOB_SPEAK_LINES, display_emote)

/mob/living/basic/aardvark/proc/add_breeding_component()
	var/static/list/partner_paths = typecacheof(list(/mob/living/basic/aardvark))
	var/static/list/baby_paths = list(
		/mob/living/basic/aardvark/calf = 100
	)
	AddComponent(\
		/datum/component/breed,\
		can_breed_with = typecacheof(list(/mob/living/basic/aardvark)),\
		baby_paths = baby_paths,\
	)

/mob/living/basic/aardvark/calf
	name = "\improper aardvark calf"
	real_name = "aardvark"
	desc = "Tiny little earth pig."
	icon_state = "calf_aardvark"
	icon_living = "calf_aardvark"
	icon_dead = "calf_aardvark_dead"
	density = FALSE
	pass_flags = PASSMOB
	ai_controller = /datum/ai_controller/basic_controller/aardvark/calf
	mob_size = MOB_SIZE_SMALL
	can_breed = FALSE

/mob/living/basic/aardvark/calf/Initialize(mapload)
	. = ..()
	AddComponent(\
		/datum/component/growth_and_differentiation,\
		growth_time = 25 MINUTES,\
		growth_path = /mob/living/basic/aardvark,\
		growth_probability = 100,\
		lower_growth_value = 0.5,\
		upper_growth_value = 1,\
		signals_to_kill_on = list(COMSIG_MOB_CLIENT_LOGIN),\
	)
