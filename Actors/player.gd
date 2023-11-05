extends Actor

class_name Player

const SPEED = 800.0
const JUMP_VELOCITY = 1000.0

@onready var state_machine = $PlayerStateMachine

func _ready():
	Global.player = self

func _physics_process(_delta):
	motion_direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
#		Input.get_axis("ui_up", "ui_down")
		0.0 # movement available only on X axis
	)

func get_current_state() -> String:
	if state_machine.active_state:
		return state_machine.active_state.get_name()
	return ""
