extends Node2D

@onready var enemies: Node2D = $"../Enemies"
@onready var player: Node2D = $"../Player"
var wave: int = 1;

@export var Sawit1: PackedScene
@export var Sawit2: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if wave == 1:
		wave_1_logic(delta)
	elif wave == 2:
		wave_2_logic(delta)

var wave_1_spawn_delta: float = 0
var wave_1_enemies_spawned = 0
@export var wave_1_spawn_cooldown_s: int = 3

func wave_1_logic(delta: float) -> void:
	if wave_1_spawn_delta >= wave_1_spawn_cooldown_s and wave_1_enemies_spawned <= 10:
		var nyawit = Sawit1.instantiate()
		spawn_enemy(nyawit)
		wave_1_enemies_spawned += 1
		wave_1_spawn_delta = 0
	else:
		wave_1_spawn_delta += delta
	
	if wave_1_enemies_spawned >= 10 and enemies.get_children().size() <= 0:
		wave = 2

var wave_2_spawn_delta: float = 0
var wave_2_enemies_spawned = 0
@export var wave_2_spawn_cooldown_s: int = 4

func wave_2_logic(delta: float) -> void:
	if wave_2_spawn_delta >= wave_2_spawn_cooldown_s and wave_2_enemies_spawned <= 25 and enemies.get_children().size() < 5:
		if wave_2_count_antisawit2() < 2:
			var nyawit2 = Sawit2.instantiate()
			spawn_enemy(nyawit2)
			wave_2_enemies_spawned += 1

		var nyawit1 = Sawit1.instantiate()
		spawn_enemy(nyawit1)
		wave_2_enemies_spawned += 1
		wave_2_spawn_delta = 0
	else:
		wave_2_spawn_delta += delta
	
	if wave_2_enemies_spawned >= 15 and enemies.get_children().size() <= 0:
		wave = 3

func wave_2_count_antisawit2() -> int:
	var count: int = 0
	for sawit in enemies.get_children():
		if sawit.sawit_name == 2:
			count += 1
	return count

func spawn_enemy(node: Node2D) -> void:
	var neg = randi_range(0, 1)
	var x = player.position.x + (-1 if neg == 1 else 1) * 360
	
	if x < 0:
		x = player.position.x + 360
	elif x > 640:
		x = player.position.x - 360
	
	node.position.x = x
	node.position.y = 288
	node.scale = Vector2(1, 1) * 0.375
	enemies.add_child(node)
