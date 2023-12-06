class_name EquipmentComponent
extends Component

var slots := {}

func get_defense_bonus() -> int:
	var bonus = 0
	
	for item in slots.values():
		if item.equippable_component:
			bonus += item.equippable_component.defense_bonus
	
	return bonus


func get_power_bonus() -> int:
	var bonus = 0
	
	for item in slots.values():
		if item.equippable_component:
			bonus += item.equippable_component.power_bonus
	
	return bonus


func is_item_equipped(item: Entity) -> bool:
	return item in slots.values()


func unequip_message(item_name: String) -> void:
	MessageLog.send_message("You remove the %s." % item_name, Color.WHITE)


func equip_message(item_name: String) -> void:
	MessageLog.send_message("You equip the %s." % item_name, Color.WHITE)


func equip_to_slot(slot: EquippableComponent.EquipmentType, item: Entity, add_message: bool) -> void:
	var current_item = slots.get(slot)
	if current_item:
		unequip_from_slot(slot, add_message)
	slots[slot] = item
	if add_message:
		equip_message(item.get_entity_name())


func unequip_from_slot(slot: EquippableComponent.EquipmentType, add_message: bool) -> void:
	var current_item = slots.get(slot)
	
	if add_message:
		unequip_message(current_item.get_entity_name())
	
	slots.erase(slot)


func toggle_equip(equippable_item: Entity, add_message: bool = true) -> void:
	if not equippable_item.equippable_component:
		return
	var slot: EquippableComponent.EquipmentType = equippable_item.equippable_component.equipment_type
	
	if slots.get(slot) == equippable_item:
		unequip_from_slot(slot, add_message)
	else:
		equip_to_slot(slot, equippable_item, add_message)
