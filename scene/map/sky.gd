extends Sprite2D

@onready var camera: Camera2D = get_viewport().get_camera_2d()
var camera_pos: Vector2

func _ready() -> void:
	camera_pos = camera.get_screen_center_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_camera_pos = camera.get_screen_center_position()
	var cam_pos_x_delta = new_camera_pos.x - camera_pos.x

	position.x += cam_pos_x_delta * (4.0/5)
	
	camera_pos = new_camera_pos
