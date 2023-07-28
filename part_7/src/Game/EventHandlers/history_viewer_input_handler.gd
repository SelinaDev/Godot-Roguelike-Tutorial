extends BaseInputHandler

signal hide_message_overlay_requested


func get_action(player: Entity) -> Action:
	var action: Action
	
	if Input.is_action_just_pressed("view_history") or Input.is_action_just_pressed("quit"):
		hide_message_overlay_requested.emit()
		get_parent().transition_to(InputHandler.InputHandlers.MAIN_GAME)
	
	return action
