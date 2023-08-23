class_name EscapeAction
extends Action


func perform() -> bool:
	entity.get_tree().quit()
	return false
