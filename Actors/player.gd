extends Actor

class_name Player

const SPEED = 1000.0
const JUMP_VELOCITY = 750.0

@onready var animation_tree = $AnimationTree
@onready var state_machine = $PlayerStateMachine

var current_animation_state: int
var last_animation_state: int

var collision_data: CollisionData = CollisionData.new()
var area_interaction: Area2D

func _ready():
	Global.player = self
	motion_direction = Vector2(0.0, 0.0)

	animation_tree['parameters/conditions/idle'] = true
	animation_tree['parameters/Idle/blend_position'] = 1.0


func _process(_delta) -> void:
	# save last motion which was other than zero

	if motion_direction.x != 0.0:
		animation_tree['parameters/conditions/idle'] = false
		animation_tree['parameters/conditions/moving'] = true
		animation_tree['parameters/Idle/blend_position'] = motion_direction.x
		animation_tree['parameters/Run/blend_position'] = motion_direction.x
	else:
		animation_tree['parameters/conditions/idle'] = true
		animation_tree['parameters/conditions/moving'] = false

func handle_movement(_event: InputEvent) -> void:
	motion_direction.x = (-Input.get_action_strength("ui_left")) + Input.get_action_strength("ui_right")

func handle_jump(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		is_jumping = true

func apply_jump() -> void:
	var collider = self
	if is_instance_valid(collision_data.collider):
		if collision_data.collider.is_class("CollisionObject2D"):
			collider = collision_data.collider
	velocity = GlobalPhysics.apply_jump(collider, velocity, JUMP_VELOCITY)

func apply_gravity(delta: float) -> void:
	var collider = self
	if is_instance_valid(collision_data.collider):
		collider = collision_data.collider
	if area_interaction:
		collider = area_interaction
	velocity = GlobalPhysics.apply_gravity(collider, velocity, delta)

func apply_move() -> void:
	move_and_slide()
	collision_data = get_collision_data()

func get_active_state_id() -> int:
	return state_machine.active_state.state_id

func get_active_state_name() -> String:
	if state_machine.active_state:
		return state_machine.active_state.get_state_name()
	return ""
