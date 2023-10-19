extends MarginContainer

@onready var xp_bar: ProgressBar = $"%XpBar"
@onready var xp_label: Label = $"%XpLabel"


func initialize(player: Entity) -> void:
	if not is_inside_tree():
		await ready
	player.level_component.xp_changed.connect(player_xp_changed)
	var player_xp: int = player.level_component.current_xp
	var player_max_xp: int = player.level_component.get_experience_to_next_level()
	player_xp_changed(player_xp, player_max_xp)


func player_xp_changed(xp: int, max_xp: int) -> void:
	xp_bar.max_value = max_xp
	xp_bar.value = xp
	xp_label.text = "XP: %d/%d" % [xp, max_xp]
