extends Node2D

@export_category("Incoming slide")
@export var start_position: Vector2 = Vector2(100.0, 0.0)
@export var start_scale: Vector2 = Vector2(0.9, 0.9)
@export var start_alpha: float = 0.0
@export var start_duration: float = 0.5
@export var start_delay: float = 0.5

@export_category("Outgoing slide")
@export var end_position: Vector2 = Vector2(100.0, 0.0)
@export var end_scale: Vector2 = Vector2(0.9, 0.9)
@export var end_alpha: float = 0.0
@export var end_duration: float = 0.5
@export var end_delay: float = 0.5

@export_category("Slides list")
@export var slides: Array[PackedScene]

@onready var slide_container: Node2D = $SlideContainer
@onready var slide_count: Label = $Gui/MarginContainer/SlideCount

var current_slide_index: int = 0
var locked: bool = false

func _ready():
	assert (slides.size() > 0, "Slides array is empty.")
	set_slide(slides[current_slide_index])

func set_slide(scene: PackedScene, direction: float = 0.0):
	print("Setting new slide: ", scene.resource_path)

	# set slide count
	slide_count.set_text(str(current_slide_index + 1) + " / " + str(slides.size()))

	# delete old slide(s)

	for child in slide_container.get_children():
		var tween: Tween = get_tree().create_tween()
		tween.set_parallel(true)

		tween.tween_property(child, "position", direction * end_position, end_duration)
		tween.tween_property(child, "scale", end_scale, end_duration)
		tween.tween_property(child, "modulate:a", end_alpha, end_duration)

		tween = get_tree().create_tween()
		tween.tween_callback(child.queue_free).set_delay(end_delay)

	# add new slide
	var instance = scene.instantiate()
	slide_container.add_child(instance)

	instance.position = direction * start_position
	instance.scale = start_scale
	instance.modulate.a = start_alpha

	var tween: Tween = get_tree().create_tween()
	tween.set_parallel(true)

	tween.tween_property(instance, "position", Vector2(0, 0), 0.5).set_delay(start_delay)
	tween.tween_property(instance, "scale", Vector2(1.0, 1.0), 0.5).set_delay(start_delay)
	tween.tween_property(instance, "modulate:a", 1.0, 0.5).set_delay(start_delay)

	# unlock input
	tween = get_tree().create_tween()
	tween.tween_callback(unlock)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		print("Bye, bye")
		get_tree().quit()

	if event.is_action_pressed("ui_select") or \
	   event.is_action_pressed("ui_right"):
		# prevent from fireing events too quickly
		if locked:
			return
		locked = true

		current_slide_index += 1

		if current_slide_index >= slides.size():
			print("Starting from the beginning")
			current_slide_index = 0

		set_slide(slides[current_slide_index], 1.0)

	if event.is_action_pressed("ui_left"):
		# prevent from fireing events too quickly
		if locked:
			return
		locked = true

		current_slide_index -= 1

		if current_slide_index < 0:
			print("Going to the end")
			current_slide_index = slides.size() - 1

		set_slide(slides[current_slide_index], -1.0)

func unlock():
	locked = false
