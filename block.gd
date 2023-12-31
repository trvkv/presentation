@tool
extends StaticBody2D

@export_category("Terrain")
@export var terrain_type: Types.TerrainTypes = Types.TerrainTypes.DIRT:
	get = get_terrain_type, set = set_terrain_type
@export var friction_coefficient: float:
	get:
		if is_instance_valid(physics_material_override):
			return physics_material_override.friction
		return 0.0
	set(value):
		friction_coefficient = value
		if is_instance_valid(physics_material_override):
			physics_material_override.friction = value

# This is test change 1...
# This is test change 2
# This is test change 3 and asdasdasdasdasdasdasdasdasdasdasd

# SZYMON 1 and 2: Collision shape for our block
# TODO: Add more collision shapes
@onready var collision: Shape2D = $CollisionShape2D.shape

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
