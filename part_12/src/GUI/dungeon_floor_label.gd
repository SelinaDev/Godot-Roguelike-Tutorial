extends Label


func set_dungeon_floor(current_floor: int) -> void:
	text = "Dungeon Level: %d" % current_floor
