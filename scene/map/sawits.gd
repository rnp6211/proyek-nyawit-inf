extends TileMapLayer

var camera_pos: Vector2

func _ready() -> void:
	if not get_viewport().get_camera_2d():
		return
	camera_pos = get_viewport().get_camera_2d().get_screen_center_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not get_viewport().get_camera_2d():
		return
	var camera: Camera2D = get_viewport().get_camera_2d()


	var new_camera_pos = camera.get_screen_center_position()
	var cam_pos_x_delta = new_camera_pos.x - camera_pos.x

	position.x += cam_pos_x_delta * (1.0/2)

	camera_pos = new_camera_pos
