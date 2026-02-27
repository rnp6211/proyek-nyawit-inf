extends CharacterBody2D

@export var health: int = 150
@export var speed_lo: int = 80
@export var speed_hi: int = 120
@export var bullet_speed: int = 100
@export var Bullet: PackedScene
@export var sawit_name: int = 1
@export var Sawit1: PackedScene
@export var Sawit2: PackedScene

@onready var scale_0: Vector2
@onready var player: Node2D = $"../../Player"
@onready var bullets: Node2D = $"../../Bullets"
var health_total: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_total = health
	scale_0 = scale
	position.x = 320
	position.y -= 100
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 1).from(Color(1, 1, 1, 0))
	tween.tween_property(self, "position", Vector2(0, -50), 1).as_relative()

var sawitboss_delta: float = 1
var attack_delta: float = 0
var spawn_delta: float = 0
var sawitboss_face: int = 0
var sawitboss_spawn_delta: float = 0
var terminated: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if terminated:
		return
	
	if sawitboss_spawn_delta <= 2:
		sawitboss_spawn_delta += delta
		return

	if sawitboss_delta >= 2:
		sawitboss_face = 1 if position.x > player.position.x else 0
		sawitboss_delta = -delta

	var dir: Vector2 = Vector2(-1 if sawitboss_face else 1, 0)
	velocity = dir * randi_range(speed_lo, speed_hi)
	move_and_slide()
	
	sawitboss_delta += delta
	attack_delta += delta
	spawn_delta += delta
	
	if attack_delta >= 6.3:
		var distance = abs(position - player.position).length()
		if distance < 200:
			if health > health_total/2:
				call("bullet_atks")
			else:
				call("laser_atk")
			
		attack_delta = 0

	if spawn_delta >= 8.7:
		var wave_logic = $"../../WaveLogic"
		if $"../".get_children().size() <= 5:
			var sawit: Node2D
			if randi_range(0, 1):
				sawit = Sawit1.instantiate()
			else:
				sawit = Sawit2.instantiate()
			wave_logic.spawn_enemy(sawit)
		spawn_delta = 0

	if health <= 0:
		terminate()

func get_hit_animation() -> void:
	if health <= health_total/2:
		$Node2D/AnimatedSprite2D.animation = "half"
		$Node2D/AnimatedSprite2D2.show()
	var tween = create_tween()
	tween.tween_property($Node2D, "modulate", Color(1, 1, 1), 0.3).from(Color(2, 2, 2))

func terminate() -> void:
	terminated = true
	$CollisionShape2D.disabled = true
	var tween = create_tween()
	tween.tween_property($Node2D, "rotation_degrees", 45, 0.5)
	tween.parallel().tween_property($Node2D, "position", Vector2(0, 360*1.5), 1)
	await tween.finished
	queue_free()

func laser_atk() -> void:
	var tween0 = create_tween()
	tween0.tween_property(self, "modulate", Color(3, 3, 3, 1), 1).from(Color(1, 1, 1, 1))
	await tween0.finished

	modulate = Color(1, 1, 1, 1)
	
	if terminated:
		return

	$AntiSawit2Attack.show()
	$AntiSawit2Attack.modulate = Color(1, 1, 1, 1)
	$AntiSawit2Attack.process_mode = Node.PROCESS_MODE_INHERIT
	
	await get_tree().create_timer(2).timeout
	
	$AntiSawit2Attack.process_mode = Node.PROCESS_MODE_DISABLED
	
	var tween1 = create_tween()
	tween1.tween_property($AntiSawit2Attack, "modulate", Color(1, 1, 1, 0), 1).from(Color(1, 1, 1, 1))
	await tween1.finished
	
	$AntiSawit2Attack.hide()

func bullet_atks() -> void:
	for i in range(9):
		var bullet = Bullet.instantiate()
		bullet.position = position
		bullet.position.y -= 12
		bullet.scale = Vector2(1, 1) * 0.8
				
		bullet.velocity = Vector2(0, 1)
		bullet.velocity *= bullet_speed

		bullets.add_child(bullet)
					
		if terminated:
			return
					
		await get_tree().create_timer(0.4).timeout
