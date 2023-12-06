class_name LightningDamageConsumableComponent
extends ConsumableComponent

var damage: int = 0
var maximum_range: int = 0


func _init(definition: LightningDamageConsumableComponentDefinition) -> void:
	damage = definition.damage
	maximum_range = definition.maximum_range


func activate(action: ItemAction) -> bool:
	var consumer: Entity = action.entity
	var target: Entity = null
	var closest_distance: float = maximum_range + 1
	var map_data: MapData = consumer.map_data
	
	for actor in map_data.get_actors():
		if actor != consumer and map_data.get_tile(actor.grid_position).is_in_view:
			var distance: float = consumer.distance(actor.grid_position)
			if distance < closest_distance:
				target = actor
				closest_distance = distance
	
	if target:
		MessageLog.send_message("A lightning bolt strikes %s with a loud thunder, for %d damage!" % [target.get_entity_name(), damage], Color.WHITE)
		target.fighter_component.take_damage(damage)
		consume(consumer)
		return true
	
	MessageLog.send_message("No enemy is close enough to strike.", GameColors.IMPOSSIBLE)
	return false
