class_name Main

extends Node2D

@onready var current_level = $Levels/IntroLevel

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	G.main = self

func exited_level():
	for level in $Levels.get_children():
		if level.get_node("LevelBoundary").overlaps_body(G.player):
			current_level = level

func _process(delta: float) -> void:
	$Player/Camera2D.limit_left = lerpf($Player/Camera2D.limit_left, current_level.bounds.position.x, 0.1)
	if abs($Player/Camera2D.limit_left - current_level.bounds.position.x) < 2:
		$Player/Camera2D.limit_left = current_level.bounds.position.x
	$Player/Camera2D.limit_top = lerpf($Player/Camera2D.limit_top, current_level.bounds.position.y, 0.1)
	if abs($Player/Camera2D.limit_top - current_level.bounds.position.y) < 2:
		$Player/Camera2D.limit_top = current_level.bounds.position.y
	$Player/Camera2D.limit_right = lerpf($Player/Camera2D.limit_right, current_level.bounds.end.x, 0.1)
	if abs($Player/Camera2D.limit_right - current_level.bounds.end.x) < 2:
		$Player/Camera2D.limit_right = current_level.bounds.end.x
	$Player/Camera2D.limit_bottom = lerpf($Player/Camera2D.limit_bottom, current_level.bounds.end.y, 0.1)
	if abs($Player/Camera2D.limit_bottom - current_level.bounds.end.y) < 2:
		$Player/Camera2D.limit_bottom = current_level.bounds.end.y
