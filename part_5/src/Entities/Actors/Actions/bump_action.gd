class_name BumpAction
extends ActionWithDirection


func perform(game: Game, entity: Entity) -> void:
	var destination := Vector2i(entity.grid_position + offset)
	
	if game.get_map_data().get_blocking_entity_at_location(destination):
		MeleeAction.new(offset.x, offset.y).perform(game, entity)
	else:
		MovementAction.new(offset.x, offset.y).perform(game, entity)
