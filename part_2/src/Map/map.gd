class_name Map
extends Node2D

@export var map_width: int = 80
@export var map_height: int = 45

var map_data: MapData


func _ready() -> void:
	map_data = MapData.new(map_width, map_height)
	_place_tiles()


func _place_tiles() -> void:
	for tile in map_data.tiles:
		add_child(tile)
