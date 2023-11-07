extends Actor

class_name Player

const SPEED = 800.0
const JUMP_VELOCITY = 700.0

@onready var state_machine = $PlayerStateMachine

func _ready():
	Global.player = self
	motion_direction = Vector2(0.0, 0.0)
	last_motion_direction = Vector2(1.0, 0.0)

func handle_movement(_event: InputEvent) -> void:
	motion_direction.x = (-Input.get_action_strength("ui_left")) + Input.get_action_strength("ui_right")

func handle_jump(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		is_jumping = true

func apply_jump() -> void:
	velocity = GlobalPhysics.apply_jump(velocity, JUMP_VELOCITY)

func get_current_state_name() -> String:
	if state_machine.active_state:
		return state_machine.active_state.get_state_name()
	return ""
