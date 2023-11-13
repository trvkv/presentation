extends Node2D

@onready var label_state_value = $GUI/PanelContainer/VBoxContainer/hb_state/label_value
@onready var label_velocity_value = $GUI/PanelContainer/VBoxContainer/hb_velocity/label_value
@onready var label_direction_value = $GUI/PanelContainer/VBoxContainer/hb_direction/label_value
@onready var label_acceleration_value = $GUI/PanelContainer/VBoxContainer/hb_current_acc/label_value

func _physics_process(delta) -> void:
	var player: Player = Global.player
	if player:
		label_state_value.set_text(player.get_active_state_name())
		label_velocity_value.set_text("X: {vx}, Y: {vy}".format({
			"vx": "%0.2f" % (player.get_last_motion().x / delta),
			"vy": "%0.2f" % player.velocity.y
		}))

		label_direction_value.set_text(str(player.motion_direction))
		label_acceleration_value.set_text(str(player.current_acceleration))
