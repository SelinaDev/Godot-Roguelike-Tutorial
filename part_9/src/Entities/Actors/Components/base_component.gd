class_name Component
extends Node

@onready var entity: Entity = get_parent() as Entity


func get_map_data() -> MapData:
	return entity.map_data
