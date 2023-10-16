class_name Reticle
extends Node2D

signal position_selected(grid_position)

const directions = {
	"move_up": Vector2i.UP,
	"move_down": Vector2i.DOWN,
	"move_left": Vector2i.LEFT,
	"move_right": Vector2i.RIGHT,
	"move_up_left": Vector2i.UP + Vector2i.LEFT,
	"move_up_right": Vector2i.UP + Vector2i.RIGHT,
	"move_down_left": Vector2i.DOWN + Vector2i.LEFT,
	"move_down_right": Vector2i.DOWN + Vector2i.RIGHT,
}

var grid_position: Vector2i:
	set(value):
		grid_position = value
		position = Grid.grid_to_world(grid_position)

var map_data: MapData

@onready var camera: Camera2D = $Camera2D
@onready var border: Line2D = $Line2D

func _ready() -> void:
	hide()
	set_physics_process(false)


func select_position(player: Entity, radius: int) -> Vector2i:
	map_data = player.map_data
	grid_position = player.grid_position
	
	var player_camera: Camera2D = get_viewport().get_camera_2d()
	camera.make_current()
	_setup_border(radius)
	show()
	await get_tree().physics_frame
	set_physics_process.call_deferred(true)
	
	var selected_position: Vector2i = await position_selected
	
	set_physics_process(false)
	player_camera.make_current()
	hide()
	
	return selected_position


func _physics_process(delta: float) -> void:
	var offset := Vector2i.ZERO
	for direction in directions:
		if Input.is_action_just_pressed(direction):
			offset += directions[direction]
	grid_position += offset
	
	if Input.is_action_just_pressed("ui_accept"):
		position_selected.emit(grid_position)
	if Input.is_action_just_pressed("ui_back"):
		position_selected.emit(Vector2i(-1, -1))


func _setup_border(radius: int) -> void:
	if radius <= 0:
		border.hide()
	else:
		border.points = [
			Vector2i(-radius, -radius) * Grid.tile_size,
			Vector2i(-radius, radius + 1) * Grid.tile_size,
			Vector2i(radius + 1, radius + 1) * Grid.tile_size,
			Vector2i(radius + 1, -radius) * Grid.tile_size,
			Vector2i(-radius, -radius) * Grid.tile_size
		]
		border.show()
