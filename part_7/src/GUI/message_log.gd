class_name MessageLog
extends ScrollContainer

var last_message: Message = null

@onready var message_list: VBoxContainer = $"%MessageList"


func _ready() -> void:
	SignalBus.message_sent.connect(add_message)


static func send_message(text: String, color: Color) -> void:
	SignalBus.message_sent.emit(text, color)


func add_message(text: String, color: Color) -> void:
	if (
		last_message != null and
		last_message.plain_text == text
	):
		last_message.count += 1
	else:
		var message := Message.new(text, color)
		last_message = message
		message_list.add_child(message)
		await get_tree().process_frame
		ensure_control_visible(message)
