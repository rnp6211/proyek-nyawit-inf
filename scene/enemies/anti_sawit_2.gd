extends CharacterBody2D

@export var health: int = 10
@export var speed_lo: int = 60
@export var speed_hi: int = 120
@export var bullet_speed: int = 100
@export var sawit_name: int = 2

@onready var scale_0: Vector2
@onready var player: Node2D = $"../../Player"
@onready var bullets: Node2D = $"../../Bullets"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale_0 = scale
	position.y -= 160

var sawit2_delta: float = 2
var attack_delta: float = 0
var reverse_delta: float = 0
var sawit2_face: int = 0
var terminated: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if terminated:
		return

	if sawit2_delta >= 1:
		var prev_sawit2_face = sawit2_face
		sawit2_face = 1 if position.x > player.position.x else 0
		sawit2_delta = -delta
		if reverse_delta <= 0 and sawit2_face != prev_sawit2_face:
			reverse_delta = 1

	var dir: Vector2 = Vector2(-1 if sawit2_face else 1, 0)

	if reverse_delta > 0:
		dir.x = 0
		reverse_delta -= delta

	velocity = dir * randi_range(speed_lo, speed_hi)

	if !$AntiSawit2Attack.visible:
		move_and_slide()

	sawit2_delta += delta
	attack_delta += delta
	
	if attack_delta >= 6.1:
		var distance = abs(position - player.position).length()
		if distance < 200:
			var anim_tween = create_tween()
			anim_tween.tween_property(self, "modulate", Color(3, 3, 3), 1).set_ease(Tween.EASE_IN).from(Color(1, 1, 1))

			var attack_func = func() -> void:
				modulate = Color(1, 1, 1)
				if terminated:
					return
				$AntiSawit2Attack.show()
				var node = $AntiSawit2Attack
				node.process_mode = Node.PROCESS_MODE_INHERIT
				await get_tree().create_timer(1).timeout
				node.process_mode = Node.PROCESS_MODE_DISABLED
				var tween = create_tween()
				tween.tween_property($AntiSawit2Attack, "modulate", Color(1, 1, 1, 0), 0.3)
				await tween.finished
				$AntiSawit2Attack.modulate = Color(1, 1, 1, 1)
				$AntiSawit2Attack.hide()
			
			anim_tween.connect("finished", attack_func, CONNECT_ONE_SHOT)
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
