class_name MeleeAction
extends ActionWithDirection


func perform() -> void:
	var target: Entity = get_target_actor()
	if not target:
		return
	
	var damage: int = entity.fighter_component.power - target.fighter_component.defense
	
	var attack_description: String = "%s attacks %s" % [entity.get_entity_name(), target.get_entity_name()]
	if damage > 0:
		attack_description += " for %d hit points." % damage
		print(attack_description)
		target.fighter_component.hp -= damage
	else:
		attack_description += " but does no damage."
		print(attack_description)
