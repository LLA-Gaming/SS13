var/global/list/cable_list = list()					//Index for all cables, so that powernets don't have to look through the entire world all the time
var/global/list/portals = list()					//for use by portals
var/global/list/mechas_list = list()				//list of all mechs. Used by hostile mobs target tracking.
var/global/list/shuttle_caller_list = list()  		//list of all communication consoles and AIs, for automatic shuttle calls when there are none.

//items that ask to be called every cycle
var/global/list/machines = list()
var/global/list/processing_objects = list()
var/global/list/active_diseases = list()

var/global/list/chemical_reactions_list				//list of all /datum/chemical_reaction datums. Used during chemical reactions
var/global/list/chemical_reagents_list				//list of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff
var/global/list/surgeries_list = list()				//list of all surgeries by name, associated with their path.
var/global/list/table_recipes = list()				//list of all table craft recipes
var/global/list/reagent_defines = list()


//Trash list, list of items people would generally throw out
//This is used in the sorting conveyer is_trash
//mobs are on this list because a thrown out body is generally trash
var/global/list/trash_items = list(
								/obj/item/trash,
								/obj/item/weapon/shard,
								/obj/item/weapon/reagent_containers/glass,
								/obj/item/weapon/reagent_containers/syringe,
								/obj/item/weapon/rack_parts,
								/obj/item/weapon/table_parts,
								/obj/item/device/tablet_carts,
								/obj/item/weapon/reagent_containers/spacebong,
								/mob/living
								)