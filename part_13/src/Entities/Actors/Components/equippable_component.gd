class_name EquippableComponent
extends Node

enum EquipmentType { WEAPON, ARMOR }

var equipment_type: EquipmentType
var power_bonus: int
var defense_bonus: int


func _init(definition: EquippableComponentDefinition) -> void:
	equipment_type = definition.equipment_type
	power_bonus = definition.power_bonus
	defense_bonus = definition.defense_bonus
