class_name InventoryComponent
extends Component

var items: Array[Entity]
var capacity: int


func _init(capacity: int) -> void:
	items = []
	self.capacity = capacity


func drop(item: Entity) -> void:
	items.erase(item)
	var map_data: MapData = get_map_data()
	map_data.entities.append(item)
	map_data.entity_placed.emit(item)
	item.map_data = map_data
	item.grid_position = entity.grid_position
	MessageLog.send_message("You dropped the %s." % item.get_entity_name(), Color.WHITE)


func get_save_data() -> Dictionary:
	var save_data: Dictionary = {
		"capacity": capacity,
		"items": []
	}
	for item in items:
		save_data["items"].append(item.get_save_data())
	return save_data


func restore(save_data: Dictionary) -> void:
	capacity = save_data["capacity"]
	for item_data in save_data["items"]:
		var item: Entity = Entity.new(null, Vector2i(-1, -1), "")
		item.restore(item_data)
		items.append(item)
