extends Actor

class_name Player

const SPEED = 800.0
const JUMP_VELOCITY = 1000.0

@onready var state_machine = $PlayerStateMachine

func _ready():
	Global.player = self
	motion_direction = Vector2(0.0, 0.0)
	last_motion_direction = Vector2(1.0, 0.0)

func handle_movement(event: InputEvent) -> void:
	motion_direction.x = 0
	if event.is_action("ui_left"):
		motion_direction.x -= 1 if event.is_pressed() else 0
	if event.is_action("ui_right"):
		motion_direction.x += 1 if event.is_pressed() else 0

func handle_jump(event: InputEvent) -> void:
	if event.is_action("ui_select"):
		is_jumping = event.is_pressed()

func get_current_state_name() -> String:
	if state_machine.active_state:
		return state_machine.active_state.get_state_name()
	return ""
