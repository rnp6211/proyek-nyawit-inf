extends Node2D

@onready var top: Sprite2D = $SpawnerTop
@onready var bottom: Sprite2D = $SpawnerBottom

func on_wave_3_start() -> void:
	show()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 1).from(Color(1, 1, 1, 0))
	await tween.finished
	await get_tree().create_timer(2).timeout
	var n_tween = create_tween()
	n_tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1).from(Color(1, 1, 1, 1))
