extends Node

class_name PlayerStateMachine

enum STATES { INVALID = StateMachine.INVALID, IDLE, RUNNING, FALLING, JUMPING, DASHING }

class PlayerStateIdle extends StateMachine.State:

	func _init() -> void:
		super(STATES.IDLE, "Idle")

	func get_transition() -> int:
		var player: Player = Global.player
		if not player.is_on_floor():
			return STATES.FALLING
		if player.is_jumping:
			return STATES.JUMPING
		if player.motion_direction.length() > 0.0:
			return STATES.RUNNING
		return STATES.INVALID

	func physics_tick(delta) -> void:
		var player: Player = Global.player

		player.current_acceleration -= player.acceleration_damp
		player.current_acceleration = max(player.current_acceleration, 0.0)

		player.velocity = GlobalPhysics.apply_gravity(player.velocity, delta)
		player.move_and_slide()

		var collision_data: Player.CollisionData = player.get_collision_data()

		player.friction = GlobalPhysics.count_friction(
			player.velocity,
			player.mass,
			collision_data.friction_coefficient,
			delta
		)

		player.velocity += player.friction

	func input(event: InputEvent) -> void:
		if event.is_action_type():
			var player: Player = Global.player
			player.handle_movement(event)
			player.handle_jump(event)
			player.get_viewport().set_input_as_handled()

class PlayerStateRunning extends StateMachine.State:

	func _init() -> void:
		super(STATES.RUNNING, "Running")

	func get_transition() -> int:
		var player: Player = Global.player
		if not player.is_on_floor():
			return STATES.FALLING
		if player.is_jumping:
			return STATES.JUMPING
		if player.motion_direction.length() == 0.0:
			return STATES.IDLE
		return STATES.INVALID

	func physics_tick(delta) -> void:
		var player: Player = Global.player
		var v: Vector2 = player.velocity
		v = GlobalPhysics.apply_gravity(v, delta)

		player.current_acceleration += max(abs(player.friction.x), 10.0)
		player.current_acceleration = min(player.current_acceleration, player.max_acceleration_buildup)

		v = v + (player.motion_direction.normalized() * player.current_acceleration)
		v = v.limit_length(player.max_motion_velocity)

		player.velocity = v
		player.move_and_slide()

		var collision_data: Player.CollisionData = player.get_collision_data()
		player.friction = GlobalPhysics.count_friction(
			player.velocity,
			player.mass,
			collision_data.friction_coefficient,
			delta
		)
		player.velocity += player.friction

	func input(event: InputEvent) -> void:
		if event.is_action_type():
			var player: Player = Global.player
			player.handle_movement(event)
			player.handle_jump(event)
			player.get_viewport().set_input_as_handled()

class PlayerStateFalling extends StateMachine.State:

	func _init() -> void:
		super(STATES.FALLING, "Falling")

	func get_transition() -> int:
		var player: Player = Global.player
		if player.velocity.y == 0.0:
			if player.motion_direction.length() == 0.0:
				return STATES.IDLE
			else:
				return STATES.RUNNING
		return STATES.INVALID

	func physics_tick(delta):
		var player: Player = Global.player
		player.velocity = player.velocity * Vector2(0.995, 1.0)
		player.velocity = GlobalPhysics.apply_gravity(player.velocity, delta)
		player.move_and_slide()

	func input(event: InputEvent) -> void:
		if event.is_action_type():
			var player: Player = Global.player
			player.handle_movement(event)
			player.get_viewport().set_input_as_handled()

class PlayerStateJumping extends StateMachine.State:

	func _init() -> void:
		super(STATES.JUMPING, "Jumping")

	func get_transition() -> int:
		var player: Player = Global.player
		if player.is_jumping:
			return STATES.INVALID
		if player.is_on_floor():
			if player.motion_direction.length() == 0:
				return STATES.IDLE
			return STATES.RUNNING
		return STATES.FALLING

	func enter() -> void:
		var player: Player = Global.player
		player.apply_jump()

	func physics_tick(delta) -> void:
		var player: Player = Global.player
		player.velocity = GlobalPhysics.apply_gravity(player.velocity, delta)
		player.move_and_slide()
		player.is_jumping = false

	func input(event: InputEvent) -> void:
		if event.is_action_type():
			var player: Player = Global.player
			player.handle_movement(event)
			player.get_viewport().set_input_as_handled()

class PlayerStateDashing extends StateMachine.State:

	func _init() -> void:
		super(STATES.DASHING, "Dashing")

#
# main script part
#

@export var player_node_path: NodePath
var player_node: Player

var state_machine: StateMachine
var active_state: StateMachine.State:
	get:
		return state_machine.active_state
	set(value):
		active_state = value

func _ready():
	player_node = get_node_or_null(player_node_path)
	Util.crash_if_false(is_instance_valid(player_node), "Player node required")

	state_machine = StateMachine.new(STATES.IDLE, {
		STATES.IDLE: PlayerStateIdle.new(),
		STATES.RUNNING: PlayerStateRunning.new(),
		STATES.FALLING: PlayerStateFalling.new(),
		STATES.JUMPING: PlayerStateJumping.new(),
		STATES.DASHING: PlayerStateDashing.new()
	})

	add_child(state_machine)
