extends Node

var towerCosts = {
	"milkJug" : 6,
	"diffuser" : 10,
	"supplementDispenser": 15
}

var enemy_hitpoints = {
	"book": 10,
	"sunscreen": 25,
	"vaccine": 15,
}

var enemy_drops = {
	"book": 1,
	"sunscreen": 2,
	"vaccine": 2,
}

var enemy_descriptions = {
	"book": "The book is a simple, moderately paced enemy designed to indoctrinate your children.",
	"sunscreen": "Evil, wicked concotion of chemicals designed to destroy the immune system.",
	"vaccine": "Vial of lethal ingredients, will absolutely give your children autism.",
}

var enemy_proper_names = {
	"book": "Book",
	"sunscreen": "Sunscreen",
	"vaccine": "Vaccine",
}

var enemy_sprite_configs = {
	# Sprite path, hframes
	"book": ["res://artAssets/enemies/bookIcon.png", 1],
	"sunscreen": ["res://artAssets/enemies/sunScreen.png", 1],
	"vaccine": ["res://artAssets/enemies/vaccine.png", 1],
}
