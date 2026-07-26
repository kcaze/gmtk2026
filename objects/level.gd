class_name Level
extends Node2D

var bounds: Rect2

func _ready():
	bounds = $LevelBoundary/Shape2D.global_transform * ($LevelBoundary/Shape2D.shape as RectangleShape2D).get_rect()

func _on_level_boundary_body_exited(body: Node2D) -> void:
	if body == G.player:
		G.main.exited_level()
