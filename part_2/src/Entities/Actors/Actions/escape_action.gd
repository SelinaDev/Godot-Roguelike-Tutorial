class_name EscapeAction
extends Action


func perform(game: Game, entity: Entity) -> void:
	game.get_tree().quit()
