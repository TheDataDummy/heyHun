extends CanvasLayer
@onready var enemy_name_node = $enemyName
@onready var enemy_hitpoints_node = $enemyHitpoints
@onready var enemy_drop_value_node = $enemyDropValue
@onready var enemy_description_node = $enemyDescription
@onready var enemy_sprite_node = $enemySprite

func show_info(enemy_name):
	visible = true
	var enemy_hp = Globals.enemy_hitpoints[enemy_name]
	var enemy_drop_value = Globals.enemy_drops[enemy_name]
	var enemy_description = Globals.enemy_descriptions[enemy_name]
	var enemy_proper_name = Globals.enemy_proper_names[enemy_name]
	var enemy_sprite_config = Globals.enemy_sprite_configs[enemy_name]

	enemy_name_node.text = '[center]' + enemy_proper_name
	enemy_hitpoints_node.text = '[center]' + str(enemy_hp)
	enemy_drop_value_node.text = '[center]' + str(enemy_drop_value)
	enemy_description_node.text = enemy_description
	enemy_sprite_node.texture = load(enemy_sprite_config[0])
	enemy_sprite_node.hframes = enemy_sprite_config[1]

func hide_info():
	visible = false
