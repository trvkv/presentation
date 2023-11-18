extends Node2D

@export var slides: Array[PackedScene]

var current_slide_index: int = 0

func _ready():
	assert (slides.size() > 0, "Slides array is empty.")
	set_slide(slides[current_slide_index])

func set_slide(scene: PackedScene):
	for child in get_children():
		remove_child(child)
	add_child(scene.instantiate())

func _unhandled_input(event):
	if event.is_action_pressed("ui_select"):
		current_slide_index += 1

		if current_slide_index >= slides.size():
			get_tree().quit(0)
			return

		set_slide(slides[current_slide_index])
