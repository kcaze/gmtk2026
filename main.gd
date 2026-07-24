extends Node2D

@onready var current_level = $IntroLevel

func _physics_process(delta: float) -> void:
	$Player/Camera2D.global_position = $Player.global_position.round()
