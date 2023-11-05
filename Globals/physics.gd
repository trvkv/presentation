extends Node

class_name GlobalPhysics

static var world: World2D = World2D.new()

static func get_gravity_vector() -> Vector2:
	return PhysicsServer2D.area_get_param(world.space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR)

static func get_gravity_magnitude() -> float:
	return PhysicsServer2D.area_get_param(world.space, PhysicsServer2D.AREA_PARAM_GRAVITY)

static func get_gravity() -> Vector2:
	return get_gravity_vector() * get_gravity_magnitude()

static func apply_gravity(velocity: Vector2, delta: float) -> Vector2:
	return velocity + (get_gravity() * delta)

static func count_friction(velocity: Vector2, mass: float, coefficient: float, delta: float) -> Vector2:
	var friction: float = coefficient * mass * delta
	var direction: float = -sign(velocity.x)
	return Vector2(min(friction, abs(velocity.x)), velocity.y) * direction

static func apply_friction(velocity: Vector2, mass: float, coefficient: float, delta: float) -> Vector2:
	return velocity + count_friction(velocity, mass, coefficient, delta)
