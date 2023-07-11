class_name TileDefinition
extends Resource

@export_category("Visuals")
@export var texture: AtlasTexture
@export_color_no_alpha var color_lit: Color = Color.WHITE
@export_color_no_alpha var color_dark: Color = Color.WHITE

@export_category("Mechanics")
@export var is_walkable: bool = true
@export var is_transparent: bool = true
