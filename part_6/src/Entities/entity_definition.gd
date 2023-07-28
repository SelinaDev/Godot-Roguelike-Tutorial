class_name EntityDefinition
extends Resource

@export_category("Visuals")
@export var name: String = "Unnamed Entity"
@export var texture: AtlasTexture
@export_color_no_alpha var color: Color = Color.WHITE

@export_category("Mechanics")
@export var is_blocking_movement: bool = true
@export var type: Entity.EntityType = Entity.EntityType.ACTOR

@export_category("Components")
@export var fighter_definition: FighterComponentDefinition
@export var ai_type: Entity.AIType
