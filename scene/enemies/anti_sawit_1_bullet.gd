extends CharacterBody2D

@onready var velocity_0: Vector2

func _ready() -> void:
	velocity_0 = velocity

var terminated: bool = false

func _physics_process(delta: float) -> void:
	if terminated:
		return

	velocity = velocity_0

	move_and_slide()

	if get_slide_collision_count() > 0:
		terminate()

func terminate() -> void:
	terminated = true
	await get_tree().physics_frame
	await get_tree().physics_frame
	queue_free()
