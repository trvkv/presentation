extends Node

class PlayerStateIdle extends StateMachine.State:

	func _init() -> void:
		super("Idle")

	func enter() -> void:
		pass

	func tick(delta) -> void:
		var player: Player = Global.player
		player.velocity = GlobalPhysics.apply_gravity(player.velocity, delta)
		var collided: bool = player.move_and_slide()

		if not collided:
			return

		player.velocity = player.count_friction(delta)

class PlayerStateRun extends StateMachine.State:

	func _init() -> void:
		super("Run")

	func enter() -> void:
		pass

class PlayerStateFalling extends StateMachine.State:

	func _init() -> void:
		super("Falling")

class PlayerStateDashing extends StateMachine.State:

	func _init() -> void:
		super("Dashing")

#
# main script part
#

@export var player_node_path: NodePath
var player_node: Player

var state_machine: StateMachine

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
