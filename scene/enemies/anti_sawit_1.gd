extends CharacterBody2D

@export var health: int = 10
@export var speed_lo: int = 10
@export var speed_hi: int = 50
@export var bullet_speed: int = 100
@export var Bullet: PackedScene
@export var sawit_name: int = 1

@onready var scale_0: Vector2
@onready var player: Node2D = $"../../Player"
@onready var bullets: Node2D = $"../../Bullets"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale_0 = scale
	position.y -= randi_range(0, 1) * 100

var sawit1_delta: float = 2
var attack_delta: float = 0
var sawit1_face: int = 0
var terminated: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if terminated:
		return

	if sawit1_delta >= 2:
		sawit1_face = 1 if position.x > player.position.x else 0
		sawit1_delta = -delta

	var dir: Vector2 = Vector2(-1 if sawit1_face else 1, 0)
	velocity = dir * randi_range(speed_lo, speed_hi)
	move_and_slide()
	
	sawit1_delta += delta
	attack_delta += delta
	
	if attack_delta >= 2.6:
		var distance = abs(position - player.position).length()
		if distance > 120 and distance < 200:
			var bullet = Bullet.instantiate()
			bullet.position = position
			bullet.position.y -= 12
			bullet.scale = Vector2(1, 1) * 0.8
			
			var gradient = (position.y - player.position.y) / abs(position.x - player.position.x)
			bullet.velocity = Vector2(-1 if sawit1_face else 1, -gradient).normalized()
			
			bullet.velocity *= bullet_speed
			
			bullets.add_child(bullet)
		attack_delta = 0
	
	if health <= 0:
		terminate()

func get_hit_animation() -> void:
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.3).from(Color(2, 2, 2))

func terminate() -> void:
	terminated = true
	$CollisionShape2D.disabled = true
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "rotation_degrees", 45, 0.5)
	tween.parallel().tween_property($AnimatedSprite2D, "position", Vector2(0, 360*1.5), 1)
	await tween.finished
	queue_free()
