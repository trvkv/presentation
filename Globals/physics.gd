extends Node

class_name GlobalPhysics

static var world: World2D = World2D.new()

static var default_friction_strength: float = 2000.0

static func get_gravity_vector() -> Vector2:
	return PhysicsServer2D.area_get_param(world.space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR)

static func get_gravity_magnitude() -> float:
	return PhysicsServer2D.area_get_param(world.space, PhysicsServer2D.AREA_PARAM_GRAVITY)

static func get_gravity() -> Vector2:
	return get_gravity_vector() * get_gravity_magnitude()

static func apply_gravity(velocity: Vector2, delta: float) -> Vector2:
	return velocity + (get_gravity() * delta)

static func apply_friction(velocity: Vector2, friction_strength: float, delta: float) -> Vector2:
	var friction_force: Vector2 = (-velocity).normalized() * friction_strength * delta
	var combined: Vector2
	if friction_force.length() < velocity.length():
		combined = velocity + friction_force
	return combined
