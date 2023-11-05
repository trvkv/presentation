extends CharacterBody2D

class_name Actor

@export var acceleration: float = 150.0
@export var max_acceleration_buildup: float = 500.0
@export var acceleration_damp: float = 30.0
@export var max_motion_velocity: float = 500.0
@export var mass: float = 2000.0

# # # # #

class CollisionData:
	var friction_coefficient: float

# # # # #

var motion_direction: Vector2
var last_motion_direction: Vector2
var current_acceleration: float
var friction: Vector2

func get_collision_data() -> CollisionData:
	var coefficient: float = 0.0

	var collisions: int = get_slide_collision_count()
	for i in range(collisions):
		var collision = get_slide_collision(i)
		# assume it's block for now
		coefficient += collision.get_collider().friction_coefficient

	coefficient /= max(collisions, 1)

	var collision_data: CollisionData = CollisionData.new()
	collision_data.friction_coefficient = coefficient

	return collision_data
