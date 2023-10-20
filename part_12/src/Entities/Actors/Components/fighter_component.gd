class_name FighterComponent
extends Component

signal hp_changed(hp, max_hp)

var max_hp: int
var hp: int:
	set(value):
		hp = clampi(value, 0, max_hp)
		hp_changed.emit(hp, max_hp)
		if hp <= 0:
			var die_silently := false
			if not is_inside_tree():
				die_silently = true
				await ready
			die(not die_silently)
var defense: int
var power: int

var death_texture: Texture
var death_color: Color


func _init(definition: FighterComponentDefinition) -> void:
	max_hp = definition.max_hp
	hp = definition.max_hp
	defense = definition.defense
	power = definition.power
	death_texture = definition.death_texture
	death_color = definition.death_color


func heal(amount: int) -> int:
	if hp == max_hp:
		return 0
	
	var new_hp_value: int = hp + amount
	
	if new_hp_value > max_hp:
		new_hp_value = max_hp
		
	var amount_recovered: int = new_hp_value - hp
	hp = new_hp_value
	return amount_recovered


func take_damage(amount: int) -> void:
	hp -= amount


func die(trigger_side_effects := true) -> void:
	var death_message: String
	var death_message_color: Color
	
	if get_map_data().player == entity:
		death_message = "You died!"
		death_message_color = GameColors.PLAYER_DIE
		SignalBus.player_died.emit()
	else:
		death_message = "%s is dead!" % entity.get_entity_name()
		death_message_color = GameColors.ENEMY_DIE
	
	if trigger_side_effects:
		MessageLog.send_message(death_message, death_message_color)
		get_map_data().player.level_component.add_xp(entity.level_component.xp_given)
	entity.texture = death_texture
	entity.modulate = death_color
	entity.ai_component.queue_free()
	entity.ai_component = null
	entity.entity_name = "Remains of %s" % entity.entity_name
	entity.blocks_movement = false
	entity.type = Entity.EntityType.CORPSE
	get_map_data().unregister_blocking_entity(entity)


func get_save_data() -> Dictionary:
	return {
		"max_hp": max_hp,
		"hp": hp,
		"power": power,
		"defense": defense
	}


func restore(save_data: Dictionary) -> void:
	max_hp = save_data["max_hp"]
	hp = save_data["hp"]
	power = save_data["power"]
	defense = save_data["defense"]
