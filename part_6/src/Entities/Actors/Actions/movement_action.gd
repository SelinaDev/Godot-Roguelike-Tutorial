class_name MovementAction
extends ActionWithDirection


func perform() -> void:
	var map_data: MapData = get_map_data()
	var destination_tile: Tile = map_data.get_tile(get_destination())
	if not destination_tile or not destination_tile.is_walkable():
		return
	if get_blocking_entity_at_destination():
		return
	entity.move(offset)
	
