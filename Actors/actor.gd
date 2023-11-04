extends CharacterBody2D

class_name Actor

@export var default_move_speed: float = 800.0
@export var max_motion_velocity: float = 500.0

var motion_direction: Vector2

func count_friction(delta) -> Vector2:
	var friction: float = 0.0

	var collisions: int = get_slide_collision_count()
	for i in range(collisions):
		var collision = get_slide_collision(i)
		# assume it's block for now
		friction += collision.get_collider().friction_strength
	friction /= collisions

	return GlobalPhysics.apply_friction(velocity, friction, delta)
