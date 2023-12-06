extends Node2D

signal entities_focussed(entity_list)


var _mouse_tile := Vector2i(-1, -1)

@onready var map: Map = get_parent()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_position: Vector2 = get_local_mouse_position()
		var tile_position: Vector2i = Grid.world_to_grid(mouse_position)
		if _mouse_tile != tile_position:
			_mouse_tile = tile_position
			var entity_names = get_names_at_location(tile_position)
			entities_focussed.emit(entity_names)


func get_names_at_location(grid_position: Vector2i) -> String:
	var entity_names := ""
	var map_data: MapData = map.map_data
	var tile: Tile = map_data.get_tile(grid_position)
	if not tile or not tile.is_in_view:
		return entity_names
	var entities_at_location: Array[Entity] = []
	for entity in map_data.entities:
		if entity.grid_position == grid_position:
			entities_at_location.append(entity)
	entities_at_location.sort_custom(func(a, b): return a.z_index > b.z_index)
	if not entities_at_location.is_empty():
		entity_names = entities_at_location[0].get_entity_name()
		for i in range(1, entities_at_location.size()):
			entity_names += ", %s" % entities_at_location[i].get_entity_name()
	return entity_names
