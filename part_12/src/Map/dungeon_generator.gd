class_name DungeonGenerator
extends Node

const max_items_by_floor = [
	[1, 1],
	[4, 2]
]

const max_monsters_by_floor = [
	[1, 2],
	[4, 3],
	[6, 5]
]

const item_chances = {
	0: {"health_potion": 35},
	2: {"confusion_scroll": 10},
	4: {"lightning_scroll": 25},
	6: {"fireball_scroll": 25},
}

const enemy_chances = {
	0: {"orc": 80},
	3: {"troll": 15},
	5: {"troll": 30},
	7: {"troll": 60}
}


@export_category("Map Dimensions")
@export var map_width: int = 80
@export var map_height: int = 45

@export_category("Rooms RNG")
@export var max_rooms: int = 30
@export var room_max_size: int = 10
@export var room_min_size: int = 6

var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()


func generate_dungeon(player: Entity, current_floor: int) -> MapData:
	var dungeon := MapData.new(map_width, map_height, player)
	dungeon.current_floor = current_floor
	dungeon.entities.append(player)
	
	var rooms: Array[Rect2i] = []
	var center_last_room: Vector2i
	
	for _try_room in max_rooms:
		var room_width: int = _rng.randi_range(room_min_size, room_max_size)
		var room_height: int = _rng.randi_range(room_min_size, room_max_size)
		
		var x: int = _rng.randi_range(0, dungeon.width - room_width - 1)
		var y: int = _rng.randi_range(0, dungeon.height - room_height - 1)
		
		var new_room := Rect2i(x, y, room_width, room_height)
		
		var has_intersections := false
		for room in rooms:
			if room.intersects(new_room):
				has_intersections = true
				break
		if has_intersections:
			continue
		
		_carve_room(dungeon, new_room)
		center_last_room = new_room.get_center()
		
		if rooms.is_empty():
			player.grid_position = new_room.get_center()
			player.map_data = dungeon
		else:
			_tunnel_between(dungeon, rooms.back().get_center(), new_room.get_center())
		
		_place_entities(dungeon, new_room, current_floor)
		
		rooms.append(new_room)
	
	dungeon.down_stairs_location = center_last_room
	var down_tile: Tile = dungeon.get_tile(center_last_room)
	down_tile.set_tile_type("down_stairs")
	
	dungeon.setup_pathfinding()
	return dungeon


func _carve_room(dungeon: MapData, room: Rect2i) -> void:
	var inner: Rect2i = room.grow(-1)
	for y in range(inner.position.y, inner.end.y + 1):
		for x in range(inner.position.x, inner.end.x + 1):
			_carve_tile(dungeon, x, y)


func _tunnel_horizontal(dungeon: MapData, y: int, x_start: int, x_end: int) -> void:
	var x_min: int = mini(x_start, x_end)
	var x_max: int = maxi(x_start, x_end)
	for x in range(x_min, x_max + 1):
		_carve_tile(dungeon, x, y)


func _tunnel_vertical(dungeon: MapData, x: int, y_start: int, y_end: int) -> void:
	var y_min: int = mini(y_start, y_end)
	var y_max: int = maxi(y_start, y_end)
	for y in range(y_min, y_max + 1):
		_carve_tile(dungeon, x, y)


func _tunnel_between(dungeon: MapData, start: Vector2i, end: Vector2i) -> void:
	if _rng.randf() < 0.5:
		_tunnel_horizontal(dungeon, start.y, start.x, end.x)
		_tunnel_vertical(dungeon, end.x, start.y, end.y)
	else:
		_tunnel_vertical(dungeon, start.x, start.y, end.y)
		_tunnel_horizontal(dungeon, end.y, start.x, end.x)


func _carve_tile(dungeon: MapData, x: int, y: int) -> void:
		var tile_position = Vector2i(x, y)
		var tile: Tile = dungeon.get_tile(tile_position)
		tile.set_tile_type("floor")


func _get_max_value_for_floor(weighted_chances_by_floor: Array, current_floor: int) -> int:
	var current_value = 0
	
	for chance in weighted_chances_by_floor:
		if chance[0] > current_floor:
			break
		else:
			current_value = chance[1]
	
	return current_value


func _get_entities_at_random(weighted_chances_by_floor: Dictionary, number_of_entities: int, current_floor: int) -> Array[String]:
	var entity_weighted_chances = {}
	var chosen_entities: Array[String] = []
	
	for key in weighted_chances_by_floor:
		if key > current_floor:
			break
		else:
			for entity_name in weighted_chances_by_floor[key]:
				entity_weighted_chances[entity_name] = weighted_chances_by_floor[key][entity_name]
	
	for _i in number_of_entities:
		chosen_entities.append(_pick_weighted(entity_weighted_chances))
	
	return chosen_entities


func _pick_weighted(weighted_chances: Dictionary) -> String:
	var keys: Array[String] = []
	var cumulative_chances := []
	var sum: int = 0
	for key in weighted_chances:
		keys.append(key)
		var chance: int = weighted_chances[key]
		cumulative_chances.append(chance)
		sum += chance
	var random_chance: int = _rng.randi_range(0, sum - 1)
	var selection: String
	
	for i in cumulative_chances.size():
		if cumulative_chances[i] > random_chance:
			selection = keys[i]
			break
	
	return selection


func _place_entities(dungeon: MapData, room: Rect2i, current_floor: int) -> void:
	var max_monsters_per_room: int = _get_max_value_for_floor(max_monsters_by_floor, current_floor)
	var max_items_per_room: int = _get_max_value_for_floor(max_items_by_floor, current_floor)
	var number_of_monsters: int = _rng.randi_range(0, max_monsters_per_room)
	var number_of_items: int = _rng.randi_range(0, max_items_per_room)
	
	var monsters: Array[String] = _get_entities_at_random(enemy_chances, number_of_monsters, current_floor)
	var items: Array[String] = _get_entities_at_random(item_chances, number_of_items, current_floor)
	
	var entity_keys: Array[String] = monsters + items
	
	for entity_key in entity_keys:
		var x: int = _rng.randi_range(room.position.x + 1, room.end.x - 1)
		var y: int = _rng.randi_range(room.position.y + 1, room.end.y - 1)
		var new_entity_position := Vector2i(x, y)
		
		var can_place = true
		for entity in dungeon.entities:
			if entity.grid_position == new_entity_position:
				can_place = false
				break
		
		if can_place:
			var new_entity := Entity.new(dungeon, new_entity_position, entity_key)
			dungeon.entities.append(new_entity)
