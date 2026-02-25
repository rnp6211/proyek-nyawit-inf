extends Node2D

@onready var top: AnimatedSprite2D = $Top
@onready var bottom: AnimatedSprite2D = $Bottom
@onready var player: Player = $".."

var jumping: bool = false

func _ready() -> void:
	animation_default()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale.x = player.face

	if !player.is_on_floor():
		jumping = true
		bottom.pause()
		bottom.animation = "jump"
		bottom.frame = 0
		var tween = create_tween()
		tween.tween_property(bottom, "frame", 3, 1.0).from(0).set_trans(Tween.TRANS_LINEAR)
	
	if jumping:
		if player.is_on_floor():
			var tween = create_tween()
			tween.tween_property(bottom, "frame", 4, 1.0/8).from(2).set_trans(Tween.TRANS_LINEAR)
			tween.connect("finished", func(): jumping = false; bottom.play(); bottom.animation = "default", CONNECT_ONE_SHOT)
	
	if Input.is_action_pressed("attack"):
		if Input.is_action_pressed("up"):
				top.animation = "attack_up"
		elif Input.is_action_pressed("down"):
			top.animation = "attack_down"
		else:
			top.animation = "attack"

	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		if bottom.animation != "jump":
			bottom.animation = "move"
		if !Input.is_action_pressed("attack"):
			top.animation = "move"
		else:
			if Input.is_action_pressed("up"):
				top.animation = "attack_up"
			elif Input.is_action_pressed("down"):
				top.animation = "attack_down"
			else:
				top.animation = "attack"
	else:
		if !Input.is_action_pressed("attack"):
			top.animation = "default"
		if bottom.animation != "jump":
			bottom.animation = "default"

func animation_default():
	top.animation = "default"
	bottom.animation = "default"
