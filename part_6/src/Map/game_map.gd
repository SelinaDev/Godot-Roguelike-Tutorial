class_name GameMap
extends Node2D


var width: int
var height: int
var _tiles := []


func initialize(
	max_rooms: int, 
	room_min_size: int, 
	room_max_size: int,
	map_width: int, 
	map_height: int,
	player: Entity
	) -> void:
	width = map_width
	height = map_height
	_cleanup()
	var procgen := ProcGen.new()
	_tiles = procgen.generate_dungeon(
		max_rooms,
		room_min_size,
		room_max_size,
		map_width, 
		map_height,
		player
		)
	_build_from_tiles()


func _cleanup() -> void:
	for tile in get_children():
		tile.queue_free()
	_tiles = []


func _build_from_tiles() -> void:
	for column in _tiles:
		for tile in column:
			add_child(tile)


func is_in_bounds(coordinate: Vector2i) -> bool:
	return (
		0 <= coordinate.x and 
		coordinate.x < width and
		0 <= coordinate.y and 
		coordinate.y < height
	)


func is_walkable(coordinate: Vector2i) -> bool:
	if not is_in_bounds(coordinate):
		return false
	return _tiles[coordinate.x][coordinate.y].is_walkable()
