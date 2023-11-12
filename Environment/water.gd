extends Area2D

class_name Water

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body) -> void:
	if body.is_in_group("players"):
		body.area_interaction = self

func _on_body_exited(body) -> void:
	if body.is_in_group("players"):
		body.area_interaction = null
