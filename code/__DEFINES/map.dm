/*
The /tg/ codebase allows mixing of hardcoded and dynamically-loaded z-levels.
Z-levels can be reordered as desired and their properties are set by "traits".
See map_config.dm for how a particular station's traits may be chosen.
The list DEFAULT_MAP_TRAITS at the bottom of this file should correspond to
the maps that are hardcoded, as set in _maps/_basemap.dm. SSmapping is
responsible for loading every non-hardcoded z-level.

As of 2018-02-04, the typical z-levels for a single-level station are:
1: CentCom
2: Station
3-4: Randomized space
5: Mining
6: City of Cogs
7-11: Randomized space
12: Empty space
13: Transit space

Multi-Z stations are supported and multi-Z mining and away missions would
require only minor tweaks.
*/

#define STANDARD_RESERVED_TURF_TYPE		/turf/space/basic
#define STANDARD_TRANSIT_TURF_TYPE		/turf/space

#define DEFINE_RUIN_BUDGET_MULT 1			//be careful
#define STANDARD_RUIN_COST 12		//This is for a 15x15 ruin.
//These are crap formulas, someone make better ones.
#define STANDARD_RUIN_COST_CALC_SQUARE(side)			STANDARD_RUIN_COST_CALC_TILES(side ** 2)
#define STANDARD_RUIN_COST_CALC_TILES(total_area)		((total_area) ** 0.52)
#define STANDARD_RUIN_BUDGET_CALC_SQUARE(side)			STANDARD_RUIN_BUDGET_CALC_TILES(side ** 2)
#define STANDARD_RUIN_BUDGET_CALC_TILES(total_area)		((total_area ^ 0.5) * DEFINE_RUIN_BUDGET_MULT)

#define RUIN_PLACEMENT_TRIES 100				//times to place a ruin before giving up

#define SHUTTLE_TRANSIT_BORDER		7
#define SPACE_TRANSITION_BORDER		7 // Default distance from edge to move to another z-level.

#define FALLBACK_DEFAULT_ALLOWED_SPAWNPOINTS list(/datum/spawnpoint/arrivals, /datum/spawnpoint/gateway, /datum/spawnpoint/cryo, /datum/spawnpoint/cyborg)		//When spawnpoint laoding fails.

//ZTRAITS
#define DL_NAME "name"
#define DL_TRAITS "traits"
#define DECLARE_LEVEL(NAME, TRAITS) list(DL_NAME = NAME, DL_TRAITS = TRAITS)

// boolean - marks if present {"Trait" = TRUE}
#define ZTRAIT_CENTCOM "CentCom"
#define ZTRAIT_STATION "Station"
#define ZTRAIT_RESERVED "Transit/Reserved"
#define ZTRAIT_MINING "Mining"
#define ZTRAIT_AWAY "Away Mission"

// numeric offsets - e.g. {"Down": -1} means that chasms will fall to z - 1 rather than oblivion
#define ZTRAIT_UP "Up"
#define ZTRAIT_DOWN "Down"

// number - bombcap is multiplied by this before being applied to bombs
#define ZTRAIT_BOMBCAP_MULTIPLIER "Bombcap Multiplier"

// string - type path of the z-level's baseturf (defaults to space)
#define ZTRAIT_BASETURF "Baseturf"

// enum - how space transitions should affect this level
#define ZTRAIT_LINKAGE "Linkage"
	// UNAFFECTED if absent - no space transitions
	#define UNAFFECTED null
	// SELFLOOPING - space transitions always self-loop
	#define SELFLOOPING "Self"
	// CROSSLINKED - mixed in with the cross-linked space pool
	#define CROSSLINKED "Cross"
	// STATIC - Links to another zlevel with the same ID
	#define STATIC "Static"

// string - id for static linkage as above.
#define ZTRAIT_TRANSITION_ID_NORTH "Transition ID North"
#define ZTRAIT_TRANSITION_ID_SOUTH "Transition ID South"
#define ZTRAIT_TRANSITION_ID_EAST "Transition ID East"
#define ZTRAIT_TRANSITION_ID_WEST "Transition ID West"

// number - tiles of padding on edge for transitions - defaults to SPACE_TRANSITION_BORDER
#define ZTRAIT_TRANSITION_PADDING "Transition Padding"

// boolean - Enable transition mirage holders - defaults to false
#define ZTRAIT_TRANSITION_MIRAGE "Transition Mirage"

// boolean - Linkage uses step teleporters instead of space tiles only
#define ZTRAIT_TRANSITION_FORCED "Transition forced"

// default trait definitions, used by SSmapping

// must correspond to _basemap.dm for things to work correctly
//THIS IS NOT CORRECT! OVERRIDDEN IN USING_MAP UNTIL A PROPER REFACTOR!
#define DEFAULT_MAP_TRAITS list(\
    DECLARE_LEVEL("CentCom", ZTRAITS_CENTCOM),\
)
#define ZTRAITS_CENTCOM list(ZTRAIT_CENTCOM = TRUE)
#define ZTRAITS_STATION list(ZTRAIT_LINKAGE = CROSSLINKED, ZTRAIT_STATION = TRUE, ZTRAIT_TRANSITION_MIRAGE = TRUE)
#define ZTRAITS_SPACE list(ZTRAIT_LINKAGE = CROSSLINKED, ZTRAIT_SPACE_RUINS = TRUE, ZTRAIT_TRANSITION_MIRAGE = TRUE)

/*
// helpers for modifying jobs, used in various job_changes.dm files
#define MAP_JOB_CHECK if(SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) { return; }
#define MAP_JOB_CHECK_BASE if(SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) { return ..(); }
#define MAP_REMOVE_JOB(jobpath) /datum/job/##jobpath/map_check() { return (SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) && ..() }

#define SPACERUIN_MAP_EDGE_PAD 15

// traits
// boolean - marks a level as having that property if present
#define ZTRAIT_REEBE "Reebe"
#define ZTRAIT_SPACE_RUINS "Space Ruins"
#define ZTRAIT_LAVA_RUINS "Lava Ruins"


// number - default gravity if there's no gravity generators or area overrides present
#define ZTRAIT_GRAVITY "Gravity"

#define ZTRAITS_LAVALAND list(\
    ZTRAIT_MINING = TRUE, \
    ZTRAIT_LAVA_RUINS = TRUE, \
    ZTRAIT_BOMBCAP_MULTIPLIER = 2, \
    ZTRAIT_BASETURF = /turf/open/lava/smooth/lava_land_surface)
#define ZTRAITS_REEBE list(ZTRAIT_REEBE = TRUE, ZTRAIT_BOMBCAP_MULTIPLIER = 0.5)



// Camera lock flags
#define CAMERA_LOCK_STATION 1
#define CAMERA_LOCK_MINING 2
#define CAMERA_LOCK_CENTCOM 4
#define CAMERA_LOCK_REEBE 8

//Ruin Generation

#define PLACEMENT_TRIES 100 //How many times we try to fit the ruin somewhere until giving up (really should just swap to some packing algo)

#define PLACE_DEFAULT "random"
#define PLACE_SAME_Z "same"
#define PLACE_SPACE_RUIN "space"
#define PLACE_LAVA_RUIN "lavaland"
*/

#define SUBMAP_GROUP_ID_DEFAULT "Default"

// Helpers for checking whether a z-level conforms to a specific requirement

// Basic levels
#define is_centcom_level(z) SSmapping.level_trait(z, ZTRAIT_CENTCOM)

#define is_station_level(z) SSmapping.level_trait(z, ZTRAIT_STATION)

#define is_mining_level(z) SSmapping.level_trait(z, ZTRAIT_MINING)

#define is_reserved_level(z) SSmapping.level_trait(z, ZTRAIT_RESERVED)

#define is_away_level(z) SSmapping.level_trait(z, ZTRAIT_AWAY)

//vorestation stuff below


// Z-level flags bitfield - Set these flags to determine the z level's purpose
#define MAP_LEVEL_STATION		0x001 // Z-levels the station exists on
#define MAP_LEVEL_ADMIN			0x002 // Z-levels for admin functionality (Centcom, shuttle transit, etc)
#define MAP_LEVEL_CONTACT		0x004 // Z-levels that can be contacted from the station, for eg announcements
#define MAP_LEVEL_PLAYER		0x008 // Z-levels a character can typically reach
#define MAP_LEVEL_SEALED		0x010 // Z-levels that don't allow random transit at edge
#define MAP_LEVEL_EMPTY			0x020 // Empty Z-levels that may be used for various things (currently used by bluespace jump)
#define MAP_LEVEL_CONSOLES		0x040 // Z-levels available to various consoles, such as the crew monitor (when that gets coded in). Defaults to station_levels if unset.

// Misc map defines.
#define SUBMAP_MAP_EDGE_PAD 15 // Automatically created submaps are forbidden from being this close to the main map's edge.
#define TRANSITIONEDGE SPACE_TRANSITION_BORDER
