class_name FighterComponent
extends Component

var max_hp: int
var hp: int:
	set(value):
		hp = clampi(value, 0, max_hp)
		if hp <= 0:
			die()
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


func die() -> void:
	var death_message: String
	
	if get_map_data().player == entity:
		death_message = "You died!"
		SignalBus.player_died.emit()
	else:
		death_message = "%s is dead!" % entity.get_entity_name()
	
	print(death_message)
	entity.texture = death_texture
	entity.modulate = death_color
	entity.ai_component.queue_free()
	entity.ai_component = null
	entity.entity_name = "Remains of %s" % entity.entity_name
	entity.blocks_movement = false
	get_map_data().unregister_blocking_entity(entity)
	entity.type = Entity.EntityType.CORPSE
