class_name EscapeAction
extends Action


func perform() -> bool:
	#entity.get_tree().quit()
	entity.map_data.save()
	SignalBus.escape_requested.emit()
	return false
