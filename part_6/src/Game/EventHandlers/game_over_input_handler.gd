extends BaseInputHandler

func get_action(player: Entity) -> Action:
	var action: Action
	
	if Input.is_action_just_pressed("quit"):
		action = EscapeAction.new(player)
	
	return action
