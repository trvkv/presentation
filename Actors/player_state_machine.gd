extends Node

class PlayerStateIdle extends StateMachine.State:

	func _init() -> void:
		super("Idle")

	func get_transition() -> String:
		var player: Player = Global.player

		if not player.is_on_floor():
			return "Falling"
		else:
			if player.motion_direction.length() > 0.0:
				return "Run"
		return ""

	func physics_tick(delta) -> void:
		var player: Player = Global.player
		player.velocity = GlobalPhysics.apply_gravity(player.velocity, delta)
		var collided: bool = player.move_and_slide()

		if not collided:
			return

		player.velocity = player.count_friction(delta)

class PlayerStateRun extends StateMachine.State:

	func _init() -> void:
		super("Run")

	func get_transition() -> String:
		var player: Player = Global.player
		if not player.is_on_floor():
			return "Falling"
		if player.motion_direction.length() == 0.0:
			return "Idle"
		return ""

	func physics_tick(delta) -> void:
		var player: Player = Global.player

		var v: Vector2 = player.velocity
		v = GlobalPhysics.apply_gravity(v, delta)
		v = v + (player.motion_direction * player.default_move_speed)
		v = v.limit_length(player.max_motion_velocity)
		player.velocity = v

		player.move_and_slide()
		player.velocity = player.count_friction(delta)

class PlayerStateFalling extends StateMachine.State:

	func _init() -> void:
		super("Falling")

	func get_transition() -> String:
		var player: Player = Global.player
		if player.velocity.y == 0.0:
			if player.motion_direction.length() == 0.0:
				return "Idle"
			else:
				return "Run"
		return ""

	func physics_tick(delta):
		var player: Player = Global.player
		player.velocity = player.velocity * Vector2(0.98, 1.0)
		player.velocity = GlobalPhysics.apply_gravity(player.velocity, delta)
		player.move_and_slide()

class PlayerStateDashing extends StateMachine.State:

	func _init() -> void:
		super("Dashing")

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

	state_machine = StateMachine.new("Idle", [
		PlayerStateIdle.new(),
		PlayerStateRun.new(),
		PlayerStateFalling.new(),
		PlayerStateDashing.new()
	])

	add_child(state_machine)
