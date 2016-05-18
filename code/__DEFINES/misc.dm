#define MIDNIGHT_ROLLOVER		864000	//number of deciseconds in a day

//Security levels
#define SEC_LEVEL_GREEN	0
#define SEC_LEVEL_BLUE	1
#define SEC_LEVEL_RED	2
#define SEC_LEVEL_DELTA	3

//some arbitrary defines to be used by self-pruning global lists. (see master_controller)
#define PROCESS_KILL 26	//Used to trigger removal from a processing list

#define MANIFEST_ERROR_NAME		1
#define MANIFEST_ERROR_COUNT	2
#define MANIFEST_ERROR_ITEM		4

#define TRANSITIONEDGE			7 //Distance from edge to move to another z-level
#define MAX_Z_LEVELS			7 //how many Z levels are on the map



//HUD styles. Please ensure HUD_VERSIONS is the same as the maximum index. Index order defines how they are cycled in F12.
#define HUD_STYLE_STANDARD 1
#define HUD_STYLE_REDUCED 2
#define HUD_STYLE_NOHUD 3


#define HUD_VERSIONS 3	//used in show_hud()
//1 = standard hud
//2 = reduced hud (just hands and intent switcher)
//3 = no hud (for screenshots)

#define MINERAL_MATERIAL_AMOUNT 2000
//The amount of materials you get from a sheet of mineral like iron/diamond/glass etc

//Event flags
#define EVENT_MINOR				1<<0	//minor events such as airlock malfunction and lights breaking
#define EVENT_MAJOR				1<<1	//events that involve people possibly dying
#define EVENT_SPECIAL			1<<2	//holidays and events not in rotation
#define EVENT_REWARD			1<<3	//events that are rewarding and nice
#define EVENT_CONSEQUENCE		1<<4	//events that are mean and cruel (and usually for naughty people)
#define EVENT_ENDGAME			1<<5	//events that most likely will end the round or at least change the face of it
#define EVENT_TASK				1<<6	//events that are not in rotation that involve the crew working towards a common goal
#define EVENT_ROUNDSTART		1<<7	//events that can happen ONLY at round start
#define EVENT_HIDDEN			1<<8	//secret events :^)

#define FOR_DVIEW(type, range, center, invis_flags) \
	dview_mob.loc = center; \
	dview_mob.see_invisible = invis_flags; \
	for(type in view(range, dview_mob))
