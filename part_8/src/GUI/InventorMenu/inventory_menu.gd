class_name InventoryMenu
extends CanvasLayer

signal item_selected(item)

const inventory_menu_item_scene := preload("res://src/GUI/InventorMenu/inventory_menu_item.tscn")

@onready var inventory_list: VBoxContainer = $"%InventoryList"
@onready var title_label: Label = $"%TitleLabel"

func _ready() -> void:
	hide()


func build(title_text: String, inventory: InventoryComponent) -> void:
	if inventory.items.is_empty():
		button_pressed.call_deferred()
		MessageLog.send_message("No items in inventory.", GameColors.IMPOSSIBLE)
		return
	title_label.text = title_text
	for i in inventory.items.size():
		_register_item(i, inventory.items[i])
	inventory_list.get_child(0).grab_focus()
	show()


func _register_item(index: int, item: Entity) -> void:
	var item_button: Button = inventory_menu_item_scene.instantiate()
	var char: String = String.chr("a".unicode_at(0) + index)
	item_button.text = "( %s ) %s" % [char, item.get_entity_name()]
	var shortcut_event := InputEventKey.new()
	shortcut_event.keycode = KEY_A + index
	item_button.shortcut = Shortcut.new()
	item_button.shortcut.events = [shortcut_event]
	item_button.pressed.connect(button_pressed.bind(item))
	inventory_list.add_child(item_button)


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_back"):
		item_selected.emit(null)
		queue_free()


func button_pressed(item: Entity = null) -> void:
	item_selected.emit(item)
	queue_free()
