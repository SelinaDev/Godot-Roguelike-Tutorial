class_name ActionWithDirection
extends Action

var offset: Vector2i


func _init(dx: int, dy: int) -> void:
	offset = Vector2i(dx, dy)


func perform(game: Game, entity: Entity) -> void:
	pass
