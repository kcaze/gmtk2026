class_name Level
extends Node2D

var bounds: Rect2

func _ready():
	bounds = $LevelBoundary/Shape2D.global_transform * ($LevelBoundary/Shape2D.shape as RectangleShape2D).get_rect()
