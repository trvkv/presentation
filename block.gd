@tool
extends StaticBody2D

@export_category("Terrain")
@export var terrain_type: Types.TerrainTypes = Types.TerrainTypes.DIRT:
	get = get_terrain_type, set = set_terrain_type

@onready var collision: Shape2D = $CollisionShape2D.shape

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_terrain_type() -> Types.TerrainTypes:
	return terrain_type

func set_terrain_type(value: Types.TerrainTypes):
	terrain_type = value
	var properties = Types.TerrainSettings[value].keys()
	for property in properties:
		if get(property) == null:
			printerr("Property ", property, " not found on ", self)
			continue
		set(property, Types.TerrainSettings[value][property])
