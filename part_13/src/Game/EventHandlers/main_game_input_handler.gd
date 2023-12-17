extends BaseInputHandler

const directions = {
	"move_up": Vector2i.UP,
	"move_down": Vector2i.DOWN,
	"move_left": Vector2i.LEFT,
	"move_right": Vector2i.RIGHT,
	"move_up_left": Vector2i.UP + Vector2i.LEFT,
	"move_up_right": Vector2i.UP + Vector2i.RIGHT,
	"move_down_left": Vector2i.DOWN + Vector2i.LEFT,
	"move_down_right": Vector2i.DOWN + Vector2i.RIGHT,
}

const inventory_menu_scene = preload("res://src/GUI/InventorMenu/inventory_menu.tscn")

@export var reticle: Reticle


func get_action(player: Entity) -> Action:
	var action: Action = null
	
	for direction in directions:
		if Input.is_action_just_pressed(direction):
			var offset: Vector2i = directions[direction]
			action = BumpAction.new(player, offset.x, offset.y)
	
	if Input.is_action_just_pressed("wait"):
		action = WaitAction.new(player)
	
	if Input.is_action_just_pressed("view_history"):
		get_parent().transition_to(InputHandler.InputHandlers.HISTORY_VIEWER)
	
	if Input.is_action_just_pressed("pickup"):
		action = PickupAction.new(player)
	
	if Input.is_action_just_pressed("drop"):
		var selected_item: Entity = await get_item("Select an item to drop", player.inventory_component)
		action = DropItemAction.new(player, selected_item)
	
	if Input.is_action_just_pressed("activate"):
		action = await activate_item(player)
	
	if Input.is_action_just_pressed("look"):
		await get_grid_position(player, 0)
	
	
	if Input.is_action_just_pressed("descend"):
		action = TakeStairsAction.new(player)
	
	
	if Input.is_action_just_pressed("quit") or Input.is_action_just_pressed("ui_back"):
		action = EscapeAction.new(player)
	
	return action


func activate_item(player: Entity) -> Action:
	var selected_item: Entity = await get_item("Select an item to use", player.inventory_component, true)
	if selected_item == null:
		return null
	var target_radius: int = -1
	if selected_item.consumable_component != null:
		target_radius = selected_item.consumable_component.get_targeting_radius()
	if target_radius == -1:
		return ItemAction.new(player, selected_item)
	var target_position: Vector2i = await get_grid_position(player, target_radius)
	if target_position == Vector2i(-1, -1):
		return null
	return ItemAction.new(player, selected_item, target_position)


func get_item(window_title: String, inventory: InventoryComponent, evaluate_for_next_step: bool = false) -> Entity:
	if inventory.items.is_empty():
		await get_tree().physics_frame
		MessageLog.send_message("No items in inventory.", GameColors.IMPOSSIBLE)
		return null
	var inventory_menu: InventoryMenu = inventory_menu_scene.instantiate()
	add_child(inventory_menu)
	inventory_menu.build(window_title, inventory)
	get_parent().transition_to(InputHandler.InputHandlers.DUMMY)
	var selected_item: Entity = await inventory_menu.item_selected
	var has_item: bool = selected_item != null
	var needs_targeting: bool = has_item and selected_item.consumable_component and selected_item.consumable_component.get_targeting_radius() != -1
	if not evaluate_for_next_step or not has_item or not needs_targeting:
		await get_tree().physics_frame
		get_parent().call_deferred("transition_to", InputHandler.InputHandlers.MAIN_GAME)
	return selected_item


func get_grid_position(player: Entity, radius: int) -> Vector2i:
	get_parent().transition_to(InputHandler.InputHandlers.DUMMY)
	var selected_position: Vector2i = await reticle.select_position(player, radius)
	await get_tree().physics_frame
	get_parent().call_deferred("transition_to", InputHandler.InputHandlers.MAIN_GAME)
	return selected_position


