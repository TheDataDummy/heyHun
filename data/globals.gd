extends Node

var towerCosts = {
	"milkJug" : 8,
	"diffuser" : 12,
	"supplementDispenser": 20
}

var upgradeCosts = {
	"milkJug" : 10,
	"diffuser" : 25,
	"supplementDispenser": 35
}

var towerRefundValue = {
	"milkJug" : 5,
	"diffuser" : 6,
	"supplementDispenser": 9
}

var enemy_hitpoints = {
	"book": 10,
	"sunscreen": 30,
	"vaccine": 15,
}

var enemy_drops = {
	"book": 1,
	"sunscreen": 2,
	"vaccine": 3,
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
