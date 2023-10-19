class_name ConfusedEnemyAIComponent
extends BaseAIComponent

var previous_ai: BaseAIComponent
var turns_remaining: int


func _ready() -> void:
	previous_ai = entity.ai_component
	entity.ai_component = self


func _init(turns_remaining: int) -> void:
	self.turns_remaining = turns_remaining


func perform() -> void:
	if turns_remaining <= 0:
		MessageLog.send_message("The %s is no longer confused.", Color.WHITE)
		entity.ai_component = previous_ai
		queue_free()
	else:
		var direction: Vector2i = [
			Vector2i(-1, -1),
			Vector2i( 0, -1),
			Vector2i( 1, -1),
			Vector2i(-1,  0),
			Vector2i( 1,  0),
			Vector2i(-1,  1),
			Vector2i( 0,  1),
			Vector2i( 1,  1),
		].pick_random()
		turns_remaining -= 1
		return BumpAction.new(entity, direction.x, direction.y).perform()


func get_save_data() -> Dictionary:
	return {
		"type": "ConfusedEnemyAI",
		"turns_remaining": turns_remaining
	}
