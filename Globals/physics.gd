extends Node

class_name GlobalPhysics

static func get_gravity_vector(space: RID) -> Vector2:
	return PhysicsServer2D.area_get_param(space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR)

static func get_gravity_magnitude(space: RID) -> float:
	return PhysicsServer2D.area_get_param(space, PhysicsServer2D.AREA_PARAM_GRAVITY)

static func get_gravity(space: RID) -> Vector2:
	return get_gravity_vector(space) * get_gravity_magnitude(space)

static func apply_gravity(object: Node, velocity: Vector2, delta: float) -> Vector2:
	var space: RID = object.get_viewport().world_2d.space
	if object.is_class("Area2D"):
		space = object.get_rid()
	return velocity + (get_gravity(space) * delta)

static func apply_jump(object: Node, velocity: Vector2, jump_strength: float) -> Vector2:
	var space: RID = object.get_viewport().world_2d.space
	if object.is_class("Area2D"):
		space = object.get_rid()
	return velocity + (-get_gravity_vector(space) * jump_strength)

static func count_friction(velocity: Vector2, mass: float, coefficient: float, delta: float) -> Vector2:
	var friction: float = coefficient * mass * delta
	var direction: float = -sign(velocity.x)
	return Vector2(min(friction, abs(velocity.x)), velocity.y) * direction

static func apply_friction(velocity: Vector2, mass: float, coefficient: float, delta: float) -> Vector2:
	return velocity + count_friction(velocity, mass, coefficient, delta)
