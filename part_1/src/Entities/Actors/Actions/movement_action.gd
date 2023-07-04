class_name MovementAction
extends Action

var offset: Vector2i

func _init(dx: int, dy: int) -> void:
	offset = Vector2i(dx, dy)
