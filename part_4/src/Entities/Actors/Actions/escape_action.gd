class_name EscapeAction
extends Action


func perform(game: Game, _entity: Entity) -> void:
	game.get_tree().quit()
