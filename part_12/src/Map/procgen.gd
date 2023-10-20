class_name ProcGen
extends RefCounted

const tile_types = {
	"wall": preload("res://assets/tile_definitions/tile_wall.tres"),
	"floor": preload("res://assets/tile_definitions/tile_floor.tres"),
}

var _rng := RandomNumberGenerator.new()
var _tiles: Array


func _init() -> void:
	_rng.randomize()
	_tiles = []


func generate_dungeon(
	max_rooms: int, 
	room_min_size: int, 
	room_max_size: int,
	map_width: int, 
	map_height: int,
	player: Entity
	) -> Array:
	_initialize_tiles(map_width, map_height)
	
	var rooms: Array[Rect2i] = []
	
	for r in max_rooms:
		var room_width = _rng.randi_range(room_min_size, room_max_size)
		var room_height = _rng.randi_range(room_min_size, room_max_size)
		
		var x: int = _rng.randi_range(0, map_width - room_width - 1)
		var y: int = _rng.randi_range(0, map_height - room_height - 1)
		
		var new_room := Rect2i(x, y, room_width, room_height)
		
		var has_intersections := false
		for room in rooms:
			if new_room.intersects(room):
				has_intersections = true
				continue
		if has_intersections:
			continue
		
		_carve_room(new_room)
		
		if rooms.is_empty():
			player.grid_position = new_room.get_center()
		else:
			_tunnel_between(rooms.back().get_center(), new_room.get_center())
		
		rooms.append(new_room)
	
	return _tiles


func _initialize_tiles(map_width: int, map_height: int) -> void:
	for x in map_width:
		var column := []
		for y in map_height:
			var grid_position := Vector2i(x, y)
			var tile := Tile.new(grid_position, tile_types.wall)
			column.append(tile)
		_tiles.append(column)


func _carve_room(room: Rect2i) -> void:
	var inner: Rect2i = room.grow(-1)
	for x in range(inner.position.x, inner.end.x):
		for y in range(inner.position.y, inner.end.y):
			var tile: Tile = _tiles[x][y]
			tile.set_tile_type(tile_types.floor)


func _carve_tunnel_h(y: int, x_start: int, x_end: int) -> void:
	var x_min := mini(x_start, x_end)
	var x_max := maxi(x_start, x_end)
	for x in range(x_min, x_max + 1):
		var tile: Tile = _tiles[x][y]
		tile.set_tile_type(tile_types.floor)


func _carve_tunnel_v(x: int, y_start: int, y_end: int) -> void:
	var y_min := mini(y_start, y_end)
	var y_max := maxi(y_start, y_end)
	for y in range(y_min, y_max + 1):
		var tile: Tile = _tiles[x][y]
		tile.set_tile_type(tile_types.floor)


func _tunnel_between(start: Vector2i, end: Vector2i):
	if _rng.randf() < 0.5:
		_carve_tunnel_h(start.y, start.x, end.x)
		_carve_tunnel_v(end.x, start.y, end.y)
	else:
		_carve_tunnel_v(start.x, start.y, end.y)
		_carve_tunnel_h(end.y, start.x, end.x)
	
