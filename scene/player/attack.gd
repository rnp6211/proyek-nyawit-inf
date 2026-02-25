extends Node2D

@export var speed: int = 1000
@export var attack_cooldown: float = 0.2
@export var Bullet: PackedScene

@onready var player: Player = $".."

var attack_delta: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if attack_delta > 0:
		attack_delta += delta
		if attack_delta >= attack_cooldown:
			attack_delta = 0
	elif Input.is_action_pressed("attack"):
		attack_delta += delta
		var bullet = Bullet.instantiate()
		bullet.position = player.position
		bullet.position.y -= 12
		bullet.scale = Vector2(0.5, 0.5)
		if Input.is_action_pressed("down"):
			bullet.velocity = Vector2(0, speed)
		elif Input.is_action_pressed("up"):
			bullet.velocity = Vector2(0, -speed)
		else:
			bullet.velocity = Vector2(player.face * speed, 0)
		player.bullets.add_child(bullet)
