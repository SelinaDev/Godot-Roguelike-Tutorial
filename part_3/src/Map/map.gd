class_name Map
extends Node2D

var map_data: MapData

@onready var dungeon_generator: DungeonGenerator = $DungeonGenerator


func generate(player: Entity) -> void:
	map_data = dungeon_generator.generate_dungeon(player)
	_place_tiles()


func _place_tiles() -> void:
	for tile in map_data.tiles:
		add_child(tile)
