class_name EquipAction
extends Action

var _item: Entity


func _init(entity: Entity, item: Entity) -> void:
	super._init(entity)
	_item = item


func perform() -> bool:
	entity.equipment_component.toggle_equip(_item)
	return true
