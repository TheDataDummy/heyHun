extends Node

var towerCosts = {
	"milkJug" : 16,
	"diffuser" : 24,
	"pillDispenser": 40,
	"sprinkler": 35
}

var upgradeCosts = {
	"milkJug" : 22,
	"diffuser" : 30,
	"pillDispenser": 80,
	"sprinkler": 50
}

var towerRefundValue = {
	"milkJug" : 8,
	"diffuser" : 12,
	"pillDispenser": 20,
	"sprinkler": 15
}

var enemy_hitpoints = {
	"book": 10,
	"sunscreen": 30,
	"oil": 12,
	"vaccine": 15,
}

var enemy_drops = {
	"book": 1,
	"oil": 2,
	"sunscreen": 4,
	"vaccine": 2,
}

var enemy_descriptions = {
	"book": "The book is a simple, moderately paced enemy designed to indoctrinate your children.",
	"sunscreen": "Evil, wicked concotion of chemicals designed to destroy the immune system.",
	"vaccine": "Vial of lethal ingredients, will absolutely give your children autism.",
	"oil": "Acid, essentially.  Inflames every muscle in your body and causes you to retain weight."
}

var enemy_proper_names = {
	"book": "Book",
	"sunscreen": "Sunscreen",
	"vaccine": "Vaccine",
	"oil": "Seed oil"
}

var enemy_sprite_configs = {
	# Sprite path, hframes
	"book": ["res://artAssets/enemies/bookIcon.png", 1],
	"sunscreen": ["res://artAssets/enemies/sunScreen.png", 1],
	"vaccine": ["res://artAssets/enemies/vaccine.png", 1],
	"oil": ["res://artAssets/enemies/oilIcon.png", 1]
}
