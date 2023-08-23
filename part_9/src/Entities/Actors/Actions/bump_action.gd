class_name BumpAction
extends ActionWithDirection


func perform() -> bool:
	if get_target_actor():
		return MeleeAction.new(entity, offset.x, offset.y).perform()
	else:
		return MovementAction.new(entity, offset.x, offset.y).perform()
