class_name FireballDamageConsumableComponent
extends ConsumableComponent

var damage: int
var radius: int


func _init(definition: FireballDamageConsumableComponentDefinition):
	damage = definition.damage
	radius = definition.radius


func activate(action: ItemAction) -> bool:
	var target_position: Vector2i = action.target_position
	var map_data: MapData = get_map_data()
	
	if not map_data.get_tile(target_position).is_in_view:
		MessageLog.send_message("You cannot target an area that you cannot see.", GameColors.IMPOSSIBLE)
		return false
	
	var targets := []
	for actor in map_data.get_actors():
		if actor.distance(target_position) <= radius:
			targets.append(actor)
	
	if targets.is_empty():
		MessageLog.send_message("There are no targets in the radius.", GameColors.IMPOSSIBLE)
		return false
	if targets.size() == 1 and targets[0] == map_data.player:
		MessageLog.send_message("There are not enemy targets in the radius.", GameColors.IMPOSSIBLE)
		return false
	
	for target in targets:
		MessageLog.send_message("The %s is engulfed in a fiery explosion, taking %d damage!" % [target.get_entity_name(), damage], GameColors.PLAYER_ATTACK)
		target.fighter_component.take_damage(damage)
	
	consume(action.entity)
	return true


func get_targeting_radius() -> int:
	return radius
