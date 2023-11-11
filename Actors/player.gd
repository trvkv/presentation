extends Actor

class_name Player

const SPEED = 800.0
const JUMP_VELOCITY = 700.0

@onready var animation_tree = $AnimationTree
@onready var state_machine = $PlayerStateMachine

var current_animation_state: int
var last_animation_state: int

func _ready():
	Global.player = self
	motion_direction = Vector2(0.0, 0.0)

	animation_tree['parameters/conditions/moving_right'] = true
	animation_tree["parameters/conditions/moving_left"] = false

func _process(_delta) -> void:
	# save last motion which was other than zero
	if motion_direction.x > 0:
		animation_tree['parameters/conditions/moving_right'] = true
		animation_tree["parameters/conditions/moving_left"] = false
	elif motion_direction.x < 0:
		animation_tree['parameters/conditions/moving_right'] = false
		animation_tree["parameters/conditions/moving_left"] = true

func handle_movement(_event: InputEvent) -> void:
	motion_direction.x = (-Input.get_action_strength("ui_left")) + Input.get_action_strength("ui_right")

func handle_jump(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		is_jumping = true

func apply_jump() -> void:
	velocity = GlobalPhysics.apply_jump(velocity, JUMP_VELOCITY)

func get_active_state_id() -> int:
	return state_machine.active_state.state_id

func get_active_state_name() -> String:
	if state_machine.active_state:
		return state_machine.active_state.get_state_name()
	return ""
