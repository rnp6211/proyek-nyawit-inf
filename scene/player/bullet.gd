extends CharacterBody2D

@onready var velocity_0: Vector2

func _ready() -> void:
	velocity_0 = velocity
	
var total_delta: float

func _physics_process(delta: float) -> void:
	velocity = velocity_0
	total_delta += delta

	if total_delta >= 1:
		queue_free()

	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is CharacterBody2D:
			collision.get_collider().health -= 1
			collision.get_collider().get_hit_animation()

	if get_slide_collision_count() > 0:
		queue_free()
