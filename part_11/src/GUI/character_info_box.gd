extends HBoxContainer

var _player: Entity

@onready var level_label: Label = $LevelLabel
@onready var attack_label: Label = $AttackLabel
@onready var defense_label: Label = $DefenseLabel


func setup(player: Entity) -> void:
	_player = player
	_player.level_component.leveled_up.connect(update_labels)
	update_labels()


func update_labels() -> void:
	level_label.text = "LVL: %d" % _player.level_component.current_level
	attack_label.text = "ATK: %d" % _player.fighter_component.power
	defense_label.text = "DEF: %d" % _player.fighter_component.defense
