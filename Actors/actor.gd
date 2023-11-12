extends CharacterBody2D

class_name Actor

@export var acceleration: float = 150.0
@export var max_acceleration_buildup: float = 500.0
@export var acceleration_damp: float = 30.0
@export var max_motion_velocity: float = 500.0
@export var mass: float = 2000.0

# # # # #

class CollisionData:
	var collider: Object
	var friction_coefficient: float

# # # # #

var motion_direction: Vector2
var last_motion_direction: Vector2
var current_acceleration: float
var friction: Vector2
var is_jumping: bool = false

func get_collision_data() -> CollisionData:
	var coefficient: float = 0.0

	# TODO: HANDLE MORE THAN SINGLE COLLISION HERE
	var collider: Object = null

	var collisions: int = get_slide_collision_count()
	for i in range(collisions):
		collider = get_slide_collision(i).get_collider()
		if is_instance_valid(collider):
			# rigid body
			if collider.get("physics_material_override"):
				coefficient += collider.physics_material_override.friction
			# tile map
			elif collider.get("tile_set"):
				var rid: RID = get_slide_collision(i).get_collider_rid()
				var layer: int = collider.get_layer_for_body_rid(rid)
				coefficient += collider.tile_set.get_physics_layer_physics_material(layer).friction

	coefficient /= max(collisions, 1)

	var collision_data: CollisionData = CollisionData.new()
	collision_data.collider = collider
	collision_data.friction_coefficient = coefficient

	return collision_data
