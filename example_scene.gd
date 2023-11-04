extends Node2D

@onready var label_state_value = $GUI/PanelContainer/VBoxContainer/hb_state/label_value

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta) -> void:
	var player: Player = Global.player
	if player:
		label_state_value.set_text(player.get_current_state())
