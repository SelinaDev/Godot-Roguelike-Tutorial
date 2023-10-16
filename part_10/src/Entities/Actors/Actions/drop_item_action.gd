class_name DropItemAction
extends ItemAction


func perform() -> bool:
	if item == null:
		return false
	entity.inventory_component.drop(item)
	return true
