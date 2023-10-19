class_name Entity
extends Sprite2D

enum AIType {NONE, HOSTILE}
enum EntityType {CORPSE, ITEM, ACTOR}

const entity_types = {
	"player": "res://assets/definitions/entities/actors/entity_definition_player.tres",
	"orc": "res://assets/definitions/entities/actors/entity_definition_orc.tres",
	"troll": "res://assets/definitions/entities/actors/entity_definition_troll.tres",
	"health_potion": "res://assets/definitions/entities/items/health_potion_definition.tres",
	"lightning_scroll": "res://assets/definitions/entities/items/lightning_scroll_definition.tres",
	"confusion_scroll": "res://assets/definitions/entities/items/confusion_scroll_definition.tres",
	"fireball_scroll": "res://assets/definitions/entities/items/fireball_scroll_definition.tres",
}

var grid_position: Vector2i:
	set(value):
		grid_position = value
		position = Grid.grid_to_world(grid_position)

var _definition: EntityDefinition
var entity_name: String
var blocks_movement: bool
var type: EntityType:
	set(value):
		type = value
		z_index = type
var map_data: MapData
var key: String

var fighter_component: FighterComponent
var ai_component: BaseAIComponent
var consumable_component: ConsumableComponent
var inventory_component: InventoryComponent
var level_component: LevelComponent


func _init(map_data: MapData, start_position: Vector2i, key: String = "") -> void:
	centered = false
	grid_position = start_position
	self.map_data = map_data
	if key != "":
		set_entity_type(key)


func set_entity_type(key: String) -> void:
	self.key = key
	var entity_definition: EntityDefinition = load(entity_types[key])
	_definition = entity_definition
	type = _definition.type
	blocks_movement = _definition.is_blocking_movment
	entity_name = _definition.name
	texture = entity_definition.texture
	modulate = entity_definition.color
	
	match entity_definition.ai_type:
		AIType.HOSTILE:
			ai_component = HostileEnemyAIComponent.new()
			add_child(ai_component)
	
	if entity_definition.fighter_definition:
		fighter_component = FighterComponent.new(entity_definition.fighter_definition)
		add_child(fighter_component)
		
	if entity_definition.consumable_definition:
		_handle_consumable(entity_definition.consumable_definition)
	
	if entity_definition.inventory_capacity > 0:
		inventory_component = InventoryComponent.new(entity_definition.inventory_capacity)
		add_child(inventory_component)
	
	if entity_definition.level_info:
		level_component = LevelComponent.new(entity_definition.level_info)
		add_child(level_component)


func move(move_offset: Vector2i) -> void:
	map_data.unregister_blocking_entity(self)
	grid_position += move_offset
	map_data.register_blocking_entity(self)
	visible = map_data.get_tile(grid_position).is_in_view


func distance(other_position: Vector2i) -> float:
	var relative: Vector2i = other_position - grid_position
	return relative.length()


func is_blocking_movement() -> bool:
	return blocks_movement


func get_entity_name() -> String:
	return entity_name


func get_entity_type() -> int:
	return _definition.type


func is_alive() -> bool:
	return ai_component != null


func _handle_consumable(consumable_definition: ConsumableComponentDefinition) -> void:
	if consumable_definition is HealingConsumableComponentDefinition:
		consumable_component = HealingConsumableComponent.new(consumable_definition)
	elif consumable_definition is LightningDamageConsumableComponentDefinition:
		consumable_component = LightningDamageConsumableComponent.new(consumable_definition)
	elif consumable_definition is ConfusionConsumableComponentDefinition:
		consumable_component = ConfusionConsumableComponent.new(consumable_definition)
	elif consumable_definition is FireballDamageConsumableComponentDefinition:
		consumable_component = FireballDamageConsumableComponent.new(consumable_definition)
	
	if consumable_component:
		add_child(consumable_component)


func get_save_data() -> Dictionary:
	var save_data: Dictionary = {
		"x": grid_position.x,
		"y": grid_position.y,
		"key": key,
	}
	if fighter_component:
		save_data["fighter_component"] = fighter_component.get_save_data()
	if ai_component:
		save_data["ai_component"] = ai_component.get_save_data()
	if inventory_component:
		save_data["inventory_component"] = inventory_component.get_save_data()
	if level_component:
		save_data["level_component"] = level_component.get_save_data()
	return save_data


func restore(save_data: Dictionary) -> void:
	grid_position = Vector2i(save_data["x"], save_data["y"])
	set_entity_type(save_data["key"])
	if fighter_component and save_data.has("fighter_component"):
		fighter_component.restore(save_data["fighter_component"])
	if ai_component and save_data.has("ai_component"):
		var ai_data: Dictionary = save_data["ai_component"]
		if ai_data["type"] == "ConfusedEnemyAIComponent":
			var confused_enemy_ai := ConfusedEnemyAIComponent.new(ai_data["turns_remaining"])
			add_child(confused_enemy_ai)
	if inventory_component and save_data.has("inventory_component"):
		inventory_component.restore(save_data["inventory_component"])
	if level_component and save_data.has("level_component"):
		level_component.restore(save_data["level_component"])
