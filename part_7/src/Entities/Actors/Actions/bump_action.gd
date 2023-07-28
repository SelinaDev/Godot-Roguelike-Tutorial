class_name BumpAction
extends ActionWithDirection


func perform() -> void:
	if get_target_actor():
		MeleeAction.new(entity, offset.x, offset.y).perform()
	else:
		MovementAction.new(entity, offset.x, offset.y).perform()
