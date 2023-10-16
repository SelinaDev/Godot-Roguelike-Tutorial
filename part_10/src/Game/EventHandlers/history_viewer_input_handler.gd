extends BaseInputHandler

const scroll_step = 16

@export_node_path("PanelContainer") var messages_panel_path
@export_node_path("MessageLog") var message_log_path

@onready var message_panel: PanelContainer = get_node(messages_panel_path)
@onready var message_log: MessageLog = get_node(message_log_path)


func enter() -> void:
	message_panel.self_modulate = Color.RED


func exit() -> void:
	message_panel.self_modulate = Color.WHITE


func get_action(player: Entity) -> Action:
	var action: Action
	
	if Input.is_action_just_pressed("move_up"):
		message_log.scroll_vertical -= scroll_step
	elif Input.is_action_just_pressed("move_down"):
		message_log.scroll_vertical += scroll_step
	elif Input.is_action_just_pressed("move_left"):
		message_log.scroll_vertical = 0
	elif Input.is_action_just_pressed("move_right"):
		message_log.scroll_vertical = message_log.get_v_scroll_bar().max_value
	
	if Input.is_action_just_pressed("view_history") or Input.is_action_just_pressed("ui_back"):
		get_parent().transition_to(InputHandler.InputHandlers.MAIN_GAME)
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	return action
