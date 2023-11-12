extends Sprite2D

class_name LightSource

@export var flicker_strength: float = 10.0

@onready var light: PointLight2D = $PointLight2D

var noise: FastNoiseLite
var xy_offset: Vector2

func _ready():
	randomize()

func _process(_delta):
	if Engine.get_process_frames() % 6 == 0:
		light.offset.x = randf() * flicker_strength
		light.offset.y = randf() * flicker_strength
