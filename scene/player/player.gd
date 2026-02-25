class_name Player
extends CharacterBody2D

@export var health: int = 5
@export var speed: int = 130
@export var jump_accel: int = -350
@export var get_hit_cd: float = 1

@onready var scale_0: Vector2
@onready var attack: Node2D = $Attack
@onready var enemy_detect: Area2D = $EnemyDetect
@onready var bullets: Node2D = $"../Bullets"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale_0 = scale

var face: int = 1
var jumped: bool = false
var get_hit_delta: float = 0
var jump_t: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var input_dir = Vector2(0 , 0)
	if Input.is_action_pressed("left"):
		input_dir.x = -1
	elif Input.is_action_pressed("right"):
		input_dir.x = 1
	if input_dir.x != 0:
		face = input_dir.x

	velocity = input_dir * speed
	velocity.y += get_gravity().y*7 * delta
	
	if Input.is_action_pressed("jump") and is_on_floor() and !jumped:
		jumped = true
	
	if jumped:
		jump_t += delta
		velocity.y += jump_accel
		if jump_t >= 0.4:
			jumped = false
			jump_t = 0

	move_and_slide()

	for collision in enemy_detect.get_overlapping_bodies():
		if collision is CharacterBody2D:
			if get_hit_delta <= 0:
				health -= 1
				get_hit_delta = get_hit_cd
				get_hit_animation()

	if get_hit_delta > 0:
		get_hit_delta -= delta

func get_hit_animation() -> void:
	var tween = create_tween()
	tween.tween_property($Sprite, "modulate", Color(1, 1, 1), 0.3).from(Color(2, 2, 2))

func on_enemy_detect_body(body: Node2D) -> void:
	if body is CharacterBody2D:
		if get_hit_delta <= 0:
				health -= 1
				get_hit_delta = get_hit_cd
				get_hit_animation()
