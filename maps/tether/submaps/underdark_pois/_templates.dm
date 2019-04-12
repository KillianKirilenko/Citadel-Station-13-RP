/datum/map_template/submap/underdark
	abstract_type = /datum/map_template/submap/underdark

/datum/map_template/submap/underdark/normal_mob
	name = "Underdark Normal Mob Spawn"
	mappath = 'normal_mob.dmm'
	id = "underdark_mob"
	cost = 5
	allow_duplicates = TRUE

/datum/map_template/submap/underdark/hard_mob
	name = "Underdark Hard Mob Spawn"
	mappath = 'hard_mob.dmm'
	id = "underdark_mob_hard"
	cost = 15
	allow_duplicates = TRUE
/*
/datum/map_template/underdark/boss_mob
	name = "Underdark Boss Mob Spawn"
	mappath = 'boss_mob.dmm'
	cost = 60
	allow_duplicates = FALSE
*/
/*
/datum/map_template/underdark/whatever_treasure
	name = "Some Kinda Treasure" //A name, only visible to admins
	mappath = 'hard_mob.dmm' //The .dmm file for this template (in this folder)
	cost = 10 //How 'valuable' this template is
*/