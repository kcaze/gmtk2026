extends Node2D

@onready var current_level = $IntroLevel

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
